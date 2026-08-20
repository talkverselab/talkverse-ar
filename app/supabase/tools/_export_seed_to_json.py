"""
Talkverse 시드 SQL → 로컬 JSON 자산 변환.

supabase/seed_*.sql 파일들을 파싱해서 다음 JSON 생성:
  assets/data/<lang>/items.json          (per-language)
  assets/data/_shared/etymon.json
  assets/data/_shared/hanja_master.json
  assets/data/_shared/hanja_related.json
  assets/data/_shared/hanzi_studies_zh.json
  assets/data/_shared/hanzi_related_zh.json
  assets/data/_shared/hanzi_studies_jp.json
  assets/data/_shared/hanzi_related_jp.json

처리 순서:
  1. 모든 INSERT INTO 문 → 메모리 테이블 누적 (PK 기반 upsert)
  2. 모든 UPDATE 문 → PK 매칭해서 필드 덮어씀 (tier·dialogue_order 등)
  3. DELETE / ALTER / DROP / CREATE → skip
  4. 그룹화 + JSON dump

실행:
  cd C:\\dev\\talkverse_learning
  py supabase/tools/_export_seed_to_json.py
"""

from __future__ import annotations

import json
import re
import sys
import io
from pathlib import Path

# Windows 콘솔 cp949 회피.
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8")
    except Exception:
        pass

ROOT = Path(__file__).resolve().parents[2]
SEED_DIR = ROOT / "supabase"
ASSETS_DIR = ROOT / "assets" / "data"
SHARED_DIR = ASSETS_DIR / "_shared"

# 처리할 테이블 목록 + 어디에 저장할지.
# items 만 per-lang 분리. 나머지는 _shared/.
SHARED_TABLES = {
    "etymon": SHARED_DIR / "etymon.json",
    "hanja_master": SHARED_DIR / "hanja_master.json",
    "hanja_related": SHARED_DIR / "hanja_related.json",
    "hanzi_studies_zh": SHARED_DIR / "hanzi_studies_zh.json",
    "hanzi_related_zh": SHARED_DIR / "hanzi_related_zh.json",
    "hanzi_studies_jp": SHARED_DIR / "hanzi_studies_jp.json",
    "hanzi_related_jp": SHARED_DIR / "hanzi_related_jp.json",
}

# 각 테이블의 PK 컬럼 (UPDATE 매칭 / dedup 용).
TABLE_PK = {
    "items": ["id"],
    "etymon": ["id"],
    "hanja_master": ["kor_hanja"],
    "hanja_related": ["source", "related", "relation"],
    "hanzi_studies_zh": ["id"],
    "hanzi_related_zh": ["study_id", "character", "relation_type"],
    "hanzi_studies_jp": ["id"],
    "hanzi_related_jp": ["study_id", "character", "relation_type"],
}

# ----------------------- SQL 토크나이저 -----------------------

def strip_sql_comments(sql: str) -> str:
    """`-- ...` 주석과 `/* ... */` 블록 주석 제거. 따옴표 안은 보존."""
    out = []
    i = 0
    n = len(sql)
    in_string = False
    while i < n:
        c = sql[i]
        if in_string:
            out.append(c)
            if c == "'":
                # SQL escape: '' = literal '
                if i + 1 < n and sql[i + 1] == "'":
                    out.append("'")
                    i += 2
                    continue
                in_string = False
        else:
            if c == "'":
                in_string = True
                out.append(c)
            elif c == "-" and i + 1 < n and sql[i + 1] == "-":
                # line comment
                j = sql.find("\n", i)
                if j < 0:
                    break
                i = j
                out.append("\n")
                continue
            elif c == "/" and i + 1 < n and sql[i + 1] == "*":
                j = sql.find("*/", i + 2)
                if j < 0:
                    break
                i = j + 2
                continue
            else:
                out.append(c)
        i += 1
    return "".join(out)


def split_statements(sql: str) -> list[str]:
    """`;` 로 statement 분리. 따옴표 안의 `;` 보호."""
    stmts = []
    cur = []
    in_str = False
    i = 0
    n = len(sql)
    while i < n:
        c = sql[i]
        cur.append(c)
        if c == "'":
            if in_str and i + 1 < n and sql[i + 1] == "'":
                cur.append("'")
                i += 2
                continue
            in_str = not in_str
        elif c == ";" and not in_str:
            stmts.append("".join(cur).strip())
            cur = []
        i += 1
    tail = "".join(cur).strip()
    if tail:
        stmts.append(tail)
    return stmts


def parse_value(s: str):
    """SQL value 토큰을 Python 값으로 변환."""
    s = s.strip()
    if not s:
        return None
    if s.upper() == "NULL":
        return None
    if s.upper() == "TRUE":
        return True
    if s.upper() == "FALSE":
        return False
    # 숫자
    if re.fullmatch(r"-?\d+", s):
        return int(s)
    if re.fullmatch(r"-?\d+\.\d*", s):
        return float(s)
    # 'string' or 'string'::jsonb / ::text
    m = re.match(r"^'((?:[^']|'')*)'(?:::([\w]+))?$", s, re.DOTALL)
    if m:
        raw = m.group(1).replace("''", "'")
        cast = (m.group(2) or "").lower()
        if cast in ("jsonb", "json"):
            try:
                return json.loads(raw)
            except Exception:
                return raw
        return raw
    # 배열 literal: '{a,b,c}' 같은 PG array — 스트링으로 두면 세부 type 보존 안 됨.
    # items.tags 의 경우 '{new,l1,day:01}' 형식. 따옴표는 외부에서 이미 벗겨졌을 수도.
    if s.startswith("{") and s.endswith("}"):
        inner = s[1:-1]
        if not inner:
            return []
        return [t.strip() for t in inner.split(",")]
    # array::cast 변형
    m = re.match(r"^ARRAY\[(.*)\](?:::[\w\[\]]+)?$", s, re.IGNORECASE | re.DOTALL)
    if m:
        return [parse_value(x) for x in split_top_commas(m.group(1))]
    return s  # fallback — 알 수 없는 식


def split_top_commas(s: str) -> list[str]:
    """최상위 쉼표 분리. 괄호·따옴표 안의 쉼표는 보호."""
    out = []
    depth = 0
    in_str = False
    cur = []
    i = 0
    n = len(s)
    while i < n:
        c = s[i]
        if in_str:
            cur.append(c)
            if c == "'":
                if i + 1 < n and s[i + 1] == "'":
                    cur.append("'")
                    i += 2
                    continue
                in_str = False
        else:
            if c == "'":
                in_str = True
                cur.append(c)
            elif c in "([{":
                depth += 1
                cur.append(c)
            elif c in ")]}":
                depth -= 1
                cur.append(c)
            elif c == "," and depth == 0:
                out.append("".join(cur).strip())
                cur = []
            else:
                cur.append(c)
        i += 1
    tail = "".join(cur).strip()
    if tail:
        out.append(tail)
    return out


def split_value_tuples(values_blob: str) -> list[str]:
    """VALUES (a,b,c), (d,e,f), ... 에서 각 (...) 추출."""
    tuples = []
    depth = 0
    in_str = False
    start = -1
    i = 0
    n = len(values_blob)
    while i < n:
        c = values_blob[i]
        if in_str:
            if c == "'":
                if i + 1 < n and values_blob[i + 1] == "'":
                    i += 2
                    continue
                in_str = False
        else:
            if c == "'":
                in_str = True
            elif c == "(":
                if depth == 0:
                    start = i + 1
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0 and start >= 0:
                    tuples.append(values_blob[start:i])
                    start = -1
        i += 1
    return tuples


# ----------------------- INSERT / UPDATE 파서 -----------------------

INSERT_RE = re.compile(
    r"^\s*INSERT\s+INTO\s+(?:public\.)?(\w+)\s*"
    r"(?:\(([^)]*?)\)\s*)?"
    r"(?:OVERRIDING\s+\w+\s+VALUE\s+)?"
    r"VALUES\s*",
    re.IGNORECASE | re.DOTALL,
)

UPDATE_RE = re.compile(
    r"^\s*UPDATE\s+(?:public\.)?(\w+)\s+SET\s+(.*?)(?:\s+WHERE\s+(.+))?$",
    re.IGNORECASE | re.DOTALL,
)


def parse_insert(stmt: str) -> tuple[str, list[str], list[list]] | None:
    m = INSERT_RE.match(stmt)
    if not m:
        return None
    table = m.group(1)
    cols = []
    if m.group(2):
        cols = [c.strip() for c in m.group(2).split(",") if c.strip()]
    values_blob = stmt[m.end():]
    # `;` trailing
    if values_blob.rstrip().endswith(";"):
        values_blob = values_blob.rstrip()[:-1]
    # ON CONFLICT DO UPDATE 등 trailing 절 제거
    upper = values_blob.upper()
    cut = -1
    for kw in [" ON CONFLICT ", " RETURNING "]:
        idx = upper.find(kw)
        if idx >= 0 and (cut < 0 or idx < cut):
            cut = idx
    if cut >= 0:
        values_blob = values_blob[:cut]
    tuples = split_value_tuples(values_blob)
    rows = []
    for t in tuples:
        try:
            rows.append([parse_value(x) for x in split_top_commas(t)])
        except Exception:
            pass
    return table, cols, rows


SET_ASSIGN_RE = re.compile(r"(\w+)\s*=\s*(.+)", re.DOTALL)


def parse_update(stmt: str):
    m = UPDATE_RE.match(stmt.rstrip(";").strip())
    if not m:
        return None
    table = m.group(1)
    set_blob = m.group(2)
    where_blob = m.group(3) or ""
    # SET col=val, col=val
    sets = {}
    for piece in split_top_commas(set_blob):
        am = SET_ASSIGN_RE.match(piece)
        if not am:
            continue
        col = am.group(1).strip()
        val_expr = am.group(2).strip()
        # update_at = now() 같은 함수 호출은 skip (DateTime.now 로 대체)
        if val_expr.lower().startswith(("now(", "current_timestamp")):
            continue
        sets[col] = parse_value(val_expr)
    return table, sets, where_blob


def matches_where(row: dict, where_blob: str) -> bool:
    """단순 WHERE 매칭 — `col = 'val' AND col2 = 'val2'` 패턴만 처리."""
    if not where_blob.strip():
        return True
    # AND 분리
    parts = re.split(r"\s+AND\s+", where_blob, flags=re.IGNORECASE)
    for p in parts:
        p = p.strip()
        # col = val
        em = re.match(r"^(\w+)\s*=\s*(.+)$", p, re.DOTALL)
        if em:
            col = em.group(1).strip()
            val = parse_value(em.group(2).strip())
            if row.get(col) != val:
                return False
            continue
        # col LIKE 'pattern' — fallback: SQL LIKE를 fnmatch 로 흉내
        lm = re.match(r"^(\w+)\s+LIKE\s+'((?:[^']|'')*)'$", p, re.IGNORECASE)
        if lm:
            col = lm.group(1).strip()
            pat = lm.group(2).replace("''", "'")
            row_v = row.get(col, "")
            if not isinstance(row_v, str):
                return False
            # SQL LIKE: % → .*, _ → .
            regex = "^" + re.escape(pat).replace(r"\%", ".*").replace(r"\_", ".") + "$"
            if not re.match(regex, row_v):
                return False
            continue
        # 미지원 절은 보수적으로 false (UPDATE 적용 안 함).
        return False
    return True


# ----------------------- 메인 처리 -----------------------

def pk_key(table: str, row: dict) -> tuple:
    cols = TABLE_PK.get(table)
    if not cols:
        return tuple()
    return tuple(row.get(c) for c in cols)


def main():
    if not SEED_DIR.exists():
        print(f"[FATAL] {SEED_DIR} 없음")
        sys.exit(1)

    SHARED_DIR.mkdir(parents=True, exist_ok=True)
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)

    # 메모리 저장소: table_name → list[dict] (PK 기반 upsert)
    tables: dict[str, dict[tuple, dict]] = {}

    # _share dataset 도 datasets/built/Dataset_*.sql 포함.
    seed_files = list(SEED_DIR.glob("seed_*.sql"))
    seed_files += list((SEED_DIR / "datasets" / "built").glob("Dataset_*.sql"))
    # 안정 정렬 — 작업 순서가 결과에 영향이 적도록.
    seed_files.sort(key=lambda p: p.name)

    print(f"[INFO] {len(seed_files)} seed files 찾음")

    insert_count = 0
    update_count = 0
    update_applied = 0

    # Pass 1: INSERT 만 처리
    for f in seed_files:
        try:
            text = f.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            text = f.read_text(encoding="utf-8-sig")
        text = strip_sql_comments(text)
        for stmt in split_statements(text):
            up = stmt.lstrip().upper()
            if up.startswith("INSERT"):
                parsed = parse_insert(stmt)
                if not parsed:
                    continue
                table, cols, rows = parsed
                if table not in TABLE_PK:
                    continue
                store = tables.setdefault(table, {})
                for vals in rows:
                    if not cols:
                        # cols 미지정 — 알 수 없는 schema. skip.
                        continue
                    if len(vals) != len(cols):
                        continue
                    row = dict(zip(cols, vals))
                    key = pk_key(table, row)
                    store[key] = row
                    insert_count += 1

    # Pass 2: UPDATE 적용
    for f in seed_files:
        try:
            text = f.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            text = f.read_text(encoding="utf-8-sig")
        text = strip_sql_comments(text)
        for stmt in split_statements(text):
            up = stmt.lstrip().upper()
            if up.startswith("UPDATE"):
                parsed = parse_update(stmt)
                if not parsed:
                    continue
                table, sets, where_blob = parsed
                if table not in tables:
                    continue
                update_count += 1
                for row in tables[table].values():
                    if matches_where(row, where_blob):
                        row.update(sets)
                        update_applied += 1

    print(f"[INFO] INSERT rows: {insert_count}, UPDATE statements: {update_count} (applied to {update_applied} rows)")

    # 출력 1: items 를 language_code 별로 분리
    items_store = tables.get("items", {})
    by_lang: dict[str, list[dict]] = {}
    for row in items_store.values():
        lang = row.get("language_code")
        if not lang:
            # 추출 fallback: id prefix 'xx:...' 에서.
            id_v = row.get("id", "")
            if isinstance(id_v, str) and ":" in id_v:
                lang = id_v.split(":", 1)[0]
            else:
                continue
        by_lang.setdefault(lang, []).append(row)

    for lang, rows in sorted(by_lang.items()):
        out = ASSETS_DIR / lang / "items.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        # 안정 정렬: id 순
        rows.sort(key=lambda r: str(r.get("id", "")))
        # updated_at 누락 → 빈 문자열
        for r in rows:
            if "updated_at" not in r or r["updated_at"] is None:
                r["updated_at"] = ""
            # tags: PG 배열 리터럴 문자열 '{new,l1}' → 실제 리스트.
            # 로더(asset_seed_loader)가 tags 를 List 로 cast 하므로 문자열이면
            # 파싱 실패한다. quoted array literal 을 list 로 정규화.
            t = r.get("tags")
            if isinstance(t, str):
                s = t.strip()
                if s.startswith("{") and s.endswith("}"):
                    inner = s[1:-1].strip()
                    r["tags"] = (
                        [x.strip().strip('"') for x in inner.split(",")]
                        if inner else []
                    )
        with out.open("w", encoding="utf-8") as fp:
            json.dump(rows, fp, ensure_ascii=False, indent=0, separators=(",", ":"))
        print(f"  items[{lang}]: {len(rows):>5} rows → {out.relative_to(ROOT)}")

    # 출력 2: 공유 테이블
    for table, out in SHARED_TABLES.items():
        rows = list(tables.get(table, {}).values())
        # 안정 정렬
        if "id" in TABLE_PK.get(table, []):
            rows.sort(key=lambda r: str(r.get("id", "")))
        for r in rows:
            if "updated_at" not in r or r["updated_at"] is None:
                r["updated_at"] = ""
        out.parent.mkdir(parents=True, exist_ok=True)
        with out.open("w", encoding="utf-8") as fp:
            json.dump(rows, fp, ensure_ascii=False, indent=0, separators=(",", ":"))
        print(f"  {table}: {len(rows):>5} rows → {out.relative_to(ROOT)}")

    print("\n[DONE] 변환 완료")


if __name__ == "__main__":
    main()

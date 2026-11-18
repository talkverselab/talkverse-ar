#!/usr/bin/env python3
"""Grok 이 쓴 회화(data/review/grok/write/<id>.md)를 편 JSON 으로 옮긴다 — 형식만 바꾸고 대사는 손대지 않는다
(사용자 지시 2026-11-18 「무조건 그록으로 쓴걸로」 · uk 전달 「Claude 는 초안까지, 대사는 Grok 그대로 붙여 넣기」).
  python3 tools/grok_write_to_json.py [<id> ...]     (없으면 write/ 의 전부) → data/review/write/grok_20261118/<id>.json
감정이 여럿(emotion=a+b)이면 문장 끝(. ! ? ؟ …)으로 나눠 segs 를 만든다. 문장 수가 감정 수와 다르면 첫 감정만 쓰고 review.warn 에 적는다."""
import json, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'data/review/grok/write'
OUT = ROOT / 'data/review/write/grok_20261118'
EMO = set('neutral polite stiff cheerful amused teasing excited surprised shout tsukkomi annoyed sad worried flustered shy gentle'.split())
KIND = {'short': 'short', 'long': 'long', 'chat': 'chat'}
DOC = (ROOT / 'tools/prompts/write_grok_ar.md').read_text(encoding='utf-8')
SPEC = {l.split(' | ')[0]: [x.strip() for x in l.split(' | ')] for l in DOC.splitlines() if re.match(r'^r[0-5]_\w+ \| ', l)}
ISL = {'서바이벌': 'survival', '친구': 'friends', '사랑': 'love', '생활': 'life', '여행': 'travel', '문화': 'culture', '일': 'work', '학업': 'study'}


VOW = {0: '아', 1: '애', 4: '어', 5: '에', 8: '오', 13: '우', 18: '으', 20: '이'}
EMO_FIX = {'confused': 'flustered', 'curious': 'surprised', 'happy': 'cheerful', 'angry': 'annoyed', 'shocked': 'surprised', 'nervous': 'worried', 'embarrassed': 'flustered', 'playful': 'teasing', 'warm': 'gentle', 'relieved': 'gentle', 'resigned': 'sad', 'sheepish': 'shy', 'proud': 'cheerful', 'confident': 'cheerful'}


def fix_rd(rd):
    """독음의 프랑코 숫자(ع=3) 정리 — 앞 글자가 받침 없는 모음이면 같은 모음을 한 번 더(바3드→바아드), 아니면 지운다."""
    out = []
    for i, ch in enumerate(rd):
        if ch == '3' and out and '가' <= out[-1] <= '힣':
            nxt = rd[i + 1] if i + 1 < len(rd) else ''
            c = ord(out[-1]) - 0xAC00
            if c % 28 == 0 and not ('아' <= nxt <= '잏' and (ord(nxt) - 0xAC00) // 588 == 11):
                out.append(VOW.get((c // 28) % 21, ''))
            continue
        if ch == '3' and i + 1 < len(rd) and '가' <= rd[i + 1] <= '힣':
            continue
        out.append(ch)
    return ''.join(out)


def sentences(t):
    parts = [p for p in re.findall(r'[^.!?؟…]+[.!?؟…]*\s*', t.strip()) if p.strip()]
    return [p.rstrip() + ' ' if i < len(parts) - 1 else p.rstrip() for i, p in enumerate(parts)]  # 이으면 ar 와 똑같게


def segs_for(ar, emos, warns, num):
    if len(emos) == 1:
        return None
    ss = sentences(ar)
    if len(ss) != len(emos):
        warns.append(f'턴 {num}: 감정 {len(emos)}개 · 문장 {len(ss)}개 — 첫 감정만')
        return None
    return [[e, s] for e, s in zip(emos, ss)]


def convert(eid):
    text = (SRC / f'{eid}.md').read_text(encoding='utf-8')
    spec = SPEC[eid]
    lv = int(spec[1][1])
    head, turns, warns = {}, [], []
    cm = re.search(r'^cast:\s*(.*)$', text, re.M)
    rev = {v.strip(): k.strip() for k, v in (x.split('=', 1) for x in (cm.group(1).split(';') if cm else []) if '=' in x)}
    for ln in text.splitlines():
        ln = ln.strip()
        if not ln or ln.startswith('===') or ln.startswith('```'):
            continue
        m = re.match(r'^(title|emoji|scene|where|cast|gender|twist|line|expressions):\s*(.*)$', ln)
        if m:
            head[m.group(1)] = m.group(2).strip()
            continue
        cols = [c.strip() for c in ln.split('|')]
        if cols[0] == 'f' and turns:
            t = turns[-1]
            t['ar_f'], t['rd_f'] = cols[1], fix_rd(cols[2]) if len(cols) > 2 else ''
            if len(cols) > 3 and cols[3] != t['ko']:
                t['ko_f'] = cols[3]
            if 'segs' in t:
                s = segs_for(t['ar_f'], [x[0] for x in t['segs']], warns, t['num'])
                if s:
                    t['segs_f'] = s
            continue
        if len(cols) >= 4 and '@' in cols[0] and cols[0].split('@')[0] in rev:  # 채팅 화자를 이름으로 쓴 줄(نور@21:02) → 기호
            cols[0] = rev[cols[0].split('@')[0]] + '@' + cols[0].split('@', 1)[1]
        if len(cols) < 4 or not re.match(r'^[A-E](@[\d:]+)?$', cols[0]):
            continue
        sp, at = (cols[0].split('@') + [None])[:2]
        num = len(turns) + 1
        t = {'num': num, 'speaker': sp, 'ar': cols[1], 'rd': fix_rd(cols[2]), 'ko': cols[3],
             'note': cols[4].strip('"“”') if len(cols) > 4 else '', 'tags': [], 'new': [], 'lemmas': []}
        if at:
            t['ui'], t['at'] = 'bubble', at
        em = re.search(r'emotion=([\w+]+)', ln)
        emos = [EMO_FIX.get(e, e) for e in (em.group(1).split('+') if em else []) if e]
        bad = [e for e in emos if e not in EMO]
        if bad or not emos:
            warns.append(f'턴 {num}: 감정 {bad or "없음"} → neutral')
            emos = [e for e in emos if e in EMO] or ['neutral']
        s = segs_for(t['ar'], emos, warns, num)
        if s:
            t['segs'] = s
        else:
            t['emotion'] = emos[0]
        turns.append(t)
    kv = lambda s: dict(x.split('=', 1) for x in (p.strip() for p in s.split(';')) if '=' in x)
    speakers = {k.strip(): v.strip() for k, v in kv(head.get('cast', 'A={name}')).items()}
    gender = {k.strip(): v.strip() for k, v in kv(head.get('gender', 'A=m')).items()}
    tw = re.match(r'\d+', head.get('twist', ''))
    ep = {
        'id': eid, 'region': f'R{lv}', 'level': lv, 'island': ISL[spec[2]], 'kind': KIND[spec[3]], 'draft': True, 'variety': 'ar_EG',
        'title': head.get('title', eid), 'emoji': head.get('emoji', '💬'), 'scene': head.get('scene', ''), 'where': head.get('where', ''),
        'speakers': speakers, 'gender': gender, 'twist': int(tw.group()) if tw else None, 'line': head.get('line', ''),
        'expressions': [e.split('=')[0].strip() for e in head.get('expressions', '').split(';') if e.strip()],
        'turns': turns,
        'review': {'stage': 'grok-write', 'date': '2026-11-18', 'by': 'Grok 빠른(대사 전부) · Claude 초안(상황·인물·반전·낱말)만', 'warn': warns},
    }
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / f'{eid}.json').write_text(json.dumps(ep, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    return len(turns), warns


if __name__ == '__main__':
    ids = sys.argv[1:] or sorted(p.stem for p in SRC.glob('*.md'))
    for i in ids:
        n, w = convert(i)
        print(f'{i}: 턴 {n}' + (f' · 경고 {len(w)}' if w else ''))

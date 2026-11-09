"""절벽 단어 표 만들기 — 이집트 구어 레마 목록 상위 2,000 + 검토 결과 → assets/data/freq/lang_ar_cliff.csv, conv_words_ar.json.
  python3 tools/build_cliff_words.py <레마 목록 ar.csv> <순위표 lemma_eg.tsv> <검토 JSON 폴더>
검토 JSON: [{rank, action: hide|fix|doubt, word?, reading?, ko?, pos?}]. hide 는 표에서 빼되 순위 번호는 그대로 둔다(절벽 값과 맞춤).
앱에서 쓰는 절벽 값은 lib/core/cliff.dart — 여기 CLIFFS 와 같아야 한다."""
from pathlib import Path
import csv, glob, json, re, sys
CLIFFS = [68, 101, 216, 512]; CAP = 2000
SRC, RANKS, REV = sys.argv[1:4]
NAMES = {'نور', 'مريم', 'كريم', 'يوسف', 'أحمد', 'فاطمة', 'سارة', 'علي', 'محمد', 'ليلى'}  # 회화 등장 인물 — 회화 단어에서 뺌


def key(w):
    w = re.sub('[ً-ْٰـ]', '', w)
    return re.sub('[أإآ]', 'ا', w).replace('ى', 'ي').replace('ة', 'ه').strip()


def region(r):
    for i, c in enumerate(CLIFFS):
        if r <= c:
            return f'R{i + 1}'
    return 'R5'


rows = list(csv.DictReader(open(SRC, encoding='utf-8')))[:CAP]
cum = {int(r['rank']): r['cum_pct'] for r in csv.DictReader(open(RANKS, encoding='utf-8'), delimiter='\t') if int(r['rank']) <= CAP}
rev = {}
for f in sorted(glob.glob(f'{REV}/review*.json')):
    for e in json.load(open(f, encoding='utf-8')):
        rev[e['rank']] = e
out, hidden = [], 0
for r in rows:
    rk = int(r['rank'])
    e = rev.get(rk, {})
    if e.get('action') == 'hide':
        hidden += 1
        continue
    if e.get('action') == 'fix':
        for c in ('word', 'reading', 'ko', 'pos'):
            if e.get(c):
                r[c] = e[c]
    word = re.sub(r'\(.*?\)', '', r['word']).strip()  # ـك(남) → ـك, 구분은 뜻에 있음
    out.append([rk, word, r['reading'], r['ko'], r['pos'], cum.get(rk, ''), region(rk)])
with open('assets/data/freq/lang_ar_cliff.csv', 'w', encoding='utf-8', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['rank', 'word', 'reading', 'ko', 'pos', 'cum_pct', 'region'])
    w.writerows(out)

# 회화 단어: L1 레마 중 표 밖이면서 옛 단어장에 있는 것(등장 횟수순)
top = {key(r[1]) for r in out}
old = {}
for r in csv.DictReader(open('assets/data/freq/lang_es_top.csv', encoding='utf-8')):
    old.setdefault(key(r['word']), r)
cnt = {}


def walk(o):
    if isinstance(o, dict):
        for l in o.get('lemmas', []) or []:
            if len(l) >= 2:
                k = key(l[1])
                if k in top or l[1] in NAMES or k not in old:
                    continue
                c = cnt.setdefault(k, {'word': old[k]['word'], 'rd': l[2] if len(l) > 2 else '', 'ko': old[k]['ko'], 'n': 0})
                c['n'] += 1
        for v in o.values():
            walk(v)
    elif isinstance(o, list):
        for v in o:
            walk(v)


# 앱이 읽는 회화와 같게: 편 파일(R<레벨>/<주제>/*.json)이 있으면 그것, 없으면 옛 L1.json (2026-11-09)
_eps = sorted(Path('assets/data/dialogues').glob('R[0-9]/*/*.json')) or [Path('assets/data/dialogues/L1.json')]
for _p in _eps:
    walk(json.load(open(_p, encoding='utf-8')))
words = sorted(cnt.values(), key=lambda x: -x['n'])
json.dump({'_meta': '회화 레마 중 절벽 단어표(2,000위) 밖이면서 단어장에 있는 것 · tools/build_cliff_words.py', 'words': words},
          open('assets/data/freq/conv_words_ar.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
print('표', len(out), '뺌', hidden, '회화 단어', len(words))

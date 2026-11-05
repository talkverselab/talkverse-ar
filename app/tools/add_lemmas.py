#!/usr/bin/env python3
"""회화 턴마다 `lemmas`(내용어 [표면형, 기본형, 읽기]) 를 채운다 — 문장 레마 ↔ 단어장 연결(사용자 지시 2026-11-04, 일본어앱 tools/add_lemmas.py 의 아랍어판).
형태 분석: 이집트 구어 분석기(CAMeL Tools calima-egy-r13, MLE — 문장 단위로 중의성 해소). 읽기는 비워 둔다(한글 독음은 문장 rd 에 있음).
내용어 = 명사·동사·형용사·부사·수사(대명사·전치사·접속사·불변화사·감탄사·고유명사·기호 제외), 기본형은 모음 부호를 뺀 lex.
단어장(assets/data/freq/lang_es_top.csv)에 없는 레마는 ../data/review/write/missing_lemmas.csv 로(talkverse.uk 세션에 넘김).
  준비: python3 -m venv <venv> && <venv>/bin/pip install camel-tools && <venv>/bin/camel_data -i morphology-db-egy-r13 && <venv>/bin/camel_data -i disambig-mle-calima-egy-r13
  실행(app 폴더에서): <venv>/bin/python tools/add_lemmas.py"""
import csv, json, re
from collections import Counter
from pathlib import Path
from camel_tools.disambig.mle import MLEDisambiguator

ROOT = Path(__file__).resolve().parent.parent
DIAC = re.compile(r'[ً-ْٰـ]')
WORD = re.compile(r'[ء-ْٰ-ۓ]+')
KEEP = {'noun', 'noun_num', 'noun_quant', 'verb', 'adj', 'adj_comp', 'adj_num', 'adv', 'num', 'digit'}
# 분석기가 틀리는 낱말(표면형 → 기본형, None = 내용어에서 뺌) — 2026-11-04 L1 135 내용어 전수 검토
FIX = {
    'فاطمة': None, 'ماشاء': None, 'الحمد': None, 'بإذن': None, 'دهب': None,  # 이름·지명 · 굳은 표현(ما شاء الله·الحمد لله·بإذن الله)
    # 단어장 뜻이 이 문장의 뜻과 다른 말(잘못된 뜻을 보여 주느니 뺀다): نفضل 계속~하다 · عامل 어떻게 지내 · يوفقك 잘되길 · الشبكة 약혼 예물
    'نفضل': None, 'عامل': None, 'يوفقك': None, 'الشبكة': None, 'تصبح': None,
    'أبوها': 'أبو', 'كلت': 'اكل', 'كلتش': 'اكل',
    'قهوة': 'قهوة', 'هندسة': 'هندسة', 'كشري': 'كشري', 'واتساب': 'واتساب', 'ميرسي': 'ميرسي',
    'وحشاك': 'وحش', 'إمتى': 'إمتى', 'يعني': 'يعني', 'عشانكم': 'عشان', 'شكرا': 'شكرا',
    'كتير': 'كتير', 'أكتر': 'أكتر', 'الاتنين': 'اتنين',  # 구어 철자 그대로(분석기는 표준어 철자로 바꿈)
}

def _subseq(small, big):
    it = iter(big)
    return all(c in it for c in small)

def pick(dw, tok):
    """상위 분석 중 기본형의 자음(장모음 ا و ي 빼고)이 낱말 안에 순서대로 들어 있는 첫 분석 — 문맥 MLE 가 엉뚱한 표제어를 고르는 것(قهوة→قهي 등) 방지."""
    cands = [x.analysis for x in dw.analyses[:15]]
    t = key(tok)
    for a in cands:
        lx = key(a.get('lex') or '')
        if lx and _subseq(re.sub('[اوي]', '', lx), t): return a
    return cands[0] if cands else {}

def key(w): return re.sub('[أإآ]', 'ا', DIAC.sub('', w)).replace('ى', 'ي').replace('ة', 'ه').strip()

vocab = set()
with open(ROOT / 'assets/data/freq/lang_es_top.csv', encoding='utf-8') as f:
    for r in csv.DictReader(f): vocab.add(key(r['word']))

d = MLEDisambiguator.pretrained('calima-egy-r13')
path = ROOT / 'assets/data/dialogues/L1.json'
data = json.load(open(path, encoding='utf-8'))
miss = Counter(); ex = {}; tot = hit = 0
for ep in data['episodes']:
    for t in ep['turns']:
        toks = WORD.findall(re.sub(r'\{[a-z_]+\}', ' ', t.get('es') or ''))
        out = []
        for tok, dw in zip(toks, d.disambiguate(toks) if toks else []):
            if tok in FIX:
                if FIX[tok] is None: continue
                base = FIX[tok]
                out.append([tok, base, '']); tot += 1
                if key(base) in vocab or key(tok) in vocab: hit += 1  # 앱(WordLookup)도 기본형 → 문장 속 꼴 순으로 찾는다
                else: miss[base] += 1; ex.setdefault(base, t['es'])
                continue
            a = pick(dw, tok) if dw.analyses else {}
            if a.get('pos') not in KEEP: continue
            base = DIAC.sub('', a.get('lex') or tok)
            if not WORD.fullmatch(base): continue
            out.append([tok, base, '']); tot += 1
            if key(base) in vocab or key(tok) in vocab: hit += 1  # 앱(WordLookup)도 기본형 → 문장 속 꼴 순으로 찾는다
            else: miss[base] += 1; ex.setdefault(base, t['es'])
        t['lemmas'] = out
open(path, 'w', encoding='utf-8').write(json.dumps(data, ensure_ascii=False, indent=1) + '\n')
outp = ROOT.parent / 'data/review/write/missing_lemmas.csv'
outp.parent.mkdir(parents=True, exist_ok=True)
with open(outp, 'w', encoding='utf-8', newline='') as fo:
    w = csv.writer(fo); w.writerow(['lemma', 'reading', 'count', 'example'])
    for b, n in miss.most_common(): w.writerow([b, '', n, ex[b]])
print(f'내용어 {tot} · 단어장 있음 {hit / max(tot, 1):.0%} · 없는 레마 {len(miss)} → {outp}')

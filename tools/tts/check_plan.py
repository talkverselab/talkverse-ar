#!/usr/bin/python3
"""감정 계획 검사(아랍어). python3 tools/tts/check_plan.py [편id...] — 조각을 이으면 그 턴 본문(판별)과 같은지, 목소리·감정이 있는지."""
import json, re, sys
import ttslib as L
norm = lambda s: re.sub(r'[\s….,!?؟،«»"]', '', s)
ids = sys.argv[1:] or L.planned()
bad = 0
for ep in ids:
    P = json.load(open(f'{L.R}/data/tts/plan/{ep}.json', encoding='utf-8'))
    D = json.load(open(L.EP[ep], encoding='utf-8'))
    errs = [f'cast {k}' for k in D['speakers'] if k != 'A' and P['cast'].get(k) not in L.V['voices']]
    if len(set(P['cast'].values())) != len(P['cast']):
        errs.append(f"목소리 겹침 {P['cast']}")
    for t in D['turns']:
        T = P['turns'][str(t['num'])]
        for g in 'mf':
            segs = T.get('segs_f') if g == 'f' and T.get('segs_f') else T['segs']
            got = ''.join(s[1] for s in segs)
            if norm(got) != norm(L.side(t, g, 'ar')):
                errs.append(f"턴 {t['num']} {g}: {got} / {L.side(t, g, 'ar')}")
            for s in segs:
                if s[0] not in L.V['emotions']:
                    errs.append(f"턴 {t['num']} 감정 {s[0]}")
    if errs:
        bad += 1; print(ep, *errs[:8], sep='\n  ')
print('검사', len(ids), '문제', bad)

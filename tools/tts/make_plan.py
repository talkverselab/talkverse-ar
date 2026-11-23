#!/usr/bin/env python3
"""회화 편의 감정 열 → 음성 감정 계획 자동 생성(사용자 지시 2026-11-07, 감정을 손으로 다시 적지 않는다).
  python3 tools/tts/make_plan.py [편id...]   없으면 앱 에셋 편 전부 → data/tts/plan/<편id>.json
턴: `emotion`(턴 전체 한 감정) 또는 `segs`([감정, 본문] — 감정이 바뀌는 곳에서 나눔), 여성 학습자판은 `segs_f` 또는 `ar_f`+`emotion`.
배역(cast)은 편에 없어서 화자 이름·성별로 정한다(voices.json cast_rules): 고정 인물(كريم·يوسف·نور·مريم) → 그 목소리, عم·أبو·العجوز → uncle,
الجدة·أم → auntie, 나머지는 성별 공용 목소리 — 한 편 안에서 목소리가 겹치지 않게 다음 후보로. 감정은 voices.json 의 emotions 만 허용."""
import json, os, sys
import ttslib as L
V, C = L.V, L.V['cast_rules']


def cast(ep):
    used, out = set(), {}
    for k, name in ep['speakers'].items():
        if k == 'A':
            continue
        g = ep.get('gender', {}).get(k, 'm')
        pref = C['names'].get(name)
        if not pref and g == 'm' and (any(name.startswith(p) for p in C['old_m_prefix']) or name in C['old_m']):
            pref = 'uncle'
        if not pref and g == 'f' and (any(name.startswith(p) for p in C['old_f_prefix']) or name in C['old_f']):
            pref = 'auntie'
        for v in [pref] + C['pool'][g]:
            if v and v not in used and V['voices'][v]['g'] == g:
                out[k] = v; used.add(v); break
    return out


def main():
    ids = sys.argv[1:] or sorted(L.EP)
    errs, n = [], 0
    os.makedirs(f'{L.R}/data/tts/plan', exist_ok=True)
    for eid in ids:
        ep = json.load(open(L.EP[eid], encoding='utf-8'))
        P = {'ep': eid, 'cast': cast(ep), 'turns': {}}
        for k in ep['speakers']:
            if k != 'A' and k not in P['cast']:
                errs.append(f'{eid}: cast {k}')
        for t in ep['turns']:
            segs = t.get('segs') or ([[t['emotion'], t['ar']]] if t.get('emotion') else None)
            if not segs:
                errs.append(f"{eid} {t['num']}턴: 감정 없음"); continue
            T = {'segs': segs}
            if t.get('ar_f') and t['ar_f'] != t['ar']:
                T['segs_f'] = t.get('segs_f') or ([[t['emotion'], t['ar_f']]] if t.get('emotion') else None)
                if not T['segs_f']:
                    errs.append(f"{eid} {t['num']}턴: 여성판 조각 없음(segs_f)")
            for s in T['segs'] + (T.get('segs_f') or []):
                if s[0] not in V['emotions']:
                    errs.append(f"{eid} {t['num']}턴: 감정 {s[0]}")
            P['turns'][str(t['num'])] = T
        json.dump(P, open(f'{L.R}/data/tts/plan/{eid}.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        n += 1
    print(f'계획 {n}편', *errs, sep='\n')
    sys.exit(1 if errs else 0)


if __name__ == '__main__':
    main()

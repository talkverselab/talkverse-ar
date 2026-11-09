"""회화 초안 JSON → Grok 원고(data/review/grok/src/<id>.txt) — 헝가리어앱 형식(머리 줄 + 「화자 | 아랍어 | 독음 | 한국어 | note | emotion=」).
  python3 tools/grok_src.py data/review/write/samples_20261107/*.json
여성판(ar_f 등)은 원고에 넣지 않는다 — Grok 재작성 뒤 남성판 기준으로 다시 만든다."""
import json, os, sys

OUT = 'data/review/grok/src'
os.makedirs(OUT, exist_ok=True)


def emo(t):
    if t.get('segs'):
        return '+'.join(s[0] for s in t['segs'])
    return t.get('emotion') or 'neutral'


for path in sys.argv[1:]:
    d = json.load(open(path, encoding='utf-8'))
    sp = d.get('speakers') or {}
    b = ', '.join(f"{k}={v.get('name', v) if isinstance(v, dict) else v}" for k, v in sp.items() if k != 'A') if isinstance(sp, dict) else str(sp)
    tw = d.get('twist')
    head = [
        f"=== {d['id']}",
        f"kind: {d.get('kind', '')}",
        f"title: {d.get('title', '')}",
        f"emoji: {d.get('emoji', '')}",
        f"scene: {d.get('scene', '')}",
        f"b: {b}",
        f"register: {d.get('register', '')}",
        f"twist: {tw if tw is not None else ''} {d.get('twist_type', '')}".rstrip(),
        f"level: {d.get('level', '')}",
        f"expressions: {'; '.join((e.get('ar') or e.get('text') or '') if isinstance(e, dict) else str(e) for e in (d.get('expressions') or []))}",
    ]
    lines = []
    for t in d['turns']:
        extra = ''.join(f" | {k}={t[k]}" for k in ('at', 'read') if k in t)
        note = (t.get('note') or '').replace('|', '/').replace('\n', ' ')
        lines.append(f"{t['speaker']} | {t['ar']} | {t.get('rd', '')} | {t.get('ko', '')} | {note} | emotion={emo(t)}{extra}")
    open(f"{OUT}/{d['id']}.txt", 'w', encoding='utf-8').write('\n'.join(head + lines) + '\n')
    print(d['id'], len(lines))

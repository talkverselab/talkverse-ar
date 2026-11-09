#!/usr/bin/env python3
"""통과한 회화 편 JSON → 앱 에셋 assets/data/dialogues/R<레벨>/<주제>/<id>.json (2026-11-09).
  python3 tools/sync_dialogues.py ../data/review/write/samples_20261107/r*.json
`approved` 가 있는 편만 옮긴다. 리뷰 기록(review)·초안 표시(draft)는 앱에 넣지 않는다.
대상어 칸은 `ar`(여성 학습자판 `ar_f`·`rd_f`·`ko_f`) — 로더 `lib/services/dialogue_service.dart` 의 Dialogue.fromJson."""
import json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / 'assets/data/dialogues'
n = 0
for p in sys.argv[1:]:
    d = json.load(open(p, encoding='utf-8'))
    if not d.get('approved'):
        print('건너뜀(미통과)', d['id']); continue
    for k in ('review', 'draft', 'sample'):
        d.pop(k, None)
    out = ROOT / f"R{d['level']}" / d['island'] / f"{d['id']}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    n += 1; print(out.relative_to(ROOT.parent.parent.parent))
print(n, '편')

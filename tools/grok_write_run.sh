#!/bin/zsh
# 회화 Grok 새로 쓰기 회차(PC 크롬 9248, 빠른 모드 — 사용자 지시 2026-11-18 「무조건 그록으로 쓴걸로」).
# 방 하나에 N편 — 첫 메시지만 규칙(write_grok_ar.md) 첨부, 이후 편 id 한 줄. 답 3분 상한(넘으면 중지·답 버림).
#   zsh tools/grok_write_run.sh <편id>...      결과 data/review/grok/write/<id>.md, 로그는 표준 출력
cd "$(dirname "$0")/.."
export GROK_CDP_PORT=9248
mkdir -p data/review/grok/write
chat=""
for id in "$@"; do
  out=data/review/grok/write/$id.md
  [[ -s $out ]] && { echo "skip $id"; continue; }
  if [[ -z $chat ]]; then
    print -r -- "첨부한 write_grok_ar.md 가 이 방의 규칙이다. 앞으로는 편 id 한 줄만 보낸다. 첫 편: $id" > /private/tmp/claude-501/grok_ar_write_first.txt
    r=$(python3 tools/grok_text.py /private/tmp/claude-501/grok_ar_write_first.txt $out tools/prompts/write_grok_ar.md 2>&1)
  else
    r=$(python3 tools/grok_text.py -m "$id" $out --chat "$chat" 2>&1)
  fi
  rc=$?
  echo "$(date +%H:%M) $id rc=$rc $(echo $r | grep -E '저장|LIMIT|STOPPED' | tr '\n' ' ')"
  [[ $rc -eq 3 ]] && { echo "LIMIT — 멈춤"; exit 3; }
  [[ $rc -eq 4 ]] && { echo "3분 넘김 — 생성 중지, 답 버림"; rm -f $out; }
  c=$(echo $r | grep '^CHAT ' | awk '{print $2}' | sed 's/?.*//'); [[ -n $c ]] && chat=$c
  sleep 15
done
echo "끝 $chat"

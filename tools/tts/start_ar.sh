#!/bin/zsh
# 회화 음성 시작(uk 11-23: pt 「GPU 끝」 = 「ar 지금 시작」). zsh tools/tts/start_ar.sh [--night]
#   ① 신호는 세션이 받는다(이 스크립트는 신호 뒤에 띄움) ② PC job.log·moss_jobs.json 이 5분 넘게 그대로 + 작업 스케줄러 Ready 일 때 시작.
#   --night = 06:30 PAUSE(새 묶음 금지). 이어받기는 done.txt, 끼어들기는 ~/tts_work/ar/PAUSE.
W=~/tts_work/ar; mkdir -p $W; cd "$(dirname "$0")/../.."
idle() { python3 tools/tts/pc_idle.py; }   # 두 파일의 마지막 수정이 몇 초 전인지 + 작업 상태
while :; do
  o=($(idle)); s=${o[1]}; st=${o[2]}
  [[ -n $s ]] && (( s > 300 )) && [[ $st == Ready ]] && break
  echo "$(date +%T) PC 작업 파일 ${s}초 전 변경·상태 $st — 대기"; sleep 60
done
mem=$(ssh pc 'nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i 0' | tr -d ' \r')
echo "$(date +%T) 시작(작업 파일 ${s}초 그대로, 3090 ${mem}MiB)"
rm -f $W/PAUSE
pw=
if [[ $1 == --night ]]; then ( until [[ $(date +%H%M) -ge 0630 && $(date +%H) -lt 12 ]]; do sleep 30; done; touch $W/PAUSE; echo "$(date +%T) PAUSE 06:30" >> $W/run.log ) & pw=$!; fi
~/.venvs/tts_zh/bin/python tools/tts/run_all.py $W 3 --refs >> $W/run.log 2>&1
rc=$?
[[ -n $pw ]] && kill $pw 2>/dev/null
echo "$(date +%T) run_all exit $rc"; tail -6 $W/run.log; echo "끝난 편: $(grep -c . $W/done.txt 2>/dev/null) / 65"

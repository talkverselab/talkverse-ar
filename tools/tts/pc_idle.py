#!/usr/bin/env python3
"""PC TTS 작업이 비었는지: '<job.log·moss_jobs.json 중 가장 최근 수정이 몇 초 전> <작업 스케줄러 상태>' 를 한 줄로 낸다(3090 비었다 판정, uk 11-23)."""
import base64, subprocess
ps = r"""$n=Get-Date; $a=@('D:\tts_test\job\job.log','D:\tts_test\job\moss_jobs.json') | ForEach-Object { if (Test-Path $_) { [int]($n-(Get-Item $_).LastWriteTime).TotalSeconds } else { 99999 } }
"$(($a | Measure-Object -Minimum).Minimum) $((Get-ScheduledTask -TaskName 'TTS job 2060').State)" """
b = base64.b64encode(ps.encode('utf-16le')).decode()
o = subprocess.run(['ssh', 'Administrator@100.127.143.37', f'powershell -NoProfile -EncodedCommand {b}'], capture_output=True, text=True, errors='replace').stdout
print(o.strip().splitlines()[-1] if o.strip() else '0 Unknown')

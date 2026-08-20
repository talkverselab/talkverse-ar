# -*- coding: utf-8 -*-
"""이집트 방언 자막/대화 데이터 검증 — 이집트 구어 마커 밀도 측정."""
import sys, re, glob, os
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')

# 이집트 구어(عامية مصرية) 변별 마커
EG = {'ده','دي','دول','إيه','ايه','إزاي','ازاي','ليه','فين','مش','عايز','عاوز','عايزة','عاوزة',
      'دلوقتي','كده','كدا','بتاع','بتاعة','علشان','عشان','احنا','إحنا','خالص','أوي','اوي','قوي',
      'جامد','يلا','يالا','معلش','معليش','لسه','لسة','كمان','إزيك','ازيك','إمتى','امتى','منين',
      'حاجة','بقى','أهو','اهو','طب','زي'}
AR = re.compile(r'[؀-ۿ]+')

import pandas as pd
files = glob.glob(os.path.join(os.path.dirname(__file__),'**','*.parquet'), recursive=True) \
    or glob.glob(r'C:\Users\Johnjeon\.cache\huggingface\hub\datasets--fr3on--egyptian-dialogue\**\*.parquet', recursive=True)
df = pd.concat([pd.read_parquet(f) for f in files], ignore_index=True)
print('행수:', len(df), '| 컬럼:', list(df.columns))

# 아랍어(이집트) 텍스트 컬럼 자동 탐지: 아랍문자 비율 높은 컬럼
def arab_ratio(s):
    s=str(s); a=len(AR.findall(s)); return a/max(1,len(s.split()))
col=max(df.columns, key=lambda c: df[c].astype(str).head(200).map(lambda x: len(AR.findall(x))).sum())
print('이집트어 컬럼 추정:', col)
texts = df[col].astype(str).tolist()
print('\n샘플 5:')
for t in texts[:5]: print('  ', t[:90])

tot=hit=0; mc=Counter()
for t in texts:
    for w in AR.findall(t):
        tot+=1
        if w in EG: hit+=1; mc[w]+=1
print(f'\n총 토큰 {tot:,} | 이집트 마커 {hit:,} = {hit/max(1,tot)*100:.2f}%')
print('상위 마커:', ', '.join(f'{k}:{v}' for k,v in mc.most_common(15)))
print('판정:', 'PASS 이집트 방언 반영됨' if hit/max(1,tot)>=0.01 else '약함')

#!/usr/bin/env python3
"""편 JSON 들 → 사용자 리뷰용 단일 HTML(폰 열람). python3 tools/review_html.py <출력.html> <편.json>...
일본어앱 `ja/tools/review_html.py`(2026-11-06) 를 아랍어유니버스에 맞게 고친 것(2026-11-09):
- 대상어 칸 = `ar`(RTL, 아랍어 글꼴 크게), 독음 `rd`, 한국어 `ko`.
- 여성 학습자판: 턴에 `ar_f` 가 있으면 ♀ 줄(ar_f / rd_f / ko_f)을 같이 보인다.
- 감정: `emotion` 하나 또는 `segs`([감정, 조각]) — 문장 조각마다 감정 라벨을 붙여 보인다.
- 그림·음성은 아직 없어 넣지 않는다(생기면 ja 것처럼 붙인다). 저장 API 는 uk 세션의 `/api/review/ar`(없으면 폰 localStorage 에만)."""
import json, sys, html, datetime
from pathlib import Path

out = Path(sys.argv[1]); eps = [json.load(open(p, encoding='utf-8')) for p in sys.argv[2:]]
EMO = {'stiff': '긴장·딱딱', 'flustered': '당황', 'excited': '흥분', 'amused': '유쾌', 'teasing': '놀림', 'shout': '버럭', 'cheerful': '밝음', 'tsukkomi': '츳코미', 'gentle': '다정',
       'neutral': '담담', 'polite': '공손', 'sad': '슬픔', 'annoyed': '짜증', 'surprised': '놀람', 'shy': '수줍음', 'worried': '걱정'}
LEVEL = {0: '글자·소리', 1: '활용 골격', 2: '챗 실전', 3: '그래머2', 4: '어려운 문법', 5: '어휘 완주'}
TWIST = {'slip': '말실수', 'chaos': '소동', 'emotion': '심쿵', 'reveal': '밝혀짐', 'ignore': '딴청', 'misread': '오해'}
H = html.escape


def emo(t):
    """감정 표시 — segs 가 있으면 조각마다 [감정] 조각, 없으면 감정 하나."""
    if t.get('segs'):
        return ''.join(f"<span class=sg><b>{H(EMO.get(s[0], s[0]))}</b> <span dir=rtl lang=ar>{H(s[1])}</span></span>" for s in t['segs'])
    e = t.get('emotion', '')
    return f"<span class=sg><b>{H(EMO.get(e, e))}</b></span>" if e else ''


def fem(t):
    if not t.get('ar_f'):
        return ''
    kf = f"<div class=ko>{H(t['ko_f'])}</div>" if t.get('ko_f') else ''
    return (f"<div class=fv><div class=sp>♀ 여성 학습자판</div><div class=ar dir=rtl lang=ar>{H(t['ar_f'])}</div>"
            f"<div class=rd>{H(t.get('rd_f', ''))}</div>{kf}</div>")


def turn(e, t):
    key = f"{e['id']}:{t['num']}"
    at = f" · 💬 {t['at']}" if t.get('at') else ''
    if t.get('read') is False:
        at += ' · 읽지 않음'
    marks = []
    if t['num'] == e.get('twist'):
        marks.append(f"<span class=mk>반전</span>")
    if t['num'] == e.get('kick'):
        marks.append(f"<span class=mk>킥</span>")
    if t['ar'] == e.get('line'):
        marks.append(f"<span class=mk>암기 한 줄</span>")
    who = e['speakers'].get(t['speaker'], t['speaker'])
    return (f"<div class='t {t['speaker']}' id='{key}'><div class=sp>{t['num']} {t['speaker']} <span dir=rtl lang=ar>{H(who)}</span>{at} {' '.join(marks)}</div>"
            f"<div class=ar dir=rtl lang=ar>{H(t['ar'])}</div><div class=rd>{H(t.get('rd', ''))}</div><div class=ko>{H(t['ko'])}</div>"
            f"<div class=em>{emo(t)}</div>{fem(t)}"
            f"<div class=rv><textarea data-k='{key}' placeholder='이 턴 리뷰…'></textarea><button onclick=\"sv(this)\">저장</button></div><div class=rs data-s='{key}'></div></div>")


css = """body{font-family:-apple-system,'Noto Sans KR','Noto Naskh Arabic','Geeza Pro',sans-serif;max-width:860px;margin:0 auto;padding:16px;background:#fff;color:#0a2540;line-height:1.5}
h1{font-size:20px}h2{font-size:17px;margin:28px 0 4px;color:#b77548}.meta{font-size:12px;color:#6b7c93;margin-bottom:12px}
.t{margin:10px 0;padding:10px 12px;border-radius:12px;background:#f6f8fb;border:1px solid #e6ebf1}.t.A{background:#fff7f0}
.sp{font-size:11px;color:#6b7c93}.ar{font-size:22px;font-weight:600;text-align:right;font-family:'Noto Naskh Arabic','Geeza Pro','Al Bayan',serif;line-height:1.7}.rd{font-size:13px;color:#635bff}.ko{font-size:14px}
.ok{display:inline-block;font-size:11px;padding:1px 6px;border-radius:8px;background:#e6f4ea;color:#1b7f3b}.dr{display:inline-block;font-size:11px;padding:1px 6px;border-radius:8px;background:#fff1e0;color:#b77548}
.mk{display:inline-block;font-size:10.5px;padding:0 6px;border-radius:8px;background:#ece9ff;color:#635bff;margin-left:2px}
.nav a{display:inline-block;margin:2px 6px 2px 0;font-size:12px;color:#635bff}
.rv{display:flex;gap:6px;margin-top:8px}.rv textarea{flex:1;min-height:38px;border:1px solid #cfd8e3;border-radius:8px;padding:6px 8px;font:inherit;font-size:14px;background:#fff;color:#0a2540;resize:vertical}
.rv button{border:0;border-radius:8px;padding:0 12px;background:#635bff;color:#fff;font-size:13px;cursor:pointer}.rv button.ok{background:#1b7f3b}.rv button.err{background:#b42318}
.rs{font-size:11px;color:#6b7c93;margin-top:2px}.ep{margin:0 0 6px}.ep textarea{min-height:46px}
.em{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;font-size:12px}.sg{display:inline-flex;gap:6px;align-items:baseline;padding:2px 8px;border-radius:10px;background:#fff;border:1px solid #e6ebf1;color:#0a2540}.sg b{color:#b77548;font-weight:600}.sg span{font-family:'Noto Naskh Arabic','Geeza Pro',serif;font-size:14px}
.fv{margin-top:8px;padding:8px 10px;border-radius:10px;background:#fdf2f8;border:1px dashed #e9a7c9}.fv .ar{font-size:19px}
.expr{font-size:12.5px;color:#0a2540;margin:4px 0 8px}.expr span{display:inline-block;margin:2px 4px 2px 0;padding:1px 8px;border-radius:10px;background:#f0f3f7;font-family:'Noto Naskh Arabic','Geeza Pro',serif}
.box{margin:10px 0;padding:10px 12px;border:1px solid #e6ebf1;border-radius:12px;font-size:13px;background:#fafbfd}"""
parts = [f"<!doctype html><html lang=ko><head><meta charset=utf-8><meta name=viewport content='width=device-width,initial-scale=1'><title>아랍어 회화 리뷰</title><style>{css}</style></head><body>",
         f"<h1>아랍어유니버스 회화 리뷰 시트</h1><div class=meta>갱신 {datetime.datetime.now():%Y-%m-%d %H:%M} · 카이로 이집트 구어 · 턴마다 아랍어(오른쪽에서 왼쪽) / 카이로식 한글 독음 / 한국어 · 분홍 칸 = 학습자가 여성일 때 바뀌는 말 · 감정 라벨은 음성 생성용 · 고칠 곳은 편 id·턴 번호로</div>"
         f"<div class=box>독음 규칙: ج=ㄱ, ق 는 초성 없이 끊김(قهوة 아흐와), ع 는 모음으로(نعناع 니으나아). 학습자 A 의 이름 자리는 {{name}} 그대로.</div><div class=nav>"]
parts += [f"<a href='#{e['id']}'>{H(e.get('emoji', ''))} {H(e['title'])}</a>" for e in eps] + ['</div>']
for e in eps:
    tag = f"<span class=ok>통과 {H(e['approved'])}</span>" if e.get('approved') else "<span class=dr>리뷰 대기</span>"
    g = e.get('gender', {})
    sp = ' · '.join(f"{k}=<span dir=rtl lang=ar>{H(v)}</span>({'여' if g.get(k) == 'f' else '남'})" for k, v in e['speakers'].items())
    lv = e.get('level', 0)
    tw = e.get('twist_type', '')
    parts.append(f"<h2 id='{e['id']}'>{H(e.get('emoji', ''))} {H(e['title'])} <small>{e['id']}</small></h2>"
                 f"<div class='rv ep'><textarea data-k='{e['id']}:all' placeholder='이 편 전체 리뷰 — 통과 / 다시 / 턴이 너무 짧다 등…'></textarea><button onclick=\"sv(this)\">저장</button></div><div class=rs data-s='{e['id']}:all'></div>"
                 f"<div class=meta>{tag}<br>{H(e['scene'])}<br>레벨 {lv} {LEVEL.get(lv, '')} · {H(e.get('kind', ''))} · {H(e.get('register', ''))} · 턴 {len(e['turns'])} · 반전 {e.get('twist')}턴({TWIST.get(tw, tw)}) · 킥 {e.get('kick')}턴 · {sp}</div>"
                 + (f"<div class=expr>표현 풀: {''.join(f'<span dir=rtl lang=ar>{H(x)}</span>' for x in e['expressions'])}</div>" if e.get('expressions') else '')
                 + (f"<div class=meta>문법: {H(e['grammar_item'])}</div>" if e.get('grammar_item') else ''))
    for t in e['turns']:
        parts.append(turn(e, t))
    if e.get('review', {}).get('final'):
        parts.append(f"<div class=meta>최종: {H(e['review']['final'])}</div>")
parts.append("""<script>
const API='https://talkverse.uk/api/review/ar';  // uk 세션이 여는 저장 API(POST {key,text,at} / GET → {key:{text,at}})
const LS='review_ar_v1';
function ld(){try{return JSON.parse(localStorage.getItem(LS)||'{}')}catch(e){return {}}}
function st(k,m,c){const el=document.querySelector(`[data-s="${k}"]`);if(el){el.textContent=m;}const b=document.querySelector(`[data-k="${k}"]`).nextElementSibling;b.className=c||'';}
function fill(d){for(const k in d){const t=document.querySelector(`[data-k="${k}"]`);if(t&&!t.value){t.value=d[k].text||'';const s=document.querySelector(`[data-s="${k}"]`);if(s)s.textContent='저장됨 '+(d[k].at||'');}}}
async function sv(btn){const ta=btn.previousElementSibling,k=ta.dataset.k,text=ta.value.trim(),at=new Date().toLocaleString('ko-KR',{hour12:false});
 const d=ld();d[k]={text,at};try{localStorage.setItem(LS,JSON.stringify(d))}catch(e){}
 st(k,'저장 중…','');
 try{const r=await fetch(API,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({key:k,text,at})});
  if(!r.ok)throw new Error(r.status);st(k,'서버 저장됨 '+at,'ok');}
 catch(e){st(k,'폰에만 저장됨 '+at+' (서버 연결 안 됨)','err');}}
(async()=>{fill(ld());try{const r=await fetch(API);if(r.ok){fill(await r.json());}}catch(e){}})();
</script></body></html>""")
out.write_text('\n'.join(parts), encoding='utf-8'); print(out, len(eps))

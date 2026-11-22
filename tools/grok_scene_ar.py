# -*- coding: utf-8 -*-
"""아랍어 회화 장면 컷(편마다 1컷, 글자·말풍선 없음)을 Grok(PC 크롬 9248, 「빠른」)에 4편씩 한 방에서 요청하고
받은 그림을 1168×784 jpg 로 ~/talkverse/ar-art/scene/ar/<편id>/cut1.jpg 에 둔다(ja tools/grok_scene_batch.py 꼴, 2026-11-22).
앱은 컷이 하나뿐이면 모든 턴에 가장 가까운 컷(=cut1)을 쓴다(ArtService.sceneCut).
  GROK_CDP_PORT=9248 python3 grok/grok_scene_ar.py <편id> ... [--chat <방 주소>]
첨부 = 인물 시트 chars_ar_v2.jpg + 톤 clay_389_tomodachi.png (PC D:\\grok_att\\ar\\ 로 scp). 한 요청 3분 상한 — 넘으면 생성 중지."""
import base64, glob, json, os, subprocess, sys, time, urllib.request
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import grok_cdp as G

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APP = os.path.join(ROOT, 'app')
ART = os.path.join(ROOT, 'data/review/art')
OUT = os.path.expanduser('~/talkverse/ar-art/scene/ar')
ATTS = [os.path.join(ART, 'chars_ar_v2.jpg'), os.path.join(ART, 'ref/clay_389_tomodachi.png')]
PC_ATT = 'D:/grok_att/ar/'
CAST = {
    'نور': '시트 1번 누르(20대 초 여성, 연한 복숭아색 히잡, 크림 오버핏 셔츠, 하늘색 와이드 데님, 흰 스니커즈, 크로스백)',
    'مريم': '시트 2번 마리암(20대 초 여성, 히잡 없이 검은 곱슬머리 반묶음, 올리브 린넨 셔츠, 검은 바지, 갈색 샌들, 도면 통)',
    'كريم': '시트 3번 카림(20대 중반 남성·가장 키 큼, 짧은 흑발·단정한 짧은 수염, 소매 걷은 흰 셔츠, 짙은 갈색 앞치마)',
    'يوسف': '시트 4번 유세프(20대 초 남성, 검은 페이드 컷·윗머리 짧은 곱슬, 짙은 올리브 피부, 가는 콧수염, 노란 바람막이·회색 티·검은 조거, 헬멧)',
    '{name}': '시트 5번 남자 학습자(갈색 곱슬머리, 청록 후드티, 베이지 팬츠, 갈색 백팩)',
}


def who(n):
    return CAST.get(n) or f'{n}(시트에 없는 조연 — 역할에 맞는 차림의 이집트 사람, 같은 점토 톤, 실존 인물 닮지 않게)'


def load(eid):
    f = glob.glob(os.path.join(APP, f'assets/data/dialogues/R*/*/{eid}.json'))[0]
    return json.load(open(f, encoding='utf-8'))


def prompt(eps, part):
    ls = []
    for k, ep in enumerate(eps, 1):
        cast = ', '.join(f'{s} = {who(v)}' for s, v in ep['speakers'].items())
        t = ' / '.join(f"{x['speaker']}「{x['ko']}」" for x in ep['turns'][:2])
        ls.append(f"그림{k} [{ep['id']}] 장면: {ep['scene']}\n  등장: {cast}\n  첫 대화(그리지 말고 분위기만): {t}")
    return (f"[SC-AR-{part}] **이미지 {len(eps)}장을 생성해 주세요**(글 설명 없이 그림만, 그림마다 한 장씩 따로 {len(eps)}장). 아랍어 학습 앱 회화의 장면 컷입니다.\n"
            "첨부 1 = 우리 앱 인물 기준 시트(왼쪽부터 1~6번, 얼굴·머리·옷을 그대로), 첨부 2 = 그림 톤 참고.\n"
            "톤: 부드러운 펠트·점토 인형, 파스텔·크림 배경, 둥근 얼굴, 따뜻한 조명, 오늘의 카이로·이집트 실제 장소 느낌(관광 엽서식 고정관념 없이). 3:2 가로. "
            "**그림 안에 글자·말풍선·간판 글씨·로고 없음**(말풍선은 앱이 얹습니다). 실존 인물·브랜드 금지.\n\n"
            + '\n'.join(ls) + f"\n\n지금 바로 이미지 {len(eps)}장을 생성하세요(순서대로 그림1, 그림2 …).")


IMGS = "[...document.querySelectorAll('img')].filter(i=>i.src.includes('assets.grok.com/')&&i.src.includes('/generated/')&&i.naturalWidth>=300).map(i=>i.src)"
BUSY = ("!![...document.querySelectorAll('button')].find(e=>/응답 중지|Stop/.test(e.getAttribute('aria-label')||''))"
        "||[...document.querySelectorAll('img')].some(i=>i.src.startsWith('data:image')&&i.naturalWidth>200)")


def fetch(c, url):
    d = c.ev("fetch(%s,{credentials:'include'}).then(r=>r.blob()).then(b=>new Promise(ok=>{const f=new FileReader();f.onload=()=>ok(f.result);f.readAsDataURL(b)}))" % json.dumps(url))
    return base64.b64decode(d.split(',', 1)[1]) if isinstance(d, str) and d.startswith('data:') else None


def fit(src, dst):
    o = subprocess.run(['sips', '-g', 'pixelWidth', '-g', 'pixelHeight', src], capture_output=True, text=True).stdout.split()
    w, h = int(o[o.index('pixelWidth:') + 1]), int(o[o.index('pixelHeight:') + 1])
    cw, ch = (int(h * 1.5), h) if w / h > 1.5 else (w, int(w / 1.5))
    subprocess.run(['sips', '-s', 'format', 'jpeg', '-s', 'formatOptions', '88', '--cropToHeightWidth', str(ch), str(cw), src, '--out', dst], capture_output=True)
    subprocess.run(['sips', '-z', '784', '1168', dst], capture_output=True)


def send(c, text, remote):
    for _ in range(40):
        if c.ev("!!(%s)" % G.FIND):
            break
        time.sleep(1)
    time.sleep(3)
    if remote:
        doc = c.call('DOM.getDocument', depth=-1, pierce=True)
        node = c.call('DOM.querySelector', nodeId=doc['root']['nodeId'], selector='input[type=file]')
        c.call('DOM.setFileInputFiles', nodeId=node['nodeId'], files=remote)
        time.sleep(4 + 2 * len(remote))
    model = c.ev("[...document.querySelectorAll('button')].map(b=>b.getAttribute('aria-label')||'').find(x=>/^모델/.test(x))||''")
    if '빠른' not in model:
        raise SystemExit('Grok 모델이 빠른이 아님: ' + model)
    c.ev("(()=>{const e=%s;e.focus();return 1})()" % G.FIND)
    c.call('Input.insertText', text=text)
    time.sleep(1)
    for typ in ('keyDown', 'keyUp'):
        c.call('Input.dispatchKeyEvent', type=typ, key='Enter', code='Enter', windowsVirtualKeyCode=13, nativeVirtualKeyCode=13)
    time.sleep(3)
    left = c.ev("(()=>{const e=%s;return e?(e.value||e.innerText||'').trim().length:-1})()" % G.FIND)
    if left and left > 0:
        c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(x=>/제출|보내기|Submit|Send/.test(x.getAttribute('aria-label')||''));if(b){b.click();return 1}return 0})()")
        time.sleep(3)


def stop(c):
    c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(e=>/중지|stop/i.test((e.getAttribute('aria-label')||'')+' '+e.innerText));if(b){b.click();return 1}return 0})()")


def main():
    a = sys.argv[1:]
    chat = ''
    if '--chat' in a:
        i = a.index('--chat'); chat = a[i + 1]; del a[i:i + 2]
    eps = [load(e) for e in a]
    todo = [e for e in eps if not os.path.exists(os.path.join(OUT, e['id'], 'cut1.jpg'))]
    subprocess.run(['ssh', 'pc', 'cmd /c if not exist D:\\grok_att\\ar mkdir D:\\grok_att\\ar'], capture_output=True)
    remote = []
    for p in ATTS:
        subprocess.run(['scp', '-q', p, 'pc:' + PC_ATT], check=True)
        remote.append((PC_ATT + os.path.basename(p)).replace('/', '\\'))
    t = json.load(urllib.request.urlopen(urllib.request.Request(G.BASE + '/json/new?' + (chat or 'https://grok.com/'), method='PUT')))
    c = G.CDP(t); c.call('Page.bringToFront')
    for part, k in enumerate(range(0, len(todo), 4), 1):
        chunk = todo[k:k + 4]
        before = set(c.ev(IMGS) or [])
        lim0 = c.ev("(document.body.innerText.match(/한도에 도달|limit reached/g)||[]).length") or 0
        send(c, prompt(chunk, part), remote if part == 1 else [])
        t0, new = time.time(), []
        while time.time() - t0 < 180:  # 3분 상한(사용자 지시)
            time.sleep(10)
            if (c.ev("(document.body.innerText.match(/한도에 도달|limit reached/g)||[]).length") or 0) > lim0:
                print('LIMIT', flush=True); sys.exit(3)
            new = []
            for s in c.ev(IMGS) or []:
                if s not in before and s not in new:
                    new.append(s)
            if len(new) >= len(chunk) and not c.ev(BUSY):
                break
        print('CHAT', c.ev('location.href'), flush=True)
        if len(new) < len(chunk):
            stop(c); print('FAIL', part, '그림', len(new), '/', len(chunk), flush=True); sys.exit(4)
        for ep, url in zip(chunk, new):
            b = fetch(c, url)
            if not b:
                print('FAIL 받기', ep['id'], flush=True); sys.exit(5)
            d = os.path.join(OUT, ep['id']); os.makedirs(d, exist_ok=True)
            raw = os.path.join(d, '.raw'); open(raw, 'wb').write(b)
            fit(raw, os.path.join(d, 'cut1.jpg')); os.remove(raw)
            print('OK', ep['id'], flush=True)
    print('DONE', len(todo), flush=True)


main()

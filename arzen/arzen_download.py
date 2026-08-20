# -*- coding: utf-8 -*-
"""Playwright로 Mendeley ArzEn-MultiGenre 다운로드.
페이지 로드 중 files API 응답을 가로채 다운로드 URL 확보 → 세션으로 직접 저장.
클릭 기반 'Download all' 폴백 포함."""
import sys, os, json, time
sys.stdout.reconfigure(encoding='utf-8')
from playwright.sync_api import sync_playwright

OUT = os.path.dirname(os.path.abspath(__file__))
URL = "https://data.mendeley.com/datasets/6k97jty9xg/5"
captured = []

with sync_playwright() as p:
    br = p.chromium.launch(headless=True)
    ctx = br.new_context(accept_downloads=True)
    page = ctx.new_page()

    def on_resp(r):
        u = r.url
        if 'file' in u.lower() and ('mendeley' in u or 'amazonaws' in u):
            try:
                if 'application/json' in (r.headers.get('content-type','')):
                    captured.append((u, r.json()))
            except Exception: pass
    page.on("response", on_resp)

    print("페이지 로드...", flush=True)
    page.goto(URL, wait_until="networkidle", timeout=90000)
    time.sleep(5)

    # 1) 가로챈 JSON에서 파일 다운로드 URL 추출
    urls = []
    for u, j in captured:
        items = j if isinstance(j, list) else (j.get('files') or j.get('results') or [])
        if isinstance(items, dict): items=[items]
        for it in (items or []):
            cd = (it.get('content_details') or {}) if isinstance(it,dict) else {}
            du = cd.get('download_url') or (it.get('content_details',{}) if isinstance(it,dict) else {})
            fn = it.get('filename') or it.get('name') if isinstance(it,dict) else None
            durl = cd.get('download_url')
            if durl: urls.append((fn or 'file', durl))
    print(f"가로챈 파일 URL: {len(urls)}", flush=True)

    if urls:
        for fn, durl in urls:
            try:
                resp = ctx.request.get(durl, timeout=120000)
                dest = os.path.join(OUT, fn)
                with open(dest,'wb') as f: f.write(resp.body())
                print(f"  저장: {fn} ({len(resp.body())} bytes)", flush=True)
            except Exception as e:
                print(f"  실패 {fn}: {str(e)[:100]}", flush=True)
    else:
        # 2) 폴백: 'Download all' 버튼 클릭
        print("JSON 미포착 → 'Download all' 버튼 시도", flush=True)
        clicked=False
        for sel in ["text=/Download all/i","text=/Download All/","button:has-text('Download')","a:has-text('Download')"]:
            try:
                el=page.locator(sel).first
                if el.count()>0:
                    with page.expect_download(timeout=120000) as di:
                        el.click()
                    d=di.value; dest=os.path.join(OUT, d.suggested_filename); d.save_as(dest)
                    print(f"  다운로드(클릭): {dest}", flush=True); clicked=True; break
            except Exception as e:
                print(f"  셀렉터 {sel} 실패: {str(e)[:80]}", flush=True)
        if not clicked:
            # 페이지 HTML 덤프(디버그)
            open(os.path.join(OUT,'_mendeley_rendered.html'),'w',encoding='utf-8').write(page.content())
            print("  버튼 못 찾음 → 렌더HTML 덤프함", flush=True)
    br.close()
print("=== 받은 파일 ===", flush=True)
for f in os.listdir(OUT):
    if f.endswith(('.zip','.xlsx','.csv','.txt','.tsv')) and not f.startswith('_'):
        print(f"  {f}  {os.path.getsize(os.path.join(OUT,f))} bytes")

"""회화 음성 공통(이집트 아랍어): 감정 계획 + 편 JSON → 턴별 남성판·여성판. 포르투갈어앱 tools/tts/ttslib.py 와 같은 구조.
편 파일은 하나(`app/assets/data/dialogues/R*/<주제>/<id>.json`) — 여성 학습자판은 같은 턴의 `ar_f`·`rd_f`·`ko_f`(없으면 남성판과 같음).
D1 audio_lines 열: text = 아랍어 본문, reading = 빈 값, rd = 한글 독음, ko = 한국어 뜻. 소리 낼 글이 없는 턴만 뺀다.
계획(data/tts/plan/<편id>.json, make_plan.py 가 만듦): turns[num] = {segs, segs_f?} — 조각 [감정, 글(, 읽기)]."""
import glob, json, os, re
R = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
V = json.load(open(f'{R}/data/tts/voices.json', encoding='utf-8'))
EP = {os.path.basename(p)[:-5]: p for p in glob.glob(f'{R}/app/assets/data/dialogues/R*/*/*.json')}
SIL = re.compile(r'[\s….,!?؟،«»"\-—]')


def fill(s, g, key='text'):
    for k, x in V['fill'].items():
        s = s.replace(k, (x.get(g) or x)[key])
    return s


def say(s):
    """소리 낼 때만 바꿔 읽는 글(숫자 등)."""
    for k, x in V.get('say', {}).items():
        s = s.replace(k, x)
    return s


def side(t, g, k):
    return t.get(f'{k}_f') or t[k] if g == 'f' else t[k]


def turns(ep):
    P = json.load(open(f'{R}/data/tts/plan/{ep}.json', encoding='utf-8'))
    D = json.load(open(EP[ep], encoding='utf-8'))
    out = []
    for t in D['turns']:
        T = P['turns'][str(t['num'])]; row = {'num': t['num'], 'speaker': t['speaker']}
        for g in 'mf':
            src = T.get('segs_f') if g == 'f' and T.get('segs_f') else T['segs']
            segs = [(s[0], fill(say(s[-1]), g).strip()) for s in src]
            segs = [s for s in segs if SIL.sub('', s[1])]
            row[g] = {'voice': ('am' if g == 'm' else 'af') if t['speaker'] == 'A' else P['cast'][t['speaker']],
                      'text': fill(side(t, g, 'ar'), g), 'reading': '', 'rd': fill(side(t, g, 'rd'), g, 'rd'), 'ko': fill(side(t, g, 'ko'), g, 'ko'), 'segs': segs}
        if not row['m']['segs'] or not row['f']['segs']:
            continue
        row['same'] = row['m']['voice'] == row['f']['voice'] and row['m']['segs'] == row['f']['segs']
        out.append(row)
    return out


def seg_files(ep):
    """생성할 조각 [(파일이름, 목소리, 감정, 읽기)] — 두 판이 같으면 c 하나, 다르면 m·f."""
    out = []
    for r in turns(ep):
        for tag in (['c'] if r['same'] else ['m', 'f']):
            x = r['m' if tag == 'c' else tag]
            for i, (emo, text) in enumerate(x['segs']):
                out.append((f"{r['num']:02d}_{i}_{tag}.wav", x['voice'], emo, text))
    return out


def planned():
    return sorted(os.path.basename(p)[:-5] for p in glob.glob(f'{R}/data/tts/plan/*.json') if os.path.basename(p)[:-5] in EP)

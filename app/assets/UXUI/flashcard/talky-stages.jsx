// Talky 7-stage status display
// Stage 1: 웃음 (Day 1)         — bright, fresh start
// Stage 2: 화이팅 (Day 2)        — pumped, fist up
// Stage 3: 굳은 결심 (Day 3)     — smile + determined
// Stage 4: 걱정 (Day 4)         — worried sweat
// Stage 5: 꼬라봄 (Day 5)       — side-eye glare
// Stage 6: 무릎꿇고 빔 (Day 6)  — pleading, hands clasped
// Stage 7: 체념 (Day 7+)        — squat, slacking, sass

const INK = '#1F3A6E';
const MINT_A = '#EAF7EF';
const MINT_B = '#A8E0BD';
const PEACH  = '#FFB59C';
const PINK   = '#FF8FB1';
const SWEAT  = '#7BC8E0';

function TalkyStage({stage = 1, size = 200, style = {}}) {
  const id = React.useId().replace(/[:]/g, '');
  return (
    <svg width={size} height={size} viewBox="0 0 240 240" style={style} fill="none">
      <defs>
        <radialGradient id={`body-${id}`} cx="38%" cy="32%" r="78%">
          <stop offset="0%" stopColor="#fff" stopOpacity="0.7"/>
          <stop offset="35%" stopColor={MINT_A}/>
          <stop offset="100%" stopColor={MINT_B}/>
        </radialGradient>
        <radialGradient id={`hand-${id}`} cx="40%" cy="35%" r="75%">
          <stop offset="0%" stopColor="#fff"/>
          <stop offset="100%" stopColor={MINT_A}/>
        </radialGradient>
        <style>{`
          @keyframes bob-${id}   { 0%,100%{transform:translateY(0) rotate(0)} 50%{transform:translateY(-4px) rotate(-1.5deg)} }
          @keyframes pump-${id}  { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
          @keyframes shake-${id} { 0%,100%{transform:rotate(-2deg)} 50%{transform:rotate(2deg)} }
          @keyframes drip-${id}  { 0%{transform:translateY(0); opacity:0} 30%{opacity:1} 100%{transform:translateY(14px); opacity:0} }
          @keyframes side-${id}  { 0%,40%{transform:translateX(0)} 50%,90%{transform:translateX(-3px)} 100%{transform:translateX(0)} }
          @keyframes plead-${id} { 0%,100%{transform:translateY(0) scale(1)} 50%{transform:translateY(2px) scale(0.97)} }
          @keyframes tap-${id}   { 0%,100%{transform:rotate(0)} 50%{transform:rotate(8deg)} }
          @keyframes aura-${id}  { 0%,100%{transform:translateY(0) scaleY(1); opacity:0.85} 50%{transform:translateY(-4px) scaleY(1.15); opacity:1} }
          @keyframes spark-${id} { 0%,100%{opacity:0.4; transform:scale(0.9)} 50%{opacity:1; transform:scale(1.2)} }
          @keyframes wave-${id}  { 0%,100%{transform:rotate(-8deg)} 50%{transform:rotate(8deg)} }
          .anim-bob-${id}   { animation: bob-${id} 2.4s ease-in-out infinite; transform-origin: 120px 130px; }
          .anim-pump-${id}  { animation: pump-${id} 0.6s ease-in-out infinite; transform-origin: center; }
          .anim-shake-${id} { animation: shake-${id} 1.2s ease-in-out infinite; transform-origin: 120px 130px; }
          .anim-drip-${id}  { animation: drip-${id} 1.8s ease-in infinite; }
          .anim-side-${id}  { animation: side-${id} 3s ease-in-out infinite; }
          .anim-plead-${id} { animation: plead-${id} 1.4s ease-in-out infinite; transform-origin: 120px 130px; }
          .anim-tap-${id}   { animation: tap-${id} 1.4s ease-in-out infinite; transform-origin: 145px 175px; }
          .anim-aura-${id}  { animation: aura-${id} 1.4s ease-in-out infinite; transform-origin: 120px 200px; }
          .anim-spark-${id} { animation: spark-${id} 0.9s ease-in-out infinite; transform-origin: center; transform-box: fill-box; }
          .anim-wave-${id}  { animation: wave-${id} 1.2s ease-in-out infinite; transform-origin: 75px 95px; }
        `}</style>
      </defs>

      {/* ground shadow (always present) */}
      <ellipse cx="120" cy="222" rx="62" ry="5" fill="rgba(31,58,110,0.12)"/>

      {stage === 1 && <Stage1 id={id}/>}
      {stage === 2 && <Stage2 id={id}/>}
      {stage === 3 && <Stage3 id={id}/>}
      {stage === 4 && <Stage4 id={id}/>}
      {stage === 5 && <Stage5 id={id}/>}
      {stage === 6 && <Stage6 id={id}/>}
      {stage === 7 && <Stage7 id={id}/>}
    </svg>
  );
}

// ─── Shared body parts ────────────────────────────────
function GlobeBody({id, eyes = 'open', mouth = 'smile', cheekColor = PEACH, extras = null}) {
  return (
    <>
      {/* Earth body */}
      <circle cx="120" cy="120" r="78" fill={`url(#body-${id})`} stroke={INK} strokeWidth="5"/>
      {/* cheeks */}
      <ellipse cx="86" cy="138" rx="11" ry="6" fill={cheekColor} opacity="0.65"/>
      <ellipse cx="154" cy="138" rx="11" ry="6" fill={cheekColor} opacity="0.65"/>
      <Eyes id={id} kind={eyes}/>
      {/* nose */}
      <ellipse cx="120" cy="138" rx="3" ry="2" fill={INK} opacity="0.5"/>
      <Mouth kind={mouth}/>
      {extras}
    </>
  );
}

function Eyes({id, kind}) {
  if (kind === 'closed-happy') {
    return <g stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none">
      <path d="M 95 122 Q 103 112, 111 122"/>
      <path d="M 129 122 Q 137 112, 145 122"/>
    </g>;
  }
  if (kind === 'determined') {
    return <g stroke={INK} strokeWidth="5" strokeLinecap="round" fill={INK}>
      {/* slight angry-smile eyes (^^) */}
      <path d="M 92 122 Q 103 116, 113 122 Q 113 124, 92 124 Z"/>
      <path d="M 127 122 Q 137 116, 148 122 Q 148 124, 127 124 Z"/>
    </g>;
  }
  if (kind === 'worried') {
    return <g fill={INK}>
      <ellipse cx="103" cy="122" rx="8" ry="10"/>
      <ellipse cx="137" cy="122" rx="8" ry="10"/>
      <circle cx="106" cy="118" r="2.8" fill="#fff"/>
      <circle cx="140" cy="118" r="2.8" fill="#fff"/>
      {/* worry eyebrows angled inward */}
      <path d="M 88 104 Q 100 102, 110 108" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
      <path d="M 152 104 Q 140 102, 130 108" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
    </g>;
  }
  if (kind === 'sideeye') {
    return <g>
      {/* eyes shifted right, narrowed */}
      <ellipse cx="105" cy="122" rx="9" ry="7" fill="#fff" stroke={INK} strokeWidth="3"/>
      <ellipse cx="139" cy="122" rx="9" ry="7" fill="#fff" stroke={INK} strokeWidth="3"/>
      <ellipse cx="111" cy="122" rx="4" ry="5" fill={INK}/>
      <ellipse cx="145" cy="122" rx="4" ry="5" fill={INK}/>
      {/* annoyed brow */}
      <path d="M 88 104 L 112 108" stroke={INK} strokeWidth="5" strokeLinecap="round"/>
      <path d="M 128 108 L 152 104" stroke={INK} strokeWidth="5" strokeLinecap="round"/>
    </g>;
  }
  if (kind === 'pleading') {
    return <g>
      {/* huge wet puppy eyes */}
      <ellipse cx="103" cy="122" rx="11" ry="13" fill={INK}/>
      <ellipse cx="137" cy="122" rx="11" ry="13" fill={INK}/>
      <circle cx="107" cy="116" r="4.5" fill="#fff"/>
      <circle cx="141" cy="116" r="4.5" fill="#fff"/>
      <circle cx="100" cy="126" r="2.5" fill="#fff"/>
      <circle cx="134" cy="126" r="2.5" fill="#fff"/>
      {/* sad brows */}
      <path d="M 86 102 Q 96 110, 112 108" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
      <path d="M 154 102 Q 144 110, 128 108" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
    </g>;
  }
  if (kind === 'dead') {
    return <g stroke={INK} strokeWidth="5" strokeLinecap="round" fill="none">
      {/* x x dead eyes */}
      <path d="M 96 116 L 110 128 M 110 116 L 96 128"/>
      <path d="M 130 116 L 144 128 M 144 116 L 130 128"/>
    </g>;
  }
  if (kind === 'halflid') {
    return <g>
      {/* half-closed bored eyes — heavy upper lid covering pupil */}
      <path d="M 90 120 Q 103 116, 116 120 L 116 124 Q 103 122, 90 124 Z" fill={INK}/>
      <path d="M 124 120 Q 137 116, 150 120 L 150 124 Q 137 122, 124 124 Z" fill={INK}/>
      {/* tiny dot pupils peeking out */}
      <circle cx="103" cy="126" r="2.5" fill={INK}/>
      <circle cx="137" cy="126" r="2.5" fill={INK}/>
      {/* eyebags / under-eye lines */}
      <path d="M 94 132 Q 103 134, 112 132" stroke={INK} strokeWidth="1.8" fill="none" opacity="0.5"/>
      <path d="M 128 132 Q 137 134, 146 132" stroke={INK} strokeWidth="1.8" fill="none" opacity="0.5"/>
    </g>;
  }
  // 'open' default — big shiny eyes
  return <g>
    <ellipse cx="103" cy="120" rx="9" ry="11" fill={INK}/>
    <ellipse cx="137" cy="120" rx="9" ry="11" fill={INK}/>
    <circle cx="106" cy="115" r="3.2" fill="#fff"/>
    <circle cx="140" cy="115" r="3.2" fill="#fff"/>
    <circle cx="100" cy="124" r="1.5" fill="#fff"/>
    <circle cx="134" cy="124" r="1.5" fill="#fff"/>
  </g>;
}

function Mouth({kind}) {
  if (kind === 'open-cheer') {
    return <g>
      <path d="M 102 148 Q 120 168, 138 148 Q 130 160, 120 160 Q 110 160, 102 148 Z" fill={INK}/>
      <ellipse cx="120" cy="160" rx="6" ry="3" fill={PINK}/>
    </g>;
  }
  if (kind === 'firm') {
    return <path d="M 105 154 L 135 154" stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none"/>;
  }
  if (kind === 'frown') {
    return <path d="M 104 156 Q 120 144, 136 156" stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none"/>;
  }
  if (kind === 'smirk') {
    return <path d="M 108 152 Q 120 158, 136 148" stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none"/>;
  }
  if (kind === 'wobble') {
    return <path d="M 104 152 Q 112 148, 120 152 Q 128 156, 136 152" stroke={INK} strokeWidth="5" strokeLinecap="round" fill="none"/>;
  }
  if (kind === 'flat') {
    return <line x1="108" y1="154" x2="132" y2="154" stroke={INK} strokeWidth="5" strokeLinecap="round"/>;
  }
  // smile
  return <path d="M 104 146 Q 120 162, 136 146" stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none"/>;
}

function Foot({cx}) {
  return <ellipse cx={cx} cy="220" rx="13" ry="6" fill="#fff" stroke={INK} strokeWidth="5"/>;
}
function Leg({x1, x2, y2 = 218}) {
  return <path d={`M ${x1} 206 L ${x2} ${y2}`} stroke={INK} strokeWidth="6" strokeLinecap="round" fill="none"/>;
}
function Hand({cx, cy, id, r = 11}) {
  return <circle cx={cx} cy={cy} r={r} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>;
}
function Arm({d}) {
  return <path d={d} stroke={INK} strokeWidth="7" strokeLinecap="round" fill="none"/>;
}

// ─── Stage 1 — Big smile, both arms relaxed ───────────
function Stage1({id}) {
  return <g className={`anim-bob-${id}`}>
    <Leg x1="96" x2="94"/><Leg x1="144" x2="146"/>
    <Foot cx="92"/><Foot cx="148"/>
    <Arm d="M 60 130 Q 40 138, 28 152"/><Hand cx={26} cy={156} id={id}/>
    <Arm d="M 180 130 Q 200 138, 212 152"/><Hand cx={214} cy={156} id={id}/>
    <GlobeBody id={id} eyes="closed-happy" mouth="open-cheer"/>
    {/* sparkles */}
    <text x="40" y="60" fontSize="20" fill={PEACH} fontWeight="900">✦</text>
    <text x="190" y="70" fontSize="16" fill={PINK} fontWeight="900">✧</text>
  </g>;
}

// ─── Stage 2 — 화이팅 (눈크게, 양팔 굽혀 화이팅 자세) ────
function Stage2({id}) {
  return <g className={`anim-pump-${id}`}>
    <Leg x1="96" x2="94"/><Leg x1="144" x2="146"/>
    <Foot cx="92"/><Foot cx="148"/>
    {/* LEFT arm bent — elbow out, fist up near shoulder */}
    <path d="M 60 135 Q 30 130, 38 90 Q 42 78, 56 76" stroke={INK} strokeWidth="7" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <circle cx={58} cy={72} r={14} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>
    <path d="M 50 72 L 66 72" stroke={INK} strokeWidth="2.5"/>
    <path d="M 50 67 L 66 67" stroke={INK} strokeWidth="2" opacity="0.5"/>
    {/* RIGHT arm bent — mirror */}
    <path d="M 180 135 Q 210 130, 202 90 Q 198 78, 184 76" stroke={INK} strokeWidth="7" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <circle cx={182} cy={72} r={14} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>
    <path d="M 174 72 L 190 72" stroke={INK} strokeWidth="2.5"/>
    <path d="M 174 67 L 190 67" stroke={INK} strokeWidth="2" opacity="0.5"/>
    {/* big shiny eyes — eager */}
    <GlobeBody id={id} eyes="open" mouth="open-cheer"/>
    {/* impact lines around fists */}
    <path d="M 38 60 L 30 50" stroke={INK} strokeWidth="3" strokeLinecap="round"/>
    <path d="M 58 56 L 58 46" stroke={INK} strokeWidth="3" strokeLinecap="round"/>
    <path d="M 202 60 L 210 50" stroke={INK} strokeWidth="3" strokeLinecap="round"/>
    <path d="M 182 56 L 182 46" stroke={INK} strokeWidth="3" strokeLinecap="round"/>
  </g>;
}

// ─── Stage 3 — 굳은 결심 + 사이어인 오라 ──────────
function Stage3({id}) {
  return <g>
    {/* SAIYAN AURA — golden flame layers behind body */}
    <g className={`anim-aura-${id}`} style={{transformOrigin:'120px 200px'}}>
      <path d="M 120 220 Q 50 180, 35 110 Q 50 140, 70 130 Q 60 90, 95 70 Q 100 100, 120 90 Q 140 100, 145 70 Q 180 90, 170 130 Q 190 140, 205 110 Q 190 180, 120 220 Z"
            fill="#FFE066" opacity="0.7"/>
      <path d="M 120 215 Q 65 180, 55 120 Q 70 145, 85 138 Q 78 100, 105 85 Q 110 105, 120 100 Q 130 105, 135 85 Q 162 100, 155 138 Q 170 145, 185 120 Q 175 180, 120 215 Z"
            fill="#FFC93C" opacity="0.85"/>
      <path d="M 120 210 Q 80 180, 75 130 Q 85 150, 95 145 Q 90 110, 110 100 Q 115 115, 120 112 Q 125 115, 130 100 Q 150 110, 145 145 Q 155 150, 165 130 Q 160 180, 120 210 Z"
            fill="#FFAB1F" opacity="0.9"/>
    </g>
    {/* aura sparks */}
    <g className={`anim-spark-${id}`}><text x="30" y="100" fontSize="22" fill="#FFD700" fontWeight="900">✦</text></g>
    <g className={`anim-spark-${id}`} style={{animationDelay:'0.3s'}}><text x="195" y="105" fontSize="20" fill="#FFD700" fontWeight="900">✧</text></g>
    <g className={`anim-spark-${id}`} style={{animationDelay:'0.6s'}}><text x="40" y="180" fontSize="16" fill="#FFAB1F" fontWeight="900">✦</text></g>
    <g className={`anim-spark-${id}`} style={{animationDelay:'0.15s'}}><text x="190" y="180" fontSize="18" fill="#FFAB1F" fontWeight="900">✦</text></g>
    {/* energy lines rising */}
    <path d="M 60 200 L 50 220" stroke="#FFD700" strokeWidth="3" strokeLinecap="round" opacity="0.7"/>
    <path d="M 180 200 L 190 220" stroke="#FFD700" strokeWidth="3" strokeLinecap="round" opacity="0.7"/>
    <path d="M 120 30 L 120 10" stroke="#FFD700" strokeWidth="3" strokeLinecap="round" opacity="0.7"/>

    <g className={`anim-bob-${id}`}>
    <Leg x1="96" x2="94"/><Leg x1="144" x2="146"/>
    <Foot cx="92"/><Foot cx="148"/>
    {/* LEFT — fist pulled in tight near body, elbow flared back */}
    <path d="M 60 130 Q 28 148, 50 175" stroke={INK} strokeWidth="7" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <circle cx={56} cy={180} r={15} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>
    <path d="M 47 180 L 65 180" stroke={INK} strokeWidth="2.8"/>
    <path d="M 47 174 L 65 174" stroke={INK} strokeWidth="2.2" opacity="0.55"/>
    <path d="M 47 186 L 65 186" stroke={INK} strokeWidth="2.2" opacity="0.55"/>
    {/* RIGHT — mirror */}
    <path d="M 180 130 Q 212 148, 190 175" stroke={INK} strokeWidth="7" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <circle cx={184} cy={180} r={15} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>
    <path d="M 175 180 L 193 180" stroke={INK} strokeWidth="2.8"/>
    <path d="M 175 174 L 193 174" stroke={INK} strokeWidth="2.2" opacity="0.55"/>
    <path d="M 175 186 L 193 186" stroke={INK} strokeWidth="2.2" opacity="0.55"/>
    {/* tense determined face */}
    <GlobeBody id={id} eyes="determined" mouth="firm"/>
    {/* power lines */}
    <path d="M 38 168 L 28 178" stroke={INK} strokeWidth="2.5" strokeLinecap="round"/>
    <path d="M 202 168 L 212 178" stroke={INK} strokeWidth="2.5" strokeLinecap="round"/>
    </g>
  </g>;
}

// ─── Stage 4 — 괜찮아요? (한 손 어색하게 흔들며 OK 제스처) ─
function Stage4({id}) {
  return <g className={`anim-shake-${id}`}>
    <Leg x1="96" x2="92"/><Leg x1="144" x2="148"/>
    <Foot cx="90"/><Foot cx="150"/>
    {/* LEFT arm — raised up uncertainly, palm out (어색한 "괜찮아요") */}
    <path d="M 60 135 Q 40 115, 55 90" stroke={INK} strokeWidth="8" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <g className={`anim-wave-${id}`}>
      {/* open palm hand — slightly bigger, with fingers hint */}
      <ellipse cx={64} cy={82} rx={14} ry={16} fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5"/>
      {/* finger creases */}
      <path d="M 56 76 L 56 88" stroke={INK} strokeWidth="1.5" opacity="0.45"/>
      <path d="M 64 74 L 64 88" stroke={INK} strokeWidth="1.5" opacity="0.45"/>
      <path d="M 72 76 L 72 88" stroke={INK} strokeWidth="1.5" opacity="0.45"/>
    </g>
    {/* RIGHT arm — limp at side, fidgeting */}
    <path d="M 180 135 Q 195 155, 200 175" stroke={INK} strokeWidth="8" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    <Hand cx={202} cy={180} id={id} r={12}/>
    <GlobeBody id={id} eyes="worried" mouth="wobble"/>
    {/* sweat drops animated */}
    <g className={`anim-drip-${id}`}>
      <path d="M 105 70 Q 101 80, 105 80 Q 109 80, 105 70 Z" fill={SWEAT}/>
    </g>
    <g className={`anim-drip-${id}`} style={{animationDelay:'0.7s'}}>
      <path d="M 140 68 Q 136 78, 140 78 Q 144 78, 140 68 Z" fill={SWEAT}/>
    </g>
  </g>;
}

// ─── Stage 5 — 저기요 (왼팔을 턱에 괴는 자세) ───────
function Stage5({id}) {
  return <g className={`anim-side-${id}`}>
    <Leg x1="96" x2="94"/><Leg x1="144" x2="146"/>
    <Foot cx="92"/><Foot cx="148"/>
    {/* LEFT arm — bent up, propping chin (visible elbow out to the left) */}
    <path d="M 60 135 Q 22 145, 30 100 Q 36 80, 70 80" stroke={INK} strokeWidth="8" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
    {/* fist supporting chin (under jaw line — chin around y=170 on body, but body ends at 198; so prop near lower-left of face) */}
    <Hand cx={88} cy={166} id={id} r={14}/>
    {/* RIGHT arm — relaxed at side */}
    <path d="M 180 132 Q 198 142, 206 158" stroke={INK} strokeWidth="7" strokeLinecap="round" fill="none"/>
    <Hand cx={208} cy={162} id={id}/>
    <GlobeBody id={id} eyes="sideeye" mouth="smirk"/>
    {/* tch mark */}
    <text x="175" y="100" fontSize="22" fill={INK} fontWeight="900">…</text>
  </g>;
}

// ─── Stage 6 — 제발 (얼굴 오른쪽 향함, 기도하는 손만) ─
function Stage6({id}) {
  return <g className={`anim-plead-${id}`}>
    {/* ground shadow */}
    <ellipse cx="120" cy="222" rx="75" ry="7" fill={INK} opacity="0.18"/>

    {/* knees folded under (front view, simple) */}
    <ellipse cx="88" cy="214" rx="18" ry="9" fill="#fff" stroke={INK} strokeWidth="5"/>
    <ellipse cx="152" cy="214" rx="18" ry="9" fill="#fff" stroke={INK} strokeWidth="5"/>

    {/* body */}
    <circle cx="120" cy="130" r="78" fill={`url(#body-${id})`} stroke={INK} strokeWidth="5"/>

    {/* FACE pushed to the RIGHT (looking up-right toward heavens) */}
    {/* cheeks */}
    <ellipse cx="118" cy="150" rx="10" ry="6" fill={PEACH} opacity="0.65"/>
    <ellipse cx="158" cy="148" rx="11" ry="6" fill={PEACH} opacity="0.7"/>
    {/* big crying pleading eyes \u2014 shifted right */}
    <ellipse cx="130" cy="128" rx="10" ry="13" fill={INK}/>
    <ellipse cx="160" cy="126" rx="10" ry="13" fill={INK}/>
    <circle cx="134" cy="121" r="4" fill="#fff"/>
    <circle cx="164" cy="119" r="4" fill="#fff"/>
    <circle cx="127" cy="132" r="2.5" fill="#fff"/>
    <circle cx="157" cy="130" r="2.5" fill="#fff"/>
    {/* sad brows */}
    <path d="M 116 108 Q 126 114, 142 110" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
    <path d="M 148 108 Q 158 114, 174 110" stroke={INK} strokeWidth="4" strokeLinecap="round" fill="none"/>
    {/* tears streaming */}
    <path d="M 128 142 Q 124 156, 128 168" stroke={SWEAT} strokeWidth="3.5" fill="none" strokeLinecap="round"/>
    <path d="M 158 140 Q 154 154, 158 166" stroke={SWEAT} strokeWidth="3.5" fill="none" strokeLinecap="round"/>
    <ellipse cx="128" cy="170" rx="3.5" ry="5" fill={SWEAT}/>
    <ellipse cx="158" cy="168" rx="3.5" ry="5" fill={SWEAT}/>
    {/* trembling frown mouth */}
    <path d="M 130 162 Q 140 158, 150 162 Q 158 165, 166 162" stroke={INK} strokeWidth="4.5" strokeLinecap="round" fill="none"/>

    {/* PRAYER HANDS \u2014 floating in front of body, no arms */}
    <g>
      {/* LEFT hand */}
      <path d="M 78 188 Q 60 170, 62 140 Q 66 120, 80 122 Q 90 130, 90 156 L 90 188 Q 90 192, 86 192 Z"
            fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5" strokeLinejoin="round"/>
      {/* RIGHT hand mirroring */}
      <path d="M 102 188 Q 120 170, 118 140 Q 114 120, 100 122 Q 90 130, 90 156 L 90 188 Q 90 192, 94 192 Z"
            fill={`url(#hand-${id})`} stroke={INK} strokeWidth="5" strokeLinejoin="round"/>
      {/* center seam */}
      <path d="M 90 124 L 90 188" stroke={INK} strokeWidth="2.2" opacity="0.55"/>
      {/* fingertip points */}
      <path d="M 78 124 Q 84 120, 90 124 Q 96 120, 102 124" stroke={INK} strokeWidth="1.8" fill="none" opacity="0.5"/>
      {/* wrist line */}
      <path d="M 80 188 L 100 188" stroke={INK} strokeWidth="2" opacity="0.5"/>
    </g>

    {/* sparkles — emanating from prayer hands */}
    <g className={`anim-spark-${id}`}><text x="15" y="75" fontSize="18" fill={PINK} fontWeight="900">✦</text></g>
    <g className={`anim-spark-${id}`} style={{animationDelay:'0.4s'}}><text x="50" y="60" fontSize="14" fill={PINK} fontWeight="900">✧</text></g>
    <g className={`anim-spark-${id}`} style={{animationDelay:'0.7s'}}><text x="5" y="110" fontSize="12" fill={PINK} fontWeight="900">✦</text></g>
  </g>;
}

// ─── Stage 7 — 체념, 쪼그려 앉음 (sass) ──────────
function Stage7({id}) {
  return <g>
    {/* squat shadow */}
    <ellipse cx="120" cy="220" rx="75" ry="8" fill={INK} opacity="0.18"/>
    {/* squat — character lower, smaller body, knees out */}
    <g transform="translate(0 25)">
      {/* knees sticking out */}
      <ellipse cx="68" cy="190" rx="22" ry="14" fill="#fff" stroke={INK} strokeWidth="5"/>
      <ellipse cx="172" cy="190" rx="22" ry="14" fill="#fff" stroke={INK} strokeWidth="5"/>
      {/* feet flat on ground */}
      <ellipse cx="60" cy="200" rx="16" ry="6" fill="#fff" stroke={INK} strokeWidth="5"/>
      <ellipse cx="180" cy="200" rx="16" ry="6" fill="#fff" stroke={INK} strokeWidth="5"/>
      {/* one arm draped on knee, finger tapping */}
      <path d="M 60 130 Q 50 160, 60 178" stroke={INK} strokeWidth="7" strokeLinecap="round" fill="none"/>
      <g className={`anim-tap-${id}`}>
        <Hand cx={60} cy={182} id={id} r={11}/>
      </g>
      {/* other arm bored chin rest */}
      <path d="M 180 130 Q 178 110, 162 96" stroke={INK} strokeWidth="7" strokeLinecap="round" fill="none"/>
      <Hand cx={158} cy={92} id={id}/>
      <GlobeBody id={id} eyes="halflid" mouth="flat" cheekColor={MINT_B}/>
    </g>
    {/* big sigh cloud */}
    <g opacity="0.7">
      <ellipse cx="54" cy="40" rx="22" ry="14" fill="#D8E0EC"/>
      <ellipse cx="82" cy="34" rx="16" ry="11" fill="#D8E0EC"/>
      <ellipse cx="38" cy="50" rx="12" ry="9" fill="#D8E0EC"/>
      <ellipse cx="96" cy="46" rx="10" ry="7" fill="#D8E0EC"/>
    </g>
    <text x="40" y="50" fontSize="24" fill={INK} fontWeight="900" opacity="0.75" letterSpacing="1">하…</text>
  </g>;
}

window.TalkyStage = TalkyStage;

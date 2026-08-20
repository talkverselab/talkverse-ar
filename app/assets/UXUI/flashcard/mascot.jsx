// Talky — 라인 일러스트 + 통통한 손 + 큰 눈코입
// 2가지 컬러: 'mint' (초록 파스텔), 'pink' (핑크 파스텔)
// moods: happy / wave / cheer / think / sleep

const STROKE = '#1F3A6E';
const STROKE_THIN = '#1F3A6E';

const PALETTES = {
  mint: {
    bodyA: '#D4F1DF',  // light
    bodyB: '#A8E0BD',  // mid
    land: '#7FCBA4',
    cheek: '#FFB59C',
  },
  pink: {
    bodyA: '#FFE0EB',
    bodyB: '#FFB6CD',
    land: '#FF8FB1',
    cheek: '#FF7A9A',
  },
};

function TalkyMascot({size = 140, mood = 'happy', color = 'mint', style = {}}) {
  const p = PALETTES[color] || PALETTES.mint;
  const id = React.useId();
  const sw = 5;       // body outline
  const swArm = 7;    // arms — thicker as requested
  const swDetail = 3; // continents

  // Arm positions per mood
  const arms = {
    happy: {  // 손을 옆에 살짝
      left:  { d: 'M 60 130 Q 38 138, 28 152', hand: { cx: 26, cy: 156 } },
      right: { d: 'M 180 130 Q 202 138, 212 152', hand: { cx: 214, cy: 156 } },
    },
    wave: {  // 한 손 번쩍 흔들기
      left:  { d: 'M 60 130 Q 40 140, 28 158', hand: { cx: 26, cy: 162 } },
      right: { d: 'M 180 120 Q 202 80, 200 42', hand: { cx: 200, cy: 36 } },
    },
    cheer: {  // 양손 만세
      left:  { d: 'M 60 110 Q 38 70, 36 36', hand: { cx: 36, cy: 30 } },
      right: { d: 'M 180 110 Q 202 70, 204 36', hand: { cx: 204, cy: 30 } },
    },
    think: {  // 한 손 턱
      left:  { d: 'M 60 130 Q 40 138, 30 154', hand: { cx: 28, cy: 158 } },
      right: { d: 'M 180 110 Q 178 90, 162 78', hand: { cx: 158, cy: 76 } },
    },
    sleep: {  // 양손 가지런히
      left:  { d: 'M 60 130 Q 50 140, 50 156', hand: { cx: 50, cy: 160 } },
      right: { d: 'M 180 130 Q 190 140, 190 156', hand: { cx: 190, cy: 160 } },
    },
  };
  const a = arms[mood] || arms.happy;

  // Idle bobbing animation key
  const animClass = `talky-bob-${id.replace(/[:]/g, '')}`;

  return (
    <svg width={size} height={size} viewBox="0 0 240 240" style={style} fill="none">
      <defs>
        <radialGradient id={`body-${id}`} cx="38%" cy="32%" r="78%">
          <stop offset="0%" stopColor="#fff" stopOpacity="0.7"/>
          <stop offset="35%" stopColor={p.bodyA}/>
          <stop offset="100%" stopColor={p.bodyB}/>
        </radialGradient>
        <radialGradient id={`hand-${id}`} cx="40%" cy="35%" r="75%">
          <stop offset="0%" stopColor="#fff"/>
          <stop offset="100%" stopColor={p.bodyA}/>
        </radialGradient>
        <style>{`
          @keyframes bob-${animClass} {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50%      { transform: translateY(-3px) rotate(-1deg); }
          }
          @keyframes wave-${animClass} {
            0%, 100% { transform: rotate(-8deg); }
            50%      { transform: rotate(12deg); }
          }
          @keyframes blink-${animClass} {
            0%, 92%, 100% { transform: scaleY(1); }
            95%           { transform: scaleY(0.1); }
          }
          .${animClass}-body  { animation: bob-${animClass} 2.4s ease-in-out infinite; transform-origin: 120px 130px; }
          .${animClass}-wave  { animation: wave-${animClass} 0.7s ease-in-out infinite; transform-origin: 180px 120px; }
          .${animClass}-eyes  { animation: blink-${animClass} 4s ease-in-out infinite; transform-origin: center; transform-box: fill-box; }
        `}</style>
      </defs>

      {/* Ground shadow */}
      <ellipse cx="120" cy="222" rx="62" ry="5" fill="rgba(31,58,110,0.12)"/>

      <g className={`${animClass}-body`}>

        {/* Legs (small + chubby) */}
        <g stroke={STROKE} strokeWidth={swArm - 1} strokeLinecap="round" fill="#fff">
          <path d="M 96 206 L 94 218"/>
          <path d="M 144 206 L 146 218"/>
          {/* feet — bean shaped */}
          <ellipse cx="92" cy="220" rx="13" ry="6" fill="#fff" stroke={STROKE} strokeWidth={sw}/>
          <ellipse cx="148" cy="220" rx="13" ry="6" fill="#fff" stroke={STROKE} strokeWidth={sw}/>
        </g>

        {/* Left arm */}
        <g stroke={STROKE} strokeWidth={swArm} strokeLinecap="round" fill="none">
          <path d={a.left.d}/>
        </g>
        {/* Left hand — chubby */}
        <g>
          <circle cx={a.left.hand.cx} cy={a.left.hand.cy} r="11"
            fill={`url(#hand-${id})`} stroke={STROKE} strokeWidth={sw}/>
          {/* tiny finger crease */}
          <path d={`M ${a.left.hand.cx - 4} ${a.left.hand.cy + 2} Q ${a.left.hand.cx} ${a.left.hand.cy + 5}, ${a.left.hand.cx + 4} ${a.left.hand.cy + 2}`}
            stroke={STROKE} strokeWidth="1.5" strokeLinecap="round" fill="none" opacity="0.5"/>
        </g>

        {/* Right arm — animates if waving */}
        <g className={mood === 'wave' ? `${animClass}-wave` : ''}>
          <path d={a.right.d} stroke={STROKE} strokeWidth={swArm} strokeLinecap="round" fill="none"/>
          <circle cx={a.right.hand.cx} cy={a.right.hand.cy} r="12"
            fill={`url(#hand-${id})`} stroke={STROKE} strokeWidth={sw}/>
          <path d={`M ${a.right.hand.cx - 4} ${a.right.hand.cy + 2} Q ${a.right.hand.cx} ${a.right.hand.cy + 5}, ${a.right.hand.cx + 4} ${a.right.hand.cy + 2}`}
            stroke={STROKE} strokeWidth="1.5" strokeLinecap="round" fill="none" opacity="0.5"/>
        </g>

        {/* Earth body (sphere) */}
        <circle cx="120" cy="120" r="78"
          fill={`url(#body-${id})`} stroke={STROKE} strokeWidth={sw}/>

        {/* Continents — colored fill, hand-drawn world map */}
        <g stroke={STROKE} strokeWidth="2" strokeLinejoin="round" strokeLinecap="round" fill={p.land} fillOpacity="0.35">
          {/* Eurasia */}
          <path d="M 50 78 Q 58 70, 70 72 Q 80 66, 92 70 Q 104 64, 116 70 Q 128 68, 138 76 Q 146 74, 152 82 Q 158 86, 156 94 Q 150 102, 140 100 Q 134 110, 124 106 Q 118 112, 110 108 Q 100 116, 92 110 Q 82 112, 74 108 Q 66 112, 60 106 Q 52 104, 50 96 Q 46 88, 50 78 Z"/>
          {/* India */}
          <path d="M 108 108 Q 112 118, 110 124 Q 106 122, 104 116 Q 104 110, 108 108 Z"/>
          {/* SE Asia */}
          <path d="M 132 106 Q 138 116, 134 124 Q 128 122, 128 114 Q 128 108, 132 106 Z"/>
          {/* Africa */}
          <path d="M 84 110 Q 96 108, 100 122 Q 102 138, 96 152 Q 90 162, 84 156 Q 78 144, 78 130 Q 78 118, 84 110 Z"/>
          {/* Australia */}
          <path d="M 144 144 Q 158 140, 166 148 Q 168 156, 158 160 Q 148 162, 142 156 Q 138 148, 144 144 Z"/>
        </g>

        {/* Cheeks — bigger, more prominent */}
        <ellipse cx="86" cy="138" rx="11" ry="6" fill={p.cheek} opacity="0.65"/>
        <ellipse cx="154" cy="138" rx="11" ry="6" fill={p.cheek} opacity="0.65"/>

        {/* ─── FACE — bigger, more expressive ─── */}

        {/* Eyes */}
        {mood === 'sleep' ? (
          <g stroke={STROKE} strokeWidth={swArm - 1} strokeLinecap="round" fill="none">
            <path d="M 95 118 Q 103 124, 111 118"/>
            <path d="M 129 118 Q 137 124, 145 118"/>
          </g>
        ) : mood === 'cheer' ? (
          // Star-like happy eyes (^^)
          <g stroke={STROKE} strokeWidth={swArm - 1} strokeLinecap="round" fill="none">
            <path d="M 95 122 Q 103 110, 111 122"/>
            <path d="M 129 122 Q 137 110, 145 122"/>
          </g>
        ) : (
          // Big round eyes with sparkles
          <g className={`${animClass}-eyes`}>
            <ellipse cx="103" cy="120" rx="9" ry="11" fill={STROKE}/>
            <ellipse cx="137" cy="120" rx="9" ry="11" fill={STROKE}/>
            {/* sparkles */}
            <circle cx="106" cy="115" r="3.2" fill="#fff"/>
            <circle cx="140" cy="115" r="3.2" fill="#fff"/>
            <circle cx="100" cy="124" r="1.5" fill="#fff"/>
            <circle cx="134" cy="124" r="1.5" fill="#fff"/>
          </g>
        )}

        {/* Tiny nose (between eyes, low) */}
        <ellipse cx="120" cy="138" rx="3" ry="2" fill={STROKE} opacity="0.5"/>

        {/* Mouth — bigger, more animated */}
        {mood === 'cheer' ? (
          // Open big smile with tongue
          <g>
            <path d="M 104 148 Q 120 168, 136 148 Q 130 158, 120 158 Q 110 158, 104 148 Z"
              fill={STROKE}/>
            <ellipse cx="120" cy="160" rx="6" ry="3" fill={p.cheek}/>
          </g>
        ) : mood === 'sleep' ? (
          // Z mouth
          <g stroke={STROKE} strokeWidth={swArm - 2} strokeLinecap="round" fill="none">
            <path d="M 112 152 Q 120 156, 128 152"/>
            <text x="170" y="80" fontSize="20" fontWeight="900" fill={STROKE} fontFamily="sans-serif">z</text>
            <text x="186" y="62" fontSize="14" fontWeight="900" fill={STROKE} fontFamily="sans-serif">z</text>
          </g>
        ) : mood === 'think' ? (
          // small "o" mouth
          <ellipse cx="120" cy="152" rx="5" ry="6" fill={STROKE}/>
        ) : (
          // default smile — big and round
          <path d="M 104 146 Q 120 162, 136 146"
            stroke={STROKE} strokeWidth={swArm - 1} strokeLinecap="round" strokeLinejoin="round" fill="none"/>
        )}

      </g>
    </svg>
  );
}

window.TalkyMascot = TalkyMascot;

// Flashcard variants — Polaroid style, KO front → VI back, 3D flip
const FC_INK = '#1F3A6E';
const FC_CREAM = '#F4EDE0';
const FC_TAPE = '#FFE99A';

// Sample sentence: "오늘 날씨가 정말 좋네요" → "Hôm nay thời tiết thật đẹp"
// Per-syllable tones
const SAMPLE = {
  ko: '오늘 날씨가 정말 좋네요',
  hint: '날씨, 정말, 좋다',
  vi: 'Hôm nay thời tiết thật đẹp',
  reading: '홈 나이 터이 띠엣 텃 댑',
  syllables: [
    { vi: 'Hôm',  read: '홈',   tone: 'ngang' },
    { vi: 'nay',  read: '나이', tone: 'ngang' },
    { vi: 'thời', read: '터이', tone: 'huyen' },
    { vi: 'tiết', read: '띠엣', tone: 'sac' },
    { vi: 'thật', read: '텃',   tone: 'nang' },
    { vi: 'đẹp',  read: '댑',   tone: 'nang' },
  ],
  note: '"thời tiết"은 "날씨", "thật đẹp"은 "정말 예쁘다/좋다"라는 뜻이에요.',
};

// 3D Flip wrapper — controlled by `flipped` prop or internal click toggle
function Flippable({ front, back, flipped: controlled, onFlip, style = {} }) {
  const [internal, setInternal] = React.useState(false);
  const flipped = controlled !== undefined ? controlled : internal;
  const toggle = () => {
    if (controlled !== undefined) onFlip && onFlip(!flipped);
    else setInternal(!internal);
  };
  return (
    <div onClick={toggle} style={{
      perspective: '1400px',
      cursor: 'pointer',
      width: '100%', height: '100%',
      ...style,
    }}>
      <div style={{
        position: 'relative', width: '100%', height: '100%',
        transition: 'transform 0.7s cubic-bezier(0.4, 0.0, 0.2, 1)',
        transform: flipped ? 'rotateY(180deg)' : 'rotateY(0deg)',
        transformStyle: 'preserve-3d',
      }}>
        <div style={{
          position:'absolute', inset:0,
          opacity: flipped ? 0 : 1,
          transition: 'opacity 0s linear 0.35s',
          transitionDelay: flipped ? '0s' : '0.35s',
          pointerEvents: flipped ? 'none' : 'auto',
        }}>
          {front}
        </div>
        <div style={{
          position:'absolute', inset:0,
          opacity: flipped ? 1 : 0,
          transform: 'rotateY(180deg)',
          transition: 'opacity 0s linear',
          transitionDelay: flipped ? '0.35s' : '0s',
          pointerEvents: flipped ? 'auto' : 'none',
        }}>
          {back}
        </div>
      </div>
    </div>
  );
}

// Polaroid frame — base shape used by all variants
function Polaroid({ children, rotate = 0, tint = '#FFFFFF', shadow = 'lg', children2, style = {} }) {
  const shadows = {
    sm: '0 2px 6px rgba(31,58,110,0.12), 0 8px 16px rgba(31,58,110,0.08)',
    lg: '0 6px 12px rgba(31,58,110,0.14), 0 20px 40px rgba(31,58,110,0.18), 0 32px 64px rgba(31,58,110,0.10)',
    xl: '0 8px 16px rgba(31,58,110,0.15), 0 28px 56px rgba(31,58,110,0.22), 0 50px 80px rgba(31,58,110,0.12)',
  };
  return (
    <div style={{
      width: '100%', height: '100%',
      background: tint,
      borderRadius: 6,
      boxShadow: shadows[shadow],
      transform: `rotate(${rotate}deg)`,
      display: 'flex', flexDirection: 'column',
      padding: '18px 18px 56px',
      position: 'relative',
      fontFamily: 'Pretendard, sans-serif',
      ...style,
    }}>
      {children}
    </div>
  );
}

// ─────────────────────────────────────────
// VARIANT A — Classic Polaroid
// 흰 배경, 큰 사진영역(=한국어), 하단 손글씨 캡션
// ─────────────────────────────────────────
function VariantA_Front({ sample = SAMPLE }) {
  return (
    <Polaroid tint="#FFFFFF" rotate={-1.5}>
      {/* photo area */}
      <div style={{
        flex: 1,
        background: 'linear-gradient(160deg, #FFE0EB 0%, #FFD3B6 50%, #FFE99A 100%)',
        borderRadius: 3,
        position: 'relative',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '20px 16px',
        overflow: 'hidden',
      }}>
        {/* paper grain */}
        <div style={{
          position:'absolute', inset:0,
          background:'radial-gradient(circle at 20% 20%, rgba(255,255,255,0.5), transparent 50%)',
          mixBlendMode:'overlay',
        }}/>
        <div style={{
          fontSize: 28, fontWeight: 800, color: FC_INK,
          textAlign: 'center', lineHeight: 1.45,
          letterSpacing: '-0.5px',
          textShadow: '0 1px 0 rgba(255,255,255,0.5)',
        }}>
          {sample.ko}
        </div>
        {/* hint chip */}
        <div style={{
          position: 'absolute', top: 14, right: 14,
          background: 'rgba(255,255,255,0.85)',
          padding: '4px 10px', borderRadius: 999,
          fontSize: 10, fontWeight: 800, color: FC_INK,
          letterSpacing: 0.5, opacity: 0.85,
        }}>
          KO → VI
        </div>
        {/* date corner */}
        <div style={{
          position:'absolute', bottom:8, left:10,
          fontSize:9, fontWeight:700, color:FC_INK, opacity:0.5,
          fontFamily:'Be Vietnam Pro, sans-serif',
        }}>
          08.05.2026
        </div>
      </div>
      {/* polaroid caption — handwritten feel */}
      <div style={{
        marginTop: 14,
        fontSize: 13, fontWeight: 600, color: FC_INK,
        opacity: 0.7,
        fontStyle: 'italic',
        textAlign:'center',
      }}>
        ─ {sample.hint} ─
      </div>
      {/* tap hint */}
      <div style={{
        position:'absolute', bottom: 16, right: 16,
        fontSize: 9, fontWeight: 800, color: FC_INK, opacity: 0.4,
        letterSpacing: 1.5,
      }}>
        TAP →
      </div>
    </Polaroid>
  );
}

function VariantA_Back({ sample = SAMPLE, showReading = true }) {
  return (
    <Polaroid tint="#FFFFFF" rotate={-1.5}>
      <div style={{
        flex: 1,
        background: 'linear-gradient(160deg, #EAF7EF 0%, #D4F1DF 100%)',
        borderRadius: 3,
        padding: '14px 14px',
        display:'flex', flexDirection:'column', gap:8,
        overflow:'hidden',
      }}>
        {/* tones row */}
        <div style={{display:'flex', gap:4, justifyContent:'space-between', padding:'4px 2px'}}>
          {sample.syllables.map((s, i) => (
            <div key={i} style={{flex:1, display:'flex', flexDirection:'column', alignItems:'center', minWidth:0}}>
              <ToneCurve tone={s.tone} size={36}/>
              <div style={{
                fontSize: 13, fontWeight: 800, color: FC_INK,
                fontFamily:'Be Vietnam Pro, sans-serif',
                marginTop: 1, lineHeight: 1.1,
                textAlign:'center', whiteSpace:'nowrap',
              }}>{s.vi}</div>
              {showReading && (
                <div style={{fontSize:9, fontWeight:600, color:FC_INK, opacity:0.55, marginTop:1}}>
                  {s.read}
                </div>
              )}
            </div>
          ))}
        </div>
        {/* note */}
        <div style={{
          marginTop:'auto',
          padding:'8px 10px',
          background:'rgba(255,255,255,0.7)',
          borderRadius:8,
          fontSize:10, fontWeight:600, color:FC_INK, opacity:0.85,
          lineHeight: 1.45,
        }}>
          💡 {sample.note}
        </div>
      </div>
      <div style={{
        marginTop: 12,
        display:'flex', justifyContent:'space-between', alignItems:'center',
      }}>
        <div style={{fontSize:11, fontWeight:800, color:FC_INK, opacity:0.7, letterSpacing:1}}>
          ANSWER
        </div>
        <button onClick={(e)=>e.stopPropagation()} style={{
          fontSize:9, fontWeight:800, color:FC_INK, opacity:0.55,
          background:'transparent', border:`1px solid rgba(31,58,110,0.25)`,
          padding:'3px 8px', borderRadius:999, cursor:'pointer',
        }}>
          {showReading ? '독음 끄기' : '독음 켜기'}
        </button>
      </div>
    </Polaroid>
  );
}

// ─────────────────────────────────────────
// VARIANT B — Vintage taped photo (테이프 + 라벨 + 살짝 누런 종이)
// ─────────────────────────────────────────
function VariantB_Front({ sample = SAMPLE }) {
  return (
    <div style={{position:'relative', width:'100%', height:'100%'}}>
      {/* tape */}
      <div style={{
        position:'absolute', top:-6, left:'50%', transform:'translateX(-50%) rotate(-3deg)',
        width:80, height:18,
        background: 'linear-gradient(180deg, rgba(255,233,154,0.85), rgba(255,200,100,0.7))',
        boxShadow:'0 2px 4px rgba(0,0,0,0.15)',
        zIndex: 10,
      }}/>
      <Polaroid tint="#FBF6EE" rotate={2} shadow="xl">
        <div style={{
          flex:1,
          background: '#F9EAD3',
          backgroundImage: 'radial-gradient(circle at 30% 25%, #FFE5C7 0%, transparent 60%), radial-gradient(circle at 70% 70%, #FFD7B0 0%, transparent 60%)',
          borderRadius:2,
          padding:'24px 18px',
          position:'relative',
          display:'flex', alignItems:'center', justifyContent:'center',
        }}>
          {/* corner triangle */}
          <div style={{position:'absolute', top:6, left:6, width:0, height:0,
            borderLeft:'14px solid #1F3A6E', borderBottom:'14px solid transparent',
            opacity:0.15,
          }}/>
          <div style={{
            fontSize: 26, fontWeight: 800, color:FC_INK,
            textAlign:'center', lineHeight:1.45, letterSpacing:'-0.5px',
          }}>
            {sample.ko}
          </div>
        </div>
        {/* metadata strip */}
        <div style={{
          marginTop: 14, display:'flex', justifyContent:'space-between',
          fontSize: 10, fontWeight: 700, color:FC_INK,
          fontFamily: 'Be Vietnam Pro, monospace', letterSpacing: 0.5,
        }}>
          <span style={{opacity:0.55}}>VI · LV.A2</span>
          <span style={{opacity:0.55}}>#0142</span>
        </div>
      </Polaroid>
    </div>
  );
}

function VariantB_Back({ sample = SAMPLE, showReading = true }) {
  return (
    <div style={{position:'relative', width:'100%', height:'100%'}}>
      <div style={{
        position:'absolute', top:-6, left:'50%', transform:'translateX(-50%) rotate(-3deg)',
        width:80, height:18,
        background: 'linear-gradient(180deg, rgba(255,233,154,0.85), rgba(255,200,100,0.7))',
        boxShadow:'0 2px 4px rgba(0,0,0,0.15)',
        zIndex: 10,
      }}/>
      <Polaroid tint="#FBF6EE" rotate={2} shadow="xl">
        <div style={{
          flex:1,
          background:'#FFFFFF',
          borderRadius:2,
          padding:'12px 12px',
          display:'flex', flexDirection:'column', gap:8,
          border: `1px solid rgba(31,58,110,0.06)`,
        }}>
          {/* full sentence with stacked tones */}
          <div style={{display:'flex', gap:3, justifyContent:'center', flexWrap:'wrap', padding:'4px 0'}}>
            {sample.syllables.map((s, i) => (
              <div key={i} style={{display:'flex', flexDirection:'column', alignItems:'center', minWidth:42}}>
                <ToneCurve tone={s.tone} size={34}/>
                <div style={{
                  fontSize:13, fontWeight:800, color:FC_INK,
                  fontFamily:'Be Vietnam Pro,sans-serif', marginTop:1,
                }}>{s.vi}</div>
                {showReading && <div style={{fontSize:8.5, fontWeight:600, color:FC_INK, opacity:0.5}}>{s.read}</div>}
              </div>
            ))}
          </div>
          <div style={{
            background:'#FBF6EE', padding:'8px 10px', borderRadius:6,
            fontSize:10, fontWeight:600, color:FC_INK, opacity:0.85, lineHeight:1.5,
            marginTop:'auto',
          }}>
            <strong style={{color:'#7FCBA4'}}>NOTE</strong> · {sample.note}
          </div>
        </div>
        <div style={{
          marginTop:12, display:'flex', justifyContent:'space-between', alignItems:'center',
        }}>
          <div style={{fontSize:10, fontWeight:800, color:FC_INK, opacity:0.6, letterSpacing:1}}>
            VI ANSWER
          </div>
          <button onClick={(e)=>e.stopPropagation()} style={{
            fontSize:9, fontWeight:800, color:FC_INK, opacity:0.55,
            background:'transparent', border:`1px solid rgba(31,58,110,0.2)`,
            padding:'3px 8px', borderRadius:999, cursor:'pointer',
          }}>{showReading ? '독음 끄기' : '독음 켜기'}</button>
        </div>
      </Polaroid>
    </div>
  );
}

// ─────────────────────────────────────────
// VARIANT C — Minimalist Polaroid (성조 곡선 강조)
// 큰 곡선 그래프, 중앙 정렬, 과감한 여백
// ─────────────────────────────────────────
function VariantC_Front({ sample = SAMPLE }) {
  return (
    <Polaroid tint="#FFFFFF" rotate={0} shadow="lg" style={{padding:'28px 24px 64px'}}>
      <div style={{
        flex:1,
        background: '#FBF6EE',
        borderRadius: 2,
        padding: '32px 20px',
        display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center',
        gap: 16,
      }}>
        {/* big quote marks */}
        <div style={{fontSize:42, lineHeight:0.8, color:FC_INK, opacity:0.15, fontFamily:'serif', alignSelf:'flex-start'}}>"</div>
        <div style={{
          fontSize: 24, fontWeight: 800, color:FC_INK,
          textAlign:'center', lineHeight:1.5, letterSpacing:'-0.3px',
          marginTop:-20,
        }}>
          {sample.ko}
        </div>
        <div style={{fontSize:42, lineHeight:0.4, color:FC_INK, opacity:0.15, fontFamily:'serif', alignSelf:'flex-end'}}>"</div>
      </div>
      <div style={{
        marginTop:16, fontSize:10, fontWeight:800, color:FC_INK, opacity:0.5,
        textAlign:'center', letterSpacing:2,
      }}>
        TAP TO REVEAL
      </div>
    </Polaroid>
  );
}

function VariantC_Back({ sample = SAMPLE, showReading = true }) {
  return (
    <Polaroid tint="#FFFFFF" rotate={0} shadow="lg" style={{padding:'24px 18px 56px'}}>
      <div style={{
        flex:1, background:'#F4EDE0', borderRadius:2,
        padding:'18px 14px', display:'flex', flexDirection:'column',
      }}>
        {/* large stacked tone graph */}
        <div style={{
          display:'flex', justifyContent:'center', gap:6, marginBottom:8,
          padding: '8px 4px',
          background:'#FFFFFF', borderRadius:8,
        }}>
          {sample.syllables.map((s, i) => (
            <div key={i} style={{display:'flex', flexDirection:'column', alignItems:'center', flex:1}}>
              <ToneCurve tone={s.tone} size={42}/>
            </div>
          ))}
        </div>
        {/* big VI text */}
        <div style={{
          textAlign:'center', marginTop:14,
          fontSize:20, fontWeight:900, color:FC_INK,
          fontFamily:'Be Vietnam Pro, sans-serif',
          letterSpacing:'-0.3px', lineHeight:1.3,
        }}>
          {sample.vi}
        </div>
        {showReading && (
          <div style={{textAlign:'center', marginTop:6, fontSize:11, fontWeight:600, color:FC_INK, opacity:0.55}}>
            {sample.reading}
          </div>
        )}
        {/* note */}
        <div style={{
          marginTop:'auto',
          fontSize:10, fontWeight:600, color:FC_INK, opacity:0.7,
          lineHeight:1.5, textAlign:'center', padding:'8px 4px 0',
          borderTop:'1px dashed rgba(31,58,110,0.2)',
        }}>
          {sample.note}
        </div>
      </div>
      <button onClick={(e)=>e.stopPropagation()} style={{
        position:'absolute', bottom:18, right:18,
        fontSize:9, fontWeight:800, color:FC_INK, opacity:0.55,
        background:'transparent', border:`1px solid rgba(31,58,110,0.2)`,
        padding:'3px 8px', borderRadius:999, cursor:'pointer',
      }}>{showReading ? '독음 끄기' : '독음 켜기'}</button>
    </Polaroid>
  );
}

// ─────────────────────────────────────────
// VARIANT D — Layered photo cards (스택, 다른 색감)
// 뒤에 카드 1-2장 살짝 보임
// ─────────────────────────────────────────
function VariantD_Front({ sample = SAMPLE }) {
  return (
    <div style={{position:'relative', width:'100%', height:'100%'}}>
      {/* back card 2 */}
      <div style={{
        position:'absolute', inset:0, transform:'rotate(4deg) translateY(8px)',
        background:'#F4EDE0', borderRadius:6,
        boxShadow:'0 4px 12px rgba(31,58,110,0.1)',
      }}/>
      {/* back card 1 */}
      <div style={{
        position:'absolute', inset:0, transform:'rotate(-2deg) translateY(4px)',
        background:'#FFE0EB', borderRadius:6,
        boxShadow:'0 4px 12px rgba(31,58,110,0.1)',
      }}/>
      {/* front */}
      <Polaroid tint="#FFFFFF" rotate={1} shadow="xl">
        <div style={{
          flex:1, position:'relative',
          background:`
            radial-gradient(circle at 30% 30%, #C8B6FF 0%, transparent 50%),
            radial-gradient(circle at 70% 70%, #A8E0BD 0%, transparent 55%),
            #FBF6EE
          `,
          borderRadius:3,
          display:'flex', alignItems:'center', justifyContent:'center',
          padding:'24px 18px',
        }}>
          <div style={{
            fontSize:26, fontWeight:800, color:FC_INK,
            textAlign:'center', lineHeight:1.45, letterSpacing:'-0.5px',
          }}>
            {sample.ko}
          </div>
          {/* number stamp */}
          <div style={{
            position:'absolute', top:10, left:10,
            fontSize:9, fontWeight:900, color:FC_INK, opacity:0.4,
            fontFamily:'monospace', letterSpacing:1,
          }}>NO.142 / 250</div>
        </div>
        <div style={{
          marginTop:12, display:'flex', justifyContent:'center', gap:6,
        }}>
          {[0,1,2,3].map(i => (
            <div key={i} style={{
              width:6, height:6, borderRadius:'50%',
              background: i === 0 ? FC_INK : 'rgba(31,58,110,0.2)',
            }}/>
          ))}
        </div>
      </Polaroid>
    </div>
  );
}

function VariantD_Back({ sample = SAMPLE, showReading = true }) {
  return (
    <div style={{position:'relative', width:'100%', height:'100%'}}>
      <div style={{
        position:'absolute', inset:0, transform:'rotate(4deg) translateY(8px)',
        background:'#F4EDE0', borderRadius:6,
        boxShadow:'0 4px 12px rgba(31,58,110,0.1)',
      }}/>
      <div style={{
        position:'absolute', inset:0, transform:'rotate(-2deg) translateY(4px)',
        background:'#D4F1DF', borderRadius:6,
        boxShadow:'0 4px 12px rgba(31,58,110,0.1)',
      }}/>
      <Polaroid tint="#FFFFFF" rotate={1} shadow="xl">
        <div style={{
          flex:1, background:'#FBF6EE', borderRadius:3, padding:'14px 14px',
          display:'flex', flexDirection:'column', gap:6,
        }}>
          {/* tones row */}
          <div style={{display:'flex', gap:3, justifyContent:'space-between'}}>
            {sample.syllables.map((s, i) => (
              <div key={i} style={{flex:1, display:'flex', flexDirection:'column', alignItems:'center'}}>
                <ToneCurve tone={s.tone} size={32}/>
                <div style={{fontSize:13, fontWeight:800, color:FC_INK, fontFamily:'Be Vietnam Pro,sans-serif', marginTop:1}}>{s.vi}</div>
                {showReading && <div style={{fontSize:8.5, fontWeight:600, color:FC_INK, opacity:0.55}}>{s.read}</div>}
              </div>
            ))}
          </div>
          <div style={{
            marginTop:'auto', padding:'8px 10px',
            background:'#FFFFFF', borderRadius:8,
            fontSize:10, fontWeight:600, color:FC_INK, opacity:0.85, lineHeight:1.5,
            border:'1px solid rgba(31,58,110,0.08)',
          }}>
            <strong>📖</strong> {sample.note}
          </div>
        </div>
        <button onClick={(e)=>e.stopPropagation()} style={{
          position:'absolute', bottom:16, right:16,
          fontSize:9, fontWeight:800, color:FC_INK, opacity:0.55,
          background:'transparent', border:`1px solid rgba(31,58,110,0.2)`,
          padding:'3px 8px', borderRadius:999, cursor:'pointer',
        }}>{showReading ? '독음 끄기' : '독음 켜기'}</button>
      </Polaroid>
    </div>
  );
}

window.FlashcardVariants = {
  A: { Front: VariantA_Front, Back: VariantA_Back },
  B: { Front: VariantB_Front, Back: VariantB_Back },
  C: { Front: VariantC_Front, Back: VariantC_Back },
  D: { Front: VariantD_Front, Back: VariantD_Back },
};
window.Flippable = Flippable;
window.SAMPLE = SAMPLE;

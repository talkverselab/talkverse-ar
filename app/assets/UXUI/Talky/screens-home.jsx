// HOME SCREEN — Learning map / path
// 5 variants exposing different layout philosophies

const FRAME_W = 390;
const FRAME_H = 844;
const SCREEN_H = FRAME_H - 47 - 34; // status + home indicator

// ─────────────────────────────────────────────────────────────
// Shared: lesson node (neumorphic-pop button)
// ─────────────────────────────────────────────────────────────
function LessonNode({state='locked', icon='star', size=72, label, sublabel, color='sage', glow=false, halo=false}) {
  // state: locked | available | current | done
  const palette = {
    sage:  {fg:'#7FCBA4', dk:'#3F8E68', bg:'#D4EEDF'},
    peach: {fg:'#FFB59C', dk:'#C9633A', bg:'#FFE8D6'},
    lav:   {fg:'#B8A1FF', dk:'#8665E6', bg:'#ECE3FF'},
    sun:   {fg:'#FFD566', dk:'#E0A82E', bg:'#FFF4D2'},
    coral: {fg:'#FF8E85', dk:'#D9544A', bg:'#FFE0DC'},
  }[color];

  if (state === 'locked') {
    return (
      <div style={{
        width:size, height:size, borderRadius:'50%',
        background:'var(--bg-deep)',
        boxShadow:'var(--nm-in-sm)',
        display:'flex', alignItems:'center', justifyContent:'center',
        position:'relative',
      }}>
        <Icon.Lock size={size*0.34} color="#A89572"/>
        {label && <div style={nodeLabelStyle}>{label}</div>}
      </div>
    );
  }

  const isDone = state === 'done';
  const isCurrent = state === 'current';

  return (
    <div style={{position:'relative', width:size, height:size + (label?24:0)}}>
      {halo && (
        <div style={{
          position:'absolute', inset:-12, borderRadius:'50%',
          background:`radial-gradient(circle, ${palette.fg}55 0%, transparent 70%)`,
          animation: 'pulse 2s infinite',
        }}/>
      )}
      <div style={{
        width:size, height:size, borderRadius:'50%',
        background: isDone ? `linear-gradient(160deg, ${palette.fg}, ${palette.dk})` : palette.fg,
        boxShadow: `0 7px 0 ${palette.dk}, 0 11px 16px ${palette.dk}55, inset 0 -4px 0 rgba(0,0,0,0.08), inset 0 3px 0 rgba(255,255,255,0.4)`,
        display:'flex', alignItems:'center', justifyContent:'center',
        position:'relative',
      }}>
        {isDone ? <Icon.Check size={size*0.5}/> :
         icon === 'star' ? <Icon.Star size={size*0.5} color="#fff"/> :
         icon === 'play' ? <Icon.Play size={size*0.42}/> :
         icon === 'mic' ? <Icon.Mic size={size*0.45}/> :
         <Icon.Book size={size*0.45} color="#fff"/>}
        {isCurrent && (
          <div style={{
            position:'absolute', top:-30, left:'50%', transform:'translateX(-50%)',
            background:'#fff', color:palette.dk, fontSize:11, fontWeight:800,
            padding:'4px 10px', borderRadius:8,
            boxShadow:'0 3px 0 rgba(0,0,0,0.1), 0 4px 10px rgba(0,0,0,0.1)',
            whiteSpace:'nowrap',
          }}>
            시작!
            <div style={{
              position:'absolute', bottom:-5, left:'50%', transform:'translateX(-50%) rotate(45deg)',
              width:8, height:8, background:'#fff',
            }}/>
          </div>
        )}
      </div>
      {label && <div style={{...nodeLabelStyle, color: palette.dk}}>{label}</div>}
    </div>
  );
}
const nodeLabelStyle = {
  position:'absolute', bottom:-22, left:'50%', transform:'translateX(-50%)',
  fontSize:11, fontWeight:700, whiteSpace:'nowrap',
};

// ─────────────────────────────────────────────────────────────
// VARIANT A — Classic winding path (Duolingo-evolved)
// ─────────────────────────────────────────────────────────────
function HomeA() {
  // x positions create a winding S-curve
  const path = [
    {x:50,  state:'done', icon:'star', color:'sage'},
    {x:30,  state:'done', icon:'star', color:'sage'},
    {x:25,  state:'done', icon:'book', color:'sage'},
    {x:50,  state:'current', icon:'play', color:'peach', halo:true},
    {x:75,  state:'available', icon:'star', color:'peach'},
    {x:75,  state:'locked'},
    {x:55,  state:'locked'},
    {x:30,  state:'locked'},
  ];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <TopBar streak={7} hearts={4} gems={128}/>
      {/* Unit banner */}
      <div style={{padding:'4px 16px 16px'}}>
        <div style={{
          background: 'linear-gradient(135deg, var(--peach-200), var(--peach-300))',
          borderRadius:'var(--r-lg)', padding:'14px 16px',
          display:'flex', alignItems:'center', gap:12,
          boxShadow: '0 5px 0 var(--peach-400), 0 8px 14px rgba(245,148,111,0.3)',
        }}>
          <VNFlagChip size={36}/>
          <div style={{flex:1, color:'#7A2E0E'}}>
            <div style={{fontSize:10, fontWeight:700, opacity:0.7, letterSpacing:0.5}}>UNIT 2 · 카페에서</div>
            <div style={{fontSize:15, fontWeight:800}}>주문하고 결제하기</div>
          </div>
          <div style={{
            width:36,height:36, borderRadius:'50%',
            background:'rgba(255,255,255,0.4)', display:'flex',
            alignItems:'center', justifyContent:'center', fontSize:18,
          }}>📖</div>
        </div>
      </div>

      {/* Path */}
      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'10px 0 100px', position:'relative'}}>
        <div style={{position:'relative', width:'100%'}}>
          {path.map((n,i)=>(
            <div key={i} style={{
              display:'flex', justifyContent:'center', marginTop: i===0?20:36,
              paddingLeft: `${(n.x-50)*1.4}%`,
            }}>
              <LessonNode {...n} size={68}/>
            </div>
          ))}
          {/* Chest at end */}
          <div style={{display:'flex', justifyContent:'center', marginTop:50}}>
            <div style={{
              width:80, height:64, borderRadius:14,
              background:'linear-gradient(160deg, #C8A06B, #8B6038)',
              boxShadow:'0 6px 0 #6B4825, 0 10px 16px rgba(0,0,0,0.2)',
              display:'flex', alignItems:'center', justifyContent:'center',
              position:'relative',
            }}>
              <div style={{
                width:18, height:18, borderRadius:4, background:'#FFD566',
                border:'2px solid #8B6038',
              }}/>
              <div style={{
                position:'absolute', top:-6, left:0, right:0, height:14,
                background:'linear-gradient(180deg, #D4B07A, #A07840)',
                borderRadius:'14px 14px 4px 4px',
              }}/>
            </div>
          </div>
        </div>
      </div>
      <TabBar active="home"/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIANT B — Hero card + horizontal day strip
// ─────────────────────────────────────────────────────────────
function HomeB() {
  const days = [
    {n:1, state:'done'}, {n:2, state:'done'}, {n:3, state:'done'},
    {n:4, state:'current'}, {n:5, state:'available'}, {n:6, state:'locked'}, {n:7, state:'locked'},
  ];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <TopBar streak={7} hearts={4} gems={128}/>

      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'4px 16px 100px'}}>
        {/* Hero — today's lesson */}
        <div style={{
          background: 'linear-gradient(150deg, #A8E6CF 0%, #7FCBA4 60%, #5BAE85 100%)',
          borderRadius:'var(--r-xl)', padding:'18px 18px 20px',
          color:'#1F4030', position:'relative', overflow:'hidden',
          boxShadow:'0 8px 0 #3F8E68, 0 14px 24px rgba(63,142,104,0.35)',
        }}>
          <div style={{position:'absolute', right:-10, top:-10, opacity:0.85}}>
            <TalkyMascot size={130} mood="cheer"/>
          </div>
          <div style={{fontSize:11, fontWeight:800, opacity:0.7, letterSpacing:1}}>오늘의 수업 · DAY 4</div>
          <div style={{fontSize:24, fontWeight:900, marginTop:4, lineHeight:1.15, maxWidth:'62%'}}>
            카페에서<br/>주문해볼까요
          </div>
          <div style={{
            display:'inline-flex', alignItems:'center', gap:8,
            background:'rgba(255,255,255,0.5)', backdropFilter:'blur(10px)',
            borderRadius:'var(--r-pill)', padding:'4px 12px 4px 4px', marginTop:14,
            boxShadow:'0 2px 0 rgba(0,0,0,0.08)',
          }}>
            <div style={{
              width:24,height:24,borderRadius:'50%',background:'#1F4030',
              display:'flex',alignItems:'center',justifyContent:'center',
            }}>
              <Icon.Play size={11}/>
            </div>
            <span style={{fontSize:13, fontWeight:800}}>시작하기 · 5분</span>
          </div>
        </div>

        {/* Week strip */}
        <div style={{marginTop:22}}>
          <div style={{display:'flex', justifyContent:'space-between', alignItems:'baseline', marginBottom:10}}>
            <div style={{fontSize:13, fontWeight:800, color:'var(--ink)'}}>이번 주</div>
            <div style={{fontSize:11, fontWeight:700, color:'var(--ink-faint)'}}>3 / 7 완료</div>
          </div>
          <div style={{display:'flex', gap:8, justifyContent:'space-between'}}>
            {days.map(d=>{
              const done = d.state === 'done';
              const cur = d.state === 'current';
              const lock = d.state === 'locked';
              return (
                <div key={d.n} style={{
                  flex:1, height:64, borderRadius:'var(--r-md)',
                  background: done ? 'var(--sage-200)' : cur ? 'var(--peach-300)' : 'var(--bg)',
                  boxShadow: lock || (!done && !cur) ? 'var(--nm-in-sm)' :
                    done ? '0 3px 0 #5BAE85, 0 5px 8px rgba(63,142,104,0.25)' :
                    '0 3px 0 var(--peach-400), 0 5px 10px rgba(245,148,111,0.3)',
                  display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:3,
                  color: done ? '#1F4030' : cur ? '#7A2E0E' : 'var(--ink-faint)',
                }}>
                  <div style={{fontSize:10, fontWeight:800, opacity:0.7}}>{['월','화','수','목','금','토','일'][d.n-1]}</div>
                  {done ? <Icon.Check size={20} color="#1F4030"/> :
                   cur ? <Icon.Flame size={20} color="#7A2E0E"/> :
                   <Icon.Lock size={14} color="#A89572"/>}
                </div>
              );
            })}
          </div>
        </div>

        {/* Skill cards */}
        <div style={{marginTop:24, fontSize:13, fontWeight:800, marginBottom:10}}>스킬 트리</div>
        <div style={{display:'grid', gridTemplateColumns:'1fr 1fr', gap:12}}>
          {[
            {t:'발음', s:'성조 6개', c:'sage', p:80},
            {t:'어휘', s:'234 / 500', c:'lav', p:47},
            {t:'문법', s:'주어+동사', c:'peach', p:30},
            {t:'듣기', s:'천천히', c:'sun', p:60},
          ].map((s,i)=>(
            <div key={i} className="nm-card" style={{
              padding:'14px', borderRadius:'var(--r-lg)',
            }}>
              <div style={{fontSize:14, fontWeight:800}}>{s.t}</div>
              <div style={{fontSize:11, fontWeight:600, color:'var(--ink-faint)', marginTop:2}}>{s.s}</div>
              <div style={{
                marginTop:10, height:8, borderRadius:4,
                background:'var(--bg-deep)', boxShadow:'var(--nm-in-sm)',
                overflow:'hidden', position:'relative',
              }}>
                <div style={{
                  width:`${s.p}%`, height:'100%',
                  background: `var(--${s.c}-300)`,
                  borderRadius:4,
                  boxShadow:`inset 0 -2px 0 rgba(0,0,0,0.1), inset 0 1px 0 rgba(255,255,255,0.4)`,
                }}/>
              </div>
            </div>
          ))}
        </div>
      </div>
      <TabBar active="home"/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIANT C — Globe village / map metaphor
// ─────────────────────────────────────────────────────────────
function HomeC() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, #DCEFE5 0%, var(--bg) 60%)'}}>
      <TopBar streak={7} hearts={4} gems={128}/>

      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'0 0 100px'}}>
        {/* Globe scene */}
        <div style={{
          height:280, position:'relative', overflow:'hidden',
          background:'radial-gradient(ellipse at 50% 100%, #BEE3F8 0%, transparent 60%)',
        }}>
          {/* Clouds */}
          <div style={{position:'absolute', top:30, left:30, width:60, height:24, background:'#fff', borderRadius:'50%', opacity:0.7, filter:'blur(2px)'}}/>
          <div style={{position:'absolute', top:50, right:40, width:80, height:30, background:'#fff', borderRadius:'50%', opacity:0.7, filter:'blur(2px)'}}/>
          {/* Talky-globe */}
          <div style={{position:'absolute', bottom:-50, left:'50%', transform:'translateX(-50%)'}}>
            <TalkyMascot size={300} mood="happy"/>
          </div>
          {/* Pin markers floating around */}
          <div style={{position:'absolute', top:90, left:40}}>
            <Pin label="공항" done/>
          </div>
          <div style={{position:'absolute', top:80, right:50}}>
            <Pin label="식당" done/>
          </div>
          <div style={{position:'absolute', top:170, left:30}}>
            <Pin label="카페" current/>
          </div>
        </div>

        <div style={{padding:'18px 20px 0'}}>
          <div style={{fontSize:11, fontWeight:800, color:'var(--peach-600)', letterSpacing:1.5}}>CHƯƠNG 2 · 일상 회화</div>
          <div style={{fontSize:26, fontWeight:900, marginTop:4, color:'var(--ink)', lineHeight:1.1}}>
            카페에서 주문해보기
          </div>
          <div style={{fontSize:13, fontWeight:600, color:'var(--ink-soft)', marginTop:8, lineHeight:1.5}}>
            오늘은 베트남식 연유 커피 <span style={{color:'var(--peach-600)', fontWeight:800, fontFamily:'var(--font-vn)'}}>cà phê sữa đá</span>를 주문해볼게요.
          </div>

          <button className="btn-pop btn-peach" style={{
            width:'100%', marginTop:18, padding:'16px',
            fontSize:16, letterSpacing:0.3,
            display:'flex', alignItems:'center', justifyContent:'center', gap:8,
          }}>
            <Icon.Play size={18}/>
            오늘의 학습 시작
          </button>

          {/* Mini progress */}
          <div style={{display:'flex', gap:8, marginTop:18}}>
            {[1,2,3,4,5,6,7].map(i=>(
              <div key={i} style={{
                flex:1, height:6, borderRadius:3,
                background: i<=4 ? 'var(--sage-300)' : 'var(--bg-deep)',
                boxShadow: i<=4 ? 'inset 0 -1px 0 rgba(0,0,0,0.1)' : 'var(--nm-in-sm)',
              }}/>
            ))}
          </div>

          {/* Next up cards */}
          <div style={{marginTop:22, fontSize:12, fontWeight:800, color:'var(--ink-faint)'}}>다음 학습</div>
          <div style={{display:'flex', flexDirection:'column', gap:10, marginTop:10}}>
            <NextCard icon="📞" title="전화 걸기" lessons="5개 레슨" color="lav"/>
            <NextCard icon="🏛️" title="시장에서 흥정하기" lessons="7개 레슨" color="sun" locked/>
          </div>
        </div>
      </div>
      <TabBar active="home"/>
    </div>
  );
}

function Pin({label, done, current}) {
  const c = done ? '#5BAE85' : current ? '#F5946F' : '#8B7E66';
  return (
    <div style={{
      background: current ? 'var(--peach-300)' : done ? 'var(--sage-300)' : 'var(--bg)',
      color: '#fff',
      padding:'4px 10px 4px 4px',
      borderRadius:'var(--r-pill)',
      display:'flex', alignItems:'center', gap:6,
      boxShadow:`0 3px 0 ${c}, 0 5px 10px rgba(0,0,0,0.15)`,
      fontSize:11, fontWeight:800,
    }}>
      <div style={{
        width:18, height:18, borderRadius:'50%', background:'#fff',
        color:c, display:'flex', alignItems:'center', justifyContent:'center',
        fontSize:10, fontWeight:900,
      }}>{done?'✓':current?'•':''}</div>
      {label}
    </div>
  );
}
function NextCard({icon, title, lessons, color, locked}) {
  const dk = `var(--${color==='lav'?'lav-500':color==='sun'?'sun-500':'sage-500'})`;
  return (
    <div className="nm-card" style={{
      padding:'14px 16px', display:'flex', alignItems:'center', gap:14,
      opacity: locked?0.6:1,
    }}>
      <div style={{
        width:50, height:50, borderRadius:'var(--r-md)',
        background: locked ? 'var(--bg-deep)' : `var(--${color}-200)`,
        display:'flex', alignItems:'center', justifyContent:'center',
        fontSize:22, boxShadow: locked ? 'var(--nm-in-sm)' : `inset 0 -2px 0 ${dk}33, inset 0 1px 0 rgba(255,255,255,0.5)`,
      }}>{locked ? <Icon.Lock size={22}/> : icon}</div>
      <div style={{flex:1}}>
        <div style={{fontSize:14, fontWeight:800}}>{title}</div>
        <div style={{fontSize:11, fontWeight:600, color:'var(--ink-faint)', marginTop:2}}>{lessons}</div>
      </div>
      <div style={{fontSize:18, color:'var(--ink-faint)'}}>›</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIANT D — Vertical timeline / podium
// ─────────────────────────────────────────────────────────────
function HomeD() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <TopBar streak={7} hearts={4} gems={128}/>

      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'4px 20px 100px'}}>
        {/* Greeting */}
        <div style={{display:'flex', alignItems:'center', gap:14, marginBottom:18}}>
          <TalkyMascot size={70} mood="wave"/>
          <div>
            <div style={{fontSize:12, fontWeight:700, color:'var(--ink-faint)'}}>안녕, 민지님!</div>
            <div style={{fontSize:18, fontWeight:900, color:'var(--ink)', marginTop:2, fontFamily:'var(--font-vn)'}}>
              Xin chào! 👋
            </div>
          </div>
        </div>

        {/* Today goal — neumorphic gauge */}
        <div className="nm-card" style={{padding:'18px', display:'flex', alignItems:'center', gap:16}}>
          <div style={{position:'relative', width:84, height:84}}>
            <svg width="84" height="84" viewBox="0 0 84 84">
              <circle cx="42" cy="42" r="34" fill="none" stroke="var(--bg-deep)" strokeWidth="10"/>
              <circle cx="42" cy="42" r="34" fill="none" stroke="var(--peach-300)" strokeWidth="10"
                strokeDasharray={`${0.6 * 2 * Math.PI * 34} ${2 * Math.PI * 34}`}
                strokeLinecap="round"
                transform="rotate(-90 42 42)"/>
            </svg>
            <div style={{
              position:'absolute', inset:0, display:'flex', alignItems:'center', justifyContent:'center',
              flexDirection:'column',
            }}>
              <div style={{fontSize:18, fontWeight:900, color:'var(--peach-600)'}}>30</div>
              <div style={{fontSize:9, fontWeight:700, color:'var(--ink-faint)'}}>/ 50 XP</div>
            </div>
          </div>
          <div style={{flex:1}}>
            <div style={{fontSize:14, fontWeight:800}}>오늘의 목표</div>
            <div style={{fontSize:11, fontWeight:600, color:'var(--ink-faint)', marginTop:3}}>
              한 레슨만 더 하면 달성!
            </div>
          </div>
        </div>

        {/* Timeline */}
        <div style={{marginTop:24, position:'relative'}}>
          <div style={{
            position:'absolute', left:30, top:30, bottom:30, width:4,
            background:'var(--bg-deep)', borderRadius:2,
            boxShadow:'var(--nm-in-sm)',
          }}/>
          <div style={{
            position:'absolute', left:30, top:30, height:'45%', width:4,
            background:'linear-gradient(180deg, var(--sage-300), var(--peach-300))',
            borderRadius:2,
          }}/>

          {[
            {n:'01', t:'인사하기', s:'완료', c:'sage', state:'done'},
            {n:'02', t:'자기소개', s:'완료', c:'sage', state:'done'},
            {n:'03', t:'카페에서', s:'진행 중 · 3/5', c:'peach', state:'current'},
            {n:'04', t:'전화 걸기', s:'잠금', c:'lav', state:'locked'},
            {n:'05', t:'시장에서', s:'잠금', c:'sun', state:'locked'},
          ].map((it,i)=>(
            <div key={i} style={{
              display:'flex', alignItems:'center', gap:18,
              padding:'10px 0', position:'relative',
            }}>
              <div style={{
                width:64, height:64, flexShrink:0,
                background: it.state==='locked' ? 'var(--bg)' : `var(--${it.c}-300)`,
                color: it.state==='locked' ? 'var(--ink-faint)' : '#fff',
                borderRadius:'50%',
                display:'flex', alignItems:'center', justifyContent:'center',
                fontWeight:900, fontSize:14,
                boxShadow: it.state==='locked' ? 'var(--nm-in-sm)' :
                  `0 5px 0 var(--${it.c}-${it.c==='peach'?400:it.c==='sage'?500:it.c==='lav'?500:500}), 0 8px 12px rgba(0,0,0,0.12)`,
                position:'relative', zIndex:1,
              }}>
                {it.state==='done' ? <Icon.Check size={26}/> :
                 it.state==='locked' ? <Icon.Lock size={20}/> : it.n}
              </div>
              <div style={{
                flex:1,
                padding:'14px 16px',
                background: it.state==='current' ? 'var(--bg)' : 'transparent',
                borderRadius:'var(--r-md)',
                boxShadow: it.state==='current' ? 'var(--nm-out-sm)' : 'none',
              }}>
                <div style={{fontSize:11, fontWeight:800, color:'var(--ink-faint)'}}>DAY {it.n}</div>
                <div style={{fontSize:15, fontWeight:800, marginTop:2,
                  color: it.state==='locked'?'var(--ink-faint)':'var(--ink)'}}>{it.t}</div>
                <div style={{fontSize:11, fontWeight:700,
                  color: it.state==='current' ? 'var(--peach-600)' : 'var(--ink-faint)',
                  marginTop:3}}>{it.s}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
      <TabBar active="home"/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// VARIANT E — Garden / hex world (novel)
// ─────────────────────────────────────────────────────────────
function HomeE() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, #F8E8D0 0%, var(--bg) 50%)'}}>
      <TopBar streak={7} hearts={4} gems={128}/>

      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'4px 0 100px'}}>
        {/* World banner */}
        <div style={{padding:'4px 20px 16px'}}>
          <div style={{fontSize:11, fontWeight:800, color:'var(--peach-600)', letterSpacing:1.5}}>나의 마을</div>
          <div style={{fontSize:24, fontWeight:900, marginTop:2}}>
            <span style={{color:'var(--sage-500)'}}>Hà Nội</span> 카페골목
          </div>
        </div>

        {/* Hex grid */}
        <div style={{
          padding:'10px 0',
          background: 'radial-gradient(ellipse at center, rgba(168,230,207,0.3), transparent 70%)',
        }}>
          <div style={{
            position:'relative', height:380,
            display:'flex', flexDirection:'column', alignItems:'center', gap:0,
          }}>
            <HexRow nodes={[
              {state:'done', color:'sage', label:'인사'},
              {state:'done', color:'sage', label:'이름'},
            ]} offset={0}/>
            <HexRow nodes={[
              {state:'done', color:'sage', label:'숫자'},
              {state:'current', color:'peach', label:'주문', halo:true},
              {state:'available', color:'peach', label:'결제'},
            ]} offset={-1}/>
            <HexRow nodes={[
              {state:'locked'},
              {state:'locked'},
            ]} offset={0}/>
            <HexRow nodes={[
              {state:'locked'},
              {state:'locked'},
              {state:'locked'},
            ]} offset={-1}/>
          </div>
        </div>

        <div style={{padding:'20px', textAlign:'center'}}>
          <div style={{fontSize:13, fontWeight:700, color:'var(--ink-soft)', marginBottom:10}}>
            마을의 <b style={{color:'var(--sage-500)'}}>3 / 9</b> 장소를 알게 되었어요
          </div>
          <button className="btn-pop btn-peach" style={{padding:'14px 28px', fontSize:15}}>
            현재 마을로 이동
          </button>
        </div>
      </div>
      <TabBar active="home"/>
    </div>
  );
}

function HexRow({nodes, offset=0}) {
  return (
    <div style={{
      display:'flex', gap:8, marginLeft: offset * 50,
      marginTop:-12,
    }}>
      {nodes.map((n,i)=> n.state === 'locked' ? (
        <div key={i} style={{
          width:72, height:80,
          clipPath:'polygon(50% 0, 100% 25%, 100% 75%, 50% 100%, 0 75%, 0 25%)',
          background:'var(--bg-deep)',
          display:'flex', alignItems:'center', justifyContent:'center',
          boxShadow:'var(--nm-in-sm)',
        }}>
          <Icon.Lock size={20} color="#A89572"/>
        </div>
      ) : (
        <div key={i} style={{position:'relative', width:72, height:80}}>
          {n.halo && (
            <div style={{
              position:'absolute', inset:-8,
              background:`radial-gradient(circle, var(--${n.color}-300) 0%, transparent 60%)`,
              opacity:0.5, animation:'pulse 2s infinite',
            }}/>
          )}
          <div style={{
            position:'absolute', inset:0,
            clipPath:'polygon(50% 0, 100% 25%, 100% 75%, 50% 100%, 0 75%, 0 25%)',
            background: `linear-gradient(160deg, var(--${n.color}-200), var(--${n.color}-300))`,
            boxShadow: `inset 0 -4px 0 var(--${n.color}-${n.color==='sage'?500:400})66, inset 0 2px 0 rgba(255,255,255,0.4)`,
          }}/>
          <div style={{
            position:'absolute', inset:0,
            display:'flex', alignItems:'center', justifyContent:'center',
            flexDirection:'column', color:'#fff',
            fontWeight:900, fontSize:11,
          }}>
            {n.state === 'done' ? <Icon.Check size={26}/> : <Icon.Star size={20}/>}
            <div style={{fontSize:10, marginTop:2, textShadow:'0 1px 2px rgba(0,0,0,0.2)'}}>{n.label}</div>
          </div>
        </div>
      ))}
    </div>
  );
}

window.HomeA = HomeA;
window.HomeB = HomeB;
window.HomeC = HomeC;
window.HomeD = HomeD;
window.HomeE = HomeE;

// PROFILE & ONBOARDING screens

// ─────────────────────────────────────────────────────────────
// PROFILE A — Stats first
// ─────────────────────────────────────────────────────────────
function ProfileA() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'14px 20px 100px'}}>
        {/* Header card */}
        <div className="nm-card" style={{padding:'22px 18px', display:'flex', alignItems:'center', gap:16}}>
          <div style={{position:'relative'}}>
            <div style={{
              width:80, height:80, borderRadius:'50%',
              background:'linear-gradient(160deg, var(--lav-200), var(--lav-300))',
              display:'flex', alignItems:'center', justifyContent:'center',
              boxShadow:'0 4px 0 var(--lav-500), inset 0 -3px 0 rgba(0,0,0,0.08)',
              fontSize:36,
            }}>👩</div>
            <div style={{
              position:'absolute', bottom:-2, right:-4,
              background:'var(--peach-300)', color:'#fff',
              borderRadius:'var(--r-pill)', padding:'2px 8px',
              fontSize:10, fontWeight:900,
              boxShadow:'0 2px 0 var(--peach-600)',
            }}>Lv 4</div>
          </div>
          <div style={{flex:1}}>
            <div style={{fontSize:18, fontWeight:900}}>김민지</div>
            <div style={{fontSize:11, fontWeight:700, color:'var(--ink-faint)', marginTop:3}}>2026년 3월부터 시작</div>
            <div style={{display:'flex', gap:6, marginTop:8}}>
              <VNFlagChip size={20}/>
              <span style={{fontSize:11, fontWeight:800, color:'var(--ink-soft)'}}>베트남어 학습 중</span>
            </div>
          </div>
        </div>

        {/* Stat cards 2x2 */}
        <div style={{display:'grid', gridTemplateColumns:'1fr 1fr', gap:12, marginTop:14}}>
          <StatCard icon="🔥" value="7" label="연속 학습" color="sun"/>
          <StatCard icon="⚡" value="2,340" label="누적 XP" color="peach"/>
          <StatCard icon="📘" value="42" label="완료한 레슨" color="sage"/>
          <StatCard icon="🌎" value="실버" label="현재 리그" color="lav"/>
        </div>

        {/* Activity */}
        <div style={{marginTop:22, fontSize:13, fontWeight:800, marginBottom:10}}>이번 주 활동</div>
        <div className="nm-card" style={{padding:'18px'}}>
          <div style={{display:'flex', gap:6, alignItems:'flex-end', height:90}}>
            {[20, 35, 28, 50, 0, 15, 40].map((v,i)=>(
              <div key={i} style={{flex:1, display:'flex', flexDirection:'column', alignItems:'center', gap:4}}>
                <div style={{
                  width:'100%', height:`${v*1.4}px`,
                  background: v===0 ? 'var(--bg-deep)' :
                    `linear-gradient(180deg, var(--sage-200), var(--sage-300))`,
                  borderRadius:'8px 8px 4px 4px',
                  boxShadow: v===0 ? 'var(--nm-in-sm)' :
                    'inset 0 -2px 0 var(--sage-500)44, inset 0 2px 0 rgba(255,255,255,0.4)',
                }}/>
                <div style={{fontSize:9, fontWeight:700, color:'var(--ink-faint)'}}>
                  {['월','화','수','목','금','토','일'][i]}
                </div>
              </div>
            ))}
          </div>
          <div style={{
            display:'flex', justifyContent:'space-between', alignItems:'center',
            marginTop:14, paddingTop:14, borderTop:'1px solid var(--bg-deep)',
          }}>
            <div>
              <div style={{fontSize:11, color:'var(--ink-faint)', fontWeight:700}}>총 학습 시간</div>
              <div style={{fontSize:18, fontWeight:900, color:'var(--ink)'}}>3시간 12분</div>
            </div>
            <div style={{textAlign:'right'}}>
              <div style={{fontSize:11, color:'var(--ink-faint)', fontWeight:700}}>일평균</div>
              <div style={{fontSize:18, fontWeight:900, color:'var(--sage-500)'}}>+47 XP</div>
            </div>
          </div>
        </div>

        {/* Achievements */}
        <div style={{marginTop:22, display:'flex', justifyContent:'space-between', alignItems:'baseline'}}>
          <div style={{fontSize:13, fontWeight:800}}>업적</div>
          <span style={{fontSize:11, fontWeight:700, color:'var(--peach-600)'}}>전체 보기 →</span>
        </div>
        <div style={{display:'grid', gridTemplateColumns:'repeat(4, 1fr)', gap:10, marginTop:10}}>
          {[
            {emoji:'🌱', n:'새싹'},
            {emoji:'🔥', n:'7일 불꽃'},
            {emoji:'🎯', n:'정확왕'},
            {emoji:'🔒', n:'잠금'},
          ].map((b,i)=>(
            <div key={i} style={{
              aspectRatio:'1', borderRadius:'var(--r-md)',
              background: i===3 ? 'var(--bg-deep)' : 'var(--bg)',
              boxShadow: i===3 ? 'var(--nm-in-sm)' : 'var(--nm-out-sm)',
              display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:4,
              opacity: i===3 ? 0.5 : 1,
            }}>
              <div style={{fontSize:24}}>{b.emoji}</div>
              <div style={{fontSize:9, fontWeight:800, color:'var(--ink-soft)'}}>{b.n}</div>
            </div>
          ))}
        </div>
      </div>
      <TabBar active="me"/>
    </div>
  );
}

function StatCard({icon, value, label, color}) {
  const dk = `var(--${color}-500)`;
  return (
    <div style={{
      padding:'16px 14px', borderRadius:'var(--r-lg)',
      background:`linear-gradient(160deg, var(--${color}-100), var(--${color}-200))`,
      boxShadow:`inset 0 -3px 0 ${dk}33, inset 0 1px 0 rgba(255,255,255,0.6), 0 4px 12px rgba(167,145,110,0.15)`,
    }}>
      <div style={{fontSize:22}}>{icon}</div>
      <div style={{fontSize:22, fontWeight:900, color:dk, marginTop:6, fontFamily:'var(--font-num)'}}>{value}</div>
      <div style={{fontSize:11, fontWeight:700, color:'var(--ink-soft)', marginTop:2}}>{label}</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// PROFILE B — Avatar focus / showcase
// ─────────────────────────────────────────────────────────────
function ProfileB() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, #DCEFE5 0%, var(--bg) 50%)'}}>
      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'10px 20px 100px'}}>
        {/* Settings icon top right */}
        <div style={{display:'flex', justifyContent:'flex-end', padding:'4px 0 12px'}}>
          <button style={{
            width:36, height:36, borderRadius:'50%', border:'none',
            background:'var(--bg)', boxShadow:'var(--nm-out-sm)', cursor:'pointer',
            fontSize:16,
          }}>⚙️</button>
        </div>

        {/* Big mascot showcase */}
        <div style={{textAlign:'center', position:'relative'}}>
          <div style={{
            width:200, height:200, margin:'0 auto', borderRadius:'50%',
            background:'radial-gradient(circle, var(--sage-100), transparent 70%)',
            display:'flex', alignItems:'center', justifyContent:'center',
            position:'relative',
          }}>
            <div style={{
              position:'absolute', inset:14, borderRadius:'50%',
              background:'var(--bg)', boxShadow:'var(--nm-out-lg)',
            }}/>
            <div style={{position:'relative', zIndex:1}}>
              <TalkyMascot size={150} mood="cheer"/>
            </div>
          </div>
          <div style={{fontSize:22, fontWeight:900, marginTop:18}}>김민지</div>
          <div style={{
            display:'inline-flex', alignItems:'center', gap:5, marginTop:6,
            background:'var(--bg)', padding:'4px 12px', borderRadius:'var(--r-pill)',
            boxShadow:'var(--nm-out-sm)',
            fontSize:11, fontWeight:800, color:'var(--peach-600)',
          }}>
            <span>🌸</span> Lv. 4 · 새싹 학습자
          </div>
        </div>

        {/* XP bar */}
        <div className="nm-card" style={{marginTop:24, padding:'16px 18px'}}>
          <div style={{display:'flex', justifyContent:'space-between', fontSize:12, fontWeight:800, color:'var(--ink-soft)'}}>
            <span>Lv 4 → Lv 5</span>
            <span style={{color:'var(--peach-600)', fontFamily:'var(--font-num)'}}>340 / 500 XP</span>
          </div>
          <div style={{
            marginTop:8, height:12, borderRadius:6,
            background:'var(--bg)', boxShadow:'var(--nm-in-sm)', overflow:'hidden',
          }}>
            <div style={{
              width:'68%', height:'100%',
              background:'linear-gradient(90deg, var(--peach-200), var(--peach-300))',
              boxShadow:'inset 0 -2px 0 rgba(0,0,0,0.1), inset 0 1px 0 rgba(255,255,255,0.5)',
            }}/>
          </div>
        </div>

        {/* Quick stats */}
        <div style={{display:'flex', gap:10, marginTop:14}}>
          {[
            {v:7, l:'연속', c:'sun', i:'🔥'},
            {v:42, l:'레슨', c:'sage', i:'📘'},
            {v:234, l:'단어', c:'lav', i:'🔤'},
          ].map((s,i)=>(
            <div key={i} className="nm-card" style={{flex:1, padding:'14px 8px', textAlign:'center'}}>
              <div style={{fontSize:18}}>{s.i}</div>
              <div style={{fontSize:18, fontWeight:900, color:`var(--${s.c}-500)`, fontFamily:'var(--font-num)', marginTop:3}}>{s.v}</div>
              <div style={{fontSize:10, fontWeight:700, color:'var(--ink-faint)'}}>{s.l}</div>
            </div>
          ))}
        </div>

        {/* Settings list */}
        <div style={{marginTop:22, fontSize:13, fontWeight:800, marginBottom:10}}>설정</div>
        <div className="nm-card" style={{padding:'4px 0', overflow:'hidden'}}>
          {[
            {i:'🎯', t:'학습 목표', s:'15분 / 일'},
            {i:'🔔', t:'알림', s:'오후 7:00'},
            {i:'🎵', t:'음향', s:'켜짐'},
            {i:'💎', t:'프로 멤버십', s:'7일 무료', accent:true},
          ].map((it,i)=>(
            <div key={i} style={{
              padding:'14px 18px', display:'flex', alignItems:'center', gap:14,
              borderBottom: i<3 ? '1px solid var(--bg-deep)' : 'none',
            }}>
              <div style={{fontSize:22, width:30, textAlign:'center'}}>{it.i}</div>
              <div style={{flex:1}}>
                <div style={{fontSize:14, fontWeight:700, color: it.accent?'var(--peach-600)':'var(--ink)'}}>{it.t}</div>
                <div style={{fontSize:11, color:'var(--ink-faint)', fontWeight:600, marginTop:1}}>{it.s}</div>
              </div>
              <div style={{fontSize:18, color:'var(--ink-faint)'}}>›</div>
            </div>
          ))}
        </div>
      </div>
      <TabBar active="me"/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ONBOARDING — language pick + level + goal
// ─────────────────────────────────────────────────────────────
function OnboardingA() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, var(--bg-soft) 0%, var(--peach-100) 100%)',
      padding:'24px 24px 30px',
    }}>
      {/* Top: progress dots */}
      <div style={{display:'flex', gap:6, marginBottom:30}}>
        {[1,2,3,4].map(i=>(
          <div key={i} style={{
            flex:1, height:6, borderRadius:3,
            background: i===1 ? 'var(--peach-300)' : 'var(--bg)',
            boxShadow: i===1 ? 'inset 0 -1px 0 rgba(0,0,0,0.1)' : 'var(--nm-in-sm)',
          }}/>
        ))}
      </div>

      <div style={{textAlign:'center'}}>
        <TalkyMascot size={120} mood="wave"/>
        <div style={{fontSize:24, fontWeight:900, marginTop:14, color:'var(--ink)', lineHeight:1.2}}>
          어서오세요!<br/>
          저는 <span style={{color:'var(--sage-500)'}}>Talky</span>예요
        </div>
        <div style={{fontSize:14, fontWeight:600, color:'var(--ink-soft)', marginTop:10, lineHeight:1.5}}>
          한국인이 베트남어를 배우는<br/>
          가장 즐거운 길을 함께 만들어요
        </div>
      </div>

      <div style={{flex:1}}/>

      <div style={{
        marginTop:24, padding:'14px 16px', borderRadius:'var(--r-md)',
        background:'var(--bg)', boxShadow:'var(--nm-in-sm)',
        display:'flex', alignItems:'center', gap:10,
      }}>
        <div style={{
          width:36, height:36, borderRadius:'50%', background:'var(--sage-200)',
          display:'flex', alignItems:'center', justifyContent:'center', fontSize:18,
        }}>🎁</div>
        <div style={{flex:1, fontSize:12, fontWeight:700, color:'var(--ink-soft)'}}>
          <b style={{color:'var(--sage-500)'}}>7일 무료 체험</b> · 카드 등록 없음
        </div>
      </div>

      <button className="btn-pop btn-peach" style={{
        marginTop:14, padding:'18px', fontSize:16,
      }}>시작하기</button>
      <button style={{
        marginTop:8, padding:'12px', background:'none', border:'none', cursor:'pointer',
        fontSize:13, fontWeight:700, color:'var(--ink-faint)',
      }}>이미 계정이 있어요</button>
    </div>
  );
}

function OnboardingB() {
  // Language selection
  const langs = [
    {n:'베트남어', flag:'🇻🇳', sub:'Tiếng Việt', primary:true},
    {n:'태국어', flag:'🇹🇭', sub:'ภาษาไทย'},
    {n:'러시아어', flag:'🇷🇺', sub:'Русский'},
    {n:'스페인어', flag:'🇪🇸', sub:'Español'},
    {n:'프랑스어', flag:'🇫🇷', sub:'Français'},
    {n:'독일어', flag:'🇩🇪', sub:'Deutsch'},
  ];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <div style={{padding:'14px 20px 0', display:'flex', alignItems:'center', gap:10}}>
        <button style={{
          width:36, height:36, borderRadius:'50%', border:'none',
          background:'var(--bg)', boxShadow:'var(--nm-out-sm)', cursor:'pointer',
          fontSize:18, fontWeight:900,
        }}>‹</button>
        <div style={{display:'flex', gap:6, flex:1, marginLeft:8}}>
          {[1,2,3,4].map(i=>(
            <div key={i} style={{
              flex:1, height:6, borderRadius:3,
              background: i<=2 ? 'var(--sage-300)' : 'var(--bg)',
              boxShadow: i<=2 ? 'inset 0 -1px 0 rgba(0,0,0,0.1)' : 'var(--nm-in-sm)',
            }}/>
          ))}
        </div>
      </div>

      <div style={{padding:'24px 20px 0'}}>
        <div style={{fontSize:24, fontWeight:900, lineHeight:1.2}}>
          어떤 언어를<br/>배워볼까요?
        </div>
        <div style={{fontSize:13, fontWeight:600, color:'var(--ink-soft)', marginTop:8}}>
          나중에 언제든 추가할 수 있어요
        </div>
      </div>

      <div className="scroll-hidden" style={{flex:1, overflowY:'auto', padding:'20px 20px 20px',
        display:'flex', flexDirection:'column', gap:10}}>
        {langs.map((l,i)=>(
          <button key={i} style={{
            padding:'14px 18px', display:'flex', alignItems:'center', gap:14,
            borderRadius:'var(--r-md)', border:'none', cursor:'pointer',
            background: l.primary ? 'var(--sage-100)' : 'var(--bg)',
            boxShadow: l.primary ?
              '0 0 0 3px var(--sage-300), var(--nm-out-sm)' : 'var(--nm-out-sm)',
            textAlign:'left',
          }}>
            <div style={{fontSize:32, lineHeight:1}}>{l.flag}</div>
            <div style={{flex:1}}>
              <div style={{fontSize:15, fontWeight:800, color:'var(--ink)'}}>{l.n}</div>
              <div style={{fontSize:11, fontFamily:'var(--font-vn)', color:'var(--ink-faint)', marginTop:2}}>{l.sub}</div>
            </div>
            {l.primary && (
              <div style={{
                background:'var(--sage-300)', color:'#fff',
                width:24, height:24, borderRadius:'50%',
                display:'flex', alignItems:'center', justifyContent:'center',
                boxShadow:'inset 0 -1px 0 rgba(0,0,0,0.15)',
              }}>
                <Icon.Check size={14}/>
              </div>
            )}
          </button>
        ))}
      </div>

      <div style={{padding:'0 20px 24px'}}>
        <button className="btn-pop btn-sage" style={{width:'100%', padding:'16px', fontSize:15}}>
          계속
        </button>
      </div>
    </div>
  );
}

function OnboardingC() {
  // Goal setting
  const goals = [
    {m:5, t:'가볍게', s:'5분 / 일', i:'🌱'},
    {m:10, t:'꾸준히', s:'10분 / 일', i:'☘️'},
    {m:15, t:'진지하게', s:'15분 / 일', i:'🌿', primary:true},
    {m:30, t:'몰입해서', s:'30분 / 일', i:'🌳'},
  ];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, var(--bg) 0%, var(--sage-50) 100%)',
    }}>
      <div style={{padding:'14px 20px 0', display:'flex', alignItems:'center', gap:10}}>
        <button style={{
          width:36, height:36, borderRadius:'50%', border:'none',
          background:'var(--bg)', boxShadow:'var(--nm-out-sm)', cursor:'pointer',
          fontSize:18, fontWeight:900,
        }}>‹</button>
        <div style={{display:'flex', gap:6, flex:1, marginLeft:8}}>
          {[1,2,3,4].map(i=>(
            <div key={i} style={{
              flex:1, height:6, borderRadius:3,
              background: i<=3 ? 'var(--sage-300)' : 'var(--bg)',
              boxShadow: i<=3 ? 'inset 0 -1px 0 rgba(0,0,0,0.1)' : 'var(--nm-in-sm)',
            }}/>
          ))}
        </div>
      </div>

      <div style={{padding:'24px 20px 0'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--sage-500)', letterSpacing:1.5}}>일일 학습 목표</div>
        <div style={{fontSize:24, fontWeight:900, lineHeight:1.2, marginTop:6}}>
          하루에<br/>얼마나 공부할까요?
        </div>
      </div>

      <div style={{padding:'20px', display:'flex', flexDirection:'column', gap:10, flex:1}}>
        {goals.map((g,i)=>(
          <button key={i} style={{
            padding:'16px 18px', display:'flex', alignItems:'center', gap:16,
            borderRadius:'var(--r-md)', border:'none', cursor:'pointer',
            background: g.primary ? 'var(--bg)' : 'var(--bg)',
            boxShadow: g.primary ?
              '0 0 0 3px var(--sage-300), var(--nm-out-sm)' : 'var(--nm-out-sm)',
            textAlign:'left',
          }}>
            <div style={{
              width:48, height:48, borderRadius:'var(--r-md)',
              background: g.primary ? 'var(--sage-200)' : 'var(--bg-deep)',
              display:'flex', alignItems:'center', justifyContent:'center',
              fontSize:22,
              boxShadow: g.primary ? 'inset 0 -2px 0 rgba(63,142,104,0.2)' : 'var(--nm-in-sm)',
            }}>{g.i}</div>
            <div style={{flex:1}}>
              <div style={{fontSize:15, fontWeight:800, color:'var(--ink)'}}>{g.t}</div>
              <div style={{fontSize:11, fontWeight:700, color:'var(--ink-faint)', marginTop:2}}>{g.s}</div>
            </div>
            {g.primary && (
              <div style={{
                background:'var(--sage-300)', color:'#fff',
                width:26, height:26, borderRadius:'50%',
                display:'flex', alignItems:'center', justifyContent:'center',
                boxShadow:'inset 0 -1px 0 rgba(0,0,0,0.15)',
              }}>
                <Icon.Check size={16}/>
              </div>
            )}
          </button>
        ))}
      </div>

      <div style={{padding:'0 20px 24px'}}>
        <button className="btn-pop btn-sage" style={{width:'100%', padding:'16px', fontSize:15}}>
          시작하기
        </button>
      </div>
    </div>
  );
}

window.ProfileA = ProfileA;
window.ProfileB = ProfileB;
window.OnboardingA = OnboardingA;
window.OnboardingB = OnboardingB;
window.OnboardingC = OnboardingC;

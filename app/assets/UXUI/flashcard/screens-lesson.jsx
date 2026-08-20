// LESSON SCREEN — Conversation/dialogue mode
// 5 variants

// Lesson header — back arrow + heart + progress bar
function LessonHeader({progress=0.4, hearts=4}) {
  return (
    <div style={{padding:'14px 16px 8px', display:'flex', alignItems:'center', gap:12}}>
      <button style={{
        width:36, height:36, borderRadius:'50%', border:'none',
        background:'var(--bg)', boxShadow:'var(--nm-out-sm)', cursor:'pointer',
        display:'flex', alignItems:'center', justifyContent:'center',
        fontSize:18, fontWeight:900, color:'var(--ink-soft)',
      }}>✕</button>
      <div style={{flex:1, height:14, borderRadius:7,
        background:'var(--bg)', boxShadow:'var(--nm-in-sm)', overflow:'hidden', position:'relative',
      }}>
        <div style={{
          width:`${progress*100}%`, height:'100%',
          background:'linear-gradient(90deg, var(--sage-300), var(--sage-400))',
          borderRadius:7,
          boxShadow:'inset 0 -2px 0 rgba(0,0,0,0.1), inset 0 2px 0 rgba(255,255,255,0.5)',
          position:'relative',
        }}>
          <div style={{
            position:'absolute', top:2, left:'8%', right:'8%', height:3,
            background:'rgba(255,255,255,0.5)', borderRadius:2,
          }}/>
        </div>
      </div>
      <div style={{display:'flex', alignItems:'center', gap:4}}>
        <Icon.Heart size={22}/>
        <span style={{fontWeight:800, color:'var(--coral-500)', fontFamily:'var(--font-num)', fontSize:15}}>
          {hearts}
        </span>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON A — Listen & translate (chat-bubble style)
// ─────────────────────────────────────────────────────────────
function LessonA() {
  const options = [
    {t:'안녕하세요', sub:'xin chào'},
    {t:'감사합니다', sub:'cảm ơn'},
    {t:'미안합니다', sub:'xin lỗi'},
    {t:'안녕히 가세요', sub:'tạm biệt'},
  ];
  const [sel, setSel] = React.useState(0);
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <LessonHeader progress={0.4}/>

      <div style={{padding:'8px 20px 0', flex:1, display:'flex', flexDirection:'column'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--peach-600)', letterSpacing:1.5}}>듣고 뜻 고르기</div>
        <div style={{fontSize:22, fontWeight:900, marginTop:6, lineHeight:1.2}}>
          이 베트남어는 무슨 뜻일까요?
        </div>

        {/* Audio bubble + Talky */}
        <div style={{
          marginTop:24, display:'flex', alignItems:'flex-end', gap:10,
        }}>
          <TalkyMascot size={84} mood="happy"/>
          <div style={{
            background:'var(--bg)', borderRadius:'20px 20px 20px 4px',
            padding:'14px 16px', flex:1,
            boxShadow:'var(--nm-out-sm)',
            display:'flex', alignItems:'center', gap:10,
          }}>
            <button style={{
              width:44, height:44, borderRadius:'50%', border:'none',
              background:'var(--sage-300)', cursor:'pointer',
              boxShadow:'0 4px 0 var(--sage-500), 0 6px 10px rgba(63,142,104,0.3)',
              display:'flex', alignItems:'center', justifyContent:'center',
            }}>
              <Icon.Speaker size={22} color="#fff"/>
            </button>
            <div>
              <div style={{
                fontFamily:'var(--font-vn)', fontWeight:800, fontSize:18, color:'var(--ink)',
              }}>Xin chào!</div>
              <div style={{display:'flex', gap:3, marginTop:6}}>
                {[1,2,3,4,5,6,7,8].map(i=>(
                  <div key={i} style={{
                    width:3, height: 6 + Math.abs(Math.sin(i))*14,
                    background:'var(--sage-300)', borderRadius:2,
                  }}/>
                ))}
              </div>
            </div>
          </div>
        </div>

        <button style={{
          alignSelf:'flex-start', marginTop:14, marginLeft:94,
          background:'var(--bg)', border:'none', borderRadius:'var(--r-pill)',
          padding:'6px 12px', fontSize:11, fontWeight:700, color:'var(--ink-faint)',
          boxShadow:'var(--nm-out-sm)', cursor:'pointer',
        }}>🐢 천천히 듣기</button>

        {/* Options */}
        <div style={{flex:1}}/>
        <div style={{display:'flex', flexDirection:'column', gap:10}}>
          {options.map((o,i)=>(
            <button key={i} onClick={()=>setSel(i)} style={{
              background:'var(--bg)', border:'none',
              borderRadius:'var(--r-md)', padding:'14px 18px', textAlign:'left',
              boxShadow: sel===i ?
                '0 0 0 3px var(--sage-300), var(--nm-out-sm)' : 'var(--nm-out-sm)',
              display:'flex', alignItems:'center', gap:14, cursor:'pointer',
            }}>
              <div style={{
                width:28, height:28, borderRadius:8,
                background: sel===i ? 'var(--sage-300)' : 'var(--bg)',
                color: sel===i ? '#fff' : 'var(--ink-faint)',
                boxShadow: sel===i ? 'inset 0 -2px 0 rgba(0,0,0,0.15)' : 'var(--nm-in-sm)',
                display:'flex', alignItems:'center', justifyContent:'center',
                fontSize:12, fontWeight:900,
              }}>{i+1}</div>
              <div>
                <div style={{fontSize:15, fontWeight:800, color:'var(--ink)'}}>{o.t}</div>
                <div style={{fontSize:11, fontFamily:'var(--font-vn)', color:'var(--ink-faint)', marginTop:2}}>{o.sub}</div>
              </div>
            </button>
          ))}
        </div>

        <button className="btn-pop btn-sage" style={{
          marginTop:18, marginBottom:24, padding:'16px', fontSize:15, letterSpacing:0.5,
        }}>확인</button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON B — Word bank assemble sentence
// ─────────────────────────────────────────────────────────────
function LessonB() {
  const built = ['Tôi', 'muốn'];
  const bank = ['cà phê', 'một', 'sữa đá', 'ạ'];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <LessonHeader progress={0.55}/>

      <div style={{padding:'8px 20px', flex:1, display:'flex', flexDirection:'column'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--lav-500)', letterSpacing:1.5}}>문장 만들기</div>
        <div style={{fontSize:20, fontWeight:900, marginTop:6, lineHeight:1.25}}>
          "연유 커피 한 잔 주세요"<br/>
          를 베트남어로 만들어보세요
        </div>

        {/* Hint */}
        <div style={{
          marginTop:18, padding:'12px 14px', borderRadius:'var(--r-md)',
          background:'var(--lav-100)', display:'flex', alignItems:'center', gap:10,
          boxShadow:'inset 0 -2px 0 rgba(134,101,230,0.15), inset 0 1px 0 rgba(255,255,255,0.8)',
        }}>
          <div style={{
            width:32, height:32, borderRadius:'50%', background:'var(--lav-300)',
            display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0,
            boxShadow:'inset 0 -2px 0 rgba(0,0,0,0.1)',
          }}>💡</div>
          <div style={{fontSize:12, color:'var(--ink-soft)', lineHeight:1.4}}>
            <b style={{color:'var(--lav-500)'}}>muốn</b>은 '~를 원하다'.
            연유 커피는 <b style={{color:'var(--lav-500)', fontFamily:'var(--font-vn)'}}>cà phê sữa đá</b>!
          </div>
        </div>

        {/* Build area */}
        <div style={{
          marginTop:20, minHeight:100, padding:'16px',
          borderRadius:'var(--r-md)', background:'var(--bg)',
          boxShadow:'var(--nm-in-sm)',
          borderBottom:'2px dashed var(--bg-deep)',
          display:'flex', flexWrap:'wrap', gap:8, alignContent:'flex-start',
        }}>
          {built.map((w,i)=>(
            <WordChip key={i} active>{w}</WordChip>
          ))}
        </div>

        {/* Word bank */}
        <div style={{
          marginTop:14, padding:'14px',
          display:'flex', flexWrap:'wrap', gap:10,
          minHeight:80,
        }}>
          {bank.map((w,i)=>(
            <WordChip key={i}>{w}</WordChip>
          ))}
        </div>

        <div style={{flex:1}}/>

        <div style={{display:'flex', gap:10, marginBottom:24}}>
          <button style={{
            flex:'0 0 auto', padding:'14px 22px', borderRadius:'var(--r-md)',
            background:'var(--bg)', border:'none', cursor:'pointer',
            boxShadow:'var(--nm-out-sm)',
            fontSize:13, fontWeight:800, color:'var(--ink-faint)',
          }}>건너뛰기</button>
          <button className="btn-pop btn-lav" style={{flex:1, padding:'14px', fontSize:15}}>
            확인
          </button>
        </div>
      </div>
    </div>
  );
}

function WordChip({children, active}) {
  return (
    <div style={{
      padding:'10px 14px', borderRadius:'var(--r-md)',
      background:active ? 'var(--lav-200)' : 'var(--bg)',
      boxShadow: active ?
        '0 3px 0 var(--lav-500), 0 5px 8px rgba(134,101,230,0.25), inset 0 -2px 0 rgba(0,0,0,0.06), inset 0 1px 0 rgba(255,255,255,0.5)' :
        '0 3px 0 #C9B89C, 0 5px 8px rgba(167,145,110,0.2), inset 0 -2px 0 rgba(0,0,0,0.06), inset 0 1px 0 rgba(255,255,255,0.5)',
      fontFamily:'var(--font-vn)', fontWeight:700, fontSize:14,
      color: active ? 'var(--lav-500)' : 'var(--ink)',
      cursor:'pointer',
    }}>{children}</div>
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON C — Speak/pronounce (mic)
// ─────────────────────────────────────────────────────────────
function LessonC() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, var(--bg) 0%, var(--peach-100) 100%)'}}>
      <LessonHeader progress={0.7}/>

      <div style={{padding:'8px 20px', flex:1, display:'flex', flexDirection:'column'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--peach-600)', letterSpacing:1.5}}>따라 말하기</div>
        <div style={{fontSize:20, fontWeight:900, marginTop:6}}>
          마이크 버튼을 누르고 따라 말하세요
        </div>

        {/* Big phrase card */}
        <div className="nm-card" style={{
          marginTop:24, padding:'28px 22px',
          background:'var(--bg)',
        }}>
          <div style={{display:'flex', alignItems:'center', gap:8, marginBottom:14}}>
            <button style={{
              width:40, height:40, borderRadius:'50%', border:'none',
              background:'var(--sage-300)', cursor:'pointer',
              boxShadow:'0 3px 0 var(--sage-500), 0 5px 8px rgba(63,142,104,0.3)',
              display:'flex', alignItems:'center', justifyContent:'center',
            }}>
              <Icon.Speaker size={20} color="#fff"/>
            </button>
            <div style={{
              fontSize:11, fontWeight:700, color:'var(--ink-faint)',
              padding:'4px 10px', borderRadius:'var(--r-pill)',
              background:'var(--bg)', boxShadow:'var(--nm-in-sm)',
            }}>중급 · 6음절</div>
          </div>
          <div style={{
            fontFamily:'var(--font-vn)', fontWeight:900, fontSize:30,
            color:'var(--ink)', lineHeight:1.2,
          }}>
            <span style={{color:'var(--peach-600)'}}>Cà phê</span> sữa đá
          </div>
          <div style={{
            fontSize:13, fontWeight:700, color:'var(--ink-faint)', marginTop:6,
            letterSpacing:0.3,
          }}>
            [까페 스아 다] · 연유 커피
          </div>

          {/* Tone marks */}
          <div style={{display:'flex', gap:6, marginTop:14}}>
            {[
              {t:'Cà', tone:'huyền (낮음)', c:'#5DA8D0'},
              {t:'phê', tone:'평성', c:'#8B7E66'},
              {t:'sữa', tone:'ngã (꺾음)', c:'#D9544A'},
              {t:'đá', tone:'sắc (높음)', c:'#5BAE85'},
            ].map((s,i)=>(
              <div key={i} style={{
                flex:1, padding:'8px', borderRadius:10,
                background:'var(--bg)',
                boxShadow:'var(--nm-in-sm)',
                textAlign:'center',
              }}>
                <div style={{fontFamily:'var(--font-vn)', fontWeight:800, color:s.c, fontSize:14}}>{s.t}</div>
                <div style={{fontSize:8, color:'var(--ink-faint)', fontWeight:700, marginTop:2}}>{s.tone}</div>
              </div>
            ))}
          </div>
        </div>

        <div style={{flex:1, display:'flex', alignItems:'center', justifyContent:'center', position:'relative'}}>
          {/* Pulse rings */}
          <div style={{
            position:'absolute', width:180, height:180, borderRadius:'50%',
            background:'radial-gradient(circle, var(--peach-200) 0%, transparent 70%)',
            opacity:0.6,
          }}/>
          <div style={{
            position:'absolute', width:140, height:140, borderRadius:'50%',
            background:'radial-gradient(circle, var(--peach-300) 0%, transparent 70%)',
            opacity:0.5,
          }}/>

          {/* Mic button */}
          <button style={{
            width:108, height:108, borderRadius:'50%', border:'none',
            background:'linear-gradient(160deg, #FFB59C, #F5946F)',
            boxShadow:'0 8px 0 var(--peach-600), 0 14px 22px rgba(201,99,58,0.45), inset 0 -4px 0 rgba(0,0,0,0.1), inset 0 3px 0 rgba(255,255,255,0.4)',
            cursor:'pointer', display:'flex', alignItems:'center', justifyContent:'center',
            position:'relative',
          }}>
            <Icon.Mic size={48}/>
          </button>
        </div>

        <div style={{textAlign:'center', fontSize:13, fontWeight:700, color:'var(--ink-soft)', marginBottom:20}}>
          탭하고 말하기 · <button style={{
            background:'none', border:'none', color:'var(--peach-600)', fontWeight:800,
            textDecoration:'underline', cursor:'pointer', fontSize:13,
          }}>건너뛰기</button>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON D — Match pairs
// ─────────────────────────────────────────────────────────────
function LessonD() {
  const left = [
    {t:'cà phê', m:false},
    {t:'trà đá', m:true},
    {t:'bánh mì', m:false},
    {t:'phở', m:false},
  ];
  const right = [
    {t:'쌀국수', m:false},
    {t:'커피', m:false},
    {t:'반미 (샌드위치)', m:false},
    {t:'얼음 차', m:true},
  ];
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column', background:'var(--bg)'}}>
      <LessonHeader progress={0.85}/>

      <div style={{padding:'8px 20px', flex:1, display:'flex', flexDirection:'column'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--sage-500)', letterSpacing:1.5}}>짝 맞추기</div>
        <div style={{fontSize:20, fontWeight:900, marginTop:6}}>
          베트남어와 뜻을 연결하세요
        </div>

        <div style={{display:'flex', gap:12, marginTop:24, flex:1}}>
          <div style={{flex:1, display:'flex', flexDirection:'column', gap:10}}>
            {left.map((w,i)=>(
              <button key={i} style={{
                padding:'18px 12px', borderRadius:'var(--r-md)',
                background: w.m ? 'var(--sage-200)' : 'var(--bg)',
                border:'none', cursor:'pointer',
                boxShadow: w.m ?
                  '0 3px 0 var(--sage-400), 0 5px 8px rgba(63,142,104,0.25), inset 0 -2px 0 rgba(0,0,0,0.06)' :
                  'var(--nm-out-sm)',
                fontFamily:'var(--font-vn)', fontWeight:800, fontSize:16,
                color: w.m ? 'var(--sage-700)' : 'var(--ink)',
              }}>{w.t}</button>
            ))}
          </div>
          <div style={{flex:1, display:'flex', flexDirection:'column', gap:10}}>
            {right.map((w,i)=>(
              <button key={i} style={{
                padding:'18px 12px', borderRadius:'var(--r-md)',
                background: w.m ? 'var(--sage-200)' : 'var(--bg)',
                border:'none', cursor:'pointer',
                boxShadow: w.m ?
                  '0 3px 0 var(--sage-400), 0 5px 8px rgba(63,142,104,0.25), inset 0 -2px 0 rgba(0,0,0,0.06)' :
                  'var(--nm-out-sm)',
                fontWeight:800, fontSize:14,
                color: w.m ? 'var(--sage-700)' : 'var(--ink)',
              }}>{w.t}</button>
            ))}
          </div>
        </div>

        <div style={{
          marginTop:14, padding:'12px',
          borderRadius:'var(--r-md)', background:'var(--sage-100)',
          textAlign:'center', fontSize:13, fontWeight:800, color:'var(--sage-700)',
          boxShadow:'inset 0 -2px 0 rgba(63,142,104,0.15), inset 0 1px 0 rgba(255,255,255,0.6)',
        }}>
          ✨ trà đá ↔ 얼음 차 정답!
        </div>

        <button className="btn-pop btn-sage" style={{
          marginTop:14, marginBottom:24, padding:'16px', fontSize:15,
        }}>계속</button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON E — Dialogue / cinematic conversation
// ─────────────────────────────────────────────────────────────
function LessonE() {
  return (
    <div style={{height:'100%', display:'flex', flexDirection:'column',
      background:'linear-gradient(180deg, #F8E8D0 0%, var(--bg) 100%)'}}>
      <LessonHeader progress={0.3}/>

      <div style={{padding:'8px 20px', flex:1, display:'flex', flexDirection:'column'}}>
        <div style={{fontSize:11, fontWeight:800, color:'var(--peach-600)', letterSpacing:1.5}}>회화 듣기 · 카페</div>
        <div style={{fontSize:20, fontWeight:900, marginTop:4}}>
          민지가 카페에 들어갑니다
        </div>

        {/* Scene */}
        <div style={{
          marginTop:16, padding:'16px',
          borderRadius:'var(--r-lg)',
          background:'linear-gradient(160deg, #FFE8D6, #FFD3B6)',
          boxShadow:'inset 0 -3px 0 rgba(245,148,111,0.3), inset 0 2px 0 rgba(255,255,255,0.5)',
          fontSize:12, color:'var(--peach-600)', fontWeight:700,
          display:'flex', alignItems:'center', gap:10,
        }}>
          <span style={{fontSize:20}}>☕</span>
          하노이 시내 길거리 카페. 점원이 인사한다.
        </div>

        {/* Bubbles */}
        <div style={{flex:1, display:'flex', flexDirection:'column', gap:14, marginTop:18, overflowY:'auto'}}>
          {/* Other person */}
          <div style={{display:'flex', alignItems:'flex-end', gap:8}}>
            <div style={{
              width:40, height:40, borderRadius:'50%',
              background:'linear-gradient(160deg, #FFB59C, #F5946F)',
              boxShadow:'inset 0 -2px 0 rgba(0,0,0,0.1)',
              display:'flex', alignItems:'center', justifyContent:'center',
              fontSize:18,
            }}>👨‍🍳</div>
            <div style={{maxWidth:'80%'}}>
              <div style={{fontSize:10, fontWeight:700, color:'var(--ink-faint)', marginBottom:3, marginLeft:4}}>점원 (Anh)</div>
              <div style={{
                background:'var(--bg)', borderRadius:'18px 18px 18px 4px',
                padding:'12px 14px', boxShadow:'var(--nm-out-sm)',
              }}>
                <div style={{fontFamily:'var(--font-vn)', fontWeight:800, fontSize:16, color:'var(--peach-600)'}}>
                  Em uống gì ạ?
                </div>
                <div style={{fontSize:12, color:'var(--ink-faint)', marginTop:4}}>
                  (뭐 마실래요?)
                </div>
                <button style={{
                  marginTop:6, background:'none', border:'none',
                  display:'flex', alignItems:'center', gap:4, padding:0,
                  fontSize:11, color:'var(--sage-500)', fontWeight:700, cursor:'pointer',
                }}>
                  <Icon.Speaker size={14}/> 다시 듣기
                </button>
              </div>
            </div>
          </div>

          {/* User reply (incoming) */}
          <div style={{display:'flex', alignItems:'flex-end', gap:8, justifyContent:'flex-end'}}>
            <div style={{maxWidth:'80%'}}>
              <div style={{fontSize:10, fontWeight:700, color:'var(--ink-faint)', marginBottom:3, textAlign:'right', marginRight:4}}>
                나 (당신의 답변)
              </div>
              <div style={{
                background:'linear-gradient(160deg, var(--sage-200), var(--sage-300))',
                borderRadius:'18px 18px 4px 18px',
                padding:'12px 14px',
                boxShadow:'0 4px 0 var(--sage-500), 0 6px 10px rgba(63,142,104,0.25)',
                color:'#1F4030',
              }}>
                <div style={{fontFamily:'var(--font-vn)', fontWeight:800, fontSize:16}}>
                  Cho em <span style={{
                    background:'rgba(255,255,255,0.6)', padding:'1px 8px',
                    borderRadius:6, color:'var(--sage-700)',
                  }}>___</span> ạ.
                </div>
                <div style={{fontSize:11, marginTop:4, opacity:0.8}}>
                  (___ 주세요.)
                </div>
              </div>
            </div>
            <div style={{
              width:40, height:40, borderRadius:'50%',
              background:'linear-gradient(160deg, var(--lav-200), var(--lav-300))',
              boxShadow:'inset 0 -2px 0 rgba(0,0,0,0.1)',
              display:'flex', alignItems:'center', justifyContent:'center',
              fontSize:18,
            }}>👩</div>
          </div>
        </div>

        {/* Choice chips */}
        <div style={{marginTop:14, fontSize:11, fontWeight:800, color:'var(--ink-faint)', letterSpacing:1}}>빈칸을 채우세요</div>
        <div style={{display:'flex', gap:8, marginTop:8, flexWrap:'wrap'}}>
          {['cà phê sữa đá', 'phở bò', 'bánh mì'].map((w,i)=>(
            <WordChip key={i}>{w}</WordChip>
          ))}
        </div>

        <button className="btn-pop btn-peach" style={{
          marginTop:14, marginBottom:24, padding:'16px', fontSize:15,
        }}>대답하기</button>
      </div>
    </div>
  );
}

window.LessonA = LessonA;
window.LessonB = LessonB;
window.LessonC = LessonC;
window.LessonD = LessonD;
window.LessonE = LessonE;

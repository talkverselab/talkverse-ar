// Common UI atoms for Talkverse screens

// --- Icons ---
const Icon = {
  Flame: ({size=24,color='#E0A82E'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 2 C 13 6 17 8 17 13 C 17 17 14.5 20 12 20 C 9.5 20 7 17 7 13 C 7 11 8 10 9 9 C 9 11 10 12 11 12 C 11 9 12 6 12 2 Z"
        fill={color} stroke={color} strokeWidth="0.5" strokeLinejoin="round"/>
      <path d="M11 14 C 11 16 12 17 13 17 C 14 17 15 16 15 14 C 15 13 14 12 13 12 C 13 13.5 12 14 11 14 Z"
        fill="#FFE89A"/>
    </svg>
  ),
  Heart: ({size=24,color='#FF8E85',filled=true}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 21 C 6 17 2 13 2 8.5 C 2 5.5 4.5 3 7.5 3 C 9.5 3 11 4 12 5.5 C 13 4 14.5 3 16.5 3 C 19.5 3 22 5.5 22 8.5 C 22 13 18 17 12 21 Z"
        fill={filled?color:'none'} stroke={color} strokeWidth="2"/>
    </svg>
  ),
  Gem: ({size=24,color='#8FCDF0'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M6 4 L18 4 L22 10 L12 22 L2 10 Z" fill={color} stroke="#5DA8D0" strokeWidth="1.2" strokeLinejoin="round"/>
      <path d="M6 4 L9 10 L2 10 Z M18 4 L15 10 L22 10 Z M9 10 L15 10 L12 22 Z" fill="rgba(255,255,255,0.3)" stroke="#5DA8D0" strokeWidth="1" strokeLinejoin="round"/>
    </svg>
  ),
  Star: ({size=24,color='#FFD566',filled=true}) => (
    <svg width={size} height={size} viewBox="0 0 24 24">
      <path d="M12 2 L14.5 9 L22 9.3 L16 14 L18 21.5 L12 17.3 L6 21.5 L8 14 L2 9.3 L9.5 9 Z"
        fill={filled?color:'none'} stroke={color} strokeWidth="1.5" strokeLinejoin="round"/>
    </svg>
  ),
  Lock: ({size=20,color='#8B7E66'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="5" y="11" width="14" height="10" rx="2" fill={color}/>
      <path d="M8 11 V 7 C 8 5 10 3 12 3 C 14 3 16 5 16 7 V 11" stroke={color} strokeWidth="2.5" fill="none" strokeLinecap="round"/>
    </svg>
  ),
  Check: ({size=24,color='#fff'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M5 12.5 L10 17.5 L19 7" stroke={color} strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  Play: ({size=20,color='#fff'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24"><path d="M7 4 L19 12 L7 20 Z" fill={color}/></svg>
  ),
  Speaker: ({size=22,color='#5BAE85'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3 9 V 15 H 7 L 12 19 V 5 L 7 9 Z" fill={color}/>
      <path d="M16 8 Q 19 12, 16 16" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <path d="M19 5 Q 23 12, 19 19" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
  Mic: ({size=24,color='#fff'}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="9" y="3" width="6" height="12" rx="3" fill={color}/>
      <path d="M5 11 V 12 C 5 16 8 19 12 19 C 16 19 19 16 19 12 V 11" stroke={color} strokeWidth="2.5" strokeLinecap="round" fill="none"/>
      <path d="M12 19 V 22" stroke={color} strokeWidth="2.5" strokeLinecap="round"/>
    </svg>
  ),
  Home: ({size=26,color='#5A5040',active=false}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3 11 L12 3 L21 11 V 20 C 21 21 20 22 19 22 H 5 C 4 22 3 21 3 20 Z"
        fill={active?'#7FCBA4':'none'} stroke={color} strokeWidth="2" strokeLinejoin="round"/>
    </svg>
  ),
  Book: ({size=26,color='#5A5040',active=false}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M4 4 H 11 C 12 4 12 5 12 5 V 21 C 12 21 12 20 11 20 H 4 Z" fill={active?'#FFB59C':'none'} stroke={color} strokeWidth="2" strokeLinejoin="round"/>
      <path d="M20 4 H 13 C 12 4 12 5 12 5 V 21 C 12 21 12 20 13 20 H 20 Z" fill={active?'#FFB59C':'none'} stroke={color} strokeWidth="2" strokeLinejoin="round"/>
    </svg>
  ),
  Trophy: ({size=26,color='#5A5040',active=false}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M7 4 H 17 V 9 C 17 12 15 14 12 14 C 9 14 7 12 7 9 Z" fill={active?'#FFD566':'none'} stroke={color} strokeWidth="2"/>
      <path d="M7 6 H 4 C 4 8 5 10 7 10 M 17 6 H 20 C 20 8 19 10 17 10" stroke={color} strokeWidth="2" fill="none"/>
      <path d="M9 14 V 18 H 15 V 14 M 8 21 H 16" stroke={color} strokeWidth="2" strokeLinecap="round" fill="none"/>
    </svg>
  ),
  User: ({size=26,color='#5A5040',active=false}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="8" r="4" fill={active?'#B8A1FF':'none'} stroke={color} strokeWidth="2"/>
      <path d="M4 21 C 4 17 7 14 12 14 C 17 14 20 17 20 21" stroke={color} strokeWidth="2" fill={active?'#B8A1FF':'none'} strokeLinecap="round"/>
    </svg>
  ),
  Chat: ({size=26,color='#5A5040',active=false}) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3 6 C 3 4 4 3 6 3 H 18 C 20 3 21 4 21 6 V 14 C 21 16 20 17 18 17 H 9 L 4 21 V 17 C 3 17 3 16 3 14 Z"
        fill={active?'#A8E6CF':'none'} stroke={color} strokeWidth="2" strokeLinejoin="round"/>
    </svg>
  ),
};

// --- Top status bar ---
function TopBar({streak=7, hearts=4, gems=128, level=3}) {
  return (
    <div style={{
      display:'flex', alignItems:'center', gap:10, padding:'10px 16px 14px',
      background:'var(--bg)', position:'sticky', top:0, zIndex:5,
    }}>
      <div style={{
        display:'flex', alignItems:'center', gap:6,
        background:'var(--bg)', borderRadius:'var(--r-pill)',
        padding:'7px 12px 7px 9px', boxShadow:'var(--nm-out-sm)',
      }}>
        <Icon.Flame size={20}/>
        <span style={{fontWeight:800, color:'var(--sun-500)', fontFamily:'var(--font-num)'}}>{streak}</span>
      </div>
      <div style={{flex:1}}/>
      <div style={{
        display:'flex', alignItems:'center', gap:6,
        background:'var(--bg)', borderRadius:'var(--r-pill)',
        padding:'7px 12px 7px 9px', boxShadow:'var(--nm-out-sm)',
      }}>
        <Icon.Gem size={20}/>
        <span style={{fontWeight:800, color:'#5DA8D0', fontFamily:'var(--font-num)'}}>{gems}</span>
      </div>
      <div style={{
        display:'flex', alignItems:'center', gap:6,
        background:'var(--bg)', borderRadius:'var(--r-pill)',
        padding:'7px 12px 7px 9px', boxShadow:'var(--nm-out-sm)',
      }}>
        <Icon.Heart size={20}/>
        <span style={{fontWeight:800, color:'var(--coral-500)', fontFamily:'var(--font-num)'}}>{hearts}</span>
      </div>
    </div>
  );
}

// --- Bottom tab bar ---
function TabBar({active='home'}) {
  const items = [
    {id:'home', icon:Icon.Home, label:'홈'},
    {id:'lesson', icon:Icon.Book, label:'학습'},
    {id:'chat', icon:Icon.Chat, label:'회화'},
    {id:'rank', icon:Icon.Trophy, label:'리그'},
    {id:'me', icon:Icon.User, label:'나'},
  ];
  return (
    <div style={{
      position:'absolute', bottom:0, left:0, right:0,
      background:'var(--bg-soft)',
      borderTop:'1px solid rgba(167,145,110,0.15)',
      padding:'10px 8px 26px',
      display:'flex', justifyContent:'space-around',
      boxShadow:'0 -8px 20px rgba(167,145,110,0.1)',
    }}>
      {items.map(it=>{
        const I = it.icon;
        const isActive = it.id === active;
        return (
          <div key={it.id} style={{
            display:'flex', flexDirection:'column', alignItems:'center', gap:4,
            padding:'6px 10px',
            borderRadius:'var(--r-md)',
            background: isActive ? 'var(--bg)' : 'transparent',
            boxShadow: isActive ? 'var(--nm-in-sm)' : 'none',
          }}>
            <I size={24} color={isActive ? 'var(--ink)' : '#8B7E66'} active={isActive}/>
            <span style={{
              fontSize:10, fontWeight: isActive ? 800 : 600,
              color: isActive ? 'var(--ink)' : '#8B7E66',
            }}>{it.label}</span>
          </div>
        );
      })}
    </div>
  );
}

// --- VN flag chip ---
function VNFlagChip({size=22}) {
  return (
    <div style={{
      width:size, height:size, borderRadius:'50%',
      background:'#DA251D',
      display:'flex', alignItems:'center', justifyContent:'center',
      boxShadow:'inset 0 -1px 2px rgba(0,0,0,0.2), 0 1px 2px rgba(0,0,0,0.15)',
    }}>
      <svg width={size*0.55} height={size*0.55} viewBox="0 0 24 24">
        <path d="M12 2 L14.5 9 L22 9.3 L16 14 L18 21.5 L12 17.3 L6 21.5 L8 14 L2 9.3 L9.5 9 Z" fill="#FFCD2E"/>
      </svg>
    </div>
  );
}

window.Icon = Icon;
window.TopBar = TopBar;
window.TabBar = TabBar;
window.VNFlagChip = VNFlagChip;

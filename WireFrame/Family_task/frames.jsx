// frames.jsx — sketchy primitives + Phone/Tablet shells used everywhere

const Phone = ({ children, label = 'iPhone', screenStyle }) => (
  <div>
    <div className="wf-phone">
      <div className="wf-phone-inner" style={screenStyle}>{children}</div>
    </div>
    <div className="wf-device-label">{label}</div>
  </div>
);

const Tablet = ({ children, label = 'iPad', screenStyle }) => (
  <div>
    <div className="wf-tablet">
      <div className="wf-tablet-inner" style={screenStyle}>{children}</div>
    </div>
    <div className="wf-device-label">{label}</div>
  </div>
);

// Status bar — generic
const StatusBar = () => (
  <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', padding:'2px 14px', fontSize:9, fontFamily:'JetBrains Mono, monospace', color:'var(--ink-soft)' }}>
    <span>9:41</span>
    <span style={{ display:'flex', gap:4 }}>
      <span>•••</span>
      <span>▮▮</span>
    </span>
  </div>
);

// hatched placeholder with caption inside
const Placeholder = ({ children, h, w='100%', style, soft }) => (
  <div className={`wf-stroke-thin ${soft ? 'wf-hatch-soft' : 'wf-hatch'}`}
       style={{ width:w, height:h, display:'flex', alignItems:'center', justifyContent:'center', ...style }}>
    <span className="wf-explain">{children}</span>
  </div>
);

const Check = ({ on }) => <span className={`wf-checkbox ${on?'checked':''}`}></span>;

const Avatar = ({ initial='A', tone='blue', size }) => (
  <span className={`wf-avatar ${size||''} ${tone}`}>{initial}</span>
);

const TaskRow = ({ done, title, meta, who, density='regular' }) => (
  <div className="wf-row" style={{ padding: density==='compact'?'5px 0':'8px 0', borderBottom:'1px dashed var(--ink-soft)' }}>
    <Check on={done}/>
    <div style={{ flex:1, minWidth:0 }}>
      <div style={{ fontSize:13, textDecoration: done?'line-through':'none', opacity: done?0.55:1, lineHeight:1.15 }}>{title}</div>
      {meta && <div style={{ fontSize:10, color:'var(--ink-soft)', marginTop:2 }}>{meta}</div>}
    </div>
    {who}
  </div>
);

const TaskRowBig = ({ done, title, meta, who, density='regular' }) => (
  <div className="wf-row wf-stroke-thin" style={{ padding: density==='compact'?'7px 10px':'10px 12px', background:'var(--paper)' }}>
    <Check on={done}/>
    <div style={{ flex:1, minWidth:0 }}>
      <div style={{ fontSize:14, textDecoration: done?'line-through':'none', opacity: done?0.55:1, lineHeight:1.2, fontWeight:done?'400':'500' }}>{title}</div>
      {meta && <div style={{ fontSize:10, color:'var(--ink-soft)', marginTop:2 }}>{meta}</div>}
    </div>
    {who}
  </div>
);

const Pill = ({ children, tone='' }) => (
  <span className={`wf-pill ${tone}`}>{children}</span>
);

const Btn = ({ children, primary, full, style, onClick }) => (
  <div className={`wf-btn ${primary?'primary':''}`} style={{ width: full?'100%':'auto', ...style }} onClick={onClick}>{children}</div>
);

const Section = ({ label, children, style }) => (
  <div style={{ marginBottom:10, ...style }}>
    <div className="wf-section-label" style={{ marginBottom:6 }}>{label}</div>
    {children}
  </div>
);

const Star = ({ filled=true }) => (
  <span style={{ fontSize:14, color: filled?'var(--warn)':'var(--ink-faint)' }}>{filled?'★':'☆'}</span>
);

const StickyNote = ({ children, rotate=-2, style }) => (
  <div className="wf-stickynote" style={{ transform:`rotate(${rotate}deg)`, ...style }}>{children}</div>
);

const Tabbar = ({ items=['Home','Tasks','Stars','Me'], active=0 }) => (
  <div className="wf-tabbar" style={{ position:'absolute', bottom:0, left:0, right:0 }}>
    {items.map((it,i)=>(
      <div key={i} className={`wf-tabbar-item ${i===active?'active':''}`}>
        <span className="ic"></span>
        <span>{it}</span>
      </div>
    ))}
  </div>
);

const ProgressBar = ({ pct=60, color='var(--accent)' }) => (
  <div style={{ position:'relative', height:10, border:'1.4px solid var(--ink)', borderRadius:6, background:'var(--paper)' }}>
    <div style={{ position:'absolute', top:0, left:0, bottom:0, width:`${pct}%`, background:color, borderRadius:5 }}></div>
  </div>
);

const Star3 = ({ count=2, total=3 }) => (
  <span style={{ display:'inline-flex', gap:2 }}>
    {Array.from({length:total}).map((_,i)=> <Star key={i} filled={i<count}/>)}
  </span>
);

// caption line for handwritten notes
const Note = ({ children, style }) => (
  <div style={{ fontFamily:'Caveat, cursive', fontSize:14, color:'var(--ink-soft)', ...style }}>{children}</div>
);

// Caption above artboard pair
const ArtboardShell = ({ caption, sub, children }) => (
  <div className="wf-artboard">
    <div className="wf-artboard-caption">{caption}</div>
    <div className="wf-artboard-subcap">{sub}</div>
    <div className="wf-artboard-stage">{children}</div>
  </div>
);

Object.assign(window, {
  Phone, Tablet, StatusBar, Placeholder, Check, Avatar, TaskRow, TaskRowBig,
  Pill, Btn, Section, Star, Star3, StickyNote, Tabbar, ProgressBar, Note, ArtboardShell
});

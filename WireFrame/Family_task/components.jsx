// components.jsx — shared sketchy primitives + device frames

function Phone({ label = 'iPhone', children }) {
  return (
    <div className="wf-device-wrap">
      <div className="wf-phone">
        <div className="wf-phone-inner">{children}</div>
      </div>
      <div className="wf-device-tag">{label}</div>
    </div>
  );
}

function Tablet({ label = 'iPad', children }) {
  return (
    <div className="wf-device-wrap">
      <div className="wf-tablet">
        <div className="wf-tablet-inner">{children}</div>
      </div>
      <div className="wf-device-tag">{label}</div>
    </div>
  );
}

// shared little parts
function Check({ size='', done=false, accent=false }) {
  const cls = `wf-checkbox ${size} ${done?'checked':''} ${accent?'accent':''}`;
  return <span className={cls}>{done?'✓':''}</span>;
}
function Avatar({ tone='', size='', children }) {
  return <span className={`wf-avatar ${tone} ${size}`}>{children}</span>;
}
function Pill({ tone='', children }) {
  return <span className={`wf-pill ${tone}`}>{children}</span>;
}
function Btn({ tone='', size='', block=false, children }) {
  return <span className={`wf-btn ${tone} ${size} ${block?'block':''}`}>{children}</span>;
}
function Img({ w, h, label='photo', style }) {
  return <div className="wf-img" style={{ width:w, height:h, ...style }}><span>{label}</span></div>;
}
function Stars({ filled=3, total=5, size=12 }) {
  return (
    <span style={{ fontFamily:'var(--hand-head)', fontSize:size, letterSpacing:1, lineHeight:1 }}>
      {Array.from({length: total}).map((_,i) =>
        <span key={i} style={{ color: i<filled ? '#f0b043' : '#cfcec7' }}>★</span>
      )}
    </span>
  );
}
function Progress({ pct=50 }) {
  return <div className="wf-progress"><span style={{ width: `${pct}%` }}/></div>;
}
function StatusBar() {
  return (
    <div style={{display:'flex', justifyContent:'space-between', fontFamily:'var(--hand-arch)', fontSize:8, color:'var(--ink-faint)', marginBottom:4 }}>
      <span>9:41</span>
      <span>● ● ●</span>
    </div>
  );
}

Object.assign(window, { Phone, Tablet, Check, Avatar, Pill, Btn, Img, Stars, Progress, StatusBar });

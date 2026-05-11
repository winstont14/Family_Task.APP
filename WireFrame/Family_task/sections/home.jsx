// sections/home.jsx — phone = PARENT today's overview · tablet = CHILD's playful workspace

const KIDS = [
  {n:'Emma', i:'E', t:'mint',  age:7},
  {n:'Leo',  i:'L', t:'lilac', age:5},
  {n:'Riya', i:'R', t:'peach', age:9},
];

// V1 — Classic list, parent grouped by child
const HmV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><div className="wf-h">Today</div><div className="wf-spacer"/><Avatar tone="peach">M</Avatar></div>
  <div className="wf-cap">tue · may 12</div>
  <div className="scr-scroll">
    {KIDS.map(k => (
      <div key={k.n}>
        <div className="wf-row" style={{gap:6, margin:'4px 0'}}>
          <Avatar tone={k.t}>{k.i}</Avatar>
          <span style={{fontFamily:'var(--hand-head)', fontSize:16}}>{k.n}</span>
          <div className="wf-spacer"/><Pill>{k.n==='Emma'?'2/3':k.n==='Leo'?'1/2':'0/2'}</Pill>
        </div>
        <div className="wf-col" style={{gap:5}}>
          {[
            ['Clean room', false], ['Feed cat', true], ['Homework', false]
          ].slice(0, k.n==='Emma'?3:2).map(([t,d],i)=>(
            <div key={i} className="wf-row wf-stroke-thin" style={{padding:'5px 7px', gap:7}}>
              <Check size="" done={d}/><span style={{fontSize:11, textDecoration:d?'line-through':'none', color:d?'var(--ink-faint)':''}}>{t}</span>
            </div>
          ))}
        </div>
      </div>
    ))}
  </div>
  <div style={{position:'relative'}}><div className="wf-fab" style={{right:0,bottom:0,position:'absolute'}}>+</div></div>
  <div className="wf-tabbar"><div className="tab on"><div className="icn"/>Home</div><div className="tab"><div className="icn"/>Family</div><div className="tab"><div className="icn"/>Rewards</div></div>
</div>);
const HmV1T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Hi, Emma 🦊</div><div className="wf-spacer"/><Pill tone="accent">⭐ 12</Pill></div>
  <div className="wf-h2 wf-muted">3 things to do today</div>
  <div className="scr-scroll" style={{gap:10, marginTop:6}}>
    {[
      ['Clean your room','until 5pm', false, '🧸'],
      ['Feed the cat','before lunch', true, '🐱'],
      ['Finish homework','today', false, '📓'],
    ].map(([t,sub,d,e],i)=>(
      <div key={i} className={`wf-card wf-row ${d?'wf-fill-done':''}`} style={{padding:'12px 14px', gap:12, opacity:d?0.7:1}}>
        <Check size="xl" done={d}/>
        <div className="wf-col" style={{gap:0,flex:1}}>
          <div style={{fontSize:18, fontFamily:'var(--hand-head)', textDecoration:d?'line-through':''}}>{t}</div>
          <div className="wf-cap">{sub}</div>
        </div>
        <div style={{fontSize:30}}>{e}</div>
      </div>
    ))}
  </div>
  <div className="wf-tabbar" style={{margin:'auto -14px -12px'}}>
    <div className="tab on"><div className="icn"/>Today</div><div className="tab"><div className="icn"/>Done</div><div className="tab"><div className="icn"/>⭐ Stars</div>
  </div>
</div>);

// V2 — Per-child column tabs (parent), per-section tabs (child)
const HmV2P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Family today</div>
  <div className="wf-row" style={{gap:0, borderBottom:'1.4px solid var(--ink)', paddingBottom:4}}>
    {['Emma','Leo','Riya','+'].map((n,i)=>(
      <div key={n} style={{flex:1, textAlign:'center', fontFamily:'var(--hand-head)', fontSize:14, color: i===0?'var(--accent)':'var(--ink-faint)', borderBottom:i===0?'2px solid var(--accent)':'none', paddingBottom:3, marginBottom:-5}}>{n}</div>
    ))}
  </div>
  <div className="wf-cap">emma's day · 2/3</div>
  <div className="scr-scroll">
    {[['Clean room',false],['Feed cat',true],['Homework',false]].map(([t,d],i)=>(
      <div key={i} className="wf-row wf-stroke" style={{padding:'7px 9px', gap:8}}>
        <Check done={d}/><span style={{fontSize:12,textDecoration:d?'line-through':''}}>{t}</span>
        <div className="wf-spacer"/><span className="wf-cap">5pm</span>
      </div>
    ))}
  </div>
  <Btn tone="primary" size="lg" block>+ add for Emma</Btn>
</div>);
const HmV2T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">My day</div><div className="wf-spacer"/><Avatar tone="mint" size="lg">E</Avatar></div>
  <div className="wf-row" style={{gap:8, marginTop:4}}>
    {['🌅 Morning','☀ Day','🌙 Night'].map((t,i)=>(
      <div key={t} className={`wf-stroke ${i===1?'wf-fill-accent':''}`} style={{flex:1, padding:'8px 10px', textAlign:'center', fontFamily:'var(--hand-head)', fontSize:16, color:i===1?'#fff':'var(--ink)'}}>{t}</div>
    ))}
  </div>
  <div className="scr-scroll" style={{gap:8, marginTop:8}}>
    {[['Tidy backpack','🎒',false],['Practice piano','🎹',false],['Read 20 min','📖',true]].map(([t,e,d],i)=>(
      <div key={i} className="wf-card wf-row" style={{padding:10, gap:10}}>
        <Check size="lg" done={d}/><div style={{fontSize:24}}>{e}</div>
        <div style={{fontSize:16, fontFamily:'var(--hand-head)', flex:1, textDecoration:d?'line-through':''}}>{t}</div>
        <Btn tone={d?'':'primary'}>{d?'done!':'I did it'}</Btn>
      </div>
    ))}
  </div>
</div>);

// V3 — Kanban today / done (parent)
const HmV3P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Today</div>
  <div className="wf-row" style={{gap:6, flex:1, minHeight:0}}>
    {['Todo','Done'].map((c,i)=>(
      <div key={c} className="wf-stroke wf-col" style={{flex:1, padding:6, gap:5}}>
        <div className="wf-cap">{c} · {i?2:3}</div>
        {(i?[['Feed cat','E'],['Plants','L']]:[['Room','E'],['HW','E'],['Toys','L']]).map(([t,k],j)=>(
          <div key={j} className="wf-stroke-thin" style={{padding:'4px 6px', fontSize:10}}>
            <div style={{fontFamily:'var(--hand-head)', fontSize:13}}>{t}</div>
            <div className="wf-row" style={{gap:3}}><Avatar tone={k==='E'?'mint':'lilac'} size="">{k}</Avatar><span className="wf-cap">5pm</span></div>
          </div>
        ))}
      </div>
    ))}
  </div>
  <Btn tone="primary" block>+ task</Btn>
</div>);
const HmV3T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-lg">Emma's board</div><div className="wf-spacer"/><Stars filled={2}/></div>
  <div className="wf-row" style={{gap:10, flex:1, minHeight:0}}>
    {[
      {h:'To do',  e:'⏳', items:[['Clean room','🧸','5pm'],['Feed cat','🐱','noon']]},
      {h:'Doing',  e:'✏', items:[['Homework','📓','now']]},
      {h:'Done!',  e:'🎉', items:[['Brush teeth','🪥',''],['Read book','📖','']]},
    ].map(col=>(
      <div key={col.h} className="wf-stroke wf-col" style={{flex:1, padding:8, gap:6, background: col.h==='Done!'?'rgba(184,216,186,0.25)':'#fff'}}>
        <div className="wf-row"><span style={{fontSize:18}}>{col.e}</span><span style={{fontFamily:'var(--hand-head)', fontSize:16}}>{col.h}</span></div>
        {col.items.map((it,j)=>(
          <div key={j} className="wf-card-soft" style={{padding:6}}>
            <div style={{fontFamily:'var(--hand-head)', fontSize:14}}>{it[0]}</div>
            <div className="wf-row" style={{justifyContent:'space-between'}}><span style={{fontSize:18}}>{it[1]}</span><span className="wf-cap">{it[2]}</span></div>
          </div>
        ))}
      </div>
    ))}
  </div>
</div>);

// V4 — Big card grid (very visual, kid-leaning even on parent)
const HmV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Today's tasks</div>
  <div className="wf-cap">all kids · 4 of 7 done</div>
  <Progress pct={57}/>
  <div style={{display:'grid',gridTemplateColumns:'1fr 1fr', gap:6, marginTop:6}}>
    {[
      ['Clean room','E','peach',false],
      ['Feed cat','E','peach',true],
      ['Plants','L','mint',true],
      ['Homework','R','lilac',false],
      ['Toys away','L','mint',false],
      ['Set table','R','lilac',true],
    ].map(([t,k,c,d],i)=>(
      <div key={i} className={`wf-card wf-col ${d?'wf-fill-done':''}`} style={{padding:8, gap:5, opacity:d?0.7:1}}>
        <Avatar tone={c}>{k}</Avatar>
        <div style={{fontSize:11,fontFamily:'var(--hand-head)'}}>{t}</div>
        <div className="wf-row"><Check size="" done={d}/><div className="wf-spacer"/><span className="wf-cap">5pm</span></div>
      </div>
    ))}
  </div>
</div>);
const HmV4T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Hi Leo! 🐯</div><div className="wf-spacer"/><Pill tone="accent">⭐ 8 stars</Pill></div>
  <div className="wf-h2 wf-muted">Tap a card to start</div>
  <div style={{display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:10, marginTop:8}}>
    {[
      ['🧸','Toys away',false],['🐱','Feed cat',true],['🪥','Brush teeth',false],
      ['📖','Read book',false],['🥕','Eat veg',true],['🌱','Water plants',false],
    ].map(([e,t,d],i)=>(
      <div key={i} className={`wf-card wf-col ${d?'wf-fill-done':''}`} style={{padding:14, alignItems:'center', gap:6, aspectRatio:'1'}}>
        <div style={{fontSize:36}}>{e}</div>
        <div style={{fontSize:14, fontFamily:'var(--hand-head)', textAlign:'center'}}>{t}</div>
        <Check size="lg" done={d}/>
      </div>
    ))}
  </div>
</div>);

// V5 — Calendar strip (parent), today timeline (child)
const HmV5P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><div className="wf-h">May</div><div className="wf-spacer"/><span className="wf-cap">week 19</span></div>
  <div className="wf-row" style={{gap:3, justifyContent:'space-between'}}>
    {['M','T','W','T','F','S','S'].map((d,i)=>(
      <div key={i} className={`wf-stroke ${i===1?'wf-fill-accent':''}`} style={{flex:1, padding:'5px 0', textAlign:'center', borderRadius:8, color:i===1?'#fff':'', fontFamily:'var(--hand-head)'}}>
        <div style={{fontSize:9, opacity:0.7}}>{d}</div><div style={{fontSize:14, lineHeight:1}}>{10+i}</div>
        <div className="wf-row" style={{justifyContent:'center', gap:1, marginTop:1}}>
          {[1,2,3].slice(0,i%3+1).map(x=><span key={x} style={{width:3,height:3,borderRadius:'50%',background:i===1?'#fff':'var(--accent)'}}/>)}
        </div>
      </div>
    ))}
  </div>
  <div className="wf-cap" style={{marginTop:6}}>tue · 5 tasks</div>
  <div className="scr-scroll">
    {[['7am','Make beds','all'],['noon','Feed cat','E'],['3pm','Homework','R'],['5pm','Tidy room','E'],['7pm','Toys','L']].map(([h,t,k],i)=>(
      <div key={i} className="wf-row wf-stroke-thin" style={{padding:'5px 7px', gap:7}}>
        <span className="wf-cap" style={{width:32}}>{h}</span><span style={{flex:1, fontSize:11}}>{t}</span><Pill>{k}</Pill>
      </div>
    ))}
  </div>
</div>);
const HmV5T = () => (<div className="scr">
  <div className="wf-h-xl">Today's path 🐾</div>
  <div className="scr-scroll" style={{gap:0, paddingLeft:30, position:'relative', marginTop:6}}>
    <div style={{position:'absolute', left:14, top:0, bottom:0, borderLeft:'2px dashed var(--accent)'}}/>
    {[
      ['7:00','🌅','Make my bed', true],
      ['12:00','🐱','Feed the cat', true],
      ['15:00','📓','Homework time', false],
      ['17:00','🧸','Tidy the room', false],
      ['19:00','🛁','Bath time', false],
    ].map(([h,e,t,d],i)=>(
      <div key={i} className="wf-row" style={{gap:10, padding:'7px 0'}}>
        <div className="wf-stroke" style={{width:30,height:30,borderRadius:'50%',background:d?'var(--done)':'#fff',display:'flex',alignItems:'center',justifyContent:'center', position:'absolute', left:0, fontSize:16}}>{e}</div>
        <div className="wf-col" style={{gap:1, marginLeft:4}}>
          <div className="wf-cap">{h}</div>
          <div style={{fontFamily:'var(--hand-head)', fontSize:18, textDecoration:d?'line-through':''}}>{t}</div>
        </div>
        <div className="wf-spacer"/><Check size="lg" done={d}/>
      </div>
    ))}
  </div>
</div>);

// V6 — Notion-style toggle blocks (parent), blocks (child too)
const HmV6P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Family workspace</div>
  <div className="wf-cap">tue, may 12 · 3 of 7 done</div>
  <div className="scr-scroll" style={{gap:4}}>
    {[
      ['▼','Today','3/7'],
    ].map(([a,t,c],i)=>(
      <div key={i}>
        <div className="wf-row" style={{gap:5}}>
          <span className="wf-muted">{a}</span><span style={{fontFamily:'var(--hand-head)', fontSize:16}}>{t}</span>
          <div className="wf-spacer"/><Pill tone="faint">{c}</Pill>
        </div>
        <div style={{paddingLeft:12, display:'flex', flexDirection:'column', gap:3, marginTop:2}}>
          {[['Clean room','E',false],['Feed cat','E',true],['Plants','L',true],['HW','R',false]].map(([t,k,d],j)=>(
            <div key={j} className="wf-row" style={{gap:6, padding:'2px 0', borderBottom:'1px dotted var(--ink-faint)'}}>
              <Check size="" done={d}/>
              <span style={{fontSize:11, textDecoration:d?'line-through':'', color:d?'var(--ink-faint)':''}}>{t}</span>
              <div className="wf-spacer"/><Avatar tone={k==='E'?'mint':k==='L'?'lilac':'peach'}>{k}</Avatar>
            </div>
          ))}
        </div>
      </div>
    ))}
    <div className="wf-row" style={{gap:5,marginTop:5}}><span className="wf-muted">▶</span><span style={{fontFamily:'var(--hand-head)',fontSize:14}}>This week</span><div className="wf-spacer"/><Pill tone="faint">12</Pill></div>
    <div className="wf-row" style={{gap:5}}><span className="wf-muted">▶</span><span style={{fontFamily:'var(--hand-head)',fontSize:14}}>Backlog</span><div className="wf-spacer"/><Pill tone="faint">5</Pill></div>
  </div>
</div>);
const HmV6T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-xl">Emma's space</div><div className="wf-spacer"/><span className="wf-cap">tue may 12</span></div>
  <div className="scr-scroll" style={{gap:7}}>
    <div className="wf-card-soft">
      <div className="wf-row"><span style={{fontSize:18}}>📌</span><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>Note from mom</span></div>
      <div style={{fontSize:13, marginTop:3}}>Don't forget piano practice today, lovely. Mom 💛</div>
    </div>
    <div className="wf-row" style={{gap:5}}><span className="wf-muted">▼</span><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>Today</span><div className="wf-spacer"/><Pill tone="accent">2 / 4</Pill></div>
    <div style={{paddingLeft:14, display:'flex', flexDirection:'column', gap:5}}>
      {[['Clean room',false,'🧸'],['Feed cat',true,'🐱'],['Piano practice',false,'🎹'],['Read book',true,'📖']].map(([t,d,e],i)=>(
        <div key={i} className="wf-row wf-card" style={{padding:'7px 9px', gap:8, opacity:d?0.7:1}}>
          <Check size="lg" done={d}/><span style={{fontSize:18}}>{e}</span>
          <span style={{fontSize:14, fontFamily:'var(--hand-head)', textDecoration:d?'line-through':''}}>{t}</span>
        </div>
      ))}
    </div>
    <div className="wf-row" style={{gap:5,marginTop:4}}><span className="wf-muted">▶</span><span style={{fontFamily:'var(--hand-head)',fontSize:16}}>Tomorrow</span></div>
  </div>
</div>);

window.HomeVariations = [
  { id:'hm-v1', label:'V1 · Grouped list',       cap:'Tasks grouped by child',          sub:'Phone parent · tablet kid card stack',          P:HmV1P, T:HmV1T },
  { id:'hm-v2', label:'V2 · Per-child tabs',     cap:'Top tabs per family member',      sub:'Phone tabs · tablet morning/day/night',         P:HmV2P, T:HmV2T },
  { id:'hm-v3', label:'V3 · Kanban board',       cap:'Todo / done columns',             sub:'Drag-style · feels like a game board',         P:HmV3P, T:HmV3T },
  { id:'hm-v4', label:'V4 · Big icon grid',      cap:'Tap-friendly card grid',          sub:'Most playful · large emoji cards',             P:HmV4P, T:HmV4T },
  { id:'hm-v5', label:'V5 · Calendar / path',    cap:'Week strip · timeline path',       sub:'Time-anchored · kid sees a journey',           P:HmV5P, T:HmV5T },
  { id:'hm-v6', label:'V6 · Notion blocks',      cap:'Toggle blocks workspace',         sub:'Closest to brief · power layout',              P:HmV6P, T:HmV6T },
];

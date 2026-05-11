// sections/addtask.jsx — 6 variations: parent creates / assigns task

const KIDS = [
  {n:'Emma', t:'mint'},
  {n:'Leo',  t:'lilac'},
  {n:'Riya', t:'peach'},
];

// V1 — Bottom sheet wizard (3 small steps)
const AddV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><span className="icn-back wf-muted"/><div className="wf-h">New task</div><div className="wf-spacer"/><span className="wf-cap">1 / 3</span></div>
  <div className="wf-cap">what is it?</div>
  <div className="wf-stroke" style={{padding:'10px 12px', fontFamily:'var(--hand-head)', fontSize:18, color:'var(--ink-faint)'}}>Clean your room ___</div>
  <div className="wf-cap">quick picks</div>
  <div className="wf-row" style={{flexWrap:'wrap', gap:5}}>
    {['🧸 Tidy toys','🐱 Feed cat','🪥 Brush teeth','🌱 Water plants','📖 Read'].map(p=>(<Pill key={p} tone="faint">{p}</Pill>))}
  </div>
  <div className="scr-foot wf-row"><Btn>cancel</Btn><div className="wf-spacer"/><Btn tone="primary" size="lg">Next: who? →</Btn></div>
</div>);
const AddV1T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Add a task</div><div className="wf-spacer"/><Pill>step 1 of 3</Pill></div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'flex-start', minHeight:0}}>
    <div className="wf-col" style={{flex:1.2, gap:8}}>
      <div className="wf-cap">title</div>
      <div className="wf-stroke" style={{padding:'14px 16px', fontFamily:'var(--hand-head)', fontSize:24, color:'var(--ink-faint)'}}>Clean your room ___</div>
      <div className="wf-cap">notes (optional)</div>
      <div className="wf-stroke-thin" style={{padding:'10px 12px', minHeight:60, fontFamily:'var(--hand-body)', color:'var(--ink-faint)'}}>Don't forget under the bed!</div>
    </div>
    <div className="wf-col" style={{flex:1, gap:5}}>
      <div className="wf-cap">quick picks</div>
      {['🧸 Tidy toys','🐱 Feed the cat','🪥 Brush teeth','🌱 Water plants','📖 Read 20 min','🛏 Make bed'].map(p=>(
        <div key={p} className="wf-stroke-thin" style={{padding:'7px 10px', fontSize:13}}>{p}</div>
      ))}
    </div>
  </div>
  <div className="scr-foot wf-row"><Btn>cancel</Btn><div className="wf-spacer"/><Btn tone="primary" size="xl">Next: who? →</Btn></div>
</div>);

// V2 — Single-screen form (Notion-y, all fields visible)
const AddV2P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-row"><span className="icn-back wf-muted"/><div className="wf-h">New task</div></div>
  <div className="wf-stroke" style={{padding:'8px 10px', fontFamily:'var(--hand-head)', fontSize:16, color:'var(--ink-faint)'}}>Title…</div>
  <div className="wf-cap">assign to</div>
  <div className="wf-row" style={{gap:5}}>
    {KIDS.map(k=>(<div key={k.n} className={`wf-row wf-stroke-thin ${k.n==='Emma'?'wf-fill-accent':''}`} style={{padding:'4px 7px', gap:4, color:k.n==='Emma'?'#fff':''}}><Avatar tone={k.t} size="">{k.n[0]}</Avatar><span style={{fontSize:11}}>{k.n}</span></div>))}
  </div>
  <div className="wf-cap">when</div>
  <div className="wf-row" style={{gap:4}}>{['Today','Tmrw','Pick'].map((d,i)=>(<Pill key={d} tone={i===0?'accent':''}>{d}</Pill>))}</div>
  <div className="wf-cap">repeat</div>
  <div className="wf-row" style={{gap:4}}>{['Once','Daily','Weekly'].map((d,i)=>(<Pill key={d} tone={i===0?'accent':''}>{d}</Pill>))}</div>
  <div className="wf-cap">stars</div>
  <div className="wf-row" style={{gap:4}}><Stars filled={2}/><span className="wf-cap">tap to set</span></div>
  <div className="scr-foot"><Btn tone="primary" size="lg" block>Add task ✓</Btn></div>
</div>);
const AddV2T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-lg">New task</div><div className="wf-spacer"/><Pill>esc</Pill></div>
  <div className="wf-stroke" style={{padding:'12px 16px', fontFamily:'var(--hand-head)', fontSize:26, color:'var(--ink-faint)'}}>Untitled task ___</div>
  <div style={{display:'grid', gridTemplateColumns:'auto 1fr', columnGap:14, rowGap:8, alignItems:'center', marginTop:8}}>
    <span className="wf-cap">assign</span>
    <div className="wf-row" style={{gap:5}}>{KIDS.map(k=>(<div key={k.n} className={`wf-row wf-stroke ${k.n==='Emma'?'wf-fill-accent':''}`} style={{padding:'5px 9px', gap:5, color:k.n==='Emma'?'#fff':''}}><Avatar tone={k.t}>{k.n[0]}</Avatar><span>{k.n}</span></div>))}</div>
    <span className="wf-cap">when</span>
    <div className="wf-row" style={{gap:6}}>{['Today','Tomorrow','Mon May 15','Custom…'].map((d,i)=>(<Pill key={d} tone={i===0?'accent':''}>{d}</Pill>))}</div>
    <span className="wf-cap">repeat</span>
    <div className="wf-row" style={{gap:6}}>{['Once','Daily','Weekdays','Weekly','M T W T F'].map((d,i)=>(<Pill key={d} tone={i===0?'accent':''}>{d}</Pill>))}</div>
    <span className="wf-cap">stars</span>
    <div className="wf-row" style={{gap:6}}><Stars filled={2} size={20}/><span className="wf-cap">2 of 5</span></div>
    <span className="wf-cap">notes</span>
    <div className="wf-stroke-thin" style={{padding:'8px 10px', minHeight:50, color:'var(--ink-faint)'}}>e.g. don't forget under the bed!</div>
  </div>
  <div className="scr-foot wf-row"><Btn>cancel</Btn><div className="wf-spacer"/><Btn tone="primary" size="xl">Add task ✓</Btn></div>
</div>);

// V3 — Template / chore library
const AddV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Pick a chore</div>
  <div className="wf-stroke wf-row" style={{padding:'5px 8px', gap:5}}><span className="wf-muted" style={{flex:1, fontSize:11}}>search…</span><span className="wf-cap">filter</span></div>
  <div className="wf-row" style={{gap:4, flexWrap:'wrap'}}>{['All','Bedroom','Kitchen','Pets','Self-care','School'].map((c,i)=>(<Pill key={c} tone={i===0?'accent':''}>{c}</Pill>))}</div>
  <div style={{display:'grid', gridTemplateColumns:'1fr 1fr', gap:5, marginTop:5}}>
    {['🛏 Make bed','🧸 Tidy toys','🐱 Feed cat','🪴 Plants','🪥 Brush teeth','📖 Read','🍽 Set table','🗑 Trash out'].map(t=>(
      <div key={t} className="wf-card" style={{padding:6}}>
        <div style={{fontFamily:'var(--hand-head)', fontSize:14}}>{t}</div>
        <div className="wf-row" style={{justifyContent:'space-between', marginTop:3}}><Stars filled={2} size={9} total={3}/><Pill>+ add</Pill></div>
      </div>
    ))}
  </div>
  <Btn block>+ custom task</Btn>
</div>);
const AddV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Chore library</div><div className="wf-spacer"/><Btn>+ custom</Btn></div>
  <div className="wf-row" style={{gap:6, marginTop:4}}>{['All','Bedroom','Kitchen','Pets','Self-care','School','Outdoor'].map((c,i)=>(<Pill key={c} tone={i===0?'accent':''}>{c}</Pill>))}</div>
  <div className="scr-scroll" style={{marginTop:6}}>
    <div style={{display:'grid', gridTemplateColumns:'repeat(4,1fr)', gap:8}}>
      {[['🛏','Make the bed',1],['🧸','Tidy toys',1],['🐱','Feed cat',1],['🪴','Water plants',2],['🪥','Brush teeth',1],['📖','Read 20 min',2],['🍽','Set the table',2],['🗑','Take out trash',2],['🧺','Fold laundry',3],['🚲','Helmet on',1],['🎒','Pack bag',1],['🍎','Eat fruit',1]].map(([e,t,s],i)=>(
        <div key={i} className="wf-card wf-col" style={{padding:8, alignItems:'center', gap:4}}>
          <div style={{fontSize:28}}>{e}</div>
          <div style={{fontSize:12, fontFamily:'var(--hand-head)', textAlign:'center'}}>{t}</div>
          <Stars filled={s} total={3} size={10}/>
          <Btn tone="primary" size="">+ assign</Btn>
        </div>
      ))}
    </div>
  </div>
</div>);

// V4 — Voice / dictation big
const AddV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Speak it</div>
  <div className="wf-cap">tap the mic & say a task</div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:10}}>
    <div className="wf-stroke" style={{width:90,height:90,borderRadius:'50%',background:'var(--accent)',color:'#fff',display:'flex',alignItems:'center',justifyContent:'center', fontSize:40, borderColor:'var(--accent)'}}>🎤</div>
    <div className="wf-cap">listening…</div>
    <div className="bubble" style={{maxWidth:'85%'}}>"Emma… clean your room… by five…"</div>
    <div className="wf-row" style={{gap:5}}>{['Emma','today 5pm','clean your room'].map(c=>(<Pill key={c} tone="accent">{c}</Pill>))}</div>
  </div>
  <div className="scr-foot wf-row"><Btn>type instead</Btn><div className="wf-spacer"/><Btn tone="primary" size="lg">Add ✓</Btn></div>
</div>);
const AddV4T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Just say it</div><div className="wf-spacer"/><Btn>type instead</Btn></div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:14}}>
    <div className="wf-stroke" style={{width:140,height:140,borderRadius:'50%',background:'var(--accent)',color:'#fff',display:'flex',alignItems:'center',justifyContent:'center', fontSize:60, borderColor:'var(--accent)', boxShadow:'0 0 0 14px rgba(91,141,239,.15)'}}>🎤</div>
    <div className="wf-cap" style={{letterSpacing:2}}>listening…</div>
    <div className="bubble" style={{maxWidth:'70%', fontSize:18, fontFamily:'var(--hand-head)'}}>"Hey, remind Leo to feed the cat every day at noon."</div>
    <div className="wf-row" style={{gap:8, flexWrap:'wrap', justifyContent:'center'}}>
      <Pill tone="accent">👶 Leo</Pill><Pill tone="accent">🔁 daily</Pill><Pill tone="accent">⏰ 12:00</Pill><Pill tone="accent">🐱 feed cat</Pill>
    </div>
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'center', gap:10}}><Btn size="xl">try again</Btn><Btn tone="primary" size="xl">Looks right ✓</Btn></div>
</div>);

// V5 — Drag-from-library to child columns
const AddV5P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Drag to assign</div>
  <div className="wf-cap">library ↓ drop on a kid below</div>
  <div className="wf-row" style={{gap:4, overflow:'hidden'}}>
    {['🛏 Bed','🧸 Toys','🐱 Cat','📖 Read','🪥 Teeth'].map(t=>(<div key={t} className="wf-stroke-thin" style={{padding:'4px 6px', fontSize:10, fontFamily:'var(--hand-head)'}}>{t}</div>))}
  </div>
  <div className="wf-row" style={{flex:1, gap:5, marginTop:4}}>
    {KIDS.map(k=>(
      <div key={k.n} className="wf-stroke-dashed wf-col" style={{flex:1, padding:5, gap:4}}>
        <div className="wf-row"><Avatar tone={k.t} size="">{k.n[0]}</Avatar><span style={{fontSize:11}}>{k.n}</span></div>
        {k.n==='Emma' && <div className="wf-card-soft" style={{padding:4, fontSize:10}}>🧸 Toys</div>}
        {k.n==='Emma' && <div className="wf-card-soft wf-fill-accent" style={{padding:4, fontSize:10, color:'#fff', borderColor:'var(--accent)', borderStyle:'dashed'}}>🛏 Bed ←drop</div>}
      </div>
    ))}
  </div>
</div>);
const AddV5T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-lg">Drag tasks to kids</div><div className="wf-spacer"/><Btn>+ custom chore</Btn></div>
  <div className="wf-cap">library</div>
  <div className="hscroll" style={{padding:'4px 0'}}>
    {['🛏 Make bed','🧸 Tidy toys','🐱 Feed cat','🪴 Plants','📖 Read','🪥 Brush','🍽 Table','🗑 Trash','🧺 Laundry'].map(t=>(
      <div key={t} className="wf-card" style={{padding:'6px 10px', fontFamily:'var(--hand-head)', fontSize:14}}>{t}</div>
    ))}
  </div>
  <div className="wf-row" style={{flex:1, gap:10, marginTop:6, minHeight:0}}>
    {KIDS.map((k,i)=>(
      <div key={k.n} className={`wf-stroke-dashed wf-col`} style={{flex:1, padding:8, gap:5, background:i===0?'rgba(91,141,239,.06)':''}}>
        <div className="wf-row"><Avatar tone={k.t} size="lg">{k.n[0]}</Avatar><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>{k.n}</span></div>
        {i===0 && <div className="wf-card" style={{padding:6}}>🧸 Tidy toys</div>}
        {i===0 && <div className="wf-card wf-fill-accent" style={{padding:6, color:'#fff', borderStyle:'dashed', borderColor:'var(--accent)'}}>🛏 Make bed ← drop here</div>}
        {i===1 && <div className="wf-card" style={{padding:6}}>🐱 Feed cat</div>}
        <div className="wf-spacer"/>
        <div className="wf-cap" style={{textAlign:'center'}}>{['2 today','1 today','0 today'][i]}</div>
      </div>
    ))}
  </div>
</div>);

// V6 — Conversational ("What needs doing?")
const AddV6P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Quick add</div>
  <div className="wf-cap">just type — we'll figure it out</div>
  <div className="wf-stroke" style={{padding:'10px 12px', fontFamily:'var(--hand-head)', fontSize:16}}>Emma feed cat 5pm daily ✨</div>
  <div className="wf-cap" style={{marginTop:6}}>we understood</div>
  <div className="wf-col" style={{gap:5}}>
    <div className="wf-row wf-card-soft" style={{padding:5, gap:6}}><Pill tone="accent">who</Pill><span style={{fontSize:11}}>Emma</span></div>
    <div className="wf-row wf-card-soft" style={{padding:5, gap:6}}><Pill tone="accent">what</Pill><span style={{fontSize:11}}>Feed the cat 🐱</span></div>
    <div className="wf-row wf-card-soft" style={{padding:5, gap:6}}><Pill tone="accent">when</Pill><span style={{fontSize:11}}>5:00 pm · daily</span></div>
  </div>
  <div className="scr-foot wf-row"><Btn>edit</Btn><div className="wf-spacer"/><Btn tone="primary" size="lg">Add ✓</Btn></div>
</div>);
const AddV6T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">What needs doing?</div><div className="wf-spacer"/><Pill>⌘ K</Pill></div>
  <div className="wf-cap">type naturally · we parse who, what, when</div>
  <div className="wf-stroke" style={{padding:'14px 18px', fontFamily:'var(--hand-head)', fontSize:24, marginTop:8}}>Leo brush teeth before bed every night<span style={{color:'var(--accent)'}}>|</span></div>
  <div className="wf-cap" style={{marginTop:10}}>we understood…</div>
  <div className="wf-row" style={{gap:8, flexWrap:'wrap'}}>
    <div className="wf-row wf-card" style={{padding:'8px 12px', gap:8}}><Avatar tone="lilac">L</Avatar><div className="wf-col" style={{gap:0}}><span className="wf-cap">who</span><span>Leo</span></div></div>
    <div className="wf-row wf-card" style={{padding:'8px 12px', gap:8}}><span style={{fontSize:24}}>🪥</span><div className="wf-col" style={{gap:0}}><span className="wf-cap">what</span><span>Brush teeth</span></div></div>
    <div className="wf-row wf-card" style={{padding:'8px 12px', gap:8}}><span style={{fontSize:24}}>🌙</span><div className="wf-col" style={{gap:0}}><span className="wf-cap">when</span><span>before bed · daily</span></div></div>
    <div className="wf-row wf-card" style={{padding:'8px 12px', gap:8}}><span style={{fontSize:24}}>⭐</span><div className="wf-col" style={{gap:0}}><span className="wf-cap">stars</span><Stars filled={1} total={3}/></div></div>
  </div>
  <div className="scr-foot wf-row"><Btn size="xl">edit details</Btn><div className="wf-spacer"/><Btn tone="primary" size="xl">Add ✓</Btn></div>
</div>);

window.AddTaskVariations = [
  { id:'add-v1', label:'V1 · Step wizard',     cap:'Three small steps',                sub:'Most familiar · low cognitive load',     P:AddV1P, T:AddV1T },
  { id:'add-v2', label:'V2 · Single screen',   cap:'All fields visible at once',       sub:'Notion-y · fast for power parents',      P:AddV2P, T:AddV2T },
  { id:'add-v3', label:'V3 · Chore library',   cap:'Pick from preset chores',          sub:'Fastest · learns common patterns',       P:AddV3P, T:AddV3T },
  { id:'add-v4', label:'V4 · Voice first',     cap:'Speak the task',                   sub:'Best while cooking / driving',           P:AddV4P, T:AddV4T },
  { id:'add-v5', label:'V5 · Drag & drop',     cap:'Drop chores on kids',              sub:'Visual · tablet-native · planning',      P:AddV5P, T:AddV5T },
  { id:'add-v6', label:'V6 · Quick add NLP',   cap:'Natural-language one-liner',       sub:'⌘K-style · power-user joy',              P:AddV6P, T:AddV6T },
];

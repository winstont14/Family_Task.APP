// sections/family.jsx — 6 variations: family members management

const FAM = [
  {n:'Maya',  t:'peach', role:'parent', age:'',    pin:true},
  {n:'Sam',   t:'lemon', role:'parent', age:'',    pin:true},
  {n:'Emma',  t:'mint',  role:'kid',    age:'7',  emoji:'🦊'},
  {n:'Leo',   t:'lilac', role:'kid',    age:'5',  emoji:'🐯'},
  {n:'Riya',  t:'peach', role:'kid',    age:'9',  emoji:'🐼'},
];

// V1 — Simple list with roles
const FmV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><div className="wf-h">Family</div><div className="wf-spacer"/><Pill>+ add</Pill></div>
  <div className="wf-cap">5 members · The Patels</div>
  <div className="scr-scroll" style={{marginTop:5}}>
    {FAM.map((m,i)=>(
      <div key={i} className="wf-row wf-stroke" style={{padding:6, gap:7}}>
        <Avatar tone={m.t}>{m.emoji||m.n[0]}</Avatar>
        <div className="wf-col" style={{gap:0, flex:1}}><div style={{fontSize:13, fontFamily:'var(--hand-head)'}}>{m.n}</div><div className="wf-cap">{m.role}{m.age?` · age ${m.age}`:''}{m.pin?' · PIN':''}</div></div>
        <Pill>edit</Pill>
      </div>
    ))}
  </div>
</div>);
const FmV1T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">The Patel family</div><div className="wf-spacer"/><Btn tone="primary">+ add member</Btn></div>
  <div className="wf-cap">5 members · created last spring</div>
  <div className="scr-scroll" style={{marginTop:8}}>
    {FAM.map((m,i)=>(
      <div key={i} className="wf-row wf-card" style={{padding:'10px 14px', gap:14}}>
        <Avatar tone={m.t} size="lg">{m.emoji||m.n[0]}</Avatar>
        <div className="wf-col" style={{gap:1, flex:1}}>
          <div style={{fontFamily:'var(--hand-head)', fontSize:20}}>{m.n}</div>
          <div className="wf-cap">{m.role}{m.age?` · age ${m.age}`:''}{m.pin?' · admin':''}</div>
        </div>
        {m.role==='kid' && <Pill tone="accent">⭐ {[12,8,5][i-2]||0}</Pill>}
        <Pill>edit</Pill>
        <Pill>•••</Pill>
      </div>
    ))}
  </div>
</div>);

// V2 — Card grid with avatars
const FmV2P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Family</div>
  <div style={{display:'grid', gridTemplateColumns:'1fr 1fr', gap:6, marginTop:5}}>
    {[...FAM, {n:'+ add', t:'', role:'', dashed:true}].map((m,i)=>(
      <div key={i} className={`${m.dashed?'wf-stroke-dashed':'wf-card'} wf-col`} style={{padding:8, alignItems:'center', gap:4}}>
        {m.dashed ? <div style={{fontSize:30}}>+</div> : <Avatar tone={m.t} size="lg">{m.emoji||m.n[0]}</Avatar>}
        <div style={{fontSize:12, fontFamily:'var(--hand-head)'}}>{m.n}</div>
        {m.role && <Pill tone={m.pin?'accent':''}>{m.role}{m.age?` · ${m.age}`:''}</Pill>}
      </div>
    ))}
  </div>
</div>);
const FmV2T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Family members</div><div className="wf-spacer"/><span className="wf-cap">tap a face to view</span></div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(3, 1fr)', gap:14, marginTop:10}}>
    {[...FAM, {n:'add', t:'', dashed:true}].map((m,i)=>(
      <div key={i} className={`${m.dashed?'wf-stroke-dashed':'wf-card'} wf-col`} style={{padding:18, alignItems:'center', gap:8}}>
        {m.dashed ? <div style={{fontSize:46, color:'var(--ink-faint)'}}>+</div> : (
          <>
            <Avatar tone={m.t} size="xl" >{m.emoji||m.n[0]}</Avatar>
            <div style={{fontFamily:'var(--hand-head)', fontSize:24}}>{m.n}</div>
            <Pill tone={m.pin?'accent':''}>{m.role}{m.age?` · age ${m.age}`:''}{m.pin?' 🔒':''}</Pill>
            {m.role==='kid' && <div className="wf-row" style={{gap:5}}><Stars filled={[3,2,1][i-2]||0} total={3} size={12}/><span className="wf-cap">⭐ {[12,8,5][i-2]||0}</span></div>}
          </>
        )}
        {!m.dashed && <Pill>edit profile</Pill>}
      </div>
    ))}
  </div>
</div>);

// V3 — Family tree (relational)
const FmV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Family tree</div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:20, position:'relative'}}>
    <div className="wf-row" style={{gap:30, position:'relative'}}>
      <div className="wf-col" style={{alignItems:'center', gap:3}}><Avatar tone="peach" size="lg">M</Avatar><span className="wf-cap">Maya</span></div>
      <div className="wf-col" style={{alignItems:'center', gap:3}}><Avatar tone="lemon" size="lg">S</Avatar><span className="wf-cap">Sam</span></div>
      <div style={{position:'absolute', left:'50%', bottom:-10, width:1, height:20, borderLeft:'1.4px solid var(--ink)'}}/>
    </div>
    <div className="wf-row" style={{gap:10, position:'relative'}}>
      <div style={{position:'absolute', left:'50%', top:-10, width:'70%', transform:'translateX(-50%)', height:1, borderTop:'1.4px solid var(--ink)'}}/>
      <div className="wf-col" style={{alignItems:'center', gap:3}}><Avatar tone="mint" size="lg">🦊</Avatar><span className="wf-cap">Emma · 7</span></div>
      <div className="wf-col" style={{alignItems:'center', gap:3}}><Avatar tone="lilac" size="lg">🐯</Avatar><span className="wf-cap">Leo · 5</span></div>
      <div className="wf-col" style={{alignItems:'center', gap:3}}><Avatar tone="peach" size="lg">🐼</Avatar><span className="wf-cap">Riya · 9</span></div>
    </div>
  </div>
  <Btn tone="primary" block>+ add member</Btn>
</div>);
const FmV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">The Patels</div><div className="wf-spacer"/><Btn>+ add member</Btn></div>
  <div className="wf-cap" style={{textAlign:'center'}}>tap a person to see their tasks &amp; stars</div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:30, position:'relative', marginTop:8}}>
    <div className="wf-row" style={{gap:60, position:'relative'}}>
      <div className="wf-col" style={{alignItems:'center', gap:5}}>
        <Avatar tone="peach" size="xl">M</Avatar>
        <div style={{fontFamily:'var(--hand-head)', fontSize:18}}>Maya</div>
        <Pill tone="accent">parent · admin</Pill>
      </div>
      <div className="wf-col" style={{alignItems:'center', gap:5}}>
        <Avatar tone="lemon" size="xl">S</Avatar>
        <div style={{fontFamily:'var(--hand-head)', fontSize:18}}>Sam</div>
        <Pill tone="accent">parent</Pill>
      </div>
      <div style={{position:'absolute', left:'50%', bottom:-30, width:2, height:30, borderLeft:'1.6px solid var(--ink)'}}/>
    </div>
    <div className="wf-row" style={{gap:30, position:'relative'}}>
      <div style={{position:'absolute', left:'50%', top:-15, width:'85%', transform:'translateX(-50%)', height:1, borderTop:'1.6px solid var(--ink)'}}/>
      {[
        {n:'Emma',a:7,t:'mint',e:'🦊',s:12},
        {n:'Leo',a:5,t:'lilac',e:'🐯',s:8},
        {n:'Riya',a:9,t:'peach',e:'🐼',s:5},
      ].map(c=>(
        <div key={c.n} className="wf-col" style={{alignItems:'center', gap:5, position:'relative'}}>
          <div style={{position:'absolute', top:-15, left:'50%', width:1, height:15, borderLeft:'1.6px solid var(--ink)'}}/>
          <Avatar tone={c.t} size="xl">{c.e}</Avatar>
          <div style={{fontFamily:'var(--hand-head)', fontSize:18}}>{c.n}</div>
          <Pill>kid · age {c.a}</Pill>
          <Pill tone="accent">⭐ {c.s}</Pill>
        </div>
      ))}
    </div>
  </div>
</div>);

// V4 — Stacked profile detail (member focus)
const FmV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><span className="icn-back wf-muted"/><span className="wf-cap">back to family</span></div>
  <div className="wf-col" style={{alignItems:'center', gap:5, marginTop:5}}>
    <Avatar tone="mint" size="xl">🦊</Avatar>
    <div className="wf-h-lg">Emma</div>
    <Pill>kid · age 7</Pill>
  </div>
  <div className="wf-row" style={{gap:5}}>
    <div className="wf-card wf-col" style={{flex:1, padding:6, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>⭐ 12</div><div className="wf-cap">stars</div></div>
    <div className="wf-card wf-col" style={{flex:1, padding:6, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>🔥 5</div><div className="wf-cap">streak</div></div>
    <div className="wf-card wf-col" style={{flex:1, padding:6, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>3/4</div><div className="wf-cap">today</div></div>
  </div>
  <div className="wf-cap">recent</div>
  <div className="wf-col" style={{gap:4}}>{['Clean room ✓','Feed cat ✓','Read book ✓','Homework ↩'].map((t,i)=>(<div key={i} className="wf-stroke-thin" style={{padding:'4px 7px', fontSize:11}}>{t}</div>))}</div>
  <Btn block>edit profile</Btn>
</div>);
const FmV4T = () => (<div className="scr">
  <div className="wf-row"><span className="icn-back wf-muted"/><span className="wf-cap">family · Emma</span><div className="wf-spacer"/><Btn>edit</Btn><Btn>•••</Btn></div>
  <div className="wf-row" style={{gap:14, marginTop:6}}>
    <div className="wf-col" style={{alignItems:'center', gap:5}}>
      <Avatar tone="mint" size="xl">🦊</Avatar>
      <div className="wf-h-lg">Emma</div>
      <Pill>kid · age 7</Pill>
      <Pill tone="accent">⭐ 12 this wk</Pill>
    </div>
    <div className="wf-col" style={{flex:1, gap:8}}>
      <div className="wf-row" style={{gap:8}}>
        <div className="wf-card wf-col" style={{flex:1, padding:8, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:24}}>🔥 5</div><div className="wf-cap">streak</div></div>
        <div className="wf-card wf-col" style={{flex:1, padding:8, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:24}}>3/4</div><div className="wf-cap">today</div></div>
        <div className="wf-card wf-col" style={{flex:1, padding:8, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:24}}>22</div><div className="wf-cap">all-time</div></div>
      </div>
      <div className="wf-cap">recent activity</div>
      {[['Clean room','✓ approved','5pm'],['Feed cat','✓ approved','noon'],['Read book','✓ approved','3pm'],['Homework','↩ try again','am']].map((r,i)=>(
        <div key={i} className="wf-row wf-stroke-thin" style={{padding:'7px 10px', fontSize:12, gap:8}}>
          <span style={{flex:1, fontFamily:'var(--hand-head)'}}>{r[0]}</span>
          <Pill tone={r[1].includes('✓')?'done':''}>{r[1]}</Pill>
          <span className="wf-cap">{r[2]}</span>
        </div>
      ))}
    </div>
  </div>
</div>);

// V5 — Permissions table (Notion-y)
const FmV5P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Permissions</div>
  <div className="wf-row" style={{borderBottom:'1.4px solid var(--ink)', paddingBottom:3, fontFamily:'var(--hand-arch)', fontSize:9, color:'var(--ink-faint)', textTransform:'uppercase'}}>
    <span style={{flex:1.4}}>person</span>
    <span style={{flex:1, textAlign:'center'}}>add</span>
    <span style={{flex:1, textAlign:'center'}}>complete</span>
    <span style={{flex:1, textAlign:'center'}}>approve</span>
  </div>
  <div className="scr-scroll" style={{gap:0}}>
    {FAM.map((m,i)=>{
      const canAdd = m.role==='parent';
      const canApp = m.role==='parent';
      return (
        <div key={i} className="wf-row" style={{padding:'5px 0', borderBottom:'1px dotted var(--ink-faint)'}}>
          <div className="wf-row" style={{flex:1.4, gap:5}}><Avatar tone={m.t}>{m.emoji||m.n[0]}</Avatar><span style={{fontSize:11}}>{m.n}</span></div>
          <div style={{flex:1, textAlign:'center'}}><span className={`tog ${canAdd?'on':''}`}/></div>
          <div style={{flex:1, textAlign:'center'}}><span className="tog on"/></div>
          <div style={{flex:1, textAlign:'center'}}><span className={`tog ${canApp?'on':''}`}/></div>
        </div>
      );
    })}
  </div>
</div>);
const FmV5T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-xl">Permissions</div><div className="wf-spacer"/><Pill>+ add role</Pill></div>
  <div className="wf-cap">who can do what · tap to toggle</div>
  <div className="wf-row" style={{borderBottom:'1.6px solid var(--ink)', paddingBottom:5, fontFamily:'var(--hand-arch)', fontSize:9, color:'var(--ink-faint)', textTransform:'uppercase', letterSpacing:1, marginTop:8}}>
    <span style={{flex:2}}>member</span>
    <span style={{flex:1, textAlign:'center'}}>add task</span>
    <span style={{flex:1, textAlign:'center'}}>complete</span>
    <span style={{flex:1, textAlign:'center'}}>approve</span>
    <span style={{flex:1, textAlign:'center'}}>spend ⭐</span>
    <span style={{flex:1, textAlign:'center'}}>invite</span>
  </div>
  <div className="scr-scroll" style={{gap:0}}>
    {FAM.map((m,i)=>{
      const isParent = m.role==='parent';
      return (
        <div key={i} className="wf-row" style={{padding:'10px 0', borderBottom:'1px dotted var(--ink-faint)'}}>
          <div className="wf-row" style={{flex:2, gap:8}}><Avatar tone={m.t} size="lg">{m.emoji||m.n[0]}</Avatar><div className="wf-col" style={{gap:0}}><span style={{fontFamily:'var(--hand-head)', fontSize:16}}>{m.n}</span><span className="wf-cap">{m.role}{m.age?` · ${m.age}`:''}</span></div></div>
          {[isParent, true, isParent, true, isParent].map((on,j)=>(<div key={j} style={{flex:1, textAlign:'center'}}><span className={`tog ${on?'on':''}`}/></div>))}
        </div>
      );
    })}
  </div>
</div>);

// V6 — Avatar customizer / picker
const FmV6P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Make your avatar</div>
  <div className="wf-col" style={{alignItems:'center', gap:5}}>
    <div className="wf-stroke" style={{width:80,height:80,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:40, background:'var(--paper-2)'}}>🦊</div>
    <div style={{fontFamily:'var(--hand-head)', fontSize:18}}>Emma</div>
  </div>
  <div className="wf-cap">animal</div>
  <div className="wf-row" style={{gap:5, flexWrap:'wrap'}}>{['🦊','🐼','🐯','🦁','🦄','🐶','🐱','🐰','🐧'].map((e,i)=>(<div key={e} className={`wf-stroke ${i===0?'wf-fill-accent':''}`} style={{width:30,height:30,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:18}}>{e}</div>))}</div>
  <div className="wf-cap">background</div>
  <div className="wf-row" style={{gap:5}}>{['mint','peach','lilac','lemon'].map((c,i)=>(<div key={c} className={`wf-avatar ${c} ${i===0?'wf-stroke':''}`} style={{flex:1, height:30, borderRadius:8}}/>))}</div>
  <Btn tone="primary" block size="lg">Save my look ✓</Btn>
</div>);
const FmV6T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Pick your look</div><div className="wf-spacer"/><Pill>save</Pill></div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'flex-start', marginTop:8, minHeight:0}}>
    <div className="wf-col" style={{flex:1, alignItems:'center', gap:8}}>
      <div className="wf-stroke" style={{width:160,height:160,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:90, background:'#C9E4CA'}}>🦊</div>
      <div style={{fontFamily:'var(--hand-head)', fontSize:30}}>Emma</div>
      <div className="wf-cap">tap to rename</div>
    </div>
    <div className="wf-col" style={{flex:1.4, gap:8}}>
      <div className="wf-cap">animal</div>
      <div style={{display:'grid', gridTemplateColumns:'repeat(6,1fr)', gap:5}}>
        {['🦊','🐼','🐯','🦁','🦄','🐶','🐱','🐰','🐧','🐨','🐸','🦋'].map((e,i)=>(
          <div key={e} className={`wf-stroke ${i===0?'wf-fill-accent':''}`} style={{aspectRatio:'1', borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:24}}>{e}</div>
        ))}
      </div>
      <div className="wf-cap">background color</div>
      <div className="wf-row" style={{gap:6}}>{[['mint','#C9E4CA'],['peach','#F6CFB8'],['lilac','#DCD0F0'],['lemon','#F4E3A1'],['','#fff']].map(([n,c],i)=>(<div key={i} className={`wf-stroke ${i===0?'wf-fill-accent':''}`} style={{flex:1, height:34, borderRadius:8, background:c}}/>))}</div>
      <div className="wf-cap">accessory</div>
      <div className="wf-row" style={{gap:5}}>{['🎩','👓','⭐','🎀','none'].map((e,i)=>(<div key={i} className={`wf-stroke ${i===4?'wf-fill-accent':''}`} style={{flex:1, padding:'6px 0', textAlign:'center', borderRadius:8, fontSize:18}}>{i===4?<span className="wf-cap">none</span>:e}</div>))}</div>
    </div>
  </div>
</div>);

window.FamilyVariations = [
  { id:'fm-v1', label:'V1 · Member list',         cap:'Simple roster with roles',     sub:'Basic · easy to scan',                  P:FmV1P, T:FmV1T },
  { id:'fm-v2', label:'V2 · Avatar grid',         cap:'Cards in a 2-3 col grid',      sub:'Visual · tappable',                     P:FmV2P, T:FmV2T },
  { id:'fm-v3', label:'V3 · Family tree',         cap:'Relational hierarchy',         sub:'Most novel · keepsake feel',            P:FmV3P, T:FmV3T },
  { id:'fm-v4', label:'V4 · Member detail',       cap:'Profile / activity',           sub:'Drill into one person',                 P:FmV4P, T:FmV4T },
  { id:'fm-v5', label:'V5 · Permissions table',   cap:'Notion-style toggles',         sub:'Power-user · explicit control',         P:FmV5P, T:FmV5T },
  { id:'fm-v6', label:'V6 · Avatar customizer',   cap:'Pick animal · color · prop',   sub:'Kid-delight · sense of ownership',      P:FmV6P, T:FmV6T },
];

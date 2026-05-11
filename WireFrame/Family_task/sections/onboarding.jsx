// sections/onboarding.jsx — 6 variations: create the family workspace

// V1 — Step-by-step modal (conventional, Notion-y)
const OnbV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-cap">step 1 of 3</div>
  <div className="wf-h-lg">Name your family</div>
  <div className="wf-stroke" style={{padding:'10px 12px', fontFamily:'var(--hand-body)', color:'var(--ink-faint)'}}>The Patel Family ___</div>
  <div className="wf-cap" style={{marginTop:6}}>example • The Smiths · Casa de Lopez</div>
  <div className="scr-foot wf-row">
    <Btn>← back</Btn><div className="wf-spacer"/><Btn tone="primary" size="lg">Next →</Btn>
  </div>
</div>);
const OnbV1T = () => (<div className="scr">
  <div className="wf-cap">step 1 of 3 • family name → members → done</div>
  <div className="wf-h-xl">Welcome 👋</div>
  <div className="wf-h2 wf-muted">Let's set up your family workspace.</div>
  <div className="wf-stroke" style={{padding:'14px 16px', marginTop:14, fontFamily:'var(--hand-head)', fontSize:24, color:'var(--ink-faint)'}}>The ___ Family</div>
  <div className="wf-row" style={{marginTop:8, gap:6}}>
    {['Patel','Smith','Lopez','Tan','Cohen'].map(n=>(<Pill key={n} tone="faint">{n}</Pill>))}
  </div>
  <div className="scr-foot wf-row">
    <Btn>← back</Btn><div className="wf-spacer"/><Btn tone="primary" size="xl">Continue →</Btn>
  </div>
</div>);

// V2 — Single-page form (everything on one screen)
const OnbV2P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Create workspace</div>
  <div className="wf-cap">all in one place</div>
  <div className="wf-col" style={{gap:6, marginTop:4}}>
    <div className="wf-stroke-thin" style={{padding:'6px 8px'}}>Family name</div>
    <div className="wf-stroke-thin" style={{padding:'6px 8px'}}>Your name (parent)</div>
    <div className="wf-cap" style={{marginTop:4}}>add children</div>
    {['Emma — 7','Leo — 5','+ add another'].map((n,i)=>(
      <div key={i} className="wf-stroke-thin wf-row" style={{padding:'5px 7px'}}>
        <Avatar tone={i===0?'peach':i===1?'mint':''}>{i<2?n[0]:'+'}</Avatar>
        <span style={{fontSize:11}}>{n}</span>
      </div>
    ))}
  </div>
  <div className="scr-foot"><Btn tone="primary" size="lg" block>Create →</Btn></div>
</div>);
const OnbV2T = () => (<div className="scr tight">
  <div className="wf-h-lg">Set up your family</div>
  <div className="wf-cap">one screen · no wizard</div>
  <div className="wf-row" style={{gap:14, marginTop:6, alignItems:'flex-start'}}>
    <div className="wf-col" style={{flex:1, gap:8}}>
      <div className="wf-cap">family</div>
      <div className="wf-stroke" style={{padding:'8px 10px'}}>The Patel Family</div>
      <div className="wf-cap">parent</div>
      <div className="wf-stroke" style={{padding:'8px 10px'}}>Maya · admin</div>
    </div>
    <div className="wf-col" style={{flex:1.1, gap:6}}>
      <div className="wf-cap">children</div>
      {['Emma · 7','Leo · 5','Riya · 9'].map((n,i)=>(
        <div key={i} className="wf-stroke wf-row" style={{padding:'7px 9px'}}>
          <Avatar tone={['peach','mint','lilac'][i]}>{n[0]}</Avatar>
          <span>{n}</span><div className="wf-spacer"/>
          <Pill>edit</Pill>
        </div>
      ))}
      <div className="wf-stroke-dashed wf-row" style={{padding:'7px 9px', justifyContent:'center'}}>+ add child</div>
    </div>
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'flex-end'}}><Btn tone="primary" size="xl">Create workspace →</Btn></div>
</div>);

// V3 — Big illustration / pick-your-people (very visual)
const OnbV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h-lg" style={{textAlign:'center'}}>Who's in your family?</div>
  <Img w="100%" h={120} label="family illustration"/>
  <div className="wf-row" style={{gap:6, justifyContent:'center', flexWrap:'wrap'}}>
    {['👩','👨','🧒','👧','👶','🐶'].map((e,i)=>(
      <div key={i} className="wf-stroke" style={{width:34,height:34,display:'flex',alignItems:'center',justifyContent:'center',borderRadius:'50%',fontSize:18}}>{e}</div>
    ))}
  </div>
  <div className="wf-cap" style={{textAlign:'center'}}>tap to add — long-press to remove</div>
  <div className="scr-foot"><Btn tone="primary" size="xl" block>Begin →</Btn></div>
</div>);
const OnbV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Build your family</div></div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'stretch', minHeight:0}}>
    <Img w={170} h="100%" label="hero · family hugging"/>
    <div className="wf-col" style={{flex:1}}>
      <div className="wf-cap">tap a portrait to add</div>
      <div style={{display:'grid', gridTemplateColumns:'repeat(4, 1fr)', gap:6}}>
        {['👩','👨','👵','👴','🧒','👧','👶','🧑‍🦱','👨‍🦰','👩‍🦱','🐶','🐱'].map((e,i)=>(
          <div key={i} className="wf-stroke" style={{aspectRatio:'1', display:'flex',alignItems:'center',justifyContent:'center',fontSize:22, borderRadius:'50%'}}>{e}</div>
        ))}
      </div>
      <div className="wf-cap">selected</div>
      <div className="wf-row" style={{gap:6}}>
        <Avatar tone="peach">M</Avatar><Avatar tone="mint">E</Avatar><Avatar tone="lilac">L</Avatar>
      </div>
    </div>
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'flex-end'}}><Btn tone="primary" size="xl">Looks good →</Btn></div>
</div>);

// V4 — Conversational chat-style
const OnbV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-cap">setup chat</div>
  <div className="scr-scroll">
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'80%'}}>Hi! What should we call your family?</div>
    <div className="bubble wf-fill-accent" style={{alignSelf:'flex-end', maxWidth:'70%', borderColor:'var(--accent)', color:'#fff'}}>The Patels ✨</div>
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'80%'}}>Lovely. How many kids?</div>
    <div className="bubble wf-fill-accent" style={{alignSelf:'flex-end', maxWidth:'40%', color:'#fff', borderColor:'var(--accent)'}}>Two</div>
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'80%'}}>Tell me their names…</div>
  </div>
  <div className="wf-stroke wf-row" style={{padding:'6px 8px'}}>
    <span className="wf-muted" style={{flex:1, fontSize:11}}>Type a reply…</span>
    <span className="wf-fill-accent" style={{width:24,height:24,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', color:'#fff'}}>↑</span>
  </div>
</div>);
const OnbV4T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-lg">Setup, the easy way</div><div className="wf-spacer"/><Pill>skip</Pill></div>
  <div className="wf-cap">we'll ask, you answer</div>
  <div className="scr-scroll" style={{gap:10, marginTop:6}}>
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'70%'}}>Welcome! What's the family name?</div>
    <div className="bubble wf-fill-accent" style={{alignSelf:'flex-end', maxWidth:'45%', color:'#fff', borderColor:'var(--accent)'}}>The Patels</div>
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'80%'}}>Great. Add a child — what's their name & age?</div>
    <div className="wf-row" style={{alignSelf:'flex-end', gap:6}}>
      <Pill tone="faint">Emma · 7</Pill><Pill tone="faint">+ add another</Pill>
    </div>
    <div className="bubble" style={{alignSelf:'flex-start', maxWidth:'80%'}}>Pick an emoji for Emma</div>
    <div className="wf-row" style={{alignSelf:'flex-end', gap:5}}>
      {['🦊','🐼','🦄','🐯','🐶'].map(e=>(<div key={e} className="wf-stroke" style={{width:30,height:30,borderRadius:'50%',display:'flex',alignItems:'center',justifyContent:'center'}}>{e}</div>))}
    </div>
  </div>
  <div className="wf-stroke wf-row" style={{padding:'8px 10px'}}><span className="wf-muted" style={{flex:1}}>Type a reply…</span><Btn tone="primary">send</Btn></div>
</div>);

// V5 — Postcard / sticker-book metaphor (more novel)
const OnbV5P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h-lg">Your family postcard</div>
  <div className="wf-stroke" style={{flex:1, padding:10, position:'relative', display:'flex', flexDirection:'column', gap:6}}>
    <div className="wf-row"><Avatar tone="peach" size="lg">M</Avatar><div className="wf-col" style={{gap:0}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>The Patels</div><div className="wf-cap">est. today</div></div></div>
    <div className="wf-row" style={{gap:5, flexWrap:'wrap'}}>
      <Avatar tone="mint">E</Avatar><Avatar tone="lilac">L</Avatar>
      <span className="wf-stroke-dashed" style={{padding:'2px 8px', fontSize:10, borderRadius:999}}>+ add</span>
    </div>
    <div className="wf-stroke-dashed" style={{flex:1, marginTop:4, padding:8, fontFamily:'var(--hand-arch)', fontSize:9, color:'var(--ink-faint)'}}>
      drag stickers here →
    </div>
    <div className="wf-row" style={{gap:4, fontSize:14}}>🌟 🏠 🐾 🎈 🌈 ☀</div>
  </div>
  <Btn tone="primary" size="lg" block>Send postcard →</Btn>
</div>);
const OnbV5T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Make your family postcard</div><div className="wf-spacer"/><div className="wf-cap">drag · drop · decorate</div></div>
  <div className="wf-row" style={{flex:1, gap:14, minHeight:0}}>
    <div className="wf-stroke" style={{flex:2, padding:14, position:'relative', display:'flex', flexDirection:'column', gap:8, transform:'rotate(-1deg)'}}>
      <div className="wf-cap">postcard · front</div>
      <div className="wf-row" style={{gap:8}}>
        <Avatar tone="peach" size="xl">M</Avatar>
        <Avatar tone="mint" size="xl">E</Avatar>
        <Avatar tone="lilac" size="xl">L</Avatar>
        <div className="wf-stroke-dashed" style={{width:56,height:56, borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:20}}>+</div>
      </div>
      <div style={{fontFamily:'var(--hand-head)', fontSize:30, marginTop:6}}>The Patels</div>
      <div className="wf-cap">a place for our little wins</div>
      <div style={{position:'absolute', top:12, right:14, fontSize:24}}>⭐</div>
      <div style={{position:'absolute', bottom:14, right:18, fontSize:20}}>🌈</div>
    </div>
    <div className="wf-col" style={{flex:1, gap:6}}>
      <div className="wf-cap">stickers</div>
      <div style={{display:'grid', gridTemplateColumns:'repeat(3,1fr)', gap:5}}>
        {['🌟','🏠','🐾','🎈','🌈','☀','🍪','🌳','💌'].map(e=>(
          <div key={e} className="wf-stroke" style={{aspectRatio:'1', display:'flex',alignItems:'center',justifyContent:'center', fontSize:18}}>{e}</div>
        ))}
      </div>
    </div>
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'flex-end'}}><Btn tone="primary" size="xl">Pin to fridge →</Btn></div>
</div>);

// V6 — Profile picker first (single device shared)
const OnbV6P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h-lg" style={{textAlign:'center'}}>Who's using this?</div>
  <div className="wf-cap" style={{textAlign:'center'}}>this device is shared</div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(2,1fr)', gap:10, marginTop:8}}>
    <div className="wf-stroke wf-col" style={{padding:10, alignItems:'center', gap:6}}>
      <Avatar tone="peach" size="xl">M</Avatar><div>Maya</div><Pill tone="accent">parent</Pill>
    </div>
    <div className="wf-stroke wf-col" style={{padding:10, alignItems:'center', gap:6}}>
      <Avatar tone="mint" size="xl">E</Avatar><div>Emma</div><Pill>kid · 7</Pill>
    </div>
    <div className="wf-stroke wf-col" style={{padding:10, alignItems:'center', gap:6}}>
      <Avatar tone="lilac" size="xl">L</Avatar><div>Leo</div><Pill>kid · 5</Pill>
    </div>
    <div className="wf-stroke-dashed wf-col" style={{padding:10, alignItems:'center', gap:4, justifyContent:'center', fontSize:24}}>+<div className="wf-cap">add</div></div>
  </div>
  <div className="scr-foot wf-cap" style={{textAlign:'center'}}>parent · 4-digit PIN</div>
</div>);
const OnbV6T = () => (<div className="scr">
  <div className="wf-h-xl" style={{textAlign:'center'}}>Hi, Patels 👋</div>
  <div className="wf-cap" style={{textAlign:'center'}}>tap your face to begin · parent enters PIN</div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(4,1fr)', gap:14, marginTop:10}}>
    {[
      {n:'Maya',  t:'peach', role:'parent', pin:true},
      {n:'Sam',   t:'lemon', role:'parent', pin:true},
      {n:'Emma',  t:'mint',  role:'kid · 7'},
      {n:'Leo',   t:'lilac', role:'kid · 5'},
    ].map(p => (
      <div key={p.n} className="wf-stroke wf-col" style={{padding:14, alignItems:'center', gap:8}}>
        <Avatar tone={p.t} size="xl">{p.n[0]}</Avatar>
        <div style={{fontFamily:'var(--hand-head)', fontSize:20}}>{p.n}</div>
        <Pill tone={p.pin?'accent':''}>{p.role}{p.pin?' 🔒':''}</Pill>
      </div>
    ))}
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'space-between'}}>
    <Btn>+ add member</Btn>
    <span className="wf-cap">tap to switch · auto-lock 15 min</span>
  </div>
</div>);

window.OnboardingVariations = [
  { id:'onb-v1', label:'V1 · Step-by-step',     cap:'Conventional 3-step wizard',     sub:'Safe · familiar · single-task focus', P:OnbV1P, T:OnbV1T },
  { id:'onb-v2', label:'V2 · Single-page form', cap:'Everything on one screen',       sub:'Notion-y · power-user · fast',        P:OnbV2P, T:OnbV2T },
  { id:'onb-v3', label:'V3 · Pick your people', cap:'Visual avatar grid',             sub:'Playful · kid-friendly · illustrated', P:OnbV3P, T:OnbV3T },
  { id:'onb-v4', label:'V4 · Conversational',   cap:'Chat-style setup bot',           sub:'Gentle · low-effort · narrative',     P:OnbV4P, T:OnbV4T },
  { id:'onb-v5', label:'V5 · Family postcard',  cap:'Sticker-book metaphor',          sub:'Novel · keepsake · emotional',        P:OnbV5P, T:OnbV5T },
  { id:'onb-v6', label:'V6 · Profile picker',   cap:'Shared-device first run',        sub:'Practical · PIN for parent · who-am-i', P:OnbV6P, T:OnbV6T },
];

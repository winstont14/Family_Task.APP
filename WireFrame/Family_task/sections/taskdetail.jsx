// sections/taskdetail.jsx — 6 variations: child opens task & marks complete

// V1 — Big checkbox + photo report (most basic)
const TdV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><span className="icn-back wf-muted"/><span className="wf-cap">today</span><div className="wf-spacer"/><Avatar tone="mint">E</Avatar></div>
  <div className="wf-h-lg">Clean your room</div>
  <div className="wf-cap">due 5pm · ⭐ 2 stars</div>
  <Img w="100%" h={90} label="optional photo proof"/>
  <Btn block>📷 add photo</Btn>
  <div className="scr-foot wf-col" style={{gap:6}}>
    <Btn tone="primary" size="xl" block>I did it ✓</Btn>
    <Btn block>need help</Btn>
  </div>
</div>);
const TdV1T = () => (<div className="scr">
  <div className="wf-row"><span className="icn-back wf-muted"/><Avatar tone="mint">E</Avatar><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>Emma</span><div className="wf-spacer"/><Stars filled={2} size={20} total={3}/></div>
  <div className="wf-h-xl">Clean your room 🧸</div>
  <div className="wf-cap">due today by 5:00 pm</div>
  <div className="wf-row" style={{flex:1, gap:14, marginTop:8, minHeight:0}}>
    <Img w="50%" h="100%" label="add a photo when done"/>
    <div className="wf-col" style={{flex:1, gap:8}}>
      <div className="wf-cap">a tip from mom</div>
      <div className="bubble">Don't forget under the bed, lovely 💛</div>
      <div className="wf-cap">how it's going</div>
      <Progress pct={40}/>
      <div className="wf-spacer"/>
      <Btn tone="primary" size="xl" block>I did it ✓</Btn>
    </div>
  </div>
</div>);

// V2 — Sub-task checklist (steps)
const TdV2P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Clean your room</div>
  <div className="wf-cap">3 of 4 steps</div>
  <Progress pct={75}/>
  <div className="scr-scroll" style={{marginTop:6}}>
    {[['Make bed',true],['Toys in bin',true],['Clothes away',true],['Vacuum floor',false]].map(([t,d],i)=>(
      <div key={i} className={`wf-row wf-card ${d?'wf-fill-done':''}`} style={{padding:8, gap:8, opacity:d?0.7:1}}>
        <Check size="lg" done={d}/><span style={{fontSize:14, fontFamily:'var(--hand-head)', textDecoration:d?'line-through':''}}>{t}</span>
      </div>
    ))}
  </div>
  <Btn tone="primary" size="lg" block>Finish task ✓</Btn>
</div>);
const TdV2T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Clean your room</div><div className="wf-spacer"/><Pill tone="accent">step 4 of 4</Pill></div>
  <Progress pct={75}/>
  <div className="scr-scroll" style={{marginTop:8, gap:8}}>
    {[['🛏','Make bed',true],['🧸','Toys in bin',true],['👕','Clothes away',true],['🧹','Vacuum floor',false],['💌','Tell mom you\'re done',false]].map(([e,t,d],i)=>(
      <div key={i} className={`wf-card wf-row ${d?'wf-fill-done':''}`} style={{padding:'10px 14px', gap:12, opacity:d?0.7:1}}>
        <Check size="xl" done={d}/>
        <div style={{fontSize:30}}>{e}</div>
        <div style={{fontSize:18, fontFamily:'var(--hand-head)', flex:1, textDecoration:d?'line-through':''}}>{t}</div>
      </div>
    ))}
  </div>
</div>);

// V3 — Focus / timer mode
const TdV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-cap">focus · homework</div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:8}}>
    <div className="wf-stroke" style={{width:140, height:140, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', borderWidth:3, position:'relative'}}>
      <div style={{fontFamily:'var(--hand-head)', fontSize:42}}>12:30</div>
      <div style={{position:'absolute', top:-6, left:'50%', transform:'translateX(-50%)', width:8, height:8, background:'var(--accent)', borderRadius:'50%'}}/>
    </div>
    <div className="wf-cap">12 min left of 25</div>
    <div className="wf-row" style={{gap:6}}><Btn>pause</Btn><Btn tone="primary">+5 min</Btn></div>
  </div>
  <Btn block>I'm done early ✓</Btn>
</div>);
const TdV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Reading time 📖</div><div className="wf-spacer"/><Pill tone="accent">⭐ 2 stars</Pill></div>
  <div className="wf-cap">read for 20 minutes — I'll cheer you on</div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'center', justifyContent:'center', minHeight:0}}>
    <div className="wf-stroke" style={{width:240, height:240, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', borderWidth:4, position:'relative'}}>
      <div className="wf-col" style={{alignItems:'center', gap:0}}>
        <div style={{fontFamily:'var(--hand-head)', fontSize:64, lineHeight:1}}>13:42</div>
        <div className="wf-cap">left to read</div>
      </div>
    </div>
    <div className="wf-col" style={{gap:8}}>
      <Btn size="xl">⏸ pause</Btn>
      <Btn size="xl">+ 5 min</Btn>
      <Btn tone="primary" size="xl">done early ✓</Btn>
    </div>
  </div>
</div>);

// V4 — Celebration / story (post-completion)
const TdV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:8, textAlign:'center'}}>
    <div style={{fontSize:80}}>🎉</div>
    <div className="wf-h-xl">YOU DID IT!</div>
    <div className="wf-cap">+2 stars earned</div>
    <Stars filled={2} total={3} size={28}/>
    <div className="bubble" style={{maxWidth:'85%', marginTop:6}}>Great job, Emma. Mom is proud 💛</div>
  </div>
  <div className="scr-foot wf-col" style={{gap:6}}>
    <Btn tone="primary" size="xl" block>Tell parent 💌</Btn>
    <Btn block>back to my list</Btn>
  </div>
</div>);
const TdV4T = () => (<div className="scr">
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', gap:14, textAlign:'center'}}>
    <div style={{fontSize:120}}>🎉</div>
    <div style={{fontFamily:'var(--hand-head)', fontSize:60, lineHeight:1}}>You did it!</div>
    <div className="wf-h2">Clean your room — done</div>
    <Stars filled={3} total={3} size={48}/>
    <div className="wf-row" style={{gap:6, flexWrap:'wrap', justifyContent:'center'}}>
      {['🌈','🦄','🚀','🌟','🎈','🍪'].map(e=>(<div key={e} className="wf-stroke" style={{width:42, height:42, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontSize:22}}>{e}</div>))}
    </div>
    <div className="wf-cap">add a sticker to your report!</div>
  </div>
  <div className="scr-foot wf-row" style={{justifyContent:'center', gap:10}}>
    <Btn size="xl">back</Btn>
    <Btn tone="primary" size="xl">Send to mom 💌</Btn>
  </div>
</div>);

// V5 — Voice / video report
const TdV5P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Tell parent</div>
  <div className="wf-cap">say or show what you did</div>
  <Img w="100%" h={130} label="video / live preview"/>
  <div className="wf-row" style={{justifyContent:'center', gap:8, marginTop:4}}>
    <div className="wf-stroke" style={{width:40,height:40,borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontSize:18}}>📷</div>
    <div className="wf-stroke" style={{width:50,height:50,borderRadius:'50%', background:'var(--accent)', borderColor:'var(--accent)', color:'#fff', display:'flex', alignItems:'center', justifyContent:'center', fontSize:24}}>●</div>
    <div className="wf-stroke" style={{width:40,height:40,borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', fontSize:18}}>🎤</div>
  </div>
  <div className="wf-cap" style={{textAlign:'center'}}>tap & hold to record · 0:08</div>
  <div className="scr-foot"><Btn tone="primary" size="lg" block>Send report ✉</Btn></div>
</div>);
const TdV5T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Show & tell</div><div className="wf-spacer"/><Pill>2 of 4 steps</Pill></div>
  <div className="wf-row" style={{flex:1, gap:14, marginTop:6, minHeight:0}}>
    <Img w="55%" h="100%" label="camera preview"/>
    <div className="wf-col" style={{flex:1, gap:8, justifyContent:'space-between'}}>
      <div>
        <div className="wf-cap">say something</div>
        <div className="wf-stroke" style={{padding:10, fontFamily:'var(--hand-head)', fontSize:18, color:'var(--ink-faint)'}}>"I cleaned my whole room and even under the bed!"</div>
      </div>
      <div className="wf-col" style={{alignItems:'center', gap:6}}>
        <div className="wf-stroke" style={{width:80,height:80,borderRadius:'50%',background:'var(--accent)',color:'#fff',borderColor:'var(--accent)', display:'flex',alignItems:'center',justifyContent:'center', fontSize:32}}>●</div>
        <div className="wf-cap">recording 0:08</div>
      </div>
      <div className="wf-row" style={{gap:8}}><Btn size="xl">retake</Btn><Btn tone="primary" size="xl">send to mom ✉</Btn></div>
    </div>
  </div>
</div>);

// V6 — Drag-to-done gesture (slide checkbox)
const TdV6P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Feed the cat 🐱</div>
  <div className="wf-cap">noon · daily · ⭐ 1 star</div>
  <div className="wf-col" style={{flex:1, justifyContent:'center', gap:10}}>
    <div className="wf-stroke" style={{padding:'5px 6px', borderRadius:50, position:'relative', height:50, background:'rgba(91,141,239,.07)'}}>
      <div style={{position:'absolute', right:14, top:'50%', transform:'translateY(-50%)', fontFamily:'var(--hand-head)', color:'var(--ink-faint)', fontSize:14}}>slide to mark done →</div>
      <div style={{position:'absolute', left:5, top:5, width:40, height:40, borderRadius:'50%', background:'var(--accent)', borderColor:'var(--accent)', border:'1.6px solid', color:'#fff', display:'flex', alignItems:'center', justifyContent:'center', fontSize:20}}>→</div>
    </div>
    <div className="wf-cap" style={{textAlign:'center'}}>or</div>
    <Btn block>📷 send photo proof</Btn>
  </div>
  <Btn block>need help</Btn>
</div>);
const TdV6T = () => (<div className="scr">
  <div className="wf-row"><span className="icn-back wf-muted"/><div className="wf-h-xl">Water the plants 🪴</div><div className="wf-spacer"/><Stars filled={1} total={3} size={20}/></div>
  <div className="wf-cap">today · ⭐ 1 star · drag the leaf to the pot to finish</div>
  <div className="wf-col" style={{flex:1, justifyContent:'center', alignItems:'center', gap:14}}>
    <div className="wf-stroke" style={{width:'90%', padding:8, borderRadius:60, position:'relative', height:80, background:'rgba(184,216,186,.25)'}}>
      <div style={{position:'absolute', right:24, top:'50%', transform:'translateY(-50%)', fontFamily:'var(--hand-head)', fontSize:28, color:'var(--ink-faint)'}}>→ drop on the pot</div>
      <div style={{position:'absolute', left:8, top:8, width:64, height:64, borderRadius:'50%', background:'var(--accent)', color:'#fff', display:'flex', alignItems:'center', justifyContent:'center', fontSize:30, border:'1.6px solid var(--accent)'}}>🪴</div>
      <div style={{position:'absolute', right:14, top:8, width:64, height:64, borderRadius:'50%', border:'2px dashed var(--ink-faint)', display:'flex', alignItems:'center', justifyContent:'center', fontSize:30}}>🌱</div>
    </div>
    <div className="wf-cap">progress so far</div>
    <Progress pct={60}/>
  </div>
  <div className="scr-foot wf-row" style={{gap:10}}><Btn size="xl">help me</Btn><div className="wf-spacer"/><Btn tone="primary" size="xl">Skip & mark done</Btn></div>
</div>);

window.TaskDetailVariations = [
  { id:'td-v1', label:'V1 · Photo report',     cap:'Big I-did-it + photo proof',     sub:'Simplest path · most apps work like this', P:TdV1P, T:TdV1T },
  { id:'td-v2', label:'V2 · Sub-task steps',   cap:'Break work into checkboxes',     sub:'Best for big chores · feels guided',       P:TdV2P, T:TdV2T },
  { id:'td-v3', label:'V3 · Focus timer',      cap:'Pomodoro-style countdown',       sub:'Best for homework / reading',              P:TdV3P, T:TdV3T },
  { id:'td-v4', label:'V4 · Celebration',      cap:'Post-complete confetti screen',  sub:'Sticker decorate · share with parent',     P:TdV4P, T:TdV4T },
  { id:'td-v5', label:'V5 · Voice / video',    cap:'Show-and-tell report',           sub:'For pre-readers · proud moments',          P:TdV5P, T:TdV5T },
  { id:'td-v6', label:'V6 · Drag to done',     cap:'Gesture-based completion',       sub:'Tactile · feels like play',                P:TdV6P, T:TdV6T },
];

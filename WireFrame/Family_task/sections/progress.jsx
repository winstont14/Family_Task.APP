// sections/progress.jsx — 6 variations: rewards, streaks, gardens, leaderboard

// V1 — Simple progress + star count
const PgV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">My progress</div>
  <div className="wf-cap">tue · today</div>
  <div className="wf-card">
    <div className="wf-row"><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>3 of 4 done</span><div className="wf-spacer"/><Pill tone="accent">75%</Pill></div>
    <Progress pct={75}/>
  </div>
  <div className="wf-row" style={{gap:5}}>
    <div className="wf-card wf-col" style={{flex:1, padding:7, alignItems:'center'}}><div style={{fontSize:24, fontFamily:'var(--hand-head)'}}>⭐ 12</div><div className="wf-cap">stars this week</div></div>
    <div className="wf-card wf-col" style={{flex:1, padding:7, alignItems:'center'}}><div style={{fontSize:24, fontFamily:'var(--hand-head)'}}>🔥 5</div><div className="wf-cap">day streak</div></div>
  </div>
  <div className="wf-cap">this week</div>
  <div className="wf-row" style={{gap:3}}>{['M','T','W','T','F','S','S'].map((d,i)=>(<div key={i} className={`wf-stroke wf-col ${i<2?'wf-fill-done':''}`} style={{flex:1, padding:'4px 0', alignItems:'center'}}><div className="wf-cap">{d}</div><div style={{fontSize:11}}>{i<2?'✓':i===2?'·':' '}</div></div>))}</div>
</div>);
const PgV1T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Emma's progress</div><div className="wf-spacer"/><Pill tone="accent">⭐ 12 this week</Pill></div>
  <div className="wf-row" style={{gap:14, marginTop:8}}>
    <div className="wf-card wf-col" style={{flex:1, padding:14, alignItems:'center', gap:5}}><div style={{fontSize:46, fontFamily:'var(--hand-head)'}}>3/4</div><div className="wf-cap">today</div><Progress pct={75}/></div>
    <div className="wf-card wf-col" style={{flex:1, padding:14, alignItems:'center', gap:5}}><div style={{fontSize:46}}>🔥</div><div style={{fontFamily:'var(--hand-head)', fontSize:20}}>5 day streak</div></div>
    <div className="wf-card wf-col" style={{flex:1, padding:14, alignItems:'center', gap:5}}><div style={{fontSize:46}}>⭐</div><div style={{fontFamily:'var(--hand-head)', fontSize:20}}>12 / 20 weekly goal</div><Progress pct={60}/></div>
  </div>
  <div className="wf-cap" style={{marginTop:10}}>this week</div>
  <div className="wf-row" style={{gap:6}}>{['M','T','W','T','F','S','S'].map((d,i)=>(<div key={i} className={`wf-stroke wf-col ${i<2?'wf-fill-done':''}`} style={{flex:1, padding:'10px 0', alignItems:'center', gap:2}}><div className="wf-cap">{d}</div><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>{i<2?'✓':i===2?'•':' '}</div><Stars filled={i<2?3:i===2?1:0} total={3} size={9}/></div>))}</div>
</div>);

// V2 — Star jar (collection metaphor)
const PgV2P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">My star jar</div>
  <div className="wf-cap">fill it up to redeem</div>
  <div className="wf-col" style={{flex:1, alignItems:'center', justifyContent:'center', position:'relative'}}>
    <div style={{width:120, height:160, border:'2px solid var(--ink)', borderTop:'none', borderRadius:'0 0 18px 18px', position:'relative', overflow:'hidden'}}>
      <div style={{position:'absolute', bottom:0, width:'100%', height:'60%', background:'rgba(91,141,239,.18)', display:'flex', flexWrap:'wrap', alignContent:'flex-end', padding:4, gap:2}}>
        {Array.from({length:14}).map((_,i)=>(<span key={i} style={{fontSize:14}}>⭐</span>))}
      </div>
      <div style={{position:'absolute', top:-6, left:'50%', transform:'translateX(-50%)', width:60, height:8, background:'var(--ink)', borderRadius:4}}/>
    </div>
    <div style={{fontFamily:'var(--hand-head)', fontSize:22, marginTop:10}}>14 / 20 stars</div>
    <div className="wf-cap">6 to go for movie night 🎬</div>
  </div>
</div>);
const PgV2T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Star jar 🫙</div><div className="wf-spacer"/><Pill tone="accent">14 / 20</Pill></div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'center', justifyContent:'center', minHeight:0}}>
    <div className="wf-col" style={{alignItems:'center', gap:6}}>
      <div style={{width:180, height:240, border:'3px solid var(--ink)', borderTop:'none', borderRadius:'0 0 28px 28px', position:'relative', overflow:'hidden', background:'rgba(91,141,239,.05)'}}>
        <div style={{position:'absolute', bottom:0, width:'100%', height:'70%', background:'rgba(91,141,239,.2)', display:'flex', flexWrap:'wrap', alignContent:'flex-end', padding:6, gap:3}}>
          {Array.from({length:14}).map((_,i)=>(<span key={i} style={{fontSize:18}}>⭐</span>))}
        </div>
        <div style={{position:'absolute', top:-10, left:'50%', transform:'translateX(-50%)', width:90, height:10, background:'var(--ink)', borderRadius:6}}/>
      </div>
      <div style={{fontFamily:'var(--hand-head)', fontSize:36}}>14 stars!</div>
    </div>
    <div className="wf-col" style={{flex:1, gap:8}}>
      <div className="wf-cap">6 more to unlock</div>
      <div className="wf-card wf-row" style={{padding:10, gap:10, alignItems:'center'}}>
        <div style={{fontSize:36}}>🎬</div>
        <div className="wf-col" style={{gap:0, flex:1}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>Movie night</div><Progress pct={70}/><div className="wf-cap">14 / 20 ⭐</div></div>
      </div>
      <div className="wf-cap">future rewards</div>
      {[['🍦','Ice cream','30'],['🦄','New plushie','50'],['🏕','Camping trip','100']].map(([e,t,c],i)=>(
        <div key={i} className="wf-card-soft wf-row" style={{padding:7, gap:8}}>
          <span style={{fontSize:20}}>{e}</span><span style={{fontFamily:'var(--hand-head)', flex:1}}>{t}</span><Pill>⭐ {c}</Pill>
        </div>
      ))}
    </div>
  </div>
</div>);

// V3 — Streak calendar (heatmap)
const PgV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">5-day streak 🔥</div>
  <div className="wf-cap">don't break the chain</div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(7, 1fr)', gap:3, marginTop:6}}>
    {Array.from({length:35}).map((_,i)=>{
      const lvl = [0,1,2,3,2,3,1,0,2,3,3,2,1,0,1,2,3,3,3,2,1,2,3,3,3,3,3,2,3,3,3,2,3][i] || 0;
      const colors = ['rgba(31,31,31,.04)','rgba(91,141,239,.25)','rgba(91,141,239,.5)','rgba(91,141,239,.8)'];
      return <div key={i} style={{aspectRatio:'1', background:colors[lvl], border:'1px solid var(--ink-faint)', borderRadius:3}}/>;
    })}
  </div>
  <div className="wf-row" style={{gap:6, marginTop:8, fontSize:9, color:'var(--ink-faint)'}}>less {[0,1,2,3].map(l=>(<div key={l} style={{width:10,height:10,background:['rgba(31,31,31,.04)','rgba(91,141,239,.25)','rgba(91,141,239,.5)','rgba(91,141,239,.8)'][l],border:'1px solid var(--ink-faint)'}}/>))} more</div>
  <div className="wf-row" style={{gap:5, marginTop:10}}>
    <div className="wf-card wf-col" style={{flex:1, padding:6, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>5🔥</div><div className="wf-cap">current</div></div>
    <div className="wf-card wf-col" style={{flex:1, padding:6, alignItems:'center'}}><div style={{fontFamily:'var(--hand-head)', fontSize:18}}>12</div><div className="wf-cap">best ever</div></div>
  </div>
</div>);
const PgV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Streak history 🔥</div><div className="wf-spacer"/><Pill tone="accent">5 day current</Pill></div>
  <div className="wf-cap" style={{marginTop:4}}>last 12 weeks · darker = more done</div>
  <div className="wf-row" style={{gap:8, alignItems:'flex-start', marginTop:10}}>
    <div className="wf-col" style={{gap:3, fontSize:9, color:'var(--ink-faint)', paddingTop:14, fontFamily:'var(--hand-arch)'}}>
      <span>M</span><span>W</span><span>F</span>
    </div>
    <div style={{display:'grid', gridTemplateColumns:'repeat(12, 1fr)', gridTemplateRows:'repeat(7, 1fr)', gap:3, flex:1, height:130, gridAutoFlow:'column'}}>
      {Array.from({length:84}).map((_,i)=>{
        const lvl = (i*7)%4;
        const colors = ['rgba(31,31,31,.04)','rgba(91,141,239,.25)','rgba(91,141,239,.55)','rgba(91,141,239,.85)'];
        return <div key={i} style={{background:colors[lvl], border:'1px solid var(--ink-faint)', borderRadius:2}}/>;
      })}
    </div>
  </div>
  <div className="wf-row" style={{gap:14, marginTop:14}}>
    {[['🔥','5','current streak'],['🏆','12','best streak'],['📅','58','total days'],['⭐','142','total stars']].map(([e,n,l],i)=>(
      <div key={i} className="wf-card wf-col" style={{flex:1, padding:12, alignItems:'center', gap:3}}>
        <div style={{fontSize:24}}>{e}</div>
        <div style={{fontFamily:'var(--hand-head)', fontSize:24}}>{n}</div>
        <div className="wf-cap">{l}</div>
      </div>
    ))}
  </div>
</div>);

// V4 — Garden growing metaphor
const PgV4P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Emma's garden 🌱</div>
  <div className="wf-cap">grows when you finish tasks</div>
  <div className="wf-col" style={{flex:1, justifyContent:'flex-end', position:'relative'}}>
    <div style={{position:'absolute', top:0, right:0, fontSize:30}}>☀</div>
    <div style={{position:'absolute', top:30, left:10, fontSize:18, opacity:0.6}}>☁</div>
    <div className="wf-row" style={{justifyContent:'space-around', alignItems:'flex-end', marginBottom:16}}>
      <div style={{fontSize:48}}>🌳</div>
      <div style={{fontSize:36}}>🌷</div>
      <div style={{fontSize:42}}>🌻</div>
      <div style={{fontSize:24}}>🌱</div>
      <div style={{fontSize:14, opacity:0.4}}>·</div>
    </div>
    <div style={{height:18, background:'repeating-linear-gradient(45deg, rgba(120,80,40,.2) 0 4px, rgba(120,80,40,.35) 4px 8px)', borderTop:'1.6px solid var(--ink)'}}/>
  </div>
  <div className="wf-card wf-row" style={{padding:7}}><span style={{fontFamily:'var(--hand-head)'}}>4 plants grown · 1 sprouting</span><div className="wf-spacer"/><Pill tone="accent">+ ⭐ 2 = water</Pill></div>
</div>);
const PgV4T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Family garden 🌳</div><div className="wf-spacer"/><span className="wf-cap">every star waters a plant</span></div>
  <div className="wf-col" style={{flex:1, justifyContent:'flex-end', position:'relative', marginTop:8, background:'linear-gradient(180deg, rgba(135,206,235,.15) 0%, rgba(255,255,255,0) 60%)', border:'1.4px dashed var(--ink-faint)', borderRadius:14, padding:'14px'}}>
    <div style={{position:'absolute', top:14, right:24, fontSize:46}}>☀</div>
    <div style={{position:'absolute', top:60, left:30, fontSize:30, opacity:0.6}}>☁</div>
    <div style={{position:'absolute', top:80, right:80, fontSize:24, opacity:0.5}}>☁</div>
    <div className="wf-row" style={{justifyContent:'space-around', alignItems:'flex-end'}}>
      <div className="wf-col" style={{alignItems:'center', gap:2}}><div style={{fontSize:64}}>🌳</div><div className="wf-cap">Mom · 12⭐</div></div>
      <div className="wf-col" style={{alignItems:'center', gap:2}}><div style={{fontSize:54}}>🌻</div><div className="wf-cap">Emma · 8⭐</div></div>
      <div className="wf-col" style={{alignItems:'center', gap:2}}><div style={{fontSize:40}}>🌷</div><div className="wf-cap">Leo · 5⭐</div></div>
      <div className="wf-col" style={{alignItems:'center', gap:2}}><div style={{fontSize:30}}>🌱</div><div className="wf-cap">Riya · 2⭐</div></div>
    </div>
    <div style={{height:24, background:'repeating-linear-gradient(45deg, rgba(120,80,40,.2) 0 5px, rgba(120,80,40,.35) 5px 10px)', borderTop:'1.6px solid var(--ink)', marginTop:8}}/>
  </div>
  <div className="wf-row" style={{gap:8, marginTop:10}}>
    <Btn size="lg">🌧 use 2⭐ to water</Btn>
    <Btn size="lg">✂ trim weeds</Btn>
    <div className="wf-spacer"/>
    <Pill tone="accent">family total · 27⭐</Pill>
  </div>
</div>);

// V5 — Reward shop
const PgV5P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-row"><div className="wf-h">Shop</div><div className="wf-spacer"/><Pill tone="accent">⭐ 14</Pill></div>
  <div className="wf-cap">spend stars on real-life rewards</div>
  <div className="scr-scroll" style={{marginTop:5}}>
    {[
      ['🎬','Movie night','20',true],
      ['🍦','Ice cream','10',true],
      ['🦄','New plushie','50',false],
      ['📱','30 min screen','15',true],
      ['🏕','Camping trip','100',false],
    ].map(([e,t,c,can],i)=>(
      <div key={i} className="wf-card wf-row" style={{padding:7, gap:8}}>
        <span style={{fontSize:24}}>{e}</span>
        <div className="wf-col" style={{flex:1, gap:1}}>
          <span style={{fontFamily:'var(--hand-head)'}}>{t}</span>
          <Pill tone={can?'':'faint'}>⭐ {c}</Pill>
        </div>
        <Btn tone={can?'primary':''}>{can?'redeem':'soon'}</Btn>
      </div>
    ))}
  </div>
</div>);
const PgV5T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Reward shop 🛒</div><div className="wf-spacer"/><Pill tone="accent" >⭐ 14 to spend</Pill></div>
  <div className="wf-row" style={{gap:6, marginTop:4}}>{['All','Treats','Trips','Screen time','Toys','Custom'].map((c,i)=>(<Pill key={c} tone={i===0?'accent':''}>{c}</Pill>))}</div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(3,1fr)', gap:10, marginTop:10}}>
    {[
      ['🎬','Movie night','20','Pick the film',true],
      ['🍦','Ice cream cone','10','After dinner',true],
      ['🦄','New plushie','50','Up to $20',false],
      ['📱','30 min screen','15','Once redeemed',true],
      ['🏕','Camping trip','100','Family activity',false],
      ['+','Custom reward','—','Suggest your own',true],
    ].map(([e,t,c,sub,can],i)=>(
      <div key={i} className="wf-card wf-col" style={{padding:12, gap:4, alignItems:'center'}}>
        <div style={{fontSize:38}}>{e}</div>
        <div style={{fontFamily:'var(--hand-head)', fontSize:18, textAlign:'center'}}>{t}</div>
        <div className="wf-cap" style={{textAlign:'center'}}>{sub}</div>
        <Btn tone={can?'primary':''} size="lg">⭐ {c} {can?'· redeem':''}</Btn>
      </div>
    ))}
  </div>
</div>);

// V6 — Family leaderboard
const PgV6P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">This week</div>
  <div className="wf-cap">friendly family race · resets sunday</div>
  <div className="scr-scroll" style={{marginTop:5}}>
    {[
      ['1','Emma','mint',12,'🥇'],
      ['2','Leo','lilac',8,'🥈'],
      ['3','Riya','peach',5,'🥉'],
      ['4','Mom','peach',3,''],
    ].map(([r,n,t,s,m],i)=>(
      <div key={i} className={`wf-card wf-row ${i===0?'wf-fill-accent':''}`} style={{padding:7, gap:7, color:i===0?'#fff':''}}>
        <div style={{fontFamily:'var(--hand-head)', fontSize:20, width:18}}>{r}</div>
        <Avatar tone={t}>{n[0]}</Avatar>
        <span style={{fontFamily:'var(--hand-head)', flex:1}}>{n}</span>
        <span style={{fontFamily:'var(--hand-head)', fontSize:14}}>⭐ {s}</span>
        <span style={{fontSize:18}}>{m}</span>
      </div>
    ))}
  </div>
  <div className="wf-cap" style={{textAlign:'center'}}>winner picks family movie 🎬</div>
</div>);
const PgV6T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">This week's race 🏁</div><div className="wf-spacer"/><span className="wf-cap">3 days left</span></div>
  <div className="wf-row" style={{gap:14, alignItems:'flex-end', justifyContent:'center', marginTop:14, height:140}}>
    <div className="wf-col" style={{alignItems:'center', gap:4}}>
      <Avatar tone="lilac" size="xl">L</Avatar>
      <div style={{width:70, background:'var(--accent)', height:60, borderRadius:'8px 8px 0 0', border:'1.6px solid var(--ink)', display:'flex', alignItems:'center', justifyContent:'center', color:'#fff', fontFamily:'var(--hand-head)', fontSize:30}}>2</div>
      <div className="wf-cap">Leo · ⭐ 8</div>
    </div>
    <div className="wf-col" style={{alignItems:'center', gap:4}}>
      <div style={{fontSize:30}}>🏆</div>
      <Avatar tone="mint" size="xl">E</Avatar>
      <div style={{width:80, background:'var(--accent)', height:90, borderRadius:'8px 8px 0 0', border:'1.6px solid var(--ink)', display:'flex', alignItems:'center', justifyContent:'center', color:'#fff', fontFamily:'var(--hand-head)', fontSize:36}}>1</div>
      <div className="wf-cap">Emma · ⭐ 12</div>
    </div>
    <div className="wf-col" style={{alignItems:'center', gap:4}}>
      <Avatar tone="peach" size="xl">R</Avatar>
      <div style={{width:70, background:'var(--accent)', height:40, borderRadius:'8px 8px 0 0', border:'1.6px solid var(--ink)', display:'flex', alignItems:'center', justifyContent:'center', color:'#fff', fontFamily:'var(--hand-head)', fontSize:24}}>3</div>
      <div className="wf-cap">Riya · ⭐ 5</div>
    </div>
  </div>
  <div className="wf-cap" style={{textAlign:'center', marginTop:8}}>this week's prize · winner picks family movie 🎬</div>
  <div className="scr-scroll" style={{marginTop:8, gap:5}}>
    {[
      ['Emma · 12⭐ · 🔥 5 day streak'],
      ['Leo · 8⭐ · 🔥 3 day streak'],
      ['Riya · 5⭐ · just started!'],
      ['Mom · 3⭐ · admin tasks'],
    ].map((t,i)=>(<div key={i} className="wf-stroke-thin" style={{padding:'5px 8px', fontSize:12}}>{t}</div>))}
  </div>
</div>);

window.ProgressVariations = [
  { id:'pg-v1', label:'V1 · Stats dashboard',  cap:'Numbers, bars, week strip',     sub:'Conventional · readable at a glance',   P:PgV1P, T:PgV1T },
  { id:'pg-v2', label:'V2 · Star jar',         cap:'Fill a jar to redeem',          sub:'Tangible · classic chore-chart vibe',   P:PgV2P, T:PgV2T },
  { id:'pg-v3', label:'V3 · Streak heatmap',   cap:'GitHub-style consistency map',  sub:'Best for older kids · habit-tracker',   P:PgV3P, T:PgV3T },
  { id:'pg-v4', label:'V4 · Family garden',    cap:'Plants grow with stars',        sub:'Most novel · shared family world',      P:PgV4P, T:PgV4T },
  { id:'pg-v5', label:'V5 · Reward shop',      cap:'Spend stars on real things',    sub:'Strongest motivator · parent-curated',  P:PgV5P, T:PgV5T },
  { id:'pg-v6', label:'V6 · Family race',      cap:'Weekly leaderboard',            sub:'Friendly competition · resets weekly',  P:PgV6P, T:PgV6T },
];

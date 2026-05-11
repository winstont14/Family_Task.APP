// screens-progress-family.jsx — Progress/Rewards (6) + Family Members (6)

// ═══════════════════════════════════════════════════════════════════
// PROGRESS / REWARDS · 6 variations (kid-focused but parent visible)
// ═══════════════════════════════════════════════════════════════════

// P1 — Star jar
const Pr1Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22, textAlign:'center' }}>My Star Jar</div>
    <Note style={{ textAlign:'center' }}>14 stars this week</Note>
    <div className="wf-stroke" style={{ position:'relative', marginTop:14, height:200, borderRadius:'10px 10px 50px 50px / 10px 10px 30px 30px', background:'#fffaf0', overflow:'hidden' }}>
      <div style={{ position:'absolute', bottom:0, left:0, right:0, height:'58%', background:'rgba(245,217,118,0.6)' }}/>
      <div style={{ position:'absolute', bottom:30, width:'100%', textAlign:'center' }}>
        {Array.from({length:14}).map((_,i)=> <span key={i} style={{ fontSize:18 }}>⭐</span>)}
      </div>
    </div>
    <Note style={{ textAlign:'center', marginTop:8 }}>6 more for an ice-cream night 🍦</Note>
  </div>
);
const Pr1Tablet = () => (
  <div style={{ padding:'30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:36 }}>Emma's star jar</div>
    <Note style={{ fontSize:16 }}>14 of 20 — keep going!</Note>
    <div style={{ display:'flex', gap:24, marginTop:18 }}>
      <div className="wf-stroke" style={{ width:200, height:280, position:'relative', borderRadius:'10px 10px 60px 60px / 10px 10px 40px 40px', background:'#fffaf0', overflow:'hidden' }}>
        <div style={{ position:'absolute', bottom:0, left:0, right:0, height:'70%', background:'rgba(245,217,118,0.6)' }}/>
        <div style={{ position:'absolute', bottom:60, left:10, right:10, textAlign:'center', lineHeight:1.2 }}>
          {Array.from({length:14}).map((_,i)=> <span key={i} style={{ fontSize:22, margin:'0 1px' }}>⭐</span>)}
        </div>
      </div>
      <div style={{ flex:1 }}>
        <Section label="Goal"><div className="wf-stroke-thin" style={{ padding:'10px 12px', fontSize:14 }}>🍦 ice-cream night</div></Section>
        <Section label="Progress"><ProgressBar pct={70} color="var(--yellow)"/></Section>
        <Section label="Recent"><Note>+1 ⭐ feed cat · today</Note><Note>+1 ⭐ clean room · today</Note></Section>
      </div>
    </div>
  </div>
);

// P2 — Streaks (calendar dots)
const Pr2Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Streak 🔥</div>
    <Note>4 days in a row</Note>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'repeat(7, 1fr)', gap:4 }}>
      {Array.from({length:28}).map((_,i)=>{
        const done = i<24 && (i+1)%7!==0;
        const today = i===23;
        return <div key={i} className="wf-stroke-thin" style={{ aspectRatio:1, display:'flex', alignItems:'center', justifyContent:'center', background: today?'var(--accent)':done?'var(--done)':'var(--paper)', color:today?'#fff':'inherit', fontSize:9 }}>{i+1}</div>;
      })}
    </div>
    <Section label="Best streak" style={{ marginTop:14 }}>
      <div className="wf-row"><span style={{ fontSize:24 }}>🏆</span><Note style={{ fontSize:14 }}>7 days · last month</Note></div>
    </Section>
  </div>
);
const Pr2Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:34 }}>Your streak 🔥 4 days</div>
    <Note style={{ fontSize:14 }}>last 8 weeks</Note>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'repeat(8, 1fr)', gap:5 }}>
      {Array.from({length:56}).map((_,i)=>{
        const seed = (i*7+3)%11;
        const c = seed<3 ? 'var(--paper)' : seed<7 ? '#dceadd' : seed<10 ? 'var(--done)' : '#5a8f5e';
        return <div key={i} className="wf-stroke-thin" style={{ aspectRatio:1, background:c }}/>;
      })}
    </div>
    <div className="wf-row" style={{ gap:14, marginTop:18 }}>
      <div className="wf-stroke" style={{ padding:'10px 14px', flex:1 }}>
        <Note style={{ fontSize:11 }}>BEST STREAK</Note>
        <div className="wf-headline" style={{ fontSize:30 }}>🏆 7 days</div>
      </div>
      <div className="wf-stroke" style={{ padding:'10px 14px', flex:1 }}>
        <Note style={{ fontSize:11 }}>TOTAL STARS</Note>
        <div className="wf-headline" style={{ fontSize:30 }}>⭐ 42</div>
      </div>
    </div>
  </div>
);

// P3 — Badges grid
const Pr3Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Badges</div>
    <Note>4 of 12 unlocked</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:8, marginTop:12 }}>
      {[
        ['🌅','Early Bird',true],['🐱','Pet Pro',true],['📚','Bookworm',true],
        ['🧹','Tidy Tiger',true],['🔥','5 Streak',false],['🌟','10 Stars',false],
        ['🥇','Helper',false],['🎯','Focused',false],['🦸','Hero',false]
      ].map(([e,n,on],i)=>(
        <div key={i} className="wf-stroke-thin" style={{ padding:'8px 4px', textAlign:'center', opacity:on?1:0.4, background:on?'#FFF6BD':'var(--paper)' }}>
          <div style={{ fontSize:24 }}>{e}</div>
          <Note style={{ fontSize:10 }}>{n}</Note>
        </div>
      ))}
    </div>
  </div>
);
const Pr3Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>Your badges</div>
    <Note style={{ fontSize:14 }}>collect them all</Note>
    <div style={{ display:'grid', gridTemplateColumns:'repeat(6, 1fr)', gap:10, marginTop:14 }}>
      {Array.from({length:18}).map((_,i)=>{
        const on = i<6;
        const e = ['🌅','🐱','📚','🧹','🛏️','🪥','🥇','🌟','🔥','🎯','🦸','🏆','🌟','🌱','🎨','🎵','💪','🚀'][i];
        return (
          <div key={i} className="wf-stroke" style={{ padding:'12px 4px', textAlign:'center', opacity:on?1:0.35, background:on?'#FFF6BD':'var(--paper)' }}>
            <div style={{ fontSize:34 }}>{e}</div>
            <Note style={{ fontSize:11 }}>{on?'unlocked':'???'}</Note>
          </div>
        );
      })}
    </div>
  </div>
);

// P4 — Garden / pet that grows
const Pr4Phone = () => (
  <div style={{ padding:'12px', height:'100%', background:'linear-gradient(180deg,#cfe5ff,#fff7d6)' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Your garden</div>
    <Note>3 plants growing</Note>
    <div className="wf-stroke" style={{ marginTop:14, height:220, background:'#fff', position:'relative', overflow:'hidden' }}>
      <div style={{ position:'absolute', bottom:30, left:30, fontSize:42 }}>🌳</div>
      <div style={{ position:'absolute', bottom:24, left:90, fontSize:32 }}>🌷</div>
      <div style={{ position:'absolute', bottom:22, left:140, fontSize:28 }}>🌱</div>
      <div style={{ position:'absolute', bottom:0, left:0, right:0, height:18, background:'#9ec48c' }}/>
    </div>
    <Note style={{ textAlign:'center', marginTop:8 }}>finish a task to water 🌿</Note>
  </div>
);
const Pr4Tablet = () => (
  <div style={{ padding:'30px', height:'100%', background:'linear-gradient(180deg,#cfe5ff,#fff7d6)' }}>
    <div className="wf-headline" style={{ fontSize:36 }}>Emma's garden</div>
    <Note style={{ fontSize:16 }}>each task = a drop of water</Note>
    <div className="wf-stroke" style={{ marginTop:18, height:280, background:'#fff', position:'relative', overflow:'hidden' }}>
      <div style={{ position:'absolute', bottom:50, left:60, fontSize:64 }}>🌳</div>
      <div style={{ position:'absolute', bottom:40, left:150, fontSize:48 }}>🌷</div>
      <div style={{ position:'absolute', bottom:35, left:220, fontSize:42 }}>🌻</div>
      <div style={{ position:'absolute', bottom:30, left:280, fontSize:36 }}>🌱</div>
      <div style={{ position:'absolute', bottom:0, left:0, right:0, height:24, background:'#9ec48c' }}/>
      <div style={{ position:'absolute', top:14, right:14 }}>☁️ ☁️</div>
    </div>
    <Note style={{ marginTop:10, fontSize:14 }}>novel: progress as a living thing, not a number</Note>
  </div>
);

// P5 — Leaderboard / siblings
const Pr5Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Family ranking</div>
    <Note>this week</Note>
    <div style={{ marginTop:12, display:'flex', alignItems:'flex-end', justifyContent:'center', gap:6, height:140 }}>
      <div style={{ display:'flex', flexDirection:'column', alignItems:'center' }}>
        <Avatar initial="J" tone="green" size="lg"/>
        <div className="wf-stroke" style={{ width:54, height:60, display:'flex', alignItems:'center', justifyContent:'center', fontSize:24 }}>2</div>
      </div>
      <div style={{ display:'flex', flexDirection:'column', alignItems:'center' }}>
        <span style={{ fontSize:18 }}>👑</span>
        <Avatar initial="E" tone="pink" size="xl"/>
        <div className="wf-stroke" style={{ width:60, height:90, display:'flex', alignItems:'center', justifyContent:'center', fontSize:30, background:'var(--yellow)' }}>1</div>
      </div>
      <div style={{ display:'flex', flexDirection:'column', alignItems:'center' }}>
        <Avatar initial="S" tone="warm" size="lg"/>
        <div className="wf-stroke" style={{ width:54, height:40, display:'flex', alignItems:'center', justifyContent:'center', fontSize:20 }}>3</div>
      </div>
    </div>
    <hr className="wf-divider"/>
    <Note style={{ fontSize:11 }}>⭐ Emma 24 · Jay 18 · Sam 11</Note>
  </div>
);
const Pr5Tablet = () => (
  <div style={{ padding:'30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:34 }}>This week 🏆</div>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'1fr 1fr', gap:18 }}>
      <div className="wf-stroke" style={{ padding:'18px' }}>
        <Note>PODIUM</Note>
        <div style={{ display:'flex', alignItems:'flex-end', justifyContent:'center', gap:10, marginTop:8 }}>
          <div className="wf-stroke" style={{ width:50, height:60, display:'flex', alignItems:'center', justifyContent:'center' }}>2</div>
          <div className="wf-stroke" style={{ width:60, height:90, display:'flex', alignItems:'center', justifyContent:'center', background:'var(--yellow)', fontSize:26 }}>1</div>
          <div className="wf-stroke" style={{ width:50, height:40, display:'flex', alignItems:'center', justifyContent:'center' }}>3</div>
        </div>
      </div>
      <div className="wf-stroke" style={{ padding:'18px' }}>
        <Note>TABLE</Note>
        <div style={{ marginTop:6 }}>
          {[['🥇 Emma',24],['🥈 Jay',18],['🥉 Sam',11]].map((r,i)=>(
            <div key={i} className="wf-row" style={{ padding:'4px 0', borderBottom:'1px dashed var(--ink-soft)' }}>
              <div style={{ flex:1, fontSize:14 }}>{r[0]}</div>
              <div style={{ fontSize:14 }}>⭐ {r[1]}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
    <Note style={{ fontSize:12, marginTop:12, color:'var(--ink-soft)' }}>caveat: leaderboards can demotivate kids — toggle off in family settings</Note>
  </div>
);

// P6 — Reward shop
const Pr6Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}>
      <div className="wf-headline" style={{ fontSize:22 }}>Shop</div>
      <Pill tone="solid">⭐ 14</Pill>
    </div>
    <Note>spend stars on rewards</Note>
    <div style={{ display:'flex', flexDirection:'column', gap:8, marginTop:10 }}>
      {[['🍦','Ice cream night',5,true],['🎬','Movie pick',8,true],['📚','New book',12,true],['🎮','30 min screen',6,true]].map(([e,n,c,k],i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'10px 12px', gap:10 }}>
          <span style={{ fontSize:24 }}>{e}</span>
          <div style={{ flex:1 }}><div style={{ fontSize:13 }}>{n}</div><Note style={{ fontSize:10 }}>set by mom</Note></div>
          <Btn primary>⭐ {c}</Btn>
        </div>
      ))}
    </div>
  </div>
);
const Pr6Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}>
      <div className="wf-headline" style={{ fontSize:32 }}>Reward shop</div>
      <div className="wf-stroke" style={{ padding:'8px 14px', fontSize:18 }}>⭐ 14 stars</div>
    </div>
    <Note style={{ fontSize:14 }}>parents define rewards · kids spend stars</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:12, marginTop:14 }}>
      {[['🍦','Ice cream night',5],['🎬','Movie pick',8],['📚','New book',12],['🎮','30m screen',6]].map(([e,n,c],i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'14px', display:'flex', gap:12, alignItems:'center' }}>
          <div style={{ fontSize:42 }}>{e}</div>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:16 }}>{n}</div>
            <Note style={{ fontSize:12 }}>set by mom · expires in 2w</Note>
          </div>
          <Btn primary>⭐ {c} buy</Btn>
        </div>
      ))}
    </div>
  </div>
);

window.ProgressVariations = [
  { id:'p1', label:'P1 · Star jar', cap:'Star jar', sub:'visual fill · cozy', P:Pr1Phone, T:Pr1Tablet },
  { id:'p2', label:'P2 · Streaks', cap:'Streaks calendar', sub:'GitHub-grass · habit-forming', P:Pr2Phone, T:Pr2Tablet },
  { id:'p3', label:'P3 · Badges', cap:'Badge shelf', sub:'collectible achievements', P:Pr3Phone, T:Pr3Tablet },
  { id:'p4', label:'P4 · Garden', cap:'Growing garden', sub:'progress = living thing · novel', P:Pr4Phone, T:Pr4Tablet },
  { id:'p5', label:'P5 · Leaderboard', cap:'Family leaderboard', sub:'siblings podium · use carefully', P:Pr5Phone, T:Pr5Tablet },
  { id:'p6', label:'P6 · Star shop', cap:'Reward shop', sub:'parent-defined · spend stars', P:Pr6Phone, T:Pr6Tablet },
];

// ═══════════════════════════════════════════════════════════════════
// FAMILY MEMBERS · 6 variations
// ═══════════════════════════════════════════════════════════════════

// F1 — List with role chips
const F1Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}>
      <div className="wf-headline" style={{ fontSize:22 }}>The Browns</div>
      <span>⚙️</span>
    </div>
    <Note>5 members</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:6 }}>
      {[['M','Mom','parent','blue'],['D','Dad','parent','warm'],['E','Emma','kid · 9','pink'],['J','Jay','kid · 7','green'],['S','Sam','kid · 5','yellow']].map((m,i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'8px 10px', gap:10 }}>
          <Avatar initial={m[0]} tone={m[3]==='yellow'?'warm':m[3]} size="lg"/>
          <div style={{ flex:1 }}><div style={{ fontSize:14 }}>{m[1]}</div><Note style={{ fontSize:10 }}>{m[2]}</Note></div>
          <Pill tone={m[2].startsWith('parent')?'solid':''}>{m[2].startsWith('parent')?'parent':'kid'}</Pill>
        </div>
      ))}
    </div>
    <Btn full style={{ marginTop:10 }}>+ add member</Btn>
  </div>
);
const F1Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>The Browns</div>
    <Note style={{ fontSize:14 }}>5 members · 2 parents · 3 kids</Note>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
      {[['M','Mom','parent','blue'],['D','Dad','parent','warm'],['E','Emma','kid · 9','pink'],['J','Jay','kid · 7','green'],['S','Sam','kid · 5','warm']].map((m,i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'14px', gap:14 }}>
          <Avatar initial={m[0]} tone={m[3]} size="xl"/>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:18 }}>{m[1]}</div>
            <Note style={{ fontSize:12 }}>{m[2]}</Note>
            {!m[2].startsWith('parent') && <ProgressBar pct={50+i*8}/>}
          </div>
          <span>›</span>
        </div>
      ))}
    </div>
  </div>
);

// F2 — Big avatar grid (kid-pickable)
const F2Phone = () => (
  <div style={{ padding:'12px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-headline" style={{ fontSize:22, textAlign:'center' }}>Who's that?</div>
    <Note style={{ textAlign:'center' }}>tap your face</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:14, marginTop:18, flex:1 }}>
      {[['M','Mom','blue'],['D','Dad','warm'],['E','Emma','pink'],['J','Jay','green']].map((m,i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'14px 8px', textAlign:'center' }}>
          <Avatar initial={m[0]} tone={m[2]} size="xl"/>
          <div style={{ fontFamily:'Caveat, cursive', fontSize:22, marginTop:6 }}>{m[1]}</div>
        </div>
      ))}
    </div>
  </div>
);
const F2Tablet = () => (
  <div style={{ padding:'30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:38, textAlign:'center' }}>Pick your name</div>
    <Note style={{ fontSize:16, textAlign:'center' }}>this is the launch screen on a shared iPad</Note>
    <div style={{ display:'grid', gridTemplateColumns:'repeat(5, 1fr)', gap:14, marginTop:24 }}>
      {[['M','Mom','blue'],['D','Dad','warm'],['E','Emma','pink'],['J','Jay','green'],['S','Sam','warm']].map((m,i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'18px 8px', textAlign:'center' }}>
          <Avatar initial={m[0]} tone={m[2]} size="xl" style={{ width:64, height:64 }}/>
          <div style={{ fontFamily:'Caveat, cursive', fontSize:24, marginTop:8 }}>{m[1]}</div>
          {i<2 && <Note style={{ fontSize:11 }}>🔒 PIN</Note>}
        </div>
      ))}
    </div>
  </div>
);

// F3 — Member detail (selected)
const F3Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div style={{ fontSize:14 }}>← family</div>
    <div style={{ display:'flex', alignItems:'center', gap:12, marginTop:10 }}>
      <Avatar initial="E" tone="pink" size="xl"/>
      <div>
        <div className="wf-headline" style={{ fontSize:24 }}>Emma</div>
        <Note>kid · age 9 · since Jan</Note>
      </div>
    </div>
    <div className="wf-row" style={{ gap:8, marginTop:10 }}>
      <div className="wf-stroke" style={{ flex:1, padding:'8px', textAlign:'center' }}><div style={{ fontSize:18 }}>⭐ 24</div><Note style={{ fontSize:10 }}>this wk</Note></div>
      <div className="wf-stroke" style={{ flex:1, padding:'8px', textAlign:'center' }}><div style={{ fontSize:18 }}>🔥 4</div><Note style={{ fontSize:10 }}>streak</Note></div>
      <div className="wf-stroke" style={{ flex:1, padding:'8px', textAlign:'center' }}><div style={{ fontSize:18 }}>🏅 4</div><Note style={{ fontSize:10 }}>badges</Note></div>
    </div>
    <Section label="Today" style={{ marginTop:10 }}>
      <TaskRow title="Clean room" density="compact" done/>
      <TaskRow title="Homework" density="compact"/>
    </Section>
  </div>
);
const F3Tablet = () => (
  <div className="wf-split">
    <div className="left">
      {[['M','Mom','blue'],['E','Emma','pink',true],['J','Jay','green'],['S','Sam','warm']].map((m,i)=>(
        <div key={i} className="wf-row" style={{ padding:'6px 8px', background:m[3]?'#fff':'transparent', border:m[3]?'1.4px solid var(--ink)':'none', borderRadius:8 }}>
          <Avatar initial={m[0]} tone={m[2]}/><div style={{ fontSize:13 }}>{m[1]}</div>
        </div>
      ))}
    </div>
    <div className="right">
      <div className="wf-row" style={{ gap:10 }}>
        <Avatar initial="E" tone="pink" size="xl"/>
        <div>
          <div className="wf-headline" style={{ fontSize:30 }}>Emma</div>
          <Note>kid · age 9</Note>
        </div>
      </div>
      <div className="wf-row" style={{ gap:8 }}>
        <Pill>⭐ 24 this wk</Pill><Pill>🔥 4-day streak</Pill><Pill>🏅 4 badges</Pill>
      </div>
      <Section label="This week"><ProgressBar pct={68} color="var(--done)"/><Note>17 of 25 done</Note></Section>
    </div>
  </div>
);

// F4 — Permissions & PIN setup
const F4Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Permissions</div>
    <Note>parents only</Note>
    <Section label="Mom · Parent" style={{ marginTop:10 }}>
      <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:12 }}>can: assign · approve · edit · delete</div>
    </Section>
    <Section label="Emma · Kid">
      <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:12 }}>can: complete · send proof</div>
    </Section>
    <Section label="Parent PIN">
      <div className="wf-row" style={{ gap:6 }}>{[1,2,3,4].map(i=> <div key={i} className="wf-stroke" style={{ width:36, height:36, display:'flex', alignItems:'center', justifyContent:'center', fontSize:18 }}>•</div>)}</div>
    </Section>
  </div>
);
const F4Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Permissions & PIN</div>
    <Note style={{ fontSize:14 }}>kids can't change these</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:16, marginTop:14 }}>
      <div className="wf-stroke" style={{ padding:'14px' }}>
        <Note style={{ fontSize:12 }}>ROLES</Note>
        {[['Mom','parent',true],['Dad','parent',true],['Emma','kid',false],['Jay','kid',false]].map((r,i)=>(
          <div key={i} className="wf-row" style={{ padding:'6px 0', borderBottom:'1px dashed var(--ink-soft)' }}>
            <div style={{ flex:1, fontSize:14 }}>{r[0]}</div>
            <Pill tone={r[2]?'solid':''}>{r[1]}</Pill>
          </div>
        ))}
      </div>
      <div className="wf-stroke" style={{ padding:'14px' }}>
        <Note style={{ fontSize:12 }}>PARENT PIN</Note>
        <div className="wf-row" style={{ gap:8, marginTop:8 }}>
          {[1,2,3,4].map(i=> <div key={i} className="wf-stroke" style={{ width:50, height:50, display:'flex', alignItems:'center', justifyContent:'center', fontSize:26 }}>•</div>)}
        </div>
        <Note style={{ fontSize:11, marginTop:6 }}>asked when entering parent mode</Note>
      </div>
    </div>
  </div>
);

// F5 — Family tree / circle layout
const F5Phone = () => (
  <div style={{ padding:'14px', height:'100%', position:'relative' }}>
    <div className="wf-headline" style={{ fontSize:22, textAlign:'center' }}>Browns Family</div>
    <Note style={{ textAlign:'center' }}>tap a face</Note>
    <div style={{ position:'relative', height:280, marginTop:14 }}>
      <Avatar initial="🏠" tone="warm" size="xl" style={{ position:'absolute', left:'50%', top:'50%', transform:'translate(-50%,-50%)', width:54, height:54 }}/>
      {[
        ['M','blue', 50, 14],
        ['D','warm', 50, 80],
        ['E','pink', 14, 38],
        ['J','green', 86, 38],
        ['S','warm', 50, 50, true],
      ].map((m,i)=> i<4 && (
        <div key={i} style={{ position:'absolute', left:`${m[2]}%`, top:`${m[3]}%`, transform:'translate(-50%,-50%)' }}>
          <Avatar initial={m[0]} tone={m[1]} size="lg"/>
        </div>
      ))}
    </div>
  </div>
);
const F5Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32, textAlign:'center' }}>Family circle</div>
    <Note style={{ fontSize:14, textAlign:'center' }}>roles & relationships at a glance</Note>
    <div style={{ position:'relative', height:340, marginTop:14 }}>
      <div style={{ position:'absolute', left:'50%', top:'50%', transform:'translate(-50%,-50%)', textAlign:'center' }}>
        <Avatar initial="🏠" tone="warm" size="xl" style={{ width:80, height:80 }}/>
        <div style={{ fontFamily:'Caveat, cursive', fontSize:22, marginTop:4 }}>The Browns</div>
      </div>
      {[
        ['M','Mom','blue', 30, 18],
        ['D','Dad','warm', 70, 18],
        ['E','Emma','pink', 12, 60],
        ['J','Jay','green', 50, 84],
        ['S','Sam','warm', 88, 60],
      ].map((m,i)=>(
        <div key={i} style={{ position:'absolute', left:`${m[3]}%`, top:`${m[4]}%`, transform:'translate(-50%,-50%)', textAlign:'center' }}>
          <Avatar initial={m[0]} tone={m[2]} size="xl"/>
          <Note style={{ fontSize:13, marginTop:2 }}>{m[1]}</Note>
        </div>
      ))}
    </div>
  </div>
);

// F6 — Side-bar navigation with member shortcuts
const F6Phone = () => (
  <div style={{ padding:'10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:20 }}>Switch person</div>
    <Note>tap to log in</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:6 }}>
      {[['M','Mom','• in use','blue'],['D','Dad','tap to switch','warm'],['E','Emma','3 tasks waiting','pink'],['J','Jay','all done ✨','green']].map((m,i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'10px 12px', gap:10, background:i===0?'#EEF7EE':'var(--paper)' }}>
          <Avatar initial={m[0]} tone={m[3]} size="lg"/>
          <div style={{ flex:1 }}><div style={{ fontSize:14 }}>{m[1]}</div><Note style={{ fontSize:11 }}>{m[2]}</Note></div>
          {i===0 ? <span>•</span> : <span>›</span>}
        </div>
      ))}
    </div>
  </div>
);
const F6Tablet = () => (
  <div style={{ padding:'30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:34, textAlign:'center' }}>Who's using the iPad?</div>
    <Note style={{ fontSize:14, textAlign:'center' }}>shared device · pick a profile</Note>
    <div style={{ display:'grid', gridTemplateColumns:'repeat(4, 1fr)', gap:14, marginTop:24 }}>
      {[['M','Mom','blue'],['D','Dad','warm'],['E','Emma','pink'],['J','Jay','green']].map((m,i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'20px 10px', textAlign:'center' }}>
          <Avatar initial={m[0]} tone={m[2]} size="xl" style={{ width:78, height:78 }}/>
          <div style={{ fontFamily:'Caveat, cursive', fontSize:24, marginTop:8 }}>{m[1]}</div>
          {i<2 && <Note style={{ fontSize:11 }}>🔒 PIN</Note>}
          {i>=2 && <Note style={{ fontSize:11 }}>3 tasks</Note>}
        </div>
      ))}
    </div>
    <Note style={{ marginTop:18, textAlign:'center' }}>auto-locks after 5 min idle</Note>
  </div>
);

window.FamilyVariations = [
  { id:'f1', label:'F1 · Member list', cap:'Member list', sub:'classic · roles & progress', P:F1Phone, T:F1Tablet },
  { id:'f2', label:'F2 · Avatar grid', cap:'Avatar picker grid', sub:'shared-device launch screen', P:F2Phone, T:F2Tablet },
  { id:'f3', label:'F3 · Member detail', cap:'Member detail', sub:'one-kid deep dive', P:F3Phone, T:F3Tablet },
  { id:'f4', label:'F4 · Permissions', cap:'Permissions & PIN', sub:'parent-only · gates kids', P:F4Phone, T:F4Tablet },
  { id:'f5', label:'F5 · Family circle', cap:'Family circle', sub:'spatial · novel · iPad-friendly', P:F5Phone, T:F5Tablet },
  { id:'f6', label:'F6 · Profile switch', cap:'Profile switcher', sub:'shared iPad · contextual hints', P:F6Phone, T:F6Tablet },
];

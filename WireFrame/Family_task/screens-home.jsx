// screens-home.jsx — 6 home variations. Each shows Parent view on Phone and Child view on Tablet (or vice-versa).

const HomeHero = ({ name='Alex', wave='👋' }) => (
  <>
    <div className="wf-headline" style={{ fontSize:24 }}>Good morning, {name} {wave}</div>
    <Note>3 tasks today</Note>
  </>
);

// ── 1. Classic list — parent (phone) vs child (tablet)
const Home1Parent = () => (
  <div style={{ padding:'12px 12px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}>
      <div className="wf-headline" style={{ fontSize:22 }}>The Browns</div>
      <Avatar initial="M" tone="blue"/>
    </div>
    <Note>parent view</Note>
    <Section label="Today" style={{ marginTop:10 }}>
      <TaskRow title="Clean room" who={<Avatar initial="E" tone="pink"/>} done/>
      <TaskRow title="Feed cat" who={<Avatar initial="J" tone="green"/>}/>
      <TaskRow title="Homework" who={<Avatar initial="E" tone="pink"/>}/>
    </Section>
    <Section label="By Kid">
      <div className="wf-row" style={{ gap:6, flexWrap:'wrap' }}>
        <Pill tone="done">Emma 2/3</Pill>
        <Pill>Jay 0/2</Pill>
      </div>
    </Section>
    <Btn primary full style={{ marginTop:12 }}>+ assign task</Btn>
  </div>
);

const Home1Child = () => (
  <div style={{ padding:'18px 22px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}>
      <HomeHero name="Emma"/>
      <Avatar initial="E" tone="pink" size="lg"/>
    </div>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'1fr 1fr', gap:12 }}>
      <TaskRowBig title="Clean room" meta="due today" who={<Star3 count={2}/>} done/>
      <TaskRowBig title="Feed the cat" meta="due 6pm" who={<Star3 count={1}/>}/>
      <TaskRowBig title="Homework" meta="anytime" who={<Star3 count={2}/>}/>
      <div className="wf-stroke-dashed" style={{ padding:'18px 12px', textAlign:'center', fontSize:12, color:'var(--ink-faint)' }}>
        all done? you'll see a 🌟
      </div>
    </div>
    <Note style={{ marginTop:14 }}>kid view: big tap targets, stars on every row</Note>
  </div>
);

// ── 2. Card grid — chunky tappable
const Home2Parent = () => (
  <div style={{ padding:'12px 10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Family</div>
    <Note>tap a kid to see their list</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:8, marginTop:10 }}>
      {[['Emma','pink',2,3],['Jay','green',0,2],['Sam','warm',1,1],['+',null]].map((k,i)=>k[0]==='+'?(
        <div key="add" className="wf-stroke-dashed" style={{ padding:'18px 10px', textAlign:'center', fontSize:13 }}>+ add kid</div>
      ):(
        <div key={i} className="wf-stroke" style={{ padding:'10px 10px', display:'flex', flexDirection:'column', alignItems:'center', gap:4 }}>
          <Avatar initial={k[0][0]} tone={k[1]} size="lg"/>
          <div style={{ fontSize:13 }}>{k[0]}</div>
          <ProgressBar pct={(k[2]/k[3])*100}/>
          <Note style={{ fontSize:11 }}>{k[2]}/{k[3]} done</Note>
        </div>
      ))}
    </div>
  </div>
);
const Home2Child = () => (
  <div style={{ padding:'18px 20px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Hi Jay! 👋</div>
    <Note style={{ fontSize:16 }}>tap a card to do it</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:14, marginTop:14 }}>
      {[
        ['Feed cat','🐱','#FFE7B5'],
        ['Make bed','🛏️','#D6F0E5'],
        ['Brush teeth','🪥','#E5DCFF'],
        ['Read 10 min','📖','#FFD7E5'],
      ].map(([t,e,c],i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'18px 12px', background:c, display:'flex', flexDirection:'column', alignItems:'center', gap:6, minHeight:90 }}>
          <span style={{ fontSize:30 }}>{e}</span>
          <div style={{ fontSize:14, fontFamily:'Caveat, cursive', fontWeight:600 }}>{t}</div>
        </div>
      ))}
    </div>
    <Note style={{ marginTop:12, fontSize:13 }}>big colorful cards · easy for ages 5–8</Note>
  </div>
);

// ── 3. Calendar / timeline view
const Home3Parent = () => (
  <div style={{ padding:'12px 10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>This week</div>
    <div className="wf-row" style={{ gap:4, marginTop:10 }}>
      {['M','T','W','T','F','S','S'].map((d,i)=>(
        <div key={i} className="wf-stroke-thin" style={{ flex:1, textAlign:'center', padding:'4px 0', background:i===2?'var(--accent)':'transparent', color:i===2?'#fff':'inherit', fontSize:11 }}>{d}</div>
      ))}
    </div>
    <Section label="Wed · Today" style={{ marginTop:10 }}>
      <TaskRow title="9am · Pack lunch" who={<Avatar initial="E"/>}/>
      <TaskRow title="4pm · Walk dog" who={<Avatar initial="J"/>} done/>
      <TaskRow title="7pm · Dishes" who={<Avatar initial="E"/>}/>
    </Section>
    <Section label="Thu · Tomorrow">
      <TaskRow title="Tidy room" who={<Avatar initial="J"/>}/>
    </Section>
  </div>
);
const Home3Child = () => (
  <div style={{ padding:'18px 20px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>Today, Wed</div>
    <Note style={{ fontSize:14 }}>your day, hour by hour</Note>
    <div style={{ marginTop:14, display:'flex', flexDirection:'column', gap:8 }}>
      {[['9am','Pack lunch',true],['4pm','Walk the dog',true],['7pm','Dishes',false]].map(([t,n,d],i)=>(
        <div key={i} className="wf-row" style={{ gap:14 }}>
          <Note style={{ width:50, fontSize:14 }}>{t}</Note>
          <div className="wf-stroke" style={{ flex:1, padding:'10px 14px', display:'flex', alignItems:'center', gap:10, background: d?'#EEF7EE':'var(--paper)' }}>
            <Check on={d}/>
            <span style={{ fontSize:15 }}>{n}</span>
          </div>
        </div>
      ))}
    </div>
  </div>
);

// ── 4. Notion-style dense doc
const Home4Parent = () => (
  <div style={{ padding:'10px 10px', height:'100%' }}>
    <Note style={{ fontSize:11, color:'var(--ink-faint)' }}>👨‍👩‍👧‍👦 The Browns / Today</Note>
    <div className="wf-headline" style={{ fontSize:24, marginTop:4 }}>Wed, Mar 12</div>
    <div className="wf-section-label" style={{ marginTop:10, marginBottom:4 }}>H2 · Today</div>
    <TaskRow title="Clean room" who={<Avatar initial="E"/>} density="compact" done/>
    <TaskRow title="Feed cat" who={<Avatar initial="J"/>} density="compact"/>
    <TaskRow title="Math homework" who={<Avatar initial="E"/>} density="compact"/>
    <div className="wf-section-label" style={{ marginTop:10, marginBottom:4 }}>H2 · Done</div>
    <TaskRow title="Water plants" who={<Avatar initial="J"/>} density="compact" done/>
    <Note style={{ fontSize:11, marginTop:10, color:'var(--ink-faint)' }}>+ slash command…</Note>
  </div>
);
const Home4Child = () => (
  <div style={{ padding:'14px 16px', height:'100%' }}>
    <Note style={{ fontSize:12, color:'var(--ink-faint)' }}>📓 my page</Note>
    <div className="wf-headline" style={{ fontSize:30, marginTop:4 }}>Hi, Emma</div>
    <div style={{ marginTop:8 }}>
      <div className="wf-section-label" style={{ marginBottom:6 }}>To do</div>
      <TaskRow title="Clean room" density="compact"/>
      <TaskRow title="Feed cat" density="compact"/>
      <TaskRow title="Math homework" density="compact"/>
      <div className="wf-section-label" style={{ marginTop:14, marginBottom:6 }}>Done</div>
      <TaskRow title="Water plants" density="compact" done/>
      <TaskRow title="Brush teeth" density="compact" done/>
    </div>
    <Note style={{ fontSize:13, marginTop:14, color:'var(--ink-soft)' }}>looks like a Notion doc · airy & calm</Note>
  </div>
);

// ── 5. Big-cards "Today" focus (one task at a time, swipe)
const Home5Parent = () => (
  <div style={{ padding:'12px 10px', height:'100%' }}>
    <Note>parent dashboard · focus on one</Note>
    <div className="wf-stroke" style={{ padding:'14px 12px', marginTop:10, background:'#FFF6BD' }}>
      <Note style={{ fontSize:11, color:'var(--ink-soft)' }}>NEEDS REVIEW</Note>
      <div style={{ fontSize:15, marginTop:4 }}>Emma finished "Clean room"</div>
      <div className="wf-row" style={{ marginTop:8, gap:6 }}>
        <Btn>👀 see proof</Btn><Btn primary>✓ approve</Btn>
      </div>
    </div>
    <div className="wf-section-label" style={{ marginTop:14, marginBottom:6 }}>In progress</div>
    <TaskRow title="Feed cat · Jay" density="compact"/>
    <TaskRow title="Homework · Emma" density="compact"/>
  </div>
);
const Home5Child = () => (
  <div style={{ padding:'24px 30px', height:'100%', display:'flex', flexDirection:'column' }}>
    <Note style={{ textAlign:'center', fontSize:14 }}>your next thing</Note>
    <div style={{ flex:1, display:'flex', alignItems:'center', justifyContent:'center' }}>
      <div className="wf-stroke" style={{ padding:'24px 20px', width:'100%', textAlign:'center', background:'#FFF6BD' }}>
        <div style={{ fontSize:54 }}>🐱</div>
        <div className="wf-headline" style={{ fontSize:32, marginTop:6 }}>Feed the cat</div>
        <Note style={{ fontSize:14, marginTop:6 }}>by 6:00pm · 1 ⭐</Note>
        <Btn primary full style={{ marginTop:14 }}>I did it!</Btn>
      </div>
    </div>
    <div className="wf-row" style={{ justifyContent:'center', gap:6 }}>
      <span className="wf-dot fill-blue"></span><span className="wf-dot"></span><span className="wf-dot"></span>
    </div>
    <Note style={{ textAlign:'center', fontSize:11, marginTop:6 }}>swipe for next →</Note>
  </div>
);

// ── 6. Split-panel iPad-native (sidebar + detail)
const Home6Parent = () => (
  <div style={{ padding:'12px 10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>The Browns</div>
    <Note>phone-only stack of widgets</Note>
    <div className="wf-stroke" style={{ padding:'8px 10px', marginTop:8 }}>
      <Note style={{ fontSize:10, color:'var(--ink-soft)' }}>WIDGET · today's progress</Note>
      <ProgressBar pct={66}/>
      <Note style={{ fontSize:11 }}>3 of 5 done</Note>
    </div>
    <div className="wf-stroke" style={{ padding:'8px 10px', marginTop:8 }}>
      <Note style={{ fontSize:10, color:'var(--ink-soft)' }}>WIDGET · pending review</Note>
      <Pill tone="warn">2 to approve</Pill>
    </div>
    <div className="wf-stroke" style={{ padding:'8px 10px', marginTop:8 }}>
      <Note style={{ fontSize:10, color:'var(--ink-soft)' }}>WIDGET · streak</Note>
      <div style={{ fontSize:18 }}>🔥 4 days</div>
    </div>
  </div>
);
const Home6Child = () => (
  <div className="wf-split">
    <div className="left">
      <Avatar initial="E" tone="pink" size="lg"/>
      <Note style={{ fontSize:14 }}>Emma</Note>
      <hr className="wf-divider"/>
      <Note style={{ fontSize:11 }}>📋 Today (3)</Note>
      <Note style={{ fontSize:11, color:'var(--ink-faint)' }}>📅 Tomorrow</Note>
      <Note style={{ fontSize:11, color:'var(--ink-faint)' }}>⭐ My stars</Note>
      <Note style={{ fontSize:11, color:'var(--ink-faint)' }}>📜 History</Note>
    </div>
    <div className="right">
      <div className="wf-headline" style={{ fontSize:26 }}>Today</div>
      <TaskRowBig title="Clean room" meta="due now" who={<Star3 count={2}/>} done/>
      <TaskRowBig title="Feed cat" meta="6pm" who={<Star3 count={1}/>}/>
      <TaskRowBig title="Homework" who={<Star3 count={2}/>}/>
    </div>
  </div>
);

window.HomeVariations = [
  { id:'h1', label:'H1 · Classic list', cap:'Classic list', sub:'parent: by-kid roll-up · child: card grid', P:Home1Parent, T:Home1Child },
  { id:'h2', label:'H2 · Family cards', cap:'Family card grid', sub:'parent: kid tiles · child: chunky icon cards', P:Home2Parent, T:Home2Child },
  { id:'h3', label:'H3 · Timeline', cap:'Timeline / day plan', sub:'time-anchored · helps routines', P:Home3Parent, T:Home3Child },
  { id:'h4', label:'H4 · Notion doc', cap:'Notion-style doc', sub:'dense · airy · type-led', P:Home4Parent, T:Home4Child },
  { id:'h5', label:'H5 · One thing', cap:'One thing at a time', sub:'kid: full-screen card · parent: review feed', P:Home5Parent, T:Home5Child },
  { id:'h6', label:'H6 · Split / widgets', cap:'Split · widgets', sub:'phone widgets · iPad sidebar', P:Home6Parent, T:Home6Child },
];

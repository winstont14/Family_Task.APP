// screens-tasks.jsx — Add task (parent), Task detail (child), Parent review (parent)

// ═══════════════════════════════════════════════════════════════════
// ADD TASK · 6 variations
// ═══════════════════════════════════════════════════════════════════

// A1 — sheet / bottom modal
const Add1Phone = () => (
  <div style={{ padding:'10px 10px', height:'100%', position:'relative' }}>
    <div style={{ opacity:.25 }}>
      <div className="wf-headline" style={{ fontSize:20 }}>Today</div>
      <TaskRow title="Feed cat"/>
      <TaskRow title="Homework" done/>
    </div>
    <div className="wf-stroke" style={{ position:'absolute', bottom:0, left:8, right:8, padding:'14px 12px', borderRadius:'14px 14px 0 0', background:'var(--paper)', boxShadow:'0 -4px 0 rgba(0,0,0,.05)' }}>
      <div style={{ width:30, height:3, background:'var(--ink-faint)', borderRadius:2, margin:'0 auto 10px' }}></div>
      <Note style={{ fontSize:11 }}>NEW TASK</Note>
      <div className="wf-stroke-thin" style={{ padding:'6px 10px', fontSize:13, marginTop:6 }}>Wash the dishes</div>
      <div className="wf-row" style={{ marginTop:8, gap:6, flexWrap:'wrap' }}>
        <Pill>👤 Emma</Pill><Pill>📅 Today</Pill><Pill>⭐ 1 star</Pill>
      </div>
      <Btn primary full style={{ marginTop:8 }}>Add</Btn>
    </div>
  </div>
);
const Add1Tablet = () => (
  <div style={{ padding:'14px', height:'100%', position:'relative' }}>
    <div style={{ opacity:.25 }}>
      <div className="wf-headline" style={{ fontSize:24 }}>The Browns · Today</div>
      <TaskRowBig title="Clean room" who={<Avatar initial="E"/>}/>
      <TaskRowBig title="Feed cat" who={<Avatar initial="J"/>}/>
    </div>
    <div className="wf-stroke" style={{ position:'absolute', bottom:14, right:14, width:300, padding:'16px 14px', background:'var(--paper)' }}>
      <div className="wf-row" style={{ justifyContent:'space-between' }}>
        <Note style={{ fontSize:12 }}>NEW TASK</Note><span style={{ fontSize:14 }}>×</span>
      </div>
      <div className="wf-stroke-thin" style={{ padding:'10px 12px', fontSize:14, marginTop:8 }}>Wash the dishes</div>
      <div className="wf-row" style={{ marginTop:8, gap:6, flexWrap:'wrap' }}>
        <Pill>👤 Emma</Pill><Pill>📅 Today</Pill><Pill>⭐ 1</Pill>
      </div>
      <Btn primary full style={{ marginTop:10 }}>Add</Btn>
    </div>
  </div>
);

// A2 — full-screen form
const Add2Phone = () => (
  <div style={{ padding:'14px 14px', height:'100%' }}>
    <div className="wf-row" style={{ justifyContent:'space-between' }}><span style={{ fontSize:14 }}>← cancel</span><Btn primary>Save</Btn></div>
    <div className="wf-headline" style={{ fontSize:22, marginTop:10 }}>New task</div>
    <Section label="Title">
      <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:13 }}>Take out trash</div>
    </Section>
    <Section label="Assign to">
      <div className="wf-row" style={{ gap:6 }}><Avatar initial="E" tone="pink"/><Avatar initial="J" tone="green"/><Avatar initial="+" tone="warm"/></div>
    </Section>
    <Section label="When">
      <div className="wf-row" style={{ gap:6, flexWrap:'wrap' }}><Pill>Today</Pill><Pill>Tomorrow</Pill><Pill>Pick…</Pill></div>
    </Section>
    <Section label="Stars">
      <div className="wf-row" style={{ gap:8 }}><Star/><Star/><Star filled={false}/></div>
    </Section>
  </div>
);
const Add2Tablet = () => (
  <div style={{ padding:'24px 30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>New task</div>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:20, marginTop:14 }}>
      <Section label="Title"><div className="wf-stroke" style={{ padding:'12px', fontSize:15 }}>Take out trash</div></Section>
      <Section label="Notes"><div className="wf-stroke-dashed" style={{ padding:'12px', fontSize:13, color:'var(--ink-faint)' }}>optional…</div></Section>
      <Section label="Assign to">
        <div className="wf-row" style={{ gap:8 }}><Avatar initial="E" tone="pink" size="lg"/><Avatar initial="J" tone="green" size="lg"/></div>
      </Section>
      <Section label="When"><div className="wf-row" style={{ gap:6 }}><Pill>Today</Pill><Pill>Tomorrow</Pill><Pill>Pick…</Pill></div></Section>
      <Section label="Stars"><div className="wf-row" style={{ gap:6 }}><Star/><Star/><Star filled={false}/></div></Section>
      <Section label="Repeat"><Pill>None</Pill></Section>
    </div>
    <div style={{ display:'flex', gap:8, justifyContent:'flex-end', marginTop:16 }}><Btn>Cancel</Btn><Btn primary>Save task</Btn></div>
  </div>
);

// A3 — quick-add inline (Notion-style)
const Add3Phone = () => (
  <div style={{ padding:'10px 10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:20 }}>Today</div>
    <TaskRow title="Clean room" who={<Avatar initial="E"/>} density="compact" done/>
    <TaskRow title="Feed cat" who={<Avatar initial="J"/>} density="compact"/>
    <div className="wf-row" style={{ gap:8, padding:'6px 0', borderBottom:'1.4px solid var(--accent)', background:'#f1f5ff' }}>
      <Check on={false}/>
      <span style={{ fontSize:13, color:'var(--ink-soft)' }}>type a task…</span>
    </div>
    <Note style={{ fontSize:11, marginTop:6 }}>↑ ↓ to pick · @ to assign · ! for stars</Note>
  </div>
);
const Add3Tablet = () => (
  <div style={{ padding:'18px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:26 }}>Today's list</div>
    <div style={{ marginTop:10 }}>
      <TaskRow title="Clean room" who={<Avatar initial="E"/>} done/>
      <TaskRow title="Feed cat" who={<Avatar initial="J"/>}/>
      <div className="wf-row" style={{ gap:8, padding:'8px 6px', background:'#f1f5ff', borderLeft:'3px solid var(--accent)' }}>
        <Check on={false}/>
        <span style={{ fontSize:14 }}>Wash dishes</span>
        <Pill>@Emma</Pill><Pill>!1</Pill>
        <span style={{ fontSize:11, color:'var(--ink-faint)', marginLeft:'auto' }}>↵ to add</span>
      </div>
    </div>
    <Note style={{ fontSize:13, marginTop:14 }}>type-to-add · zero modals · keyboard friendly</Note>
  </div>
);

// A4 — template chips first
const Add4Phone = () => (
  <div style={{ padding:'12px 12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:20 }}>Quick add</div>
    <Note>tap a chore</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:6, marginTop:10 }}>
      {['🛏️ Make bed','🪥 Brush teeth','🐱 Feed cat','🚮 Take trash','📚 Read 10m','🍽️ Do dishes'].map((t,i)=>(
        <div key={i} className="wf-stroke-thin" style={{ padding:'8px 8px', fontSize:12, textAlign:'center' }}>{t}</div>
      ))}
    </div>
    <Note style={{ marginTop:12, fontSize:11 }}>or…</Note>
    <Btn full>+ custom task</Btn>
  </div>
);
const Add4Tablet = () => (
  <div style={{ padding:'24px 30px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Quick add</div>
    <Note style={{ fontSize:14 }}>tap a template, pick who, done</Note>
    <div style={{ display:'grid', gridTemplateColumns:'repeat(4, 1fr)', gap:10, marginTop:14 }}>
      {['🛏️ Bed','🪥 Teeth','🐱 Cat','🚮 Trash','📚 Read','🍽️ Dishes','🌱 Plants','🎒 Pack bag'].map((t,i)=>(
        <div key={i} className="wf-stroke-thin" style={{ padding:'14px 8px', fontSize:14, textAlign:'center' }}>{t}</div>
      ))}
    </div>
    <Section label="Assign to" style={{ marginTop:18 }}>
      <div className="wf-row" style={{ gap:8 }}>
        <Avatar initial="E" tone="pink" size="lg"/><Avatar initial="J" tone="green" size="lg"/><Pill>everyone</Pill>
      </div>
    </Section>
  </div>
);

// A5 — voice / single field
const Add5Phone = () => (
  <div style={{ padding:'14px 12px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Add a task</div>
    <Note>just say or type it</Note>
    <div className="wf-stroke" style={{ padding:'14px', marginTop:14, fontSize:14 }}>
      "<span style={{ fontFamily:'Caveat, cursive', fontSize:18 }}>Emma feed the cat by 6 pm</span>"
    </div>
    <div className="wf-row" style={{ gap:6, marginTop:8, flexWrap:'wrap' }}>
      <Pill tone="solid">Emma</Pill><Pill tone="solid">feed cat</Pill><Pill tone="solid">6pm today</Pill>
    </div>
    <Note style={{ fontSize:11, marginTop:6 }}>auto-parsed</Note>
    <div style={{ flex:1 }}/>
    <div className="wf-row" style={{ gap:8 }}>
      <Btn full>edit</Btn><Btn primary full>add 🎤</Btn>
    </div>
  </div>
);
const Add5Tablet = () => (
  <div style={{ padding:'30px 36px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-headline" style={{ fontSize:36 }}>Just say it.</div>
    <div className="wf-stroke" style={{ padding:'18px', marginTop:14, fontSize:18, fontFamily:'Caveat, cursive' }}>
      "Emma, feed the cat by 6 pm. Worth 1 star."
    </div>
    <div className="wf-row" style={{ gap:8, marginTop:12, flexWrap:'wrap' }}>
      <Pill tone="solid">👤 Emma</Pill><Pill tone="solid">🐱 feed cat</Pill><Pill tone="solid">⏰ 6pm</Pill><Pill tone="solid">⭐ 1</Pill>
    </div>
    <div style={{ flex:1 }}/>
    <div style={{ display:'flex', justifyContent:'center' }}>
      <div className="wf-btn fab" style={{ width:80, height:80, fontSize:32 }}>🎤</div>
    </div>
  </div>
);

// A6 — drag from library to kid columns (iPad-native)
const Add6Phone = () => (
  <div style={{ padding:'12px 10px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:20 }}>Library</div>
    <Note>tap & drag onto a kid →</Note>
    <div className="wf-stroke-thin" style={{ padding:'8px 10px', marginTop:8, fontSize:13, transform:'rotate(-2deg)', boxShadow:'2px 3px 0 rgba(0,0,0,.08)' }}>
      🪥 Brush teeth · 1⭐
    </div>
    <Note style={{ fontSize:11, color:'var(--ink-faint)', marginTop:6 }}>(phone version: tap to assign instead)</Note>
    <hr className="wf-divider"/>
    <div className="wf-row" style={{ gap:8 }}>
      <div className="wf-stroke-dashed" style={{ flex:1, padding:'10px', textAlign:'center', fontSize:12 }}>Emma drop-zone</div>
      <div className="wf-stroke-dashed" style={{ flex:1, padding:'10px', textAlign:'center', fontSize:12 }}>Jay drop-zone</div>
    </div>
  </div>
);
const Add6Tablet = () => (
  <div style={{ padding:'14px', height:'100%', display:'flex', gap:10 }}>
    <div style={{ width:120 }}>
      <Note style={{ fontSize:11, color:'var(--ink-soft)' }}>LIBRARY</Note>
      {['🪥 Teeth','🛏️ Bed','🐱 Cat','📚 Read','🚮 Trash'].map((t,i)=>(
        <div key={i} className="wf-stroke-thin" style={{ padding:'6px 8px', fontSize:11, marginTop:4, transform:`rotate(${(i%2?-1:1.5)}deg)` }}>{t}</div>
      ))}
    </div>
    <div className="wf-stroke-dashed" style={{ flex:1, padding:'10px', display:'flex', flexDirection:'column' }}>
      <div className="wf-row"><Avatar initial="E" tone="pink"/><Note>Emma</Note></div>
      <Note style={{ fontSize:11, color:'var(--ink-faint)', textAlign:'center', flex:1, paddingTop:30 }}>drop tasks here</Note>
    </div>
    <div className="wf-stroke-dashed" style={{ flex:1, padding:'10px', display:'flex', flexDirection:'column' }}>
      <div className="wf-row"><Avatar initial="J" tone="green"/><Note>Jay</Note></div>
      <div className="wf-stroke-thin" style={{ padding:'6px 8px', fontSize:11, marginTop:6 }}>🐱 Feed cat</div>
    </div>
  </div>
);

window.AddTaskVariations = [
  { id:'a1', label:'A1 · Bottom sheet', cap:'Bottom sheet', sub:'fast · stays in context', P:Add1Phone, T:Add1Tablet },
  { id:'a2', label:'A2 · Full form', cap:'Full-screen form', sub:'every option visible · safe', P:Add2Phone, T:Add2Tablet },
  { id:'a3', label:'A3 · Inline', cap:'Inline (Notion)', sub:'type to add · keyboard-led', P:Add3Phone, T:Add3Tablet },
  { id:'a4', label:'A4 · Templates', cap:'Template chips', sub:'tap a chore · fastest for parents', P:Add4Phone, T:Add4Tablet },
  { id:'a5', label:'A5 · Voice', cap:'Voice / NL parse', sub:'natural language · novel', P:Add5Phone, T:Add5Tablet },
  { id:'a6', label:'A6 · Drag library', cap:'Drag library', sub:'iPad-native · drop on kid', P:Add6Phone, T:Add6Tablet },
];

// ═══════════════════════════════════════════════════════════════════
// TASK DETAIL · child completing · 6 variations
// ═══════════════════════════════════════════════════════════════════

// D1 — Big check + report
const Det1Phone = () => (
  <div style={{ padding:'14px 14px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div style={{ fontSize:14 }}>← back</div>
    <div className="wf-headline" style={{ fontSize:26, marginTop:8 }}>Feed the cat</div>
    <Note>by 6:00 pm · 1 ⭐</Note>
    <div className="wf-stroke" style={{ padding:'30px', marginTop:18, textAlign:'center' }}>
      <div style={{ fontSize:60 }}>🐱</div>
      <Note style={{ fontSize:13, marginTop:6 }}>tap when done</Note>
    </div>
    <div style={{ flex:1 }}/>
    <Btn primary full style={{ padding:'14px', fontSize:18 }}>✓ I did it!</Btn>
  </div>
);
const Det1Tablet = () => (
  <div style={{ padding:'30px 40px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:42 }}>Feed the cat</div>
    <Note style={{ fontSize:18 }}>by 6:00 pm · worth 1 ⭐</Note>
    <div style={{ display:'flex', gap:24, marginTop:20 }}>
      <div className="wf-stroke" style={{ flex:1, padding:'30px', textAlign:'center' }}>
        <div style={{ fontSize:80 }}>🐱</div>
      </div>
      <div style={{ flex:1, display:'flex', flexDirection:'column', gap:10 }}>
        <Section label="Add a note">
          <div className="wf-stroke-dashed" style={{ padding:'14px', fontSize:13 }}>"I gave her tuna" ✏️</div>
        </Section>
        <Section label="Photo proof">
          <Placeholder h={70}>tap to add photo</Placeholder>
        </Section>
        <div style={{ flex:1 }}/>
        <Btn primary full style={{ padding:'16px', fontSize:20 }}>✓ I did it!</Btn>
      </div>
    </div>
  </div>
);

// D2 — Step checklist (subtasks)
const Det2Phone = () => (
  <div style={{ padding:'12px 12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Clean room</div>
    <Note>3 small steps</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:6 }}>
      {[['Make bed',true],['Toys away',true],['Vacuum',false]].map(([n,d],i)=>(
        <div key={i} className="wf-stroke-thin wf-row" style={{ padding:'10px 12px', background: d?'#EEF7EE':'var(--paper)' }}>
          <Check on={d}/><span style={{ fontSize:14, textDecoration: d?'line-through':'none' }}>{n}</span>
        </div>
      ))}
    </div>
    <ProgressBar pct={66} color="var(--done)"/>
    <Note style={{ marginTop:6, fontSize:11 }}>2 of 3 · keep going!</Note>
  </div>
);
const Det2Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>Clean your room</div>
    <Note style={{ fontSize:14 }}>break it into small bites</Note>
    <ProgressBar pct={66} color="var(--done)"/>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
      {[['Make the bed',true],['Put away toys',true],['Vacuum the floor',false],['Open the curtains',false]].map(([n,d],i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'14px 14px', gap:10, background: d?'#EEF7EE':'var(--paper)' }}>
          <Check on={d}/><span style={{ fontSize:16 }}>{n}</span>
        </div>
      ))}
    </div>
  </div>
);

// D3 — Timer / pomodoro
const Det3Phone = () => (
  <div style={{ padding:'14px', height:'100%', display:'flex', flexDirection:'column', alignItems:'center' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Read 10 min</div>
    <div className="wf-stroke" style={{ width:140, height:140, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center', marginTop:18, position:'relative' }}>
      <div style={{ fontFamily:'Caveat, cursive', fontSize:42, fontWeight:600 }}>06:42</div>
    </div>
    <Note style={{ marginTop:8 }}>3:18 left</Note>
    <div className="wf-row" style={{ gap:10, marginTop:14 }}>
      <Btn>pause</Btn><Btn primary>I'm done</Btn>
    </div>
  </div>
);
const Det3Tablet = () => (
  <div style={{ padding:'30px', height:'100%', display:'flex', alignItems:'center', gap:30 }}>
    <div className="wf-stroke" style={{ width:200, height:200, borderRadius:'50%', display:'flex', alignItems:'center', justifyContent:'center' }}>
      <div style={{ fontFamily:'Caveat, cursive', fontSize:60, fontWeight:600 }}>06:42</div>
    </div>
    <div style={{ flex:1 }}>
      <div className="wf-headline" style={{ fontSize:36 }}>Read for 10 minutes</div>
      <Note style={{ fontSize:16 }}>3:18 to go · keep reading</Note>
      <div className="wf-row" style={{ gap:10, marginTop:14 }}><Btn>pause</Btn><Btn primary>I'm done</Btn></div>
    </div>
  </div>
);

// D4 — Photo-required completion
const Det4Phone = () => (
  <div style={{ padding:'12px 12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Tidy room</div>
    <Note>take a photo to finish</Note>
    <Placeholder h={180} style={{ marginTop:10 }}>📷 tap to capture</Placeholder>
    <div className="wf-row" style={{ marginTop:8, gap:6 }}>
      <Btn full>📷 camera</Btn><Btn full>🖼️ library</Btn>
    </div>
    <Btn primary full style={{ marginTop:8 }}>send to mom →</Btn>
  </div>
);
const Det4Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Tidy room — proof</div>
    <Note style={{ fontSize:14 }}>show mom what you did</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr 1fr', gap:8, marginTop:12 }}>
      <Placeholder h={130}>before</Placeholder>
      <Placeholder h={130}>after</Placeholder>
      <div className="wf-stroke-dashed" style={{ height:130, display:'flex', alignItems:'center', justifyContent:'center', fontSize:14 }}>+ extra</div>
    </div>
    <div style={{ display:'flex', gap:10, marginTop:14, justifyContent:'flex-end' }}>
      <Btn>save draft</Btn><Btn primary>send to parent →</Btn>
    </div>
  </div>
);

// D5 — Conversation / send report
const Det5Phone = () => (
  <div style={{ padding:'10px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-headline" style={{ fontSize:20 }}>Homework</div>
    <Note>tell mom what you did</Note>
    <div style={{ flex:1, marginTop:10, display:'flex', flexDirection:'column', gap:6 }}>
      <div className="wf-stroke-thin" style={{ padding:'7px 10px', fontSize:12, alignSelf:'flex-start', background:'#f0f4ff', maxWidth:'80%', borderRadius:'10px 10px 10px 2px' }}>I finished pages 14–18</div>
      <div className="wf-stroke-thin" style={{ padding:'7px 10px', fontSize:12, alignSelf:'flex-start', background:'#f0f4ff', maxWidth:'80%', borderRadius:'10px 10px 10px 2px' }}>question 3 was hard</div>
    </div>
    <div className="wf-stroke" style={{ padding:'8px 10px', fontSize:12, display:'flex' }}>
      <span style={{ flex:1, color:'var(--ink-faint)' }}>add a note…</span>
      <span>📷</span><span style={{ marginLeft:6 }}>↑</span>
    </div>
  </div>
);
const Det5Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Send report</div>
    <Note style={{ fontSize:14 }}>say what you did, optionally add a photo</Note>
    <div className="wf-stroke" style={{ padding:'14px', marginTop:14, fontSize:14, minHeight:90 }}>
      "I finished my math, the long division was tricky but I got pages 14-18 done."
    </div>
    <div className="wf-row" style={{ gap:8, marginTop:8 }}>
      <Pill>📷 photo</Pill><Pill>🎤 voice</Pill><Pill>😊 emoji</Pill>
    </div>
    <Btn primary style={{ marginTop:14, alignSelf:'flex-end' }}>send to mom →</Btn>
  </div>
);

// D6 — Game / celebrate animation
const Det6Phone = () => (
  <div style={{ padding:'14px', height:'100%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', textAlign:'center', background:'#FFF6BD' }}>
    <div style={{ fontSize:60 }}>🎉</div>
    <div className="wf-headline" style={{ fontSize:30, marginTop:6 }}>Nice work!</div>
    <Note style={{ fontSize:14 }}>+1 star earned</Note>
    <div className="wf-row" style={{ gap:6, marginTop:10 }}>
      {[1,2,3].map(i=> <Star key={i} filled={i<3}/>)}
    </div>
    <Note style={{ fontSize:12, marginTop:14 }}>2 more for a sticker pack</Note>
    <Btn primary full style={{ marginTop:14 }}>Next task →</Btn>
  </div>
);
const Det6Tablet = () => (
  <div style={{ padding:'30px', height:'100%', display:'flex', alignItems:'center', justifyContent:'center', textAlign:'center', background:'linear-gradient(180deg,#FFF6BD,#FFE7B5)' }}>
    <div>
      <div style={{ fontSize:80 }}>🌟</div>
      <div className="wf-headline" style={{ fontSize:42 }}>Awesome, Emma!</div>
      <Note style={{ fontSize:18, marginTop:6 }}>you finished all 3 today</Note>
      <div className="wf-row" style={{ gap:8, justifyContent:'center', marginTop:12 }}>
        <Star/><Star/><Star/><Star filled={false}/><Star filled={false}/>
      </div>
      <Btn primary style={{ marginTop:18, padding:'12px 24px', fontSize:18 }}>see your stars →</Btn>
    </div>
  </div>
);

window.TaskDetailVariations = [
  { id:'d1', label:'D1 · Big check', cap:'Big check + send', sub:'one tap to complete', P:Det1Phone, T:Det1Tablet },
  { id:'d2', label:'D2 · Subtasks', cap:'Sub-step checklist', sub:'breaks down chunks · routines', P:Det2Phone, T:Det2Tablet },
  { id:'d3', label:'D3 · Timer', cap:'Timer / pomodoro', sub:'time-based tasks · reading', P:Det3Phone, T:Det3Tablet },
  { id:'d4', label:'D4 · Photo proof', cap:'Photo proof', sub:'before/after · helps approval', P:Det4Phone, T:Det4Tablet },
  { id:'d5', label:'D5 · Conversation', cap:'Send report', sub:'message-style report to parent', P:Det5Phone, T:Det5Tablet },
  { id:'d6', label:'D6 · Celebrate', cap:'Celebration screen', sub:'after-completion reward · novel', P:Det6Phone, T:Det6Tablet },
];

// ═══════════════════════════════════════════════════════════════════
// PARENT REVIEW · 6 variations
// ═══════════════════════════════════════════════════════════════════

// R1 — Inbox style
const Rev1Phone = () => (
  <div style={{ padding:'12px 12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Review</div>
    <Note>3 to approve</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:8 }}>
      {[['Emma','Clean room','2m ago'],['Jay','Feed cat','10m'],['Emma','Homework','1h']].map(([w,t,a],i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'8px 10px', gap:8 }}>
          <Avatar initial={w[0]} tone={i%2?'green':'pink'}/>
          <div style={{ flex:1, minWidth:0 }}>
            <div style={{ fontSize:13 }}>{t}</div>
            <Note style={{ fontSize:10 }}>{w} · {a}</Note>
          </div>
          <span style={{ fontSize:16 }}>✓</span><span style={{ fontSize:16 }}>↺</span>
        </div>
      ))}
    </div>
  </div>
);
const Rev1Tablet = () => (
  <div className="wf-split">
    <div className="left">
      <Note style={{ fontSize:13 }}>Review</Note>
      <div className="wf-stroke-thin" style={{ padding:'6px 8px', fontSize:11, background:'var(--accent)', color:'#fff' }}>📥 Pending (3)</div>
      <div className="wf-row" style={{ fontSize:11, padding:'4px 8px' }}>✓ Approved</div>
      <div className="wf-row" style={{ fontSize:11, padding:'4px 8px' }}>↺ Sent back</div>
    </div>
    <div className="right">
      <div className="wf-headline" style={{ fontSize:24 }}>Clean room — Emma</div>
      <Note>2 minutes ago</Note>
      <Placeholder h={140}>photo proof</Placeholder>
      <div className="wf-stroke-dashed" style={{ padding:'10px', fontSize:13 }}>"i did a really good job"</div>
      <div className="wf-row" style={{ gap:8, marginTop:8 }}>
        <Btn>↺ ask to redo</Btn><Btn primary>✓ approve · 1 ⭐</Btn>
      </div>
    </div>
  </div>
);

// R2 — Stack of cards swipe
const Rev2Phone = () => (
  <div style={{ padding:'14px', height:'100%' }}>
    <Note>swipe → approve · ← redo</Note>
    <div style={{ position:'relative', marginTop:14, height:280 }}>
      <div className="wf-stroke" style={{ position:'absolute', inset:'14px 14px 0 14px', background:'var(--paper-dim)' }}/>
      <div className="wf-stroke" style={{ position:'absolute', inset:'7px 7px 7px 7px', background:'var(--paper)' }}/>
      <div className="wf-stroke" style={{ position:'absolute', inset:0, background:'var(--paper)', padding:'12px' }}>
        <div className="wf-row"><Avatar initial="E" tone="pink"/><div style={{ fontSize:13 }}>Emma · clean room</div></div>
        <Placeholder h={120} style={{ marginTop:8 }}>photo proof</Placeholder>
        <Note style={{ marginTop:6, fontSize:12 }}>"i made the bed!"</Note>
      </div>
    </div>
    <div className="wf-row" style={{ justifyContent:'space-between', marginTop:14 }}>
      <Btn>↺ redo</Btn><Btn primary>✓ approve</Btn>
    </div>
  </div>
);
const Rev2Tablet = () => (
  <div style={{ padding:'30px', height:'100%' }}>
    <Note style={{ fontSize:14 }}>swipe through what kids sent</Note>
    <div style={{ position:'relative', marginTop:18, height:340 }}>
      {[{ off:24, color:'#eee'},{ off:12, color:'#f5f5f5'},{ off:0, color:'var(--paper)'}].map((s,i)=>(
        <div key={i} className="wf-stroke" style={{ position:'absolute', left:s.off+30, right:s.off+30, top:s.off, bottom:0, background:s.color, padding:i===2?'18px':0 }}>
          {i===2 && (<>
            <div className="wf-row"><Avatar initial="E" tone="pink" size="lg"/><div className="wf-headline" style={{ fontSize:22 }}>Emma · Clean room</div></div>
            <Placeholder h={170} style={{ marginTop:10 }}>photo proof</Placeholder>
            <Note style={{ marginTop:8, fontSize:14 }}>"i made the bed and tidied my desk!"</Note>
          </>)}
        </div>
      ))}
    </div>
    <div className="wf-row" style={{ justifyContent:'space-around', marginTop:14 }}>
      <Btn>↺ redo</Btn><Btn>💬 reply</Btn><Btn primary>✓ approve · 1⭐</Btn>
    </div>
  </div>
);

// R3 — Timeline / activity feed
const Rev3Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Activity</div>
    <Note>everything that happened today</Note>
    <div style={{ marginTop:10, position:'relative', paddingLeft:18 }}>
      <div style={{ position:'absolute', left:6, top:6, bottom:6, width:1, background:'var(--ink-soft)' }}/>
      {[['9:01','Emma started "clean room"'],['9:14','Emma sent proof 📷'],['9:15','✓ you approved · +1⭐'],['10:02','Jay finished "feed cat"']].map((e,i)=>(
        <div key={i} style={{ marginBottom:8, position:'relative' }}>
          <span style={{ position:'absolute', left:-18, top:3, width:10, height:10, background:'var(--accent)', border:'1.4px solid var(--ink)', borderRadius:'50%' }}/>
          <Note style={{ fontSize:11 }}>{e[0]}</Note>
          <div style={{ fontSize:13 }}>{e[1]}</div>
        </div>
      ))}
    </div>
  </div>
);
const Rev3Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Today's activity</div>
    <div style={{ marginTop:14, position:'relative', paddingLeft:24 }}>
      <div style={{ position:'absolute', left:8, top:6, bottom:6, width:1.5, background:'var(--ink-soft)' }}/>
      {[
        ['9:01','Emma started "clean room"','—'],
        ['9:14','Emma sent proof 📷','review'],
        ['9:15','You approved · +1⭐','done'],
        ['10:02','Jay finished "feed cat"','review'],
        ['10:04','You approved · +1⭐','done'],
      ].map((e,i)=>(
        <div key={i} style={{ marginBottom:14, position:'relative' }}>
          <span style={{ position:'absolute', left:-24, top:3, width:14, height:14, background: e[2]==='done'?'var(--done)':e[2]==='review'?'var(--accent)':'#fff', border:'1.6px solid var(--ink)', borderRadius:'50%' }}/>
          <Note style={{ fontSize:12 }}>{e[0]}</Note>
          <div style={{ fontSize:15 }}>{e[1]}</div>
        </div>
      ))}
    </div>
  </div>
);

// R4 — Big approve toggle row (one-tap)
const Rev4Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>Done today</div>
    <Note>tap to approve</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:8 }}>
      {[['Clean room','Emma',true],['Feed cat','Jay',false],['Plants','Jay',true]].map(([t,w,a],i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'10px 12px', gap:10, background: a?'#EEF7EE':'var(--paper)' }}>
          <Avatar initial={w[0]} tone={i%2?'green':'pink'}/>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:13 }}>{t}</div>
            <Note style={{ fontSize:10 }}>{w}</Note>
          </div>
          <div className="wf-stroke-thin" style={{ width:36, height:20, borderRadius:14, background: a?'var(--done)':'var(--paper)', position:'relative' }}>
            <div style={{ width:14, height:14, background:'var(--ink)', borderRadius:'50%', position:'absolute', top:1.5, left: a?18:1.5 }}></div>
          </div>
        </div>
      ))}
    </div>
  </div>
);
const Rev4Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Approve in bulk</div>
    <Note style={{ fontSize:14 }}>fast Sunday review</Note>
    <div className="wf-row" style={{ gap:10, marginTop:10 }}>
      <Btn>✓ approve all</Btn><Btn>filter: today</Btn>
    </div>
    <div style={{ marginTop:14, display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
      {[['Clean room','Emma',true],['Feed cat','Jay',true],['Plants','Jay',false],['Reading','Emma',true]].map(([t,w,a],i)=>(
        <div key={i} className="wf-stroke wf-row" style={{ padding:'12px 14px', gap:10, background: a?'#EEF7EE':'var(--paper)' }}>
          <Avatar initial={w[0]} tone={i%2?'green':'pink'} size="lg"/>
          <div style={{ flex:1 }}><div style={{ fontSize:14 }}>{t}</div><Note style={{ fontSize:11 }}>{w}</Note></div>
          <Pill tone={a?'done':''}>{a?'✓ approved':'tap to approve'}</Pill>
        </div>
      ))}
    </div>
  </div>
);

// R5 — Notification cards
const Rev5Phone = () => (
  <div style={{ padding:'10px', height:'100%' }}>
    <Note style={{ fontSize:11, color:'var(--ink-soft)', textAlign:'center' }}>3 new notifications</Note>
    <div style={{ marginTop:10, display:'flex', flexDirection:'column', gap:6 }}>
      {[
        ['📥','Emma finished clean room','tap to view'],
        ['🐱','Jay sent you a photo','feed cat · 2m'],
        ['📚','Emma needs help with hw','7m'],
      ].map((n,i)=>(
        <div key={i} className="wf-stroke" style={{ padding:'8px 10px', display:'flex', gap:8, alignItems:'center' }}>
          <span style={{ fontSize:22 }}>{n[0]}</span>
          <div style={{ flex:1, minWidth:0 }}>
            <div style={{ fontSize:13 }}>{n[1]}</div>
            <Note style={{ fontSize:10 }}>{n[2]}</Note>
          </div>
          <span>›</span>
        </div>
      ))}
    </div>
  </div>
);
const Rev5Tablet = () => (
  <div className="wf-split">
    <div className="left">
      <Note style={{ fontSize:14 }}>📥 Inbox</Note>
      {[['Emma · clean room','2m'],['Jay · cat','10m'],['Emma · hw','1h']].map((n,i)=>(
        <div key={i} className="wf-stroke-thin" style={{ padding:'6px 8px', fontSize:11, background:i===0?'#fff':'transparent' }}>
          <div>{n[0]}</div><Note style={{ fontSize:9 }}>{n[1]}</Note>
        </div>
      ))}
    </div>
    <div className="right">
      <div className="wf-headline" style={{ fontSize:24 }}>Emma · clean room</div>
      <Note>2 minutes ago</Note>
      <Placeholder h={150}>photo proof</Placeholder>
      <div className="wf-row" style={{ gap:8, marginTop:8 }}><Btn>↺ redo</Btn><Btn primary>✓ approve</Btn></div>
    </div>
  </div>
);

// R6 — Weekly digest grid
const Rev6Phone = () => (
  <div style={{ padding:'12px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:22 }}>This week</div>
    <Note>Mar 4 – Mar 10</Note>
    {['Emma','Jay'].map((w,k)=>(
      <Section key={w} label={w} style={{ marginTop:10 }}>
        <div className="wf-row" style={{ gap:3 }}>
          {['M','T','W','T','F','S','S'].map((d,i)=>(
            <div key={i} className="wf-stroke-thin" style={{ flex:1, height:30, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', background:i<5? (k===0? '#EEF7EE' : i===2?'var(--paper)':'#EEF7EE') :'var(--paper)' }}>
              <Note style={{ fontSize:9, color:'var(--ink-soft)' }}>{d}</Note>
              <span style={{ fontSize:10 }}>{i<5?'✓':'—'}</span>
            </div>
          ))}
        </div>
      </Section>
    ))}
  </div>
);
const Rev6Tablet = () => (
  <div style={{ padding:'24px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:32 }}>Weekly digest</div>
    <Note style={{ fontSize:14 }}>at-a-glance grid · approve any cell</Note>
    <div style={{ marginTop:14 }}>
      <div className="wf-row" style={{ gap:4, paddingLeft:80 }}>
        {['Mon','Tue','Wed','Thu','Fri','Sat','Sun'].map((d,i)=>(<div key={i} style={{ flex:1, fontSize:11, textAlign:'center' }}>{d}</div>))}
      </div>
      {['Emma','Jay','Sam'].map((w,k)=>(
        <div key={w} className="wf-row" style={{ gap:4, marginTop:6 }}>
          <div style={{ width:80, fontSize:13 }}>{w}</div>
          {[0,1,2,3,4,5,6].map(i=>{
            const done = (i + k) % 5 < 3; const today = i===2;
            return <div key={i} className="wf-stroke-thin" style={{ flex:1, height:38, display:'flex', alignItems:'center', justifyContent:'center', background:done?'#EEF7EE':today?'#FFF6BD':'var(--paper)', fontSize:14 }}>{done?'✓':today?'…':'—'}</div>;
          })}
        </div>
      ))}
    </div>
  </div>
);

window.ParentReviewVariations = [
  { id:'r1', label:'R1 · Inbox', cap:'Inbox style', sub:'list of pending · approve/redo', P:Rev1Phone, T:Rev1Tablet },
  { id:'r2', label:'R2 · Card swipe', cap:'Card stack', sub:'tinder-style · one at a time', P:Rev2Phone, T:Rev2Tablet },
  { id:'r3', label:'R3 · Activity', cap:'Activity timeline', sub:'chronological feed', P:Rev3Phone, T:Rev3Tablet },
  { id:'r4', label:'R4 · Toggles', cap:'Bulk toggles', sub:'fast Sunday review', P:Rev4Phone, T:Rev4Tablet },
  { id:'r5', label:'R5 · Notifications', cap:'Notification cards', sub:'iOS-like push feed', P:Rev5Phone, T:Rev5Tablet },
  { id:'r6', label:'R6 · Weekly grid', cap:'Weekly digest grid', sub:'at-a-glance heatmap', P:Rev6Phone, T:Rev6Tablet },
];

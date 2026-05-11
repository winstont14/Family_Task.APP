// screens-onboarding.jsx — 6 variations of family workspace setup

// ── 1. Linear stepper — name family then add members
const Onb1Phone = () => (
  <div style={{ padding: '14px 14px', height:'100%' }}>
    <div style={{ display:'flex', gap:4, marginBottom:14 }}>
      <span className="wf-dot fill-blue"></span><span className="wf-dot fill-blue"></span><span className="wf-dot"></span>
    </div>
    <div className="wf-headline" style={{ fontSize:30, marginBottom:4 }}>Name your family</div>
    <Note>Step 2 of 3</Note>
    <div style={{ marginTop:16 }}>
      <div className="wf-stroke" style={{ padding:'14px 12px', fontSize:14 }}>The Browns ✏️</div>
    </div>
    <div style={{ marginTop:16, display:'flex', alignItems:'center', justifyContent:'center', gap:6 }}>
      <Avatar initial="🏠" tone="warm" size="xl"/>
    </div>
    <Note style={{ textAlign:'center', marginTop:6 }}>tap to pick an icon</Note>
    <div style={{ position:'absolute', bottom:14, left:12, right:12, display:'flex', gap:8 }}>
      <Btn full>Back</Btn>
      <Btn full primary>Next →</Btn>
    </div>
  </div>
);

const Onb1Tablet = () => (
  <div className="wf-split">
    <div className="left">
      <Note style={{ fontSize:18 }}>Set up</Note>
      <div className="wf-row" style={{ fontSize:11 }}><span className="wf-dot fill-blue"></span>1. Welcome</div>
      <div className="wf-row" style={{ fontSize:11, fontWeight:'bold' }}><span className="wf-dot fill-blue"></span>2. Family</div>
      <div className="wf-row" style={{ fontSize:11, color:'var(--ink-faint)' }}><span className="wf-dot"></span>3. Members</div>
    </div>
    <div className="right">
      <div className="wf-headline" style={{ fontSize:34 }}>Name your family</div>
      <div className="wf-stroke" style={{ padding:'18px 16px', fontSize:18 }}>The Browns</div>
      <div style={{ display:'flex', gap:8, alignItems:'center' }}>
        <Avatar initial="🏠" tone="warm" size="xl"/>
        <Avatar initial="🌳" tone="green" size="xl"/>
        <Avatar initial="⭐" tone="warn" size="xl"/>
        <Avatar initial="🎨" tone="pink" size="xl"/>
      </div>
      <div style={{ flex:1 }}/>
      <div style={{ display:'flex', gap:10, justifyContent:'flex-end' }}>
        <Btn>Back</Btn><Btn primary>Continue →</Btn>
      </div>
    </div>
  </div>
);

// ── 2. Single-screen all-in-one
const Onb2Phone = () => (
  <div style={{ padding:'12px 12px', height:'100%', display:'flex', flexDirection:'column', gap:8 }}>
    <div className="wf-headline" style={{ fontSize:26 }}>Welcome 👋</div>
    <Note>Set up your family in one go</Note>
    <Section label="Family name">
      <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:13 }}>The Smiths</div>
    </Section>
    <Section label="Members">
      <div style={{ display:'flex', gap:6, flexWrap:'wrap' }}>
        <div className="wf-stroke-thin wf-row" style={{ padding:'5px 8px', fontSize:11 }}><Avatar initial="M" tone="blue"/>Mom</div>
        <div className="wf-stroke-thin wf-row" style={{ padding:'5px 8px', fontSize:11 }}><Avatar initial="E" tone="pink"/>Emma</div>
        <div className="wf-stroke-thin wf-row" style={{ padding:'5px 8px', fontSize:11 }}><Avatar initial="J" tone="green"/>Jay</div>
        <div className="wf-stroke-dashed wf-row" style={{ padding:'5px 8px', fontSize:11 }}>+ add</div>
      </div>
    </Section>
    <div style={{ flex:1 }}/>
    <Btn primary full>Create family →</Btn>
  </div>
);
const Onb2Tablet = () => (
  <div style={{ padding:'24px 28px', height:'100%', display:'flex', flexDirection:'column', gap:16 }}>
    <div className="wf-headline" style={{ fontSize:38 }}>Welcome 👋</div>
    <Note style={{ fontSize:18 }}>One screen, that's it. Set up your family.</Note>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:18, marginTop:8 }}>
      <Section label="Family name">
        <div className="wf-stroke" style={{ padding:'14px 14px', fontSize:18 }}>The Smiths</div>
      </Section>
      <Section label="Family icon">
        <div className="wf-row" style={{ gap:6 }}>
          {['🏠','🌳','🎨','⭐'].map((e,i)=>(<Avatar key={i} initial={e} size="lg" tone={i===0?'blue':'warm'}/>))}
        </div>
      </Section>
    </div>
    <Section label="Members">
      <div style={{ display:'flex', gap:8, flexWrap:'wrap' }}>
        {[['M','Mom','blue'],['D','Dad','warm'],['E','Emma','pink'],['J','Jay','green']].map(([i,n,t])=>(
          <div key={n} className="wf-stroke-thin wf-row" style={{ padding:'8px 12px', fontSize:13 }}>
            <Avatar initial={i} tone={t}/>{n}
          </div>
        ))}
        <div className="wf-stroke-dashed wf-row" style={{ padding:'8px 12px', fontSize:13 }}>+ add member</div>
      </div>
    </Section>
    <div style={{ flex:1 }}/>
    <div style={{ display:'flex', justifyContent:'flex-end' }}><Btn primary>Create family →</Btn></div>
  </div>
);

// ── 3. Pick-your-role kid-friendly
const Onb3Phone = () => (
  <div style={{ padding:'14px 12px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-headline" style={{ fontSize:24, textAlign:'center' }}>Who are you?</div>
    <Note style={{ textAlign:'center' }}>Tap to start</Note>
    <div style={{ display:'flex', flexDirection:'column', gap:14, marginTop:16 }}>
      <div className="wf-stroke" style={{ padding:'18px 14px', display:'flex', alignItems:'center', gap:10, background:'var(--paper)' }}>
        <Avatar initial="👨‍👩" tone="warm" size="xl"/>
        <div>
          <div style={{ fontSize:18, fontFamily:'Caveat, cursive', fontWeight:600 }}>I'm a Parent</div>
          <div style={{ fontSize:11, color:'var(--ink-soft)' }}>Set up tasks for kids</div>
        </div>
      </div>
      <div className="wf-stroke" style={{ padding:'18px 14px', display:'flex', alignItems:'center', gap:10, background:'#FFF6BD' }}>
        <Avatar initial="🧒" tone="pink" size="xl"/>
        <div>
          <div style={{ fontSize:18, fontFamily:'Caveat, cursive', fontWeight:600 }}>I'm a Kid</div>
          <div style={{ fontSize:11, color:'var(--ink-soft)' }}>Do tasks, earn stars</div>
        </div>
      </div>
    </div>
    <div style={{ flex:1 }}/>
    <Note style={{ fontSize:11, textAlign:'center' }}>parents will set a PIN later</Note>
  </div>
);
const Onb3Tablet = () => (
  <div style={{ padding:'40px 50px', height:'100%', display:'flex', flexDirection:'column', alignItems:'center' }}>
    <div className="wf-headline" style={{ fontSize:42 }}>Who are you?</div>
    <Note style={{ fontSize:18, marginBottom:30 }}>Just tap your big button</Note>
    <div style={{ display:'flex', gap:24 }}>
      <div className="wf-stroke" style={{ padding:'30px 24px', width:130, textAlign:'center', background:'var(--paper)' }}>
        <Avatar initial="👨" tone="warm" size="xl" style={{ width:80, height:80 }}/>
        <div style={{ fontSize:22, fontFamily:'Caveat, cursive', fontWeight:600, marginTop:10 }}>Parent</div>
      </div>
      <div className="wf-stroke" style={{ padding:'30px 24px', width:130, textAlign:'center', background:'#FFF6BD' }}>
        <Avatar initial="🧒" tone="pink" size="xl"/>
        <div style={{ fontSize:22, fontFamily:'Caveat, cursive', fontWeight:600, marginTop:10 }}>Kid</div>
      </div>
    </div>
    <Note style={{ marginTop:40 }}>tip: parents set a 4-digit PIN to keep kids out of admin</Note>
  </div>
);

// ── 4. Card-stack guided tour (illustration-led)
const Onb4Phone = () => (
  <div style={{ padding:'14px 14px', height:'100%', display:'flex', flexDirection:'column' }}>
    <div className="wf-stroke" style={{ height:170, position:'relative', display:'flex', alignItems:'center', justifyContent:'center', background:'#f6f0ff' }}>
      <Placeholder h="100%" style={{ width:'100%', borderRadius:0, border:'none' }}>illustration: family at table</Placeholder>
    </div>
    <div className="wf-headline" style={{ fontSize:28, marginTop:14 }}>Tasks, but for the family</div>
    <Note style={{ fontSize:13, marginTop:4 }}>Assign chores. Kids check 'em off. Easy.</Note>
    <div style={{ flex:1 }}/>
    <div style={{ display:'flex', gap:6, justifyContent:'center', marginBottom:10 }}>
      <span className="wf-dot fill-blue"></span><span className="wf-dot"></span><span className="wf-dot"></span>
    </div>
    <Btn primary full>Get started →</Btn>
  </div>
);
const Onb4Tablet = () => (
  <div style={{ padding:'24px 30px', height:'100%', display:'flex', gap:24, alignItems:'center' }}>
    <div className="wf-stroke" style={{ flex:1, height:'80%', background:'#f6f0ff' }}>
      <Placeholder h="100%" style={{ width:'100%', border:'none', borderRadius:0 }}>illustration · spot for hero art</Placeholder>
    </div>
    <div style={{ flex:1, display:'flex', flexDirection:'column', gap:14 }}>
      <div className="wf-headline" style={{ fontSize:42, lineHeight:1 }}>Tasks for the whole family</div>
      <Note style={{ fontSize:18 }}>Set up your space in three short steps.</Note>
      <div style={{ display:'flex', gap:6 }}>
        <span className="wf-dot fill-blue"></span><span className="wf-dot"></span><span className="wf-dot"></span>
      </div>
      <Btn primary>Get started →</Btn>
    </div>
  </div>
);

// ── 5. Conversational chat-style
const Onb5Phone = () => (
  <div style={{ padding:'12px 10px', height:'100%', display:'flex', flexDirection:'column', gap:8 }}>
    <Avatar initial="🤖" tone="green" size="lg"/>
    <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:13, alignSelf:'flex-start', background:'#f0f4ff', borderRadius:'12px 12px 12px 2px' }}>Hi! What's your family called?</div>
    <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:13, alignSelf:'flex-end', background:'var(--accent)', color:'#fff', borderRadius:'12px 12px 2px 12px' }}>The Carters 🏡</div>
    <div className="wf-stroke-thin" style={{ padding:'8px 10px', fontSize:13, alignSelf:'flex-start', background:'#f0f4ff', borderRadius:'12px 12px 12px 2px' }}>Nice! Who's in it?</div>
    <div className="wf-stroke-thin wf-row" style={{ padding:'5px 8px', fontSize:11, alignSelf:'flex-end', gap:4 }}>
      <Avatar initial="M" tone="blue"/>Mom <Avatar initial="L" tone="pink"/>Lily
    </div>
    <div style={{ flex:1 }}/>
    <div className="wf-stroke" style={{ padding:'8px 10px', fontSize:13, display:'flex', alignItems:'center' }}>
      <span style={{ flex:1, color:'var(--ink-faint)' }}>type a reply…</span>
      <span style={{ fontSize:18 }}>↑</span>
    </div>
  </div>
);
const Onb5Tablet = () => (
  <div className="wf-split">
    <div className="left">
      <Avatar initial="🤖" tone="green" size="xl"/>
      <Note style={{ fontSize:14 }}>Setup buddy</Note>
      <Note style={{ fontSize:11, color:'var(--ink-soft)' }}>I'll walk you through.</Note>
    </div>
    <div className="right">
      <div style={{ display:'flex', flexDirection:'column', gap:10 }}>
        <div className="wf-stroke-thin" style={{ padding:'10px 14px', fontSize:14, alignSelf:'flex-start', background:'#f0f4ff', maxWidth:'70%' }}>What's your family called?</div>
        <div className="wf-stroke-thin" style={{ padding:'10px 14px', fontSize:14, alignSelf:'flex-end', background:'var(--accent)', color:'#fff', maxWidth:'70%' }}>The Carters 🏡</div>
        <div className="wf-stroke-thin" style={{ padding:'10px 14px', fontSize:14, alignSelf:'flex-start', background:'#f0f4ff', maxWidth:'70%' }}>Add some members?</div>
      </div>
      <div style={{ flex:1 }}/>
      <div className="wf-stroke" style={{ padding:'10px 14px', fontSize:14, display:'flex' }}>
        <span style={{ flex:1, color:'var(--ink-faint)' }}>your reply…</span>
        <span>↑</span>
      </div>
    </div>
  </div>
);

// ── 6. Hero "blank workspace" Notion-style
const Onb6Phone = () => (
  <div style={{ padding:'14px 14px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:30 }}>Untitled Family</div>
    <Note style={{ marginTop:4 }}>tap to name it ✏️</Note>
    <hr className="wf-divider"/>
    <Section label="Members">
      <div className="wf-stroke-dashed" style={{ padding:'14px 12px', textAlign:'center', fontSize:13 }}>
        + add yourself first
      </div>
    </Section>
    <Section label="Today's tasks">
      <div className="wf-stroke-dashed" style={{ padding:'14px 12px', textAlign:'center', fontSize:13, color:'var(--ink-faint)' }}>
        empty
      </div>
    </Section>
    <Note style={{ marginTop:12, fontSize:11 }}>Build your workspace as you go — like Notion</Note>
  </div>
);
const Onb6Tablet = () => (
  <div style={{ padding:'30px 40px', height:'100%' }}>
    <div className="wf-headline" style={{ fontSize:46 }}>Untitled Family</div>
    <Note style={{ fontSize:16, marginTop:6 }}>tap any heading to rename ✏️</Note>
    <hr className="wf-divider" style={{ margin:'16px 0' }}/>
    <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:18 }}>
      <Section label="Members">
        <div className="wf-stroke-dashed" style={{ padding:'18px 14px', fontSize:14, textAlign:'center' }}>+ add a person</div>
      </Section>
      <Section label="Today's tasks">
        <div className="wf-stroke-dashed" style={{ padding:'18px 14px', fontSize:14, textAlign:'center', color:'var(--ink-faint)' }}>empty</div>
      </Section>
    </div>
    <Note style={{ marginTop:18 }}>Free-form. Build it like a Notion page.</Note>
  </div>
);

window.OnboardingVariations = [
  { id:'o1', label:'O1 · Stepper', cap:'Linear stepper', sub:'progress dots · classic 3-step', P:Onb1Phone, T:Onb1Tablet },
  { id:'o2', label:'O2 · One-screen', cap:'Single screen', sub:'all fields visible · no nav', P:Onb2Phone, T:Onb2Tablet },
  { id:'o3', label:'O3 · Pick role', cap:'Big role buttons', sub:'kid-friendly · parent or child?', P:Onb3Phone, T:Onb3Tablet },
  { id:'o4', label:'O4 · Hero tour', cap:'Illustrated cards', sub:'classic onboarding carousel', P:Onb4Phone, T:Onb4Tablet },
  { id:'o5', label:'O5 · Conversation', cap:'Setup chat', sub:'feels casual · novel', P:Onb5Phone, T:Onb5Tablet },
  { id:'o6', label:'O6 · Blank slate', cap:'Notion blank doc', sub:'fill it as you go · no wizard', P:Onb6Phone, T:Onb6Tablet },
];

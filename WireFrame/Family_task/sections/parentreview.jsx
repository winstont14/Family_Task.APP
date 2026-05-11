// sections/parentreview.jsx — 6 variations: parent reviews completed work

const KIDS = [{n:'Emma',t:'mint'},{n:'Leo',t:'lilac'},{n:'Riya',t:'peach'}];

// V1 — Inbox-style approve / reject feed
const PrV1P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Review</div>
  <div className="wf-cap">3 waiting</div>
  <div className="scr-scroll">
    {[
      {k:'Emma',t:'mint',title:'Clean room',time:'2m ago',photo:true},
      {k:'Leo',t:'lilac',title:'Feed cat',time:'12m ago'},
      {k:'Riya',t:'peach',title:'Homework',time:'1h',photo:true},
    ].map((r,i)=>(
      <div key={i} className="wf-card" style={{padding:8}}>
        <div className="wf-row" style={{gap:6}}><Avatar tone={r.t}>{r.k[0]}</Avatar><span style={{fontFamily:'var(--hand-head)', fontSize:14}}>{r.k}</span><div className="wf-spacer"/><span className="wf-cap">{r.time}</span></div>
        <div style={{fontSize:13, marginTop:3}}>{r.title}</div>
        {r.photo && <Img w="100%" h={50} label="proof photo"/>}
        <div className="wf-row" style={{gap:5, marginTop:5}}><Btn>send back</Btn><div className="wf-spacer"/><Btn tone="primary">✓ approve</Btn></div>
      </div>
    ))}
  </div>
</div>);
const PrV1T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Review inbox</div><div className="wf-spacer"/><Pill tone="accent">3 waiting</Pill></div>
  <div className="wf-row" style={{gap:5, marginTop:4}}>{['All','Emma','Leo','Riya'].map((c,i)=>(<Pill key={c} tone={i===0?'accent':''}>{c}</Pill>))}</div>
  <div className="scr-scroll" style={{marginTop:6}}>
    {[
      {k:'Emma',t:'mint',title:'Clean your room',time:'2 min ago',photo:true,note:'Even did under the bed!'},
      {k:'Leo',t:'lilac',title:'Feed the cat',time:'12 min ago'},
      {k:'Riya',t:'peach',title:'Finish homework',time:'1 hour ago',photo:true},
    ].map((r,i)=>(
      <div key={i} className="wf-card wf-row" style={{padding:12, gap:14}}>
        {r.photo ? <Img w={90} h={70} label="photo"/> : <div className="wf-stroke" style={{width:90,height:70,display:'flex',alignItems:'center',justifyContent:'center',fontSize:30}}>🐱</div>}
        <div className="wf-col" style={{flex:1, gap:3}}>
          <div className="wf-row" style={{gap:6}}><Avatar tone={r.t}>{r.k[0]}</Avatar><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>{r.k}</span><Pill>{r.time}</Pill></div>
          <div className="wf-h2">{r.title}</div>
          {r.note && <div className="bubble" style={{maxWidth:'90%', fontSize:11}}>{r.note}</div>}
        </div>
        <div className="wf-col" style={{gap:6, justifyContent:'center'}}>
          <Btn size="lg">↩ send back</Btn>
          <Btn tone="primary" size="lg">✓ approve · +⭐</Btn>
        </div>
      </div>
    ))}
  </div>
</div>);

// V2 — Carded grid of completion photos
const PrV2P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Today's wins</div>
  <div style={{display:'grid', gridTemplateColumns:'1fr 1fr', gap:5, marginTop:4}}>
    {[1,2,3,4].map(i=>(
      <div key={i} className="wf-card" style={{padding:5}}>
        <Img w="100%" h={60} label="proof"/>
        <div style={{fontSize:11, fontFamily:'var(--hand-head)', marginTop:3}}>{['Clean room','Feed cat','HW','Plants'][i-1]}</div>
        <div className="wf-row" style={{gap:3}}><Avatar tone={['mint','lilac','peach','mint'][i-1]}>{['E','L','R','E'][i-1]}</Avatar><div className="wf-spacer"/><Check size="" done/></div>
      </div>
    ))}
  </div>
  <div className="wf-cap" style={{marginTop:5}}>tap a card to approve</div>
</div>);
const PrV2T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Today's wins ✨</div><div className="wf-spacer"/><Pill>4 to review</Pill></div>
  <div className="wf-cap">tap a card to approve · long-press to send back</div>
  <div style={{display:'grid', gridTemplateColumns:'repeat(3, 1fr)', gap:10, marginTop:8}}>
    {[
      ['Emma','mint','Clean room','🧸',true],
      ['Leo','lilac','Feed cat','🐱',true],
      ['Riya','peach','Homework','📓',true],
      ['Emma','mint','Read book','📖',false],
      ['Leo','lilac','Toys away','🧸',false],
      ['Riya','peach','Plants','🪴',false],
    ].map(([k,t,title,e,pending],i)=>(
      <div key={i} className={`wf-card ${pending?'':'wf-fill-done'}`} style={{padding:8}}>
        <Img w="100%" h={70} label="photo"/>
        <div className="wf-row" style={{gap:5, marginTop:6}}><Avatar tone={t}>{k[0]}</Avatar><div className="wf-col" style={{gap:0}}><span style={{fontFamily:'var(--hand-head)', fontSize:14}}>{title}</span><span className="wf-cap">{k} · 2m</span></div></div>
        <div className="wf-row" style={{marginTop:5}}><Pill tone={pending?'accent':'done'}>{pending?'tap to ✓':'approved'}</Pill><div className="wf-spacer"/><span style={{fontSize:18}}>{e}</span></div>
      </div>
    ))}
  </div>
</div>);

// V3 — Single swipeable card stack
const PrV3P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-cap" style={{textAlign:'center'}}>1 of 3 to review</div>
  <div className="wf-col" style={{flex:1, position:'relative', alignItems:'center', justifyContent:'center'}}>
    <div className="wf-card" style={{position:'absolute', width:'80%', height:'80%', transform:'rotate(2deg) translate(8px,8px)', opacity:0.3}}/>
    <div className="wf-card" style={{position:'absolute', width:'85%', height:'85%', transform:'rotate(-1deg) translate(-4px,4px)', opacity:0.5}}/>
    <div className="wf-card wf-col" style={{width:'90%', height:'90%', padding:10, gap:6, position:'relative', zIndex:2}}>
      <div className="wf-row"><Avatar tone="mint">E</Avatar><span style={{fontFamily:'var(--hand-head)'}}>Emma · 2m</span></div>
      <div className="wf-h2">Clean room</div>
      <Img w="100%" h={100} label="proof"/>
      <div className="bubble" style={{fontSize:10}}>Even under the bed!</div>
      <div className="wf-row" style={{justifyContent:'space-between', marginTop:4}}><span style={{fontFamily:'var(--hand-head)', fontSize:12}}>← send back</span><span style={{fontFamily:'var(--hand-head)', fontSize:12, color:'var(--accent)'}}>approve →</span></div>
    </div>
  </div>
</div>);
const PrV3T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Review one at a time</div><div className="wf-spacer"/><Pill>2 of 5</Pill></div>
  <div className="wf-row" style={{flex:1, gap:14, alignItems:'center', justifyContent:'center', minHeight:0}}>
    <div className="wf-col" style={{alignItems:'center', justifyContent:'center'}}>
      <div className="wf-stroke" style={{width:50,height:50,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:22}}>↩</div>
      <div className="wf-cap" style={{marginTop:4}}>send back</div>
    </div>
    <div className="wf-col" style={{flex:1, position:'relative', height:'100%', alignItems:'center', justifyContent:'center'}}>
      <div className="wf-card" style={{position:'absolute', width:'80%', height:'78%', transform:'rotate(3deg) translate(12px,12px)', opacity:0.25}}/>
      <div className="wf-card" style={{position:'absolute', width:'88%', height:'85%', transform:'rotate(-1.5deg) translate(-6px,6px)', opacity:0.55}}/>
      <div className="wf-card wf-col" style={{width:'95%', height:'92%', padding:14, gap:8, position:'relative', zIndex:2}}>
        <div className="wf-row"><Avatar tone="mint" size="lg">E</Avatar><div className="wf-col" style={{gap:0}}><div style={{fontFamily:'var(--hand-head)', fontSize:20}}>Emma's report</div><div className="wf-cap">2 minutes ago</div></div><div className="wf-spacer"/><Stars filled={2} total={3}/></div>
        <div className="wf-h">Clean your room 🧸</div>
        <Img w="100%" h={120} label="proof photo"/>
        <div className="bubble">Even did under the bed!</div>
      </div>
    </div>
    <div className="wf-col" style={{alignItems:'center', justifyContent:'center'}}>
      <div className="wf-stroke" style={{width:50,height:50,borderRadius:'50%', display:'flex',alignItems:'center',justifyContent:'center', fontSize:22, background:'var(--accent)', color:'#fff', borderColor:'var(--accent)'}}>✓</div>
      <div className="wf-cap" style={{marginTop:4}}>approve</div>
    </div>
  </div>
</div>);

// V4 — Per-child columns
const PrV4P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">By child</div>
  <div className="wf-row" style={{flex:1, gap:5, minHeight:0}}>
    {KIDS.map(k=>(
      <div key={k.n} className="wf-stroke wf-col" style={{flex:1, padding:5, gap:4}}>
        <div className="wf-row"><Avatar tone={k.t} size="">{k.n[0]}</Avatar><span style={{fontSize:11, fontFamily:'var(--hand-head)'}}>{k.n}</span></div>
        <div className="wf-cap">{k.n==='Emma'?'2 to OK':k.n==='Leo'?'1 to OK':'0 to OK'}</div>
        {(k.n==='Emma'?['Room','HW']:k.n==='Leo'?['Cat']:[]).map((t,i)=>(
          <div key={i} className="wf-card-soft" style={{padding:4}}>
            <div style={{fontSize:11, fontFamily:'var(--hand-head)'}}>{t}</div>
            <div className="wf-row"><Pill tone="accent">✓</Pill><div className="wf-spacer"/><Pill>↩</Pill></div>
          </div>
        ))}
      </div>
    ))}
  </div>
</div>);
const PrV4T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-xl">Review by child</div><div className="wf-spacer"/><Pill>approve all ✓</Pill></div>
  <div className="wf-row" style={{flex:1, gap:10, marginTop:6, minHeight:0}}>
    {KIDS.map((k,j)=>(
      <div key={k.n} className="wf-stroke wf-col" style={{flex:1, padding:10, gap:6}}>
        <div className="wf-row"><Avatar tone={k.t} size="lg">{k.n[0]}</Avatar><div className="wf-col" style={{gap:0}}><span style={{fontFamily:'var(--hand-head)', fontSize:18}}>{k.n}</span><span className="wf-cap">{[2,1,0][j]} to review</span></div></div>
        {(j===0?[['Clean room','🧸',true],['Homework','📓',false]]:j===1?[['Feed cat','🐱',true]]:[]).map(([t,e,p],i)=>(
          <div key={i} className={`wf-card ${p?'':'wf-fill-done'}`} style={{padding:8}}>
            <div className="wf-row"><span style={{fontSize:22}}>{e}</span><span style={{fontFamily:'var(--hand-head)', fontSize:14, flex:1}}>{t}</span></div>
            <div className="wf-row" style={{gap:5, marginTop:4}}><Pill>↩ send back</Pill><div className="wf-spacer"/><Pill tone="accent">✓ approve</Pill></div>
          </div>
        ))}
        {j===2 && <div className="wf-cap" style={{textAlign:'center', marginTop:14}}>nothing waiting</div>}
      </div>
    ))}
  </div>
</div>);

// V5 — Timeline of today
const PrV5P = () => (<div className="scr">
  <StatusBar/>
  <div className="wf-h">Today, in order</div>
  <div className="scr-scroll" style={{paddingLeft:24, position:'relative'}}>
    <div style={{position:'absolute', left:11, top:0, bottom:0, borderLeft:'2px dashed var(--ink-faint)'}}/>
    {[
      ['7:14','Made bed','E','mint',true],
      ['8:02','Brush teeth','L','lilac',true],
      ['12:30','Feed cat','L','lilac',false],
      ['16:48','Homework','R','peach',false],
      ['17:12','Clean room','E','mint',false],
    ].map(([h,t,k,c,ok],i)=>(
      <div key={i} className="wf-row" style={{gap:8, padding:'4px 0'}}>
        <div className="wf-stroke" style={{width:22,height:22,borderRadius:'50%', position:'absolute', left:0, background:ok?'var(--done)':'#fff', display:'flex',alignItems:'center',justifyContent:'center', fontSize:11}}>{ok?'✓':'?'}</div>
        <div className="wf-cap" style={{width:30}}>{h}</div>
        <span style={{fontSize:11, flex:1}}>{t}</span>
        <Avatar tone={c} size="">{k}</Avatar>
      </div>
    ))}
  </div>
</div>);
const PrV5T = () => (<div className="scr">
  <div className="wf-row"><div className="wf-h-xl">Today's timeline</div><div className="wf-spacer"/><span className="wf-cap">tue may 12 · 5 pm</span></div>
  <div className="scr-scroll" style={{marginTop:8, paddingLeft:60, position:'relative'}}>
    <div style={{position:'absolute', left:30, top:8, bottom:0, borderLeft:'2px dashed var(--accent)'}}/>
    {[
      ['7:14','Made bed','E','mint','approved','🛏'],
      ['8:02','Brushed teeth','L','lilac','approved','🪥'],
      ['12:30','Fed the cat','L','lilac','waiting','🐱'],
      ['16:48','Finished homework','R','peach','waiting','📓'],
      ['17:12','Cleaned room','E','mint','waiting','🧸'],
    ].map(([h,t,k,c,s,e],i)=>(
      <div key={i} className="wf-row" style={{gap:14, padding:'8px 0'}}>
        <span className="wf-cap" style={{position:'absolute', left:0, width:26, textAlign:'right'}}>{h}</span>
        <div className="wf-stroke" style={{position:'absolute', left:18, width:24,height:24,borderRadius:'50%',background:s==='approved'?'var(--done)':'#fff', display:'flex',alignItems:'center',justifyContent:'center', fontSize:14}}>{e}</div>
        <div className="wf-card wf-row" style={{flex:1, padding:8, gap:8, marginLeft:14, opacity:s==='approved'?0.7:1}}>
          <Avatar tone={c}>{k}</Avatar>
          <span style={{fontSize:14, fontFamily:'var(--hand-head)', flex:1}}>{t}</span>
          {s==='waiting' ? <><Pill>↩</Pill><Pill tone="accent">✓</Pill></> : <Pill tone="done">✓ ok</Pill>}
        </div>
      </div>
    ))}
  </div>
</div>);

// V6 — Notion-style table
const PrV6P = () => (<div className="scr tight">
  <StatusBar/>
  <div className="wf-h">Tasks · table</div>
  <div className="wf-row" style={{borderBottom:'1.4px solid var(--ink)', paddingBottom:3, fontFamily:'var(--hand-arch)', fontSize:9, color:'var(--ink-faint)', textTransform:'uppercase'}}>
    <span style={{flex:2}}>task</span><span style={{flex:1}}>kid</span><span style={{flex:1}}>status</span>
  </div>
  <div className="scr-scroll" style={{gap:0}}>
    {[['Clean room','E','mint','done'],['Feed cat','L','lilac','review'],['Homework','R','peach','review'],['Plants','L','lilac','done'],['Read','E','mint','review']].map(([t,k,c,s],i)=>(
      <div key={i} className="wf-row" style={{padding:'5px 0', borderBottom:'1px dotted var(--ink-faint)'}}>
        <span style={{flex:2, fontSize:11}}>{t}</span>
        <div style={{flex:1}}><Avatar tone={c} size="">{k}</Avatar></div>
        <div style={{flex:1}}><Pill tone={s==='done'?'done':'accent'}>{s}</Pill></div>
      </div>
    ))}
  </div>
</div>);
const PrV6T = () => (<div className="scr tight">
  <div className="wf-row"><div className="wf-h-xl">Tasks · all time</div><div className="wf-spacer"/><Pill>+ filter</Pill><Pill>sort: status</Pill></div>
  <div className="wf-row" style={{borderBottom:'1.6px solid var(--ink)', paddingBottom:5, fontFamily:'var(--hand-arch)', fontSize:9, color:'var(--ink-faint)', textTransform:'uppercase', letterSpacing:1, marginTop:6}}>
    <span style={{flex:2}}>task</span><span style={{flex:1}}>assigned</span><span style={{flex:1}}>due</span><span style={{flex:1}}>stars</span><span style={{flex:1}}>status</span><span style={{flex:1}}>actions</span>
  </div>
  <div className="scr-scroll" style={{marginTop:0}}>
    {[
      ['Clean your room','E','mint','today',2,'review',true],
      ['Feed the cat','L','lilac','noon',1,'review',true],
      ['Homework','R','peach','today',3,'review',true],
      ['Plants','L','lilac','today',1,'done',false],
      ['Read 20 min','E','mint','today',2,'review',true],
      ['Set the table','R','peach','6pm',1,'todo',false],
    ].map(([t,k,c,d,s,st,p],i)=>(
      <div key={i} className="wf-row" style={{padding:'8px 0', borderBottom:'1px dotted var(--ink-faint)'}}>
        <span style={{flex:2, fontFamily:'var(--hand-head)', fontSize:14}}>{t}</span>
        <div style={{flex:1}}><div className="wf-row" style={{gap:4}}><Avatar tone={c} size="">{k}</Avatar></div></div>
        <span className="wf-cap" style={{flex:1}}>{d}</span>
        <div style={{flex:1}}><Stars filled={s} total={3} size={10}/></div>
        <div style={{flex:1}}><Pill tone={st==='review'?'accent':st==='done'?'done':''}>{st}</Pill></div>
        <div style={{flex:1, display:'flex', gap:3}}>{p && <><Pill>↩</Pill><Pill tone="accent">✓</Pill></>}</div>
      </div>
    ))}
  </div>
</div>);

window.ParentReviewVariations = [
  { id:'pr-v1', label:'V1 · Inbox feed',         cap:'Approve / send back per item',  sub:'Conventional · easiest to scan',         P:PrV1P, T:PrV1T },
  { id:'pr-v2', label:'V2 · Photo grid',         cap:'Wall of completion photos',     sub:'Heart-warming · keepsake feel',          P:PrV2P, T:PrV2T },
  { id:'pr-v3', label:'V3 · Card stack',         cap:'Swipe through one-by-one',      sub:'Forced-attention · novel',               P:PrV3P, T:PrV3T },
  { id:'pr-v4', label:'V4 · Per-child columns',  cap:'Side-by-side by member',        sub:'Best for many kids · balance view',      P:PrV4P, T:PrV4T },
  { id:'pr-v5', label:'V5 · Timeline',           cap:'Today, in chronological order', sub:'Story-of-the-day vibe',                  P:PrV5P, T:PrV5T },
  { id:'pr-v6', label:'V6 · Database table',     cap:'Notion-style table view',       sub:'Power-user · filter / sort',             P:PrV6P, T:PrV6T },
];

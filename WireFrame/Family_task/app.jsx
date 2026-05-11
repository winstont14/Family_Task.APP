// app.jsx — wires DesignCanvas with all sections + Tweaks panel

const SECTIONS = [
  { id:'onb',     title:'1 · Onboarding',         sub:'Create the family workspace · 6 variations',           v: () => window.OnboardingVariations },
  { id:'home',    title:'2 · Home (today)',       sub:'Phone = parent view · Tablet = child view',            v: () => window.HomeVariations },
  { id:'add',     title:'3 · Add task',           sub:'Parent creates / assigns · 6 variations',              v: () => window.AddTaskVariations },
  { id:'detail',  title:'4 · Task detail',        sub:'Child completes & reports · 6 variations',             v: () => window.TaskDetailVariations },
  { id:'review',  title:'5 · Parent review',      sub:'Parent approves completed work · 6 variations',        v: () => window.ParentReviewVariations },
  { id:'progress',title:'6 · Progress / rewards', sub:'Stars · streaks · gardens · shop · 6 variations',      v: () => window.ProgressVariations },
  { id:'family',  title:'7 · Family members',     sub:'Members · profiles · permissions · 6 variations',      v: () => window.FamilyVariations },
];

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "device": "both",
  "accent": "#5B8DEF",
  "density": "regular",
  "penWeight": 1.6,
  "wobble": true,
  "showNotes": true
}/*EDITMODE-END*/;

function applyTweaks(t) {
  const root = document.documentElement;
  root.style.setProperty('--accent', t.accent);
  // pen weight (override --pen via inline rule)
  let s = document.getElementById('pen-style');
  if (!s) { s = document.createElement('style'); s.id = 'pen-style'; document.head.appendChild(s); }
  s.textContent = `
    .wf-phone, .wf-tablet { border-width: ${t.penWeight + 0.4}px; }
    .wf-phone-inner, .wf-tablet-inner, .wf-stroke, .wf-checkbox, .wf-pill, .wf-btn, .wf-tabbar { border-width: ${t.penWeight}px !important; }
    .wf-stroke-thin { border-width: ${Math.max(0.9, t.penWeight - 0.4)}px !important; }
    .wf-stroke-dashed { border-width: ${Math.max(1.1, t.penWeight - 0.2)}px !important; }
    ${t.wobble ? '' : `
      .wf-stroke, .wf-stroke-thin, .wf-stroke-dashed { border-radius: 6px !important; }
      .wf-phone { border-radius: 22px !important; }
      .wf-tablet { border-radius: 16px !important; }
      .wf-phone-inner, .wf-tablet-inner { border-radius: 12px !important; }
      .wf-btn { border-radius: 8px !important; }
    `}
  `;
}

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  React.useEffect(() => { applyTweaks(t); }, [t]);

  const renderArtboard = (variant, sectionId) => {
    const showPhone = t.device === 'both' || t.device === 'phone';
    const showTablet = t.device === 'both' || t.device === 'tablet';

    // sizing — adjust artboard dims based on devices visible
    let W, H;
    if (t.device === 'both') { W = 760; H = 620; }
    else if (t.device === 'phone') { W = 360; H = 620; }
    else { W = 520; H = 620; }

    return (
      <DCArtboard key={variant.id} id={variant.id} label={variant.label} width={W} height={H}>
        <div className={`wf-artboard density-${t.density}`}>
          <div className="wf-artboard-caption">{variant.cap}</div>
          <div className="wf-artboard-subcap">{variant.sub}</div>
          <div className="wf-artboard-stage">
            {showPhone && (
              <Phone label="iPhone"><variant.P/></Phone>
            )}
            {showTablet && (
              <Tablet label="iPad"><variant.T/></Tablet>
            )}
          </div>
        </div>
      </DCArtboard>
    );
  };

  return (
    <>
      <DesignCanvas>
        {SECTIONS.map(sec => {
          const vars = sec.v() || [];
          return (
            <DCSection key={sec.id} id={sec.id} title={sec.title} subtitle={sec.sub}>
              {vars.map(v => renderArtboard(v, sec.id))}
            </DCSection>
          );
        })}
      </DesignCanvas>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Devices" />
        <TweakRadio label="Show" value={t.device}
          options={[{value:'phone',label:'📱'},{value:'both',label:'both'},{value:'tablet',label:'iPad'}]}
          onChange={(v) => setTweak('device', v)} />

        <TweakSection label="Sketch style" />
        <TweakSlider label="Pen weight" value={t.penWeight} min={1} max={3} step={0.2} unit="px"
          onChange={(v) => setTweak('penWeight', v)} />
        <TweakToggle label="Wobbly corners" value={t.wobble}
          onChange={(v) => setTweak('wobble', v)} />

        <TweakSection label="Theme" />
        <TweakColor label="Accent" value={t.accent}
          options={['#5B8DEF','#7AB87E','#E89BB0','#F0B043','#9D7BE5','#2A2A2A']}
          onChange={(v) => setTweak('accent', v)} />
        <TweakRadio label="Density" value={t.density}
          options={['compact','regular','airy']}
          onChange={(v) => setTweak('density', v)} />
      </TweaksPanel>
    </>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);

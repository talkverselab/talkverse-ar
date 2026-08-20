// Vietnamese tone curve visualizer (6 tones)
// ngang (level), huyền (falling), sắc (rising), hỏi (dipping-rising), ngã (broken-rising), nặng (dropping)
const TONE_INK = '#1F3A6E';

const TONES = {
  ngang:  { label: 'ngang',  mark: '',  color: '#7FCBA4', path: 'M 8 32 L 56 32' },
  huyen:  { label: 'huyền',  mark: '\u0300', color: '#5B9BD5', path: 'M 8 22 Q 32 28, 56 42' },
  sac:    { label: 'sắc',    mark: '\u0301', color: '#FF8FB1', path: 'M 8 42 Q 32 38, 56 18' },
  hoi:    { label: 'hỏi',    mark: '\u0309', color: '#E5B4F5', path: 'M 8 26 Q 22 50, 32 46 Q 44 42, 56 22' },
  nga:    { label: 'ngã',    mark: '\u0303', color: '#FFB59C', path: 'M 8 36 Q 18 16, 28 36 Q 38 56, 48 24 Q 52 18, 56 14' },
  nang:   { label: 'nặng',   mark: '\u0323', color: '#7C5BC8', path: 'M 8 28 Q 28 30, 36 50' },
};

function ToneCurve({ tone = 'ngang', size = 64, showLabel = false, style = {} }) {
  const t = TONES[tone] || TONES.ngang;
  const w = size, h = size;
  return (
    <div style={{ display: 'inline-flex', flexDirection: 'column', alignItems: 'center', ...style }}>
      <svg width={w} height={h * 0.85} viewBox="0 0 64 56" fill="none" style={{display:'block'}}>
        {/* baseline grid */}
        <line x1="6" y1="14" x2="58" y2="14" stroke={TONE_INK} strokeWidth="0.6" opacity="0.15" strokeDasharray="2 2"/>
        <line x1="6" y1="32" x2="58" y2="32" stroke={TONE_INK} strokeWidth="0.6" opacity="0.25"/>
        <line x1="6" y1="50" x2="58" y2="50" stroke={TONE_INK} strokeWidth="0.6" opacity="0.15" strokeDasharray="2 2"/>
        {/* curve */}
        <path d={t.path} stroke={t.color} strokeWidth="3.5" strokeLinecap="round" fill="none"/>
        {/* start dot */}
        <circle cx="8" cy={t.path.match(/M\s*[\d.]+\s+([\d.]+)/)[1]} r="2.5" fill={t.color}/>
        {/* end dot */}
        {(() => {
          const m = t.path.match(/(\d+\.?\d*)\s+(\d+\.?\d*)\s*$/);
          return <circle cx={m[1]} cy={m[2]} r="2.5" fill={t.color}/>;
        })()}
      </svg>
      {showLabel && (
        <div style={{fontSize:9, fontWeight:800, color:TONE_INK, opacity:0.8, marginTop:2, fontFamily:'Be Vietnam Pro,sans-serif'}}>
          {t.mark || '·'} {t.label}
        </div>
      )}
    </div>
  );
}

window.ToneCurve = ToneCurve;
window.TONES = TONES;

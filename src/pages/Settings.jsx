import React, { useState } from 'react';
import { 
  Settings as SettingsIcon, 
  Globe, 
  Type, 
  Bell, 
  Volume2, 
  RotateCcw, 
  ShieldCheck, 
  Sparkles, 
  User, 
  CheckCircle2, 
  Sun,
  Moon,
  Layers
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { notificationService } from '../services/notificationService';
import { speechService } from '../services/speechService';

export const Settings = () => {
  const { 
    settings, 
    setLanguage, 
    toggleLargeText, 
    setGlassTheme,
    toggleGlassMode,
    resetToDemo, 
    emergencyProfile, 
    t 
  } = useApp();

  const [notificationTestStatus, setNotificationTestStatus] = useState(null);
  const [speechTestStatus, setSpeechTestStatus] = useState(null);

  const handleTestNotification = async () => {
    setNotificationTestStatus('Testing chime & notification...');
    const granted = await notificationService.requestPermission();
    notificationService.testSound();

    if (granted) {
      new Notification('MediNest Reminder Test 🔔', {
        body: 'Time to take Ketoconazole 200mg after lunch!',
        icon: '/favicon.ico'
      });
      setNotificationTestStatus('Notification & chime triggered successfully!');
    } else {
      setNotificationTestStatus('Audio chime played! (Enable browser notifications for banners)');
    }

    setTimeout(() => setNotificationTestStatus(null), 4000);
  };

  const handleTestSpeech = () => {
    setSpeechTestStatus('Speaking...');
    speechService.speak(
      `Hello ${emergencyProfile.userName}. MediNest voice alert system is working perfectly.`, 
      settings.language
    );
    setTimeout(() => setSpeechTestStatus(null), 3000);
  };

  const glassThemes = [
    {
      id: 'crystal',
      name: 'Crystal Glass',
      desc: 'Pure frosted translucency over delicate pastel aurora lights.',
      icon: Sparkles,
      previewBg: 'bg-gradient-to-tr from-white/90 to-emerald-50/80 text-emerald-700'
    },
    {
      id: 'vibrant',
      name: 'Vibrant Aurora',
      desc: 'Enhanced color refraction with rich glowing gradient orbs.',
      icon: Layers,
      previewBg: 'bg-gradient-to-tr from-sky-100/90 to-purple-100/80 text-sky-700'
    },
    {
      id: 'midnight',
      name: 'Midnight Dark Glass',
      desc: 'Deep obsidian translucent panels with vivid neon highlights.',
      icon: Moon,
      previewBg: 'bg-gradient-to-tr from-slate-900 to-slate-850 text-emerald-400'
    }
  ];

  return (
    <div className="space-y-6 pb-24 animate-fadeIn">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <SettingsIcon className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>{t('settings')}</span>
          </h1>
          <p className="text-slate-500 font-bold text-sm mt-1">
            Customize Glass Mode aesthetics, native languages, audible alarm notifications, and voice reader.
          </p>
        </div>

        <div className="glass-pill px-4 py-2 rounded-2xl flex items-center gap-2 text-xs font-black text-emerald-950 border border-emerald-300">
          <Sparkles className="w-4 h-4 text-emerald-600 animate-spin" style={{ animationDuration: '8s' }} />
          <span>Glass Engine Active</span>
        </div>
      </div>

      {/* 💎 Glass Mode Theme Showcase */}
      <div className="glass-panel rounded-3xl p-6 sm:p-7 border border-white/90 shadow-sm space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-200/50 pb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/20">
              <Sparkles className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base sm:text-lg font-black text-slate-900">Glass Mode Aesthetics & Refraction</h2>
              <p className="text-xs text-slate-500 font-bold">Select your preferred liquid frosted glass theme</p>
            </div>
          </div>

          <label className="flex items-center gap-2.5 cursor-pointer glass-pill px-3.5 py-1.5 rounded-2xl border border-emerald-300">
            <span className="text-xs font-black text-slate-800">Glass Effect:</span>
            <input
              type="checkbox"
              checked={settings.glassMode !== false}
              onChange={toggleGlassMode}
              className="w-4 h-4 accent-emerald-600 rounded cursor-pointer"
            />
            <span className="text-xs font-black text-emerald-700">{settings.glassMode !== false ? 'Enabled' : 'Disabled'}</span>
          </label>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-3.5 pt-1">
          {glassThemes.map((th) => {
            const Icon = th.icon;
            const isSelected = (settings.glassTheme || 'crystal') === th.id;
            return (
              <button
                key={th.id}
                onClick={() => setGlassTheme(th.id)}
                className={`btn-reactive text-left p-4 rounded-2xl border transition-all cursor-pointer flex flex-col justify-between ${
                  isSelected
                    ? 'glass-card border-emerald-400 ring-2 ring-emerald-500/30 shadow-md shadow-emerald-500/10'
                    : 'glass-card border-white/80 hover:border-slate-300'
                }`}
              >
                <div>
                  <div className="flex items-center justify-between mb-2.5">
                    <div className={`w-9 h-9 rounded-xl flex items-center justify-center font-black ${th.previewBg} shadow-xs border border-white/50`}>
                      <Icon className="w-4 h-4" />
                    </div>
                    {isSelected && (
                      <span className="flex items-center gap-1 text-[11px] font-black text-emerald-800 bg-emerald-100/90 px-2.5 py-0.5 rounded-full border border-emerald-300">
                        <CheckCircle2 className="w-3 h-3 text-emerald-700" /> Active
                      </span>
                    )}
                  </div>
                  <h3 className="font-black text-sm text-slate-900 tracking-tight">{th.name}</h3>
                  <p className="text-xs text-slate-500 font-bold mt-1 leading-snug">{th.desc}</p>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Main Settings Sections */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {/* Language Selection */}
        <div className="glass-card rounded-3xl border border-white/90 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-sky-500 to-cyan-400 text-white flex items-center justify-center font-black shadow-md shadow-sky-500/20">
              <Globe className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Application Language</h2>
              <p className="text-xs text-slate-500 font-bold">Select your preferred native language</p>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-2.5 pt-2">
            {[
              { id: 'en', label: 'English', sub: 'Default' },
              { id: 'te', label: 'తెలుగు', sub: 'Telugu' },
              { id: 'hi', label: 'हिंदी', sub: 'Hindi' },
            ].map((lang) => (
              <button
                key={lang.id}
                onClick={() => setLanguage(lang.id)}
                className={`btn-reactive p-3 rounded-2xl border text-center transition-all cursor-pointer ${
                  settings.language === lang.id
                    ? 'border-emerald-500 bg-emerald-100/80 text-emerald-950 ring-2 ring-emerald-500/20 shadow-sm font-black'
                    : 'glass-card border-white/90 hover:bg-white text-slate-700 font-bold'
                }`}
              >
                <div className="text-base">{lang.label}</div>
                <div className="text-[10px] text-slate-500 mt-0.5 font-bold">{lang.sub}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Accessibility & Readability */}
        <div className="glass-card rounded-3xl border border-white/90 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center font-black shadow-md shadow-emerald-500/20">
              <Type className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Accessibility & Readability</h2>
              <p className="text-xs text-slate-500 font-bold">Elderly friendly typography and contrast</p>
            </div>
          </div>

          <div className="pt-2">
            <label className="btn-reactive flex items-center justify-between p-3.5 rounded-2xl glass-panel border border-white/90 hover:border-emerald-300 cursor-pointer transition-colors">
              <div>
                <span className="font-extrabold text-slate-900 text-sm block">Large Text Mode</span>
                <span className="text-xs text-slate-500 font-medium">Increases font sizes across all buttons, cards, and labels</span>
              </div>
              <input
                type="checkbox"
                checked={settings.largeText}
                onChange={toggleLargeText}
                className="w-5 h-5 accent-emerald-600 rounded cursor-pointer"
              />
            </label>
          </div>
        </div>

        {/* Sound & Notifications */}
        <div className="glass-card rounded-3xl border border-white/90 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-amber-500 to-orange-400 text-white flex items-center justify-center font-black shadow-md shadow-amber-500/20">
              <Bell className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Audio Alarm & Chimes</h2>
              <p className="text-xs text-slate-500 font-bold">Web Audio API medical reminder sound</p>
            </div>
          </div>

          <div className="space-y-3 pt-2">
            <button
              onClick={handleTestNotification}
              className="btn-reactive w-full py-3 px-4 rounded-2xl bg-amber-50/90 border border-amber-300 text-amber-950 hover:bg-amber-100 font-black text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer shadow-sm"
            >
              <Bell className="w-4 h-4 text-amber-600" />
              <span>Test Audio Alarm Chime</span>
            </button>

            {notificationTestStatus && (
              <p className="text-xs font-black text-center text-amber-900 bg-amber-100/80 py-1.5 rounded-xl border border-amber-300">
                {notificationTestStatus}
              </p>
            )}
          </div>
        </div>

        {/* Voice Reader (TTS) */}
        <div className="glass-card rounded-3xl border border-white/90 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-indigo-500 to-violet-400 text-white flex items-center justify-center font-black shadow-md shadow-indigo-500/20">
              <Volume2 className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Voice Assistance (TTS)</h2>
              <p className="text-xs text-slate-500 font-bold">Reads doses aloud in selected language</p>
            </div>
          </div>

          <div className="space-y-3 pt-2">
            <button
              onClick={handleTestSpeech}
              className="btn-reactive w-full py-3 px-4 rounded-2xl bg-indigo-50/90 border border-indigo-300 text-indigo-950 hover:bg-indigo-100 font-black text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer shadow-sm"
            >
              <Volume2 className="w-4 h-4 text-indigo-600" />
              <span>{speechTestStatus || 'Test Voice Reader Aloud'}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Patient Profile & Data Management */}
      <div className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-8 shadow-sm space-y-6">
        <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <User className="w-5 h-5 text-emerald-600" />
          Active Profile & Data Storage
        </h2>

        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 rounded-2xl glass-card border border-white/90 gap-4">
          <div>
            <div className="font-black text-slate-900 text-sm">
              Patient: {emergencyProfile.userName || 'Profile'} ({emergencyProfile.bloodGroup || 'Blood: Not Set'})
            </div>
            <div className="text-xs text-slate-500 font-bold mt-0.5">
              All data is stored offline in your browser's persistent localStorage.
            </div>
          </div>

          <button
            onClick={() => {
              if (window.confirm('Reset all medicines and appointments back to demo prescriptions?')) {
                resetToDemo();
              }
            }}
            className="btn-reactive flex items-center gap-2 px-4 py-2.5 rounded-xl border border-red-200 text-red-600 hover:bg-red-50 font-black text-xs shrink-0 transition-colors cursor-pointer shadow-xs"
          >
            <RotateCcw className="w-4 h-4" />
            <span>Reset Demo Data</span>
          </button>
        </div>

        {/* Application Info Footer */}
        <div className="pt-4 border-t border-slate-200/50 flex flex-col sm:flex-row sm:items-center justify-between text-xs text-slate-500 font-bold gap-2">
          <div className="flex items-center gap-1.5">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>MediNest Health Suite v2.0 • Ultra Glass Mode</span>
          </div>
          <div>Responsive Web Application (Desktop • Tablet • Mobile)</div>
        </div>
      </div>
    </div>
  );
};

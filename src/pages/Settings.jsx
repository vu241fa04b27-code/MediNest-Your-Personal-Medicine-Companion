import React, { useState } from 'react';
import { 
  Settings as SettingsIcon, 
  Globe, 
  Type, 
  Bell, 
  Volume2, 
  RotateCcw, 
  ShieldCheck, 
  Heart, 
  User, 
  CheckCircle2, 
  Smartphone,
  Info
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { notificationService } from '../services/notificationService';
import { speechService } from '../services/speechService';

export const Settings = () => {
  const { 
    settings, 
    setLanguage, 
    toggleLargeText, 
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

  return (
    <div className="space-y-6 pb-20">
      {/* Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
          <SettingsIcon className="w-8 h-8 text-emerald-600" />
          {t('settings')}
        </h1>
        <p className="text-slate-500 font-medium text-sm mt-1">
          Customize languages, accessibility, audible alarm notifications, and voice reader.
        </p>
      </div>

      {/* Main Settings Sections */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Language Selection */}
        <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold">
              <Globe className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Application Language</h2>
              <p className="text-xs text-slate-500 font-medium">Select your preferred native language</p>
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
                className={`p-3 rounded-2xl border text-center transition-all ${
                  settings.language === lang.id
                    ? 'border-emerald-600 bg-emerald-50 text-emerald-800 ring-2 ring-emerald-500/20 shadow-sm font-black'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700 font-bold'
                }`}
              >
                <div className="text-base">{lang.label}</div>
                <div className="text-[10px] text-slate-400 mt-0.5">{lang.sub}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Accessibility & Readability */}
        <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">
              <Type className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Accessibility & Readability</h2>
              <p className="text-xs text-slate-500 font-medium">Elderly friendly typography and contrast</p>
            </div>
          </div>

          <div className="pt-2">
            <label className="flex items-center justify-between p-3.5 rounded-2xl border border-slate-200 hover:bg-slate-50 cursor-pointer transition-colors">
              <div>
                <span className="font-extrabold text-slate-800 text-sm block">Large Text Mode</span>
                <span className="text-xs text-slate-500">Increases font sizes across all buttons, cards, and labels</span>
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
        <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold">
              <Bell className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Audio Alarm & Chimes</h2>
              <p className="text-xs text-slate-500 font-medium">Web Audio API medical reminder sound</p>
            </div>
          </div>

          <div className="space-y-3 pt-2">
            <button
              onClick={handleTestNotification}
              className="w-full py-3 px-4 rounded-2xl bg-amber-50 border border-amber-200 text-amber-900 hover:bg-amber-100 font-extrabold text-sm flex items-center justify-center gap-2 transition-colors"
            >
              <Bell className="w-4 h-4 text-amber-600" />
              <span>Test Audio Alarm Chime</span>
            </button>

            {notificationTestStatus && (
              <p className="text-xs font-bold text-center text-amber-700 bg-amber-50/50 py-1 rounded-lg">
                {notificationTestStatus}
              </p>
            )}
          </div>
        </div>

        {/* Voice Reader (TTS) */}
        <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold">
              <Volume2 className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Voice Assistance (TTS)</h2>
              <p className="text-xs text-slate-500 font-medium">Reads doses aloud in selected language</p>
            </div>
          </div>

          <div className="space-y-3 pt-2">
            <button
              onClick={handleTestSpeech}
              className="w-full py-3 px-4 rounded-2xl bg-indigo-50 border border-indigo-200 text-indigo-900 hover:bg-indigo-100 font-extrabold text-sm flex items-center justify-center gap-2 transition-colors"
            >
              <Volume2 className="w-4 h-4 text-indigo-600" />
              <span>{speechTestStatus || 'Test Voice Reader Aloud'}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Patient Profile & Data Management */}
      <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-6">
        <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <User className="w-5 h-5 text-emerald-600" />
          Active Profile & Data Storage
        </h2>

        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 rounded-2xl bg-slate-50 border border-slate-200 gap-4">
          <div>
            <div className="font-extrabold text-slate-900 text-sm">
              Patient: {emergencyProfile.userName} ({emergencyProfile.bloodGroup})
            </div>
            <div className="text-xs text-slate-500 mt-0.5">
              All data is stored offline in your browser's persistent localStorage.
            </div>
          </div>

          <button
            onClick={() => {
              if (window.confirm('Reset all medicines and appointments back to Ammu\'s initial prescriptions?')) {
                resetToDemo();
              }
            }}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl border border-red-200 text-red-600 hover:bg-red-50 font-bold text-xs shrink-0 transition-colors"
          >
            <RotateCcw className="w-4 h-4" />
            <span>Reset Demo Data</span>
          </button>
        </div>

        {/* Application Info Footer */}
        <div className="pt-4 border-t border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between text-xs text-slate-400 gap-2">
          <div className="flex items-center gap-1.5 font-bold">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>MediNest Health Suite v2.0 • Offline Ready</span>
          </div>
          <div>Responsive Web Application (Desktop • Tablet • Mobile)</div>
        </div>
      </div>
    </div>
  );
};

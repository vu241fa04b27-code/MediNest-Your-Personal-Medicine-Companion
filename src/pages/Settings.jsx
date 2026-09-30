import React, { useState } from 'react';
import {
  Settings as SettingsIcon,
  Globe,
  Type,
  Bell,
  Volume2,
  RotateCcw,
  ShieldCheck,
  User,
  CheckCircle2,
  Clock,
  Building2,
  Phone,
  MapPin,
  Save
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { notificationService } from '../services/notificationService';
import { speechService } from '../services/speechService';

export const Settings = () => {
  const {
    settings,
    setLanguage,
    toggleLargeText,
    setSnoozeMinutes,
    resetToDemo,
    emergencyProfile,
    hospitalInfo,
    updateHospitalInfo,
    t
  } = useApp();

  const [notificationTestStatus, setNotificationTestStatus] = useState(null);
  const [speechTestStatus, setSpeechTestStatus] = useState(null);
  const [hospitalForm, setHospitalForm] = useState({ ...hospitalInfo });
  const [hospitalSaved, setHospitalSaved] = useState(false);

  const handleTestNotification = async () => {
    setNotificationTestStatus('Testing chime & notification...');
    const granted = await notificationService.requestPermission();
    notificationService.testSound();
    if (granted) {
      new Notification('MediNest Reminder Test 🔔', {
        body: 'Time to take your scheduled medicine!',
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
      `Hello ${emergencyProfile.userName || 'there'}. MediNest voice alert system is working perfectly.`,
      settings.language
    );
    setTimeout(() => setSpeechTestStatus(null), 3000);
  };

  const handleSaveHospital = (e) => {
    e.preventDefault();
    updateHospitalInfo(hospitalForm);
    setHospitalSaved(true);
    setTimeout(() => setHospitalSaved(false), 2500);
  };

  return (
    <div className="space-y-6 pb-24 animate-fadeIn">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-slate-200 shadow-sm">
        <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
            <SettingsIcon className="w-5 h-5 stroke-[2.5]" />
          </div>
          <span>{t('settings')}</span>
        </h1>
        <p className="text-slate-500 font-bold text-sm mt-1">
          Customize language, accessibility, reminders, and hospital information.
        </p>
      </div>

      {/* Language & Accessibility side by side */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {/* Language */}
        <div className="glass-card rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-sky-500 to-cyan-400 text-white flex items-center justify-center shadow-md shadow-sky-500/20">
              <Globe className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Application Language</h2>
              <p className="text-xs text-slate-500 font-bold">Select your preferred native language</p>
            </div>
          </div>
          <div className="grid grid-cols-3 gap-2.5 pt-1">
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
                    ? 'border-emerald-500 bg-emerald-50 text-emerald-950 ring-2 ring-emerald-500/20 shadow-sm font-black'
                    : 'glass-card border-slate-200 hover:bg-slate-50 text-slate-700 font-bold'
                }`}
              >
                <div className="text-base">{lang.label}</div>
                <div className="text-[10px] text-slate-500 mt-0.5 font-bold">{lang.sub}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Accessibility */}
        <div className="glass-card rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/20">
              <Type className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Accessibility & Readability</h2>
              <p className="text-xs text-slate-500 font-bold">Elderly-friendly typography settings</p>
            </div>
          </div>
          <label className="btn-reactive flex items-center justify-between p-3.5 rounded-2xl bg-slate-50 border border-slate-200 hover:border-emerald-300 cursor-pointer transition-colors">
            <div>
              <span className="font-extrabold text-slate-900 text-sm block">Large Text Mode</span>
              <span className="text-xs text-slate-500 font-medium">Increases font sizes across all buttons and cards</span>
            </div>
            <input
              type="checkbox"
              checked={settings.largeText}
              onChange={toggleLargeText}
              className="w-5 h-5 accent-emerald-600 rounded cursor-pointer"
            />
          </label>
        </div>

        {/* Audio Alarm */}
        <div className="glass-card rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-amber-500 to-orange-400 text-white flex items-center justify-center shadow-md shadow-amber-500/20">
              <Bell className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Audio Alarm & Chimes</h2>
              <p className="text-xs text-slate-500 font-bold">Medicine reminder sound via Web Audio</p>
            </div>
          </div>
          <div className="space-y-3 pt-1">
            <button
              onClick={handleTestNotification}
              className="btn-reactive w-full py-3 px-4 rounded-2xl bg-amber-50 border border-amber-300 text-amber-950 hover:bg-amber-100 font-black text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer shadow-sm"
            >
              <Bell className="w-4 h-4 text-amber-600" />
              <span>Test Audio Alarm Chime</span>
            </button>
            {notificationTestStatus && (
              <p className="text-xs font-black text-center text-amber-900 bg-amber-50 py-1.5 rounded-xl border border-amber-300">
                {notificationTestStatus}
              </p>
            )}
          </div>
        </div>

        {/* Voice Reader */}
        <div className="glass-card rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-indigo-500 to-violet-400 text-white flex items-center justify-center shadow-md shadow-indigo-500/20">
              <Volume2 className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Voice Assistance (TTS)</h2>
              <p className="text-xs text-slate-500 font-bold">Reads doses aloud in selected language</p>
            </div>
          </div>
          <div className="space-y-3 pt-1">
            <button
              onClick={handleTestSpeech}
              className="btn-reactive w-full py-3 px-4 rounded-2xl bg-indigo-50 border border-indigo-300 text-indigo-950 hover:bg-indigo-100 font-black text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer shadow-sm"
            >
              <Volume2 className="w-4 h-4 text-indigo-600" />
              <span>{speechTestStatus || 'Test Voice Reader Aloud'}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Snooze Duration */}
      <div className="glass-panel rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-sm space-y-4">
        <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-purple-500 to-violet-400 text-white flex items-center justify-center shadow-md shadow-purple-500/20">
            <Clock className="w-5 h-5 stroke-[2.2]" />
          </div>
          <div>
            <h2 className="text-base font-black text-slate-900">Snooze Duration</h2>
            <p className="text-xs text-slate-500 font-bold">How long to wait before re-alerting after snooze</p>
          </div>
        </div>
        <div className="flex flex-wrap gap-3 pt-1">
          {[5, 10, 15, 20, 30].map((mins) => (
            <button
              key={mins}
              onClick={() => setSnoozeMinutes(mins)}
              className={`btn-reactive px-5 py-2.5 rounded-2xl border font-black text-sm transition-all cursor-pointer ${
                (settings.snoozeMinutes || 10) === mins
                  ? 'bg-purple-600 text-white border-purple-700 shadow-md shadow-purple-500/25'
                  : 'bg-white text-slate-700 border-slate-200 hover:border-purple-300 hover:bg-purple-50'
              }`}
            >
              {mins} min
            </button>
          ))}
        </div>
        <p className="text-xs text-slate-500 font-bold pt-1">
          Currently set to <span className="text-purple-700 font-black">{settings.snoozeMinutes || 10} minutes</span>
        </p>
      </div>

      {/* Hospital Information Editor */}
      <div className="glass-panel rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-sm space-y-5">
        <div className="flex items-center justify-between border-b border-slate-100 pb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center shadow-md shadow-blue-500/20">
              <Building2 className="w-5 h-5 stroke-[2.2]" />
            </div>
            <div>
              <h2 className="text-base font-black text-slate-900">Hospital Information</h2>
              <p className="text-xs text-slate-500 font-bold">Used in Hospital Tracker, GPS navigation, and Emergency card</p>
            </div>
          </div>
          {hospitalSaved && (
            <span className="flex items-center gap-1.5 text-xs font-black text-emerald-800 bg-emerald-50 border border-emerald-300 px-3 py-1 rounded-full">
              <CheckCircle2 className="w-3.5 h-3.5" /> Saved!
            </span>
          )}
        </div>

        <form onSubmit={handleSaveHospital} className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div className="sm:col-span-2">
            <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
              Hospital Name
            </label>
            <input
              type="text"
              value={hospitalForm.name}
              onChange={(e) => setHospitalForm(p => ({ ...p, name: e.target.value }))}
              placeholder="e.g. Apollo Hospitals, AIIMS Hyderabad"
              className="glass-input w-full rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 outline-none"
            />
          </div>

          <div className="sm:col-span-2">
            <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
              <MapPin className="w-3.5 h-3.5 inline mr-1 text-slate-500" />
              Address (for GPS navigation)
            </label>
            <input
              type="text"
              value={hospitalForm.address}
              onChange={(e) => setHospitalForm(p => ({ ...p, address: e.target.value }))}
              placeholder="e.g. Jubilee Hills, Hyderabad, Telangana"
              className="glass-input w-full rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
              <Phone className="w-3.5 h-3.5 inline mr-1 text-slate-500" />
              Reception Phone
            </label>
            <input
              type="tel"
              value={hospitalForm.phone}
              onChange={(e) => setHospitalForm(p => ({ ...p, phone: e.target.value }))}
              placeholder="+91 40 2345 6789"
              className="glass-input w-full rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
              <Phone className="w-3.5 h-3.5 inline mr-1 text-red-500" />
              Emergency Phone (24x7)
            </label>
            <input
              type="tel"
              value={hospitalForm.emergencyPhone}
              onChange={(e) => setHospitalForm(p => ({ ...p, emergencyPhone: e.target.value }))}
              placeholder="108"
              className="glass-input w-full rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
              Working Hours
            </label>
            <input
              type="text"
              value={hospitalForm.workingHours}
              onChange={(e) => setHospitalForm(p => ({ ...p, workingHours: e.target.value }))}
              placeholder="e.g. Mon–Sat 8 AM – 8 PM, 24x7 Emergency"
              className="glass-input w-full rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 outline-none"
            />
          </div>

          <div className="sm:col-span-2 flex justify-end pt-2">
            <button
              type="submit"
              className="btn-reactive btn-glow-blue flex items-center gap-2 px-6 py-3 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm shadow-md shadow-blue-500/20 cursor-pointer border border-white/20"
            >
              <Save className="w-4 h-4" />
              <span>Save Hospital Info</span>
            </button>
          </div>
        </form>
      </div>

      {/* Patient Profile & Data Management */}
      <div className="glass-panel rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-5">
        <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <User className="w-5 h-5 text-emerald-600" />
          Active Profile & Data Storage
        </h2>

        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 rounded-2xl bg-slate-50 border border-slate-200 gap-4">
          <div>
            <div className="font-black text-slate-900 text-sm">
              Patient: {emergencyProfile.userName || 'Profile'} ({emergencyProfile.bloodGroup || 'Blood: Not Set'})
            </div>
            <div className="text-xs text-slate-500 font-bold mt-0.5">
              All data is stored offline in your browser's persistent localStorage. No internet required.
            </div>
          </div>
          <button
            onClick={() => {
              if (window.confirm('This will permanently clear ALL medicines, appointments, journal entries, and settings. Continue?')) {
                resetToDemo();
              }
            }}
            className="btn-reactive flex items-center gap-2 px-4 py-2.5 rounded-xl border border-red-200 text-red-600 hover:bg-red-50 font-black text-xs shrink-0 transition-colors cursor-pointer"
          >
            <RotateCcw className="w-4 h-4" />
            <span>Clear All Data</span>
          </button>
        </div>

        <div className="pt-2 border-t border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between text-xs text-slate-500 font-bold gap-2">
          <div className="flex items-center gap-1.5">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>MediNest Health Suite v2.0 • Light Mode</span>
          </div>
          <div>Responsive Web App (Desktop • Tablet • Mobile)</div>
        </div>
      </div>
    </div>
  );
};

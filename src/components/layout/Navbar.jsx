import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Pill, Volume2, AlertTriangle, Globe } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { speechService } from '../../services/speechService';

export const Navbar = () => {
  const { t, settings, setLanguage, nextMedicine, totalDoses, takenDoses, emergencyProfile } = useApp();
  const location = useLocation();

  const handleVoiceRead = () => {
    const name = emergencyProfile.userName || 'there';
    const text = `Hello ${name}. You have ${totalDoses} medicine doses scheduled today. You have completed ${takenDoses}. ${nextMedicine ? `Your next medicine is ${nextMedicine.name} at ${nextMedicine.time}.` : 'All scheduled doses are taken!'}`;
    speechService.speak(text, settings.language);
  };

  return (
    <header className="sticky top-0 z-40 bg-white/80 backdrop-blur-xl border-b border-white/80 shadow-[0_4px_24px_-4px_rgba(15,23,42,0.04)] px-4 sm:px-6 lg:px-8 py-3 transition-all no-print">
      <div className="flex items-center justify-between max-w-7xl mx-auto">
        {/* Brand Logo with Reactive Hover */}
        <Link to="/" className="flex items-center gap-3 group btn-reactive">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25 group-hover:shadow-emerald-500/40 group-hover:scale-105 transition-all">
            <Pill className="w-5 h-5 stroke-[2.5]" />
          </div>
          <div>
            <div className="text-xl sm:text-2xl font-black tracking-tight flex items-center">
              <span className="text-emerald-700">Medi</span>
              <span className="text-sky-600">Nest</span>
            </div>
            <p className="text-[11px] font-bold text-slate-500 hidden sm:block tracking-tight">
              {t('tagline')}
            </p>
          </div>
        </Link>

        {/* Right Actions */}
        <div className="flex items-center gap-2 sm:gap-3">
          {/* Voice Reader Button (Reactive with Glow) */}
          <button
            onClick={handleVoiceRead}
            className="btn-reactive btn-glow-blue flex items-center gap-2 px-3.5 py-2 rounded-2xl text-sky-900 bg-sky-50/90 hover:bg-sky-100 border border-sky-200/90 font-black text-xs sm:text-sm shadow-sm transition-all cursor-pointer"
            title="Read Schedule Aloud"
          >
            <Volume2 className="w-4 h-4 text-sky-600 stroke-[2.5]" />
            <span className="hidden md:inline">{t('voice_read')}</span>
          </button>

          {/* Language Selector Glass Pill */}
          <div className="relative flex items-center bg-white/70 backdrop-blur-md rounded-2xl border border-slate-200/90 p-1 shadow-sm hover:border-slate-300 transition-colors">
            <Globe className="w-4 h-4 text-slate-600 ml-2 hidden sm:block stroke-[2.2]" />
            <select
              value={settings.language}
              onChange={(e) => setLanguage(e.target.value)}
              className="bg-transparent text-xs sm:text-sm font-black text-slate-800 py-1 px-2.5 outline-none cursor-pointer"
            >
              <option value="en">English (EN)</option>
              <option value="te">తెలుగు (Telugu)</option>
              <option value="hi">हिंदी (Hindi)</option>
            </select>
          </div>

          {/* Emergency Card Reactive Button */}
          <Link
            to="/emergency"
            className="btn-reactive btn-glow-red flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-gradient-to-r from-red-600 to-rose-600 text-white font-black text-xs sm:text-sm shadow-md shadow-red-500/30 transition-all cursor-pointer"
          >
            <AlertTriangle className="w-4 h-4 text-white animate-pulse" />
            <span className="hidden sm:inline">{t('emergency_card')}</span>
            <span className="sm:hidden font-black">SOS</span>
          </Link>
        </div>
      </div>
    </header>
  );
};

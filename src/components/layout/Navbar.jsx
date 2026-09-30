import React, { useState, useEffect } from 'react';
import { Link, NavLink, useLocation } from 'react-router-dom';
import {
  Pill,
  Volume2,
  AlertTriangle,
  Globe,
  Menu,
  X,
  Home,
  PlusCircle,
  CalendarClock,
  UserCheck,
  BookHeart,
  History,
  FileText,
  Settings,
  ChevronRight
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { speechService } from '../../services/speechService';

export const Navbar = () => {
  const {
    t,
    settings,
    setLanguage,
    nextMedicine,
    totalDoses,
    takenDoses,
    emergencyProfile
  } = useApp();

  const [menuOpen, setMenuOpen] = useState(false);
  const location = useLocation();

  // Close menu on route change
  useEffect(() => {
    setMenuOpen(false);
  }, [location.pathname]);

  // Prevent body scroll when menu open
  useEffect(() => {
    if (menuOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => { document.body.style.overflow = ''; };
  }, [menuOpen]);

  const handleVoiceRead = () => {
    const name = emergencyProfile.userName || 'there';
    const text = `Hello ${name}. You have ${totalDoses} medicine doses scheduled today. You have completed ${takenDoses}. ${nextMedicine ? `Your next medicine is ${nextMedicine.name} at ${nextMedicine.time}.` : 'All scheduled doses are taken!'}`;
    speechService.speak(text, settings.language);
    setMenuOpen(false);
  };

  const allNavItems = [
    { to: '/', icon: Home, label: 'Home', color: 'text-emerald-600', bg: 'bg-emerald-50' },
    { to: '/medicines', icon: Pill, label: 'Medicines', color: 'text-sky-600', bg: 'bg-sky-50' },
    { to: '/add-medicine', icon: PlusCircle, label: 'Add Medicine', color: 'text-teal-600', bg: 'bg-teal-50' },
    { to: '/hospital', icon: CalendarClock, label: 'Hospital Tracker', color: 'text-blue-600', bg: 'bg-blue-50' },
    { to: '/doctor', icon: UserCheck, label: 'Doctor Directory', color: 'text-indigo-600', bg: 'bg-indigo-50' },
    { to: '/journal', icon: BookHeart, label: 'Daily Health Diary', color: 'text-pink-600', bg: 'bg-pink-50' },
    { to: '/history', icon: History, label: 'History & Adherence', color: 'text-amber-600', bg: 'bg-amber-50' },
    { to: '/reports', icon: FileText, label: 'Clinical Reports', color: 'text-purple-600', bg: 'bg-purple-50' },
    { to: '/settings', icon: Settings, label: 'Settings', color: 'text-slate-600', bg: 'bg-slate-100' },
  ];

  return (
    <>
      <header className="sticky top-0 z-50 bg-white border-b border-slate-200 shadow-sm no-print">
        <div className="flex items-center justify-between px-3 sm:px-6 lg:px-8 py-3 max-w-7xl mx-auto">

          {/* LEFT: Hamburger (mobile only) + Brand */}
          <div className="flex items-center gap-2">
            {/* Hamburger — visible only below lg */}
            <button
              onClick={() => setMenuOpen(true)}
              className="lg:hidden flex items-center justify-center w-10 h-10 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 hover:bg-emerald-100 transition-colors cursor-pointer shrink-0"
              aria-label="Open navigation menu"
            >
              <Menu className="w-5 h-5 stroke-[2.5]" />
            </button>

            {/* Brand Logo */}
            <Link to="/" className="flex items-center gap-2.5 group">
              <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25 shrink-0">
                <Pill className="w-4 h-4 sm:w-5 sm:h-5 stroke-[2.5]" />
              </div>
              <div>
                <div className="text-lg sm:text-2xl font-black tracking-tight flex items-center gap-1.5">
                  <span className="text-emerald-700">Medi</span>
                  <span className="text-sky-600">Nest</span>
                  <span className="hidden sm:inline-flex items-center text-[10px] font-black uppercase tracking-wider bg-emerald-50 text-emerald-800 border border-emerald-200 px-2 py-0.5 rounded-full">
                    Health App
                  </span>
                </div>
                <p className="text-[10px] font-bold text-slate-500 hidden sm:block">
                  {t('tagline')}
                </p>
              </div>
            </Link>
          </div>

          {/* RIGHT: Voice + Language + Emergency */}
          <div className="flex items-center gap-1.5 sm:gap-2.5">
            {/* Voice Reader — hide label on small screens */}
            <button
              onClick={handleVoiceRead}
              className="flex items-center justify-center w-9 h-9 sm:w-auto sm:h-auto sm:px-3 sm:py-2 sm:gap-1.5 rounded-xl sm:rounded-2xl text-sky-900 bg-sky-50 hover:bg-sky-100 border border-sky-200 transition-all cursor-pointer"
              title="Read schedule aloud"
            >
              <Volume2 className="w-4 h-4 text-sky-600 stroke-[2.5]" />
              <span className="hidden xl:inline text-xs font-black">{t('voice_read')}</span>
            </button>

            {/* Language Selector */}
            <div className="flex items-center bg-white rounded-xl border border-slate-200 shadow-sm">
              <Globe className="w-3.5 h-3.5 text-slate-500 ml-1.5 hidden sm:block" />
              <select
                value={settings.language}
                onChange={(e) => setLanguage(e.target.value)}
                className="bg-transparent text-xs font-black text-slate-800 py-1.5 px-1.5 sm:px-2 outline-none cursor-pointer"
              >
                <option value="en">EN</option>
                <option value="te">తె</option>
                <option value="hi">हि</option>
              </select>
            </div>

            {/* Emergency SOS */}
            <Link
              to="/emergency"
              className="flex items-center gap-1.5 px-2.5 sm:px-4 py-2 sm:py-2.5 rounded-xl sm:rounded-2xl bg-gradient-to-r from-red-600 to-rose-600 text-white font-black text-xs shadow-md shadow-red-500/25 cursor-pointer"
            >
              <AlertTriangle className="w-3.5 h-3.5 sm:w-4 sm:h-4 animate-pulse" />
              <span className="hidden xs:inline sm:inline">{t('emergency_card')}</span>
              <span className="sm:hidden text-[11px] font-black">SOS</span>
            </Link>
          </div>
        </div>
      </header>

      {/* ============================================================ */}
      {/* MOBILE NAVIGATION DRAWER — full-height slide-in from left    */}
      {/* ============================================================ */}

      {/* Backdrop */}
      {menuOpen && (
        <div
          className="fixed inset-0 z-[60] bg-slate-900/50"
          onClick={() => setMenuOpen(false)}
          aria-label="Close menu"
        />
      )}

      {/* Drawer Panel */}
      <div
        className={`fixed top-0 left-0 h-full w-[300px] max-w-[85vw] z-[70] bg-white shadow-2xl flex flex-col transition-transform duration-300 ease-in-out ${
          menuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {/* Drawer Header */}
        <div className="flex items-center justify-between px-4 py-4 border-b border-slate-200 bg-gradient-to-r from-emerald-600 to-teal-500 shrink-0">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-white/20 flex items-center justify-center">
              <Pill className="w-5 h-5 text-white stroke-[2.5]" />
            </div>
            <div>
              <div className="text-lg font-black text-white">MediNest</div>
              <div className="text-[11px] text-emerald-100 font-bold">Health App</div>
            </div>
          </div>
          <button
            onClick={() => setMenuOpen(false)}
            className="w-9 h-9 rounded-xl bg-white/20 hover:bg-white/30 flex items-center justify-center text-white cursor-pointer transition-colors"
            aria-label="Close menu"
          >
            <X className="w-5 h-5 stroke-[2.5]" />
          </button>
        </div>

        {/* Patient chip */}
        {emergencyProfile.userName && (
          <div className="mx-4 mt-3 px-3 py-2 rounded-xl bg-emerald-50 border border-emerald-200 flex items-center gap-2.5 shrink-0">
            <span className="text-lg">🌸</span>
            <div>
              <div className="text-xs font-black text-slate-900">{emergencyProfile.userName}</div>
              <div className="text-[10px] font-bold text-red-600">{emergencyProfile.bloodGroup || 'Blood: Not Set'}</div>
            </div>
          </div>
        )}

        {/* Nav Items — scrollable */}
        <nav className="flex-1 overflow-y-auto py-3 px-3 space-y-1">
          {allNavItems.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                onClick={() => setMenuOpen(false)}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-3.5 rounded-2xl font-black text-sm transition-all ${
                    isActive
                      ? 'bg-gradient-to-r from-emerald-500 to-teal-400 text-white shadow-md shadow-emerald-500/25'
                      : 'text-slate-700 hover:bg-slate-50 active:bg-slate-100'
                  }`
                }
              >
                {({ isActive }) => (
                  <>
                    <div className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 ${isActive ? 'bg-white/25' : item.bg}`}>
                      <Icon className={`w-4 h-4 stroke-[2.3] ${isActive ? 'text-white' : item.color}`} />
                    </div>
                    <span className="flex-1 leading-tight">{item.label}</span>
                    {!isActive && <ChevronRight className="w-4 h-4 text-slate-300 shrink-0" />}
                  </>
                )}
              </NavLink>
            );
          })}
        </nav>

        {/* Emergency button at bottom of drawer */}
        <div className="px-4 py-4 border-t border-slate-200 shrink-0">
          <Link
            to="/emergency"
            onClick={() => setMenuOpen(false)}
            className="flex items-center justify-center gap-2 w-full py-3.5 rounded-2xl bg-gradient-to-r from-red-600 to-rose-500 text-white font-black text-sm shadow-md shadow-red-500/20"
          >
            <AlertTriangle className="w-4 h-4 animate-pulse" />
            <span>Emergency SOS Card</span>
          </Link>
        </div>
      </div>
    </>
  );
};

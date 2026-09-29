import React from 'react';
import { NavLink } from 'react-router-dom';
import { 
  Home, 
  Pill, 
  PlusCircle, 
  CalendarClock, 
  UserCheck, 
  BookHeart, 
  History, 
  FileText, 
  Settings, 
  AlertCircle 
} from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const Sidebar = () => {
  const { t, emergencyProfile } = useApp();

  const navItems = [
    { to: '/', icon: Home, label: t('nav_home') },
    { to: '/medicines', icon: Pill, label: t('nav_medicines') },
    { to: '/add-medicine', icon: PlusCircle, label: t('add_medicine') },
    { to: '/hospital', icon: CalendarClock, label: t('hospital_tracker') },
    { to: '/doctor', icon: UserCheck, label: t('doctor_directory') },
    { to: '/journal', icon: BookHeart, label: t('health_journal') },
    { to: '/history', icon: History, label: t('history') },
    { to: '/reports', icon: FileText, label: t('reports') },
    { to: '/settings', icon: Settings, label: t('settings') },
  ];

  return (
    <aside className="w-64 bg-white/65 backdrop-blur-2xl border-r border-white/75 hidden lg:flex flex-col justify-between py-6 px-4 shrink-0 no-print shadow-[4px_0_30px_-4px_rgba(15,23,42,0.03)] my-2 ml-2 rounded-3xl border">
      <div className="space-y-6">
        {/* Navigation list */}
        <nav className="space-y-1.5">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `flex items-center gap-3.5 px-4 py-3 rounded-2xl font-black text-sm btn-reactive transition-all ${
                    isActive
                      ? 'bg-gradient-to-r from-emerald-500/20 to-teal-500/15 text-emerald-950 border border-emerald-300/90 shadow-md shadow-emerald-500/10 font-black backdrop-blur-md'
                      : 'text-slate-600 hover:bg-white/70 hover:text-slate-900 border border-transparent hover:border-white/80'
                  }`
                }
              >
                <Icon className="w-5 h-5 shrink-0 stroke-[2.2]" />
                <span>{item.label}</span>
              </NavLink>
            );
          })}
        </nav>
      </div>

      {/* Patient Profile Glass Card */}
      <div className="glass-card rounded-2xl p-4 mt-6 border border-white/90">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-emerald-100/90 text-emerald-800 font-black flex items-center justify-center text-lg shadow-sm">
            🌸
          </div>
          <div>
            <div className="font-black text-sm text-slate-900">{emergencyProfile.userName || 'Patient Profile'}</div>
            <div className="text-xs text-red-600 font-extrabold">{emergencyProfile.bloodGroup || 'Blood: Not Set'}</div>
          </div>
        </div>
      </div>
    </aside>
  );
};

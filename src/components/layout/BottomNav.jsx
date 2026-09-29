import React from 'react';
import { NavLink } from 'react-router-dom';
import { Home, Pill, CalendarClock, BookHeart, User } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const BottomNav = () => {
  const { t } = useApp();

  const items = [
    { to: '/', icon: Home, label: t('nav_home') },
    { to: '/medicines', icon: Pill, label: t('nav_medicines') },
    { to: '/hospital', icon: CalendarClock, label: t('nav_hospital') },
    { to: '/journal', icon: BookHeart, label: t('nav_journal') },
    { to: '/settings', icon: User, label: t('nav_profile') },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-30 bg-white/70 backdrop-blur-2xl border-t border-white/80 py-2.5 px-3 flex justify-around items-center lg:hidden shadow-[0_-8px_32px_rgba(15,23,42,0.08)] no-print">
      {items.map((item) => {
        const Icon = item.icon;
        return (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `flex flex-col items-center gap-1 py-1.5 px-3 rounded-2xl btn-reactive transition-all ${
                isActive
                  ? 'text-emerald-950 font-black bg-gradient-to-r from-emerald-500/20 to-teal-500/15 border border-emerald-300/90 shadow-sm backdrop-blur-md'
                  : 'text-slate-600 font-bold hover:text-slate-900 hover:bg-white/60'
              }`
            }
          >
            <Icon className="w-5 h-5 stroke-[2.4]" />
            <span className="text-[11px] tracking-tight">{item.label}</span>
          </NavLink>
        );
      })}
    </nav>
  );
};

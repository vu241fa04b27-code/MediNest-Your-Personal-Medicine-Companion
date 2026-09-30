import React from 'react';
import { NavLink } from 'react-router-dom';
import { Home, Pill, CalendarClock, BookHeart, Settings } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const BottomNav = () => {
  const { t } = useApp();

  const items = [
    { to: '/', icon: Home, label: t('nav_home') },
    { to: '/medicines', icon: Pill, label: t('nav_medicines') },
    { to: '/hospital', icon: CalendarClock, label: t('nav_hospital') },
    { to: '/journal', icon: BookHeart, label: t('nav_journal') },
    { to: '/settings', icon: Settings, label: t('settings') },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-slate-200 shadow-[0_-2px_12px_rgba(15,23,42,0.08)] lg:hidden no-print">
      <div className="flex items-stretch h-16">
        {items.map((item) => {
          const Icon = item.icon;
          return (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) =>
                `flex-1 flex flex-col items-center justify-center gap-0.5 px-1 transition-colors ${
                  isActive
                    ? 'text-emerald-600'
                    : 'text-slate-500 hover:text-slate-800'
                }`
              }
            >
              {({ isActive }) => (
                <>
                  <div className={`flex items-center justify-center w-8 h-7 rounded-xl transition-colors ${
                    isActive ? 'bg-emerald-50' : ''
                  }`}>
                    <Icon className={`w-5 h-5 ${isActive ? 'stroke-[2.8]' : 'stroke-[2]'}`} />
                  </div>
                  <span className={`text-[10px] leading-none tracking-tight font-bold truncate max-w-[56px] text-center ${
                    isActive ? 'font-black' : ''
                  }`}>
                    {item.label}
                  </span>
                </>
              )}
            </NavLink>
          );
        })}
      </div>
      {/* Safe area for phones with home indicator */}
      <div className="h-safe-area-bottom bg-white" style={{ height: 'env(safe-area-inset-bottom, 0px)' }} />
    </nav>
  );
};

import React from 'react';

export const SummaryCard = ({
  title,
  value,
  subtitle,
  icon: Icon,
  color = 'blue',
  onClick
}) => {
  const colorThemes = {
    blue: {
      accent: 'border-sky-300/80 hover:border-sky-400',
      iconBg: 'bg-gradient-to-tr from-sky-500 to-cyan-400 text-white shadow-md shadow-sky-500/25',
      text: 'text-sky-700'
    },
    green: {
      accent: 'border-emerald-300/80 hover:border-emerald-400',
      iconBg: 'bg-gradient-to-tr from-emerald-500 to-teal-400 text-white shadow-md shadow-emerald-500/25',
      text: 'text-emerald-700'
    },
    amber: {
      accent: 'border-amber-300/80 hover:border-amber-400',
      iconBg: 'bg-gradient-to-tr from-amber-500 to-orange-400 text-white shadow-md shadow-amber-500/25',
      text: 'text-amber-700'
    },
    purple: {
      accent: 'border-purple-300/80 hover:border-purple-400',
      iconBg: 'bg-gradient-to-tr from-purple-500 to-indigo-400 text-white shadow-md shadow-purple-500/25',
      text: 'text-purple-700'
    }
  };

  const theme = colorThemes[color] || colorThemes.blue;

  return (
    <div
      onClick={onClick}
      className={`glass-card rounded-3xl p-5 sm:p-6 border ${theme.accent} flex flex-col justify-between transition-all ${onClick ? 'cursor-pointer' : ''}`}
    >
      <div className="flex items-center justify-between mb-3.5">
        <div className={`w-12 h-12 rounded-2xl flex items-center justify-center font-black ${theme.iconBg}`}>
          {Icon && <Icon className="w-5 h-5 stroke-[2.5]" />}
        </div>
        <div className={`text-3xl sm:text-4xl font-black tracking-tight ${theme.text}`}>
          {value}
        </div>
      </div>
      <div>
        <div className="font-black text-sm sm:text-base text-slate-900 tracking-tight">
          {title}
        </div>
        <div className="text-xs text-slate-500 font-extrabold mt-0.5 tracking-tight">
          {subtitle}
        </div>
      </div>
    </div>
  );
};

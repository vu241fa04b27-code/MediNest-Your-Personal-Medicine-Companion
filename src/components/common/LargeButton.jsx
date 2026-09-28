import React from 'react';

export const LargeButton = ({
  children,
  onClick,
  variant = 'primary',
  icon: Icon,
  className = '',
  disabled = false,
  type = 'button'
}) => {
  const baseClasses = "btn-reactive w-full min-h-[56px] rounded-2xl font-black text-base sm:text-lg flex items-center justify-center gap-3 transition-all active:scale-[0.97] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer px-6 py-3.5 tracking-tight";

  const variants = {
    primary: "btn-glow-emerald bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white shadow-emerald-600/30 shadow-lg border border-white/20",
    secondary: "btn-glow-blue bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white shadow-blue-600/30 shadow-lg border border-white/20",
    danger: "btn-glow-red bg-gradient-to-r from-red-600 to-rose-500 hover:from-red-500 hover:to-rose-400 text-white shadow-red-600/30 shadow-lg border border-white/20",
    outline: "glass-btn-white text-slate-800 border border-slate-200/80 hover:border-slate-300",
    neutral: "glass-pill text-slate-800 hover:bg-white"
  };

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      className={`${baseClasses} ${variants[variant] || variants.primary} ${className}`}
    >
      {Icon && <Icon className="w-5 h-5 shrink-0 stroke-[2.5]" />}
      <span>{children}</span>
    </button>
  );
};

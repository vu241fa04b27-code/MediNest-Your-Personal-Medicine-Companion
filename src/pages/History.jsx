import React, { useState } from 'react';
import { 
  History as HistoryIcon, 
  Calendar, 
  Flame, 
  CheckCircle2, 
  Clock, 
  ChevronLeft, 
  ChevronRight,
  Award,
  TrendingUp
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export const History = () => {
  const { medicines, adherenceRate, t } = useApp();
  const [currentMonth, setCurrentMonth] = useState('September 2026');

  // Realistic sample history days for September 2026 (1-30)
  const daysInMonth = Array.from({ length: 30 }, (_, i) => {
    const day = i + 1;
    if (day < 28) {
      return { day, status: 'complete', percent: 100 };
    } else if (day === 28) {
      return { day, status: 'today', percent: adherenceRate };
    } else {
      return { day, status: 'future', percent: 0 };
    }
  });

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <HistoryIcon className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>{t('history')}</span>
          </h1>
          <p className="text-slate-500 font-bold text-sm mt-1">
            Review your daily medicine adherence, streaks, and intake log.
          </p>
        </div>

        <div className="glass-pill px-4 py-2 rounded-2xl flex items-center gap-2 text-xs font-black text-emerald-950 border border-emerald-300">
          <Award className="w-4 h-4 text-emerald-600" />
          <span>Active Streak: 14 Days</span>
        </div>
      </div>

      {/* KPI Cards in Frosted Glass */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {/* Streak */}
        <div className="glass-card rounded-3xl border border-white/90 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-amber-500 to-orange-400 text-white flex items-center justify-center shadow-md shadow-amber-500/20 shrink-0">
            <Flame className="w-8 h-8 fill-white text-white animate-pulse" />
          </div>
          <div>
            <div className="text-xs font-black text-slate-500 uppercase tracking-wider">Current Streak</div>
            <div className="text-2xl sm:text-3xl font-black text-slate-900">14 Days</div>
            <div className="text-xs text-amber-700 font-black mt-0.5">🔥 Perfect Consistency!</div>
          </div>
        </div>

        {/* Adherence Rate */}
        <div className="glass-card rounded-3xl border border-white/90 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/20 shrink-0">
            <Award className="w-8 h-8" />
          </div>
          <div>
            <div className="text-xs font-black text-slate-500 uppercase tracking-wider">Monthly Adherence</div>
            <div className="text-2xl sm:text-3xl font-black text-emerald-800">96.8%</div>
            <div className="text-xs text-emerald-700 font-black mt-0.5">82 of 84 doses taken</div>
          </div>
        </div>

        {/* Doctor Goal */}
        <div className="glass-card rounded-3xl border border-white/90 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-sky-500 to-blue-500 text-white flex items-center justify-center shadow-md shadow-sky-500/20 shrink-0">
            <TrendingUp className="w-8 h-8" />
          </div>
          <div>
            <div className="text-xs font-black text-slate-500 uppercase tracking-wider">Doctor Goal</div>
            <div className="text-2xl sm:text-3xl font-black text-sky-800">On Track</div>
            <div className="text-xs text-sky-700 font-black mt-0.5">Dr. K. Ramesh (Apollo)</div>
          </div>
        </div>
      </div>

      {/* Calendar Card in Glass Panel */}
      <div className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-8 shadow-sm space-y-6">
        <div className="flex items-center justify-between border-b border-slate-200/50 pb-4">
          <div className="flex items-center gap-3">
            <Calendar className="w-6 h-6 text-emerald-600" />
            <h2 className="text-lg font-black text-slate-900">{currentMonth}</h2>
          </div>
          
          <div className="flex items-center gap-2">
            <button className="btn-reactive p-2 rounded-xl glass-btn-white text-slate-700 transition-colors cursor-pointer">
              <ChevronLeft className="w-5 h-5" />
            </button>
            <button className="btn-reactive p-2 rounded-xl glass-btn-white text-slate-700 transition-colors cursor-pointer">
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Weekday headers */}
        <div className="grid grid-cols-7 text-center font-black text-xs text-slate-400 uppercase tracking-wider">
          <span>Sun</span>
          <span>Mon</span>
          <span>Tue</span>
          <span>Wed</span>
          <span>Thu</span>
          <span>Fri</span>
          <span>Sat</span>
        </div>

        {/* Days grid with Vibrant Glass Cells */}
        <div className="grid grid-cols-7 gap-2 sm:gap-3">
          {daysInMonth.map((item) => {
            if (item.status === 'complete') {
              return (
                <div
                  key={item.day}
                  className="btn-reactive glass-day-complete flex flex-col items-center justify-center p-2 sm:p-2.5 rounded-2xl text-center transition-all min-h-[70px] cursor-pointer"
                  title={`Day ${item.day}: All medicine doses taken (100%)`}
                >
                  <span className="text-base sm:text-lg font-black text-emerald-950 tracking-tight">{item.day}</span>
                  <div className="mt-1 flex items-center gap-1 text-[10px] sm:text-[11px] font-black text-emerald-800 bg-emerald-100/90 px-1.5 sm:px-2 py-0.5 rounded-full border border-emerald-300 shadow-xs">
                    <CheckCircle2 className="w-3 h-3 text-emerald-700 stroke-[2.5]" />
                    <span className="hidden sm:inline">Done</span>
                  </div>
                </div>
              );
            }

            if (item.status === 'today') {
              return (
                <div
                  key={item.day}
                  className="btn-reactive glass-day-today flex flex-col items-center justify-center p-2 sm:p-2.5 rounded-2xl text-center transition-all min-h-[70px] cursor-pointer"
                  title={`Day ${item.day}: Today's doses in progress`}
                >
                  <span className="text-base sm:text-lg font-black text-amber-950 tracking-tight">{item.day}</span>
                  <div className="mt-1 flex items-center gap-1 text-[10px] sm:text-[11px] font-black text-amber-950 bg-amber-200/90 px-1.5 sm:px-2 py-0.5 rounded-full border border-amber-400 shadow-xs">
                    <span className="w-1.5 h-1.5 rounded-full bg-amber-600 animate-ping"></span>
                    <span>Today</span>
                  </div>
                </div>
              );
            }

            // Future Date (Upcoming)
            return (
              <div
                key={item.day}
                className="btn-reactive glass-day-future flex flex-col items-center justify-center p-2 sm:p-2.5 rounded-2xl text-center transition-all min-h-[70px] cursor-pointer"
                title={`Day ${item.day}: Upcoming scheduled day`}
              >
                <span className="text-base sm:text-lg font-black text-sky-950 tracking-tight">{item.day}</span>
                <div className="mt-1 flex items-center gap-1 text-[10px] sm:text-[11px] font-black text-sky-800 bg-sky-100/90 px-1.5 sm:px-2 py-0.5 rounded-full border border-sky-300 shadow-xs">
                  <span>Soon</span>
                </div>
              </div>
            );
          })}
        </div>

        {/* Legend with matching vibrant colors */}
        <div className="flex flex-wrap items-center gap-2.5 sm:gap-4 text-xs font-bold pt-4 border-t border-slate-200/50">
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-day-complete text-xs font-black shadow-xs">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-700 stroke-[2.5]" />
            <span>Complete Date (100% Taken)</span>
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-day-today text-xs font-black shadow-xs">
            <span className="w-2 h-2 rounded-full bg-amber-600 animate-ping"></span>
            <span>Current Date (Today • In Progress)</span>
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-day-future text-xs font-black shadow-xs">
            <span className="w-2 h-2 rounded-full bg-sky-600"></span>
            <span>Future Date (Upcoming)</span>
          </div>
        </div>
      </div>

      {/* Today's Intake Log */}
      <div className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-8 shadow-sm space-y-4">
        <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <Clock className="w-5 h-5 text-emerald-600" />
          <span>Today's Dose Activity Log</span>
        </h2>

        <div className="space-y-2.5 pt-2">
          {medicines.map((med) => (
            <div key={med.id} className="glass-card p-4 rounded-2xl border border-white/90 flex items-center justify-between">
              <div className="flex items-center gap-3.5">
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center font-bold text-sm ${
                  med.takenToday 
                    ? 'bg-gradient-to-tr from-emerald-500 to-teal-400 text-white shadow-sm' 
                    : 'glass-panel text-slate-500'
                }`}>
                  {med.takenToday ? <CheckCircle2 className="w-5 h-5 stroke-[2.5]" /> : <Clock className="w-5 h-5" />}
                </div>
                <div>
                  <div className={`font-black text-sm sm:text-base ${med.takenToday ? 'line-through text-slate-400' : 'text-slate-900'}`}>{med.name}</div>
                  <div className="text-xs text-slate-500 font-bold mt-0.5">Scheduled at {med.time} ({med.afterFood ? 'After Food 🍲' : 'Before Food 🍎'})</div>
                </div>
              </div>

              <div>
                {med.takenToday ? (
                  <span className="px-3.5 py-1.5 rounded-xl bg-emerald-100/90 text-emerald-950 border border-emerald-300 text-xs font-black shadow-xs">
                    Completed ✓
                  </span>
                ) : (
                  <span className="px-3.5 py-1.5 rounded-xl bg-amber-100/90 text-amber-950 border border-amber-300 text-xs font-black shadow-xs">
                    Pending
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

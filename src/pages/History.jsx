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
  // 1-27: all completed (green), 28 (today): partial (yellow), 29-30: future
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
    <div className="space-y-6 pb-20">
      {/* Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
          <HistoryIcon className="w-8 h-8 text-emerald-600" />
          {t('history')}
        </h1>
        <p className="text-slate-500 font-medium text-sm mt-1">
          Review your daily medicine adherence, streaks, and intake log.
        </p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {/* Streak */}
        <div className="bg-white rounded-3xl border border-slate-200 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center border border-amber-100 shrink-0">
            <Flame className="w-8 h-8 fill-amber-500 text-amber-500 animate-pulse" />
          </div>
          <div>
            <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">Current Streak</div>
            <div className="text-2xl sm:text-3xl font-black text-slate-900">14 Days</div>
            <div className="text-xs text-amber-600 font-extrabold mt-0.5">🔥 Perfect Consistency!</div>
          </div>
        </div>

        {/* Adherence Rate */}
        <div className="bg-white rounded-3xl border border-slate-200 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center border border-emerald-100 shrink-0">
            <Award className="w-8 h-8" />
          </div>
          <div>
            <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">Monthly Adherence</div>
            <div className="text-2xl sm:text-3xl font-black text-emerald-700">96.8%</div>
            <div className="text-xs text-emerald-600 font-extrabold mt-0.5">82 of 84 doses taken</div>
          </div>
        </div>

        {/* Doctor Goal */}
        <div className="bg-white rounded-3xl border border-slate-200 p-5 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center border border-blue-100 shrink-0">
            <TrendingUp className="w-8 h-8" />
          </div>
          <div>
            <div className="text-xs font-bold text-slate-500 uppercase tracking-wider">Doctor Goal</div>
            <div className="text-2xl sm:text-3xl font-black text-blue-700">On Track</div>
            <div className="text-xs text-blue-600 font-extrabold mt-0.5">Dr. K. Ramesh (Apollo)</div>
          </div>
        </div>
      </div>

      {/* Calendar Card */}
      <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Calendar className="w-6 h-6 text-emerald-600" />
            <h2 className="text-lg font-black text-slate-900">{currentMonth}</h2>
          </div>
          
          <div className="flex items-center gap-2">
            <button className="p-2 rounded-xl border border-slate-200 hover:bg-slate-50 text-slate-600 transition-colors">
              <ChevronLeft className="w-5 h-5" />
            </button>
            <button className="p-2 rounded-xl border border-slate-200 hover:bg-slate-50 text-slate-600 transition-colors">
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Weekday headers */}
        <div className="grid grid-cols-7 text-center font-bold text-xs text-slate-400">
          <span>Sun</span>
          <span>Mon</span>
          <span>Tue</span>
          <span>Wed</span>
          <span>Thu</span>
          <span>Fri</span>
          <span>Sat</span>
        </div>

        {/* Days grid */}
        <div className="grid grid-cols-7 gap-2 sm:gap-3">
          {daysInMonth.map((item) => {
            let bg = 'bg-slate-50 border-slate-200 text-slate-400';
            let dot = null;

            if (item.status === 'complete') {
              bg = 'bg-emerald-50 border-emerald-300 text-emerald-900 hover:bg-emerald-100';
              dot = <span className="w-2 h-2 rounded-full bg-emerald-500"></span>;
            } else if (item.status === 'today') {
              bg = 'bg-amber-50 border-2 border-amber-500 text-amber-900 font-black ring-4 ring-amber-100';
              dot = <span className="w-2 h-2 rounded-full bg-amber-500 animate-ping"></span>;
            }

            return (
              <div
                key={item.day}
                className={`flex flex-col items-center justify-center p-2 sm:p-3 rounded-2xl border text-sm font-extrabold transition-all min-h-[64px] ${bg}`}
              >
                <span>{item.day}</span>
                <div className="mt-1 flex items-center justify-center">
                  {dot}
                </div>
                {item.status === 'today' && (
                  <span className="text-[10px] text-amber-700 font-extrabold mt-0.5">Today</span>
                )}
              </div>
            );
          })}
        </div>

        {/* Legend */}
        <div className="flex flex-wrap items-center gap-4 text-xs font-bold text-slate-600 pt-3 border-t border-slate-100">
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full bg-emerald-500"></span>
            <span>All Doses Taken (100%)</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full bg-amber-500"></span>
            <span>In Progress Today</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full bg-slate-300"></span>
            <span>Upcoming Days</span>
          </div>
        </div>
      </div>

      {/* Today's Intake Log */}
      <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-4">
        <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <Clock className="w-5 h-5 text-emerald-600" />
          Today's Dose Activity Log
        </h2>

        <div className="divide-y divide-slate-100">
          {medicines.map((med) => (
            <div key={med.id} className="py-3.5 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className={`w-9 h-9 rounded-xl flex items-center justify-center font-bold text-sm ${
                  med.takenToday 
                    ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' 
                    : 'bg-slate-100 text-slate-500'
                }`}>
                  {med.takenToday ? <CheckCircle2 className="w-5 h-5 text-emerald-600" /> : <Clock className="w-5 h-5" />}
                </div>
                <div>
                  <div className="font-extrabold text-slate-900 text-sm">{med.name}</div>
                  <div className="text-xs text-slate-500 font-medium">Scheduled at {med.time} ({med.afterFood ? 'After Food' : 'Before Food'})</div>
                </div>
              </div>

              <div>
                {med.takenToday ? (
                  <span className="px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200 text-xs font-black">
                    Completed ✓
                  </span>
                ) : (
                  <span className="px-3 py-1 rounded-full bg-amber-50 text-amber-700 border border-amber-200 text-xs font-black">
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

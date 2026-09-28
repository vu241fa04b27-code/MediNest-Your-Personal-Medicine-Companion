import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Pill, Clock, CheckCircle2, Bell, AlertCircle, Utensils, Plus } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const NextMedicineCard = ({ medicine }) => {
  const { markDoseTaken, markDoseSnooze, medicines, t } = useApp();
  const [countdown, setCountdown] = useState('Due Soon');

  useEffect(() => {
    if (!medicine || medicine.takenToday) return;

    const calculateCountdown = () => {
      try {
        const timeStr = medicine.time; // e.g. "01:30 PM"
        const [time, modifier] = timeStr.split(' ');
        let [hours, minutes] = time.split(':').map(Number);
        if (modifier === 'PM' && hours < 12) hours += 12;
        if (modifier === 'AM' && hours === 12) hours = 0;

        const now = new Date();
        const target = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hours, minutes);

        if (target < now) {
          setCountdown('Due Now ⏰');
          return;
        }

        const diffMinutes = Math.round((target - now) / 60000);
        const h = Math.floor(diffMinutes / 60);
        const m = diffMinutes % 60;

        if (h > 0) {
          setCountdown(`In ${h}h ${m}m`);
        } else {
          setCountdown(`In ${m} mins`);
        }
      } catch (e) {
        setCountdown('Upcoming');
      }
    };

    calculateCountdown();
    const interval = setInterval(calculateCountdown, 30000);
    return () => clearInterval(interval);
  }, [medicine]);

  // Case 1: No medicines exist at all in tracker
  if (medicines.length === 0) {
    return (
      <div className="glass-card rounded-3xl p-6 sm:p-8 flex flex-col sm:flex-row items-center justify-between gap-4 border border-dashed border-emerald-300">
        <div className="flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shrink-0 shadow-md shadow-emerald-500/25">
            <Pill className="w-7 h-7 stroke-[2.2]" />
          </div>
          <div>
            <h3 className="text-lg font-black text-slate-900 tracking-tight">
              Ready for Your First Medicine
            </h3>
            <p className="text-xs sm:text-sm font-extrabold text-slate-500 mt-0.5">
              Add your medicine names, times, and dosages to start tracking reminders.
            </p>
          </div>
        </div>

        <Link
          to="/add-medicine"
          className="btn-reactive btn-glow-emerald inline-flex items-center gap-2 px-6 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md shadow-emerald-600/30 shrink-0 cursor-pointer"
        >
          <Plus className="w-4 h-4 stroke-[3]" />
          <span>Add Medicine</span>
        </Link>
      </div>
    );
  }

  // Case 2: All scheduled medicines for today have been completed
  if (!medicine || medicine.takenToday) {
    return (
      <div className="glass-panel rounded-3xl p-6 sm:p-8 flex items-center gap-5 border border-emerald-300/80 shadow-lg shadow-emerald-500/5">
        <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shrink-0 shadow-md shadow-emerald-500/25">
          <CheckCircle2 className="w-8 h-8 stroke-[2.5]" />
        </div>
        <div>
          <h3 className="text-xl font-black text-emerald-950 tracking-tight">
            All Doses Taken For Today! 🌸
          </h3>
          <p className="text-sm font-bold text-emerald-800 mt-1">
            Excellent job! You have taken all your scheduled tablets for today.
          </p>
        </div>
      </div>
    );
  }

  // Case 3: An active upcoming medicine is due
  return (
    <div className="glass-panel rounded-3xl p-6 sm:p-8 border-2 border-emerald-400/90 shadow-xl shadow-emerald-500/10">
      {/* Top Header Badge */}
      <div className="flex flex-wrap items-center justify-between gap-3 mb-5">
        <span className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-100/90 text-emerald-950 text-xs font-black uppercase tracking-wider border border-emerald-200">
          <Bell className="w-3.5 h-3.5 text-emerald-700" />
          {t('next_medicine')}
        </span>
        <span className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-full bg-sky-50 text-sky-800 text-xs font-black border border-sky-200">
          <Clock className="w-3.5 h-3.5 text-sky-600" />
          {countdown}
        </span>
      </div>

      {/* Main Info */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
        <div>
          <div className="flex items-center gap-3">
            <h3 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
              {medicine.name}
            </h3>
            <span className="px-3 py-1 rounded-xl bg-white/90 text-slate-800 border border-slate-200 font-black text-xs shadow-sm">
              {medicine.dosage}
            </span>
          </div>

          <div className="flex flex-wrap items-center gap-2 mt-2.5">
            <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-black border ${
              medicine.afterFood
                ? 'bg-amber-50 text-amber-900 border-amber-300'
                : 'bg-emerald-50 text-emerald-900 border-emerald-300'
            }`}>
              <Utensils className="w-3.5 h-3.5" />
              {medicine.afterFood ? t('after_food') : t('before_food')}
            </span>

            {medicine.repeat === 'Alternate Days' && (
              <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-xl bg-purple-50 text-purple-900 border border-purple-200 font-black text-xs">
                🔄 Alternate Day (Due Today)
              </span>
            )}

            {medicine.purpose && (
              <span className="text-xs font-extrabold text-slate-600">
                • {medicine.purpose}
              </span>
            )}
          </div>
        </div>

        {/* Scheduled Time Clock Display */}
        <div className="text-left sm:text-right bg-white/60 p-3 sm:p-0 rounded-2xl border border-white sm:border-none w-full sm:w-auto">
          <div className="text-xs font-black text-slate-500 uppercase tracking-wider">Scheduled Time</div>
          <div className="text-2xl sm:text-3xl font-black text-slate-900">{medicine.time}</div>
        </div>
      </div>

      {/* Action Buttons: Taken & Snooze with Tactile Hover */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5 pt-4 border-t border-slate-200/60">
        <button
          onClick={() => markDoseTaken(medicine.id)}
          className="btn-reactive btn-glow-emerald w-full py-4 px-6 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-base flex items-center justify-center gap-2.5 shadow-lg shadow-emerald-600/30 cursor-pointer"
        >
          <CheckCircle2 className="w-5 h-5 stroke-[2.5]" />
          <span>Mark as Taken ✓</span>
        </button>

        <button
          onClick={() => markDoseSnooze(medicine.id)}
          className="btn-reactive w-full py-4 px-6 rounded-2xl bg-white/80 hover:bg-white text-slate-800 border-2 border-slate-200 hover:border-slate-300 font-black text-base flex items-center justify-center gap-2 shadow-sm cursor-pointer"
        >
          <Clock className="w-5 h-5 text-slate-600" />
          <span>Remind in 10 mins (Snooze)</span>
        </button>
      </div>
    </div>
  );
};

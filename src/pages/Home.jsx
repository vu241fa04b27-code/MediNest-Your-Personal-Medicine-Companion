import React from 'react';
import { Link } from 'react-router-dom';
import { Pill, CheckCircle2, Clock, Calendar, Phone, MapPin, ArrowRight, Plus } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { SummaryCard } from '../components/common/SummaryCard';
import { NextMedicineCard } from '../components/common/NextMedicineCard';

export const Home = () => {
  const { 
    t, 
    emergencyProfile, 
    medicines, 
    todayMedicines,
    restDayMedicines,
    totalDoses, 
    takenDoses, 
    upcomingDoses, 
    daysUntilHospital, 
    activeAppointment,
    nextMedicine,
    markDoseTaken 
  } = useApp();

  // Dynamic greeting based on time of day
  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return t('good_morning');
    if (hour < 17) return t('good_afternoon');
    return t('good_evening');
  };

  const displayName = emergencyProfile.userName && emergencyProfile.userName !== 'My Profile'
    ? `, ${emergencyProfile.userName}`
    : '';

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Greeting Banner */}
      <div className="glass-panel flex flex-col sm:flex-row sm:items-center justify-between gap-4 p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm">
        <div>
          <h1 className="text-2xl sm:text-3xl lg:text-4xl font-black text-slate-900 tracking-tight">
            {getGreeting()}{displayName} 🌸
          </h1>
          <p className="text-sm sm:text-base font-bold text-slate-500 mt-1">
            {medicines.length === 0 
              ? 'Welcome to MediNest! Add your daily medicines to begin.' 
              : 'Here is your daily medication and check-up status.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-center">
          <Link
            to="/add-medicine"
            className="btn-reactive btn-glow-emerald inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white text-xs sm:text-sm font-black shadow-md shadow-emerald-600/25 transition-all cursor-pointer"
          >
            <Plus className="w-4 h-4 stroke-[3]" />
            <span>Add Medicine</span>
          </Link>
        </div>
      </div>

      {/* Four Live Metric Cards - Automatically Updating! */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3.5 sm:gap-5">
        <SummaryCard
          title={t('tablets_today')}
          value={totalDoses}
          subtitle="Doses Scheduled"
          icon={Pill}
          color="blue"
        />
        <SummaryCard
          title={t('taken')}
          value={takenDoses}
          subtitle="Completed"
          icon={CheckCircle2}
          color="green"
        />
        <SummaryCard
          title={t('upcoming')}
          value={upcomingDoses}
          subtitle="Pending Now"
          icon={Clock}
          color="amber"
        />
        <SummaryCard
          title={t('hospital_countdown')}
          value={daysUntilHospital}
          subtitle={daysUntilHospital === '—' ? 'Not Scheduled' : t('days_left')}
          icon={Calendar}
          color="purple"
        />
      </div>

      {/* Next Medicine Card with live countdown & Taken/Snooze */}
      <div>
        <div className="flex items-center justify-between mb-3 px-1">
          <h2 className="text-xl font-black text-slate-900 tracking-tight">
            {t('next_medicine')}
          </h2>
          {medicines.length > 0 && (
            <Link
              to="/medicines"
              className="text-xs sm:text-sm font-bold text-blue-600 hover:text-blue-700 flex items-center gap-1 cursor-pointer"
            >
              <span>View All ({medicines.length})</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
          )}
        </div>
        <NextMedicineCard medicine={nextMedicine} />
      </div>

      {/* Hospital Visit Alert Card (Only if scheduled) */}
      {activeAppointment && activeAppointment.hospitalName && (
        <div className="glass-panel bg-gradient-to-r from-purple-50/85 via-white/80 to-sky-50/85 border border-purple-200/90 rounded-3xl p-6 sm:p-7 flex flex-col md:flex-row items-start md:items-center justify-between gap-5 shadow-sm">
          <div className="flex items-start gap-4">
            <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-purple-600 to-indigo-500 text-white flex items-center justify-center shrink-0 shadow-md shadow-purple-500/25">
              <Calendar className="w-7 h-7 stroke-[2.2]" />
            </div>
            <div>
              <span className="text-xs font-black tracking-wider uppercase bg-purple-100 text-purple-900 px-2.5 py-0.5 rounded-md inline-block mb-1 border border-purple-200">
                Upcoming Doctor Check-up
              </span>
              <h3 className="text-xl font-black text-slate-900 tracking-tight">
                {activeAppointment.doctorName} • {activeAppointment.hospitalName}
              </h3>
              <p className="text-xs sm:text-sm font-bold text-slate-600 mt-0.5">
                {activeAppointment.date} at {activeAppointment.time} ({daysUntilHospital} days remaining)
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2.5 w-full md:w-auto">
            {activeAppointment.doctorPhone && (
              <a
                href={`tel:${activeAppointment.doctorPhone}`}
                className="btn-reactive px-4 py-2.5 rounded-2xl bg-white/90 hover:bg-white border border-purple-200 text-purple-900 font-black text-xs sm:text-sm flex items-center gap-2 shadow-sm transition-colors"
              >
                <Phone className="w-4 h-4 text-purple-600" />
                <span>Call Doctor</span>
              </a>
            )}
            <Link
              to="/hospital"
              className="btn-reactive btn-glow-blue px-4 py-2.5 rounded-2xl bg-gradient-to-r from-blue-600 to-sky-600 hover:from-blue-500 hover:to-sky-500 text-white font-black text-xs sm:text-sm flex items-center gap-2 shadow-md shadow-blue-500/25 transition-all"
            >
              <MapPin className="w-4 h-4" />
              <span>Hospital Tracker & GPS</span>
            </Link>
          </div>
        </div>
      )}

      {/* Today's Schedule Checklist */}
      <div className="glass-panel rounded-3xl p-6 sm:p-7 border border-white/90 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-black text-slate-900 tracking-tight">
            {t('today_schedule')}
          </h3>
          {medicines.length > 0 && (
            <span className="text-xs font-black text-slate-500">
              {takenDoses} of {totalDoses} completed
            </span>
          )}
        </div>

        {medicines.length === 0 ? (
          <div className="text-center py-8 space-y-3">
            <div className="w-12 h-12 rounded-2xl bg-white/80 text-slate-400 flex items-center justify-center mx-auto border border-slate-200 shadow-sm">
              <Pill className="w-6 h-6 stroke-[2]" />
            </div>
            <p className="text-slate-800 font-black text-sm">
              Your medicine schedule is currently empty.
            </p>
            <p className="text-xs text-slate-500 font-bold max-w-sm mx-auto">
              Add your daily medicines so you can mark them as taken and receive reminders.
            </p>
            <div className="pt-1">
              <Link
                to="/add-medicine"
                className="btn-reactive btn-glow-emerald inline-flex items-center gap-1.5 text-xs font-black text-white bg-gradient-to-r from-emerald-600 to-teal-500 px-5 py-2.5 rounded-2xl shadow-md shadow-emerald-600/25 transition-colors"
              >
                <Plus className="w-4 h-4 stroke-[3]" />
                <span>Add Your First Medicine</span>
              </Link>
            </div>
          </div>
        ) : todayMedicines.length === 0 ? (
          <div className="text-center py-6 bg-white/70 rounded-2xl border border-slate-200/80 space-y-1">
            <p className="text-emerald-950 font-black text-sm">
              🎉 No Doses Due Today!
            </p>
            <p className="text-xs text-slate-500 font-bold">
              All your alternate-day medicines are currently on a rest day today.
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {todayMedicines.map((med) => (
              <div
                key={med.id}
                className={`glass-card p-4 rounded-2xl border transition-all flex items-center justify-between gap-4 ${
                  med.takenToday
                    ? 'bg-emerald-50/70 border-emerald-200/90'
                    : 'bg-white/85 border-white/95'
                }`}
              >
                <div className="flex items-center gap-3.5">
                  <input
                    type="checkbox"
                    checked={med.takenToday}
                    onChange={() => markDoseTaken(med.id)}
                    className="w-5 h-5 rounded-lg text-emerald-600 focus:ring-emerald-500 cursor-pointer accent-emerald-600"
                  />
                  <div>
                    <div className={`font-black text-sm sm:text-base ${med.takenToday ? 'line-through text-slate-400' : 'text-slate-900'}`}>
                      {med.name}
                    </div>
                    <div className="text-xs font-black text-slate-500 flex items-center gap-2 mt-0.5">
                      <span>{med.dosage ? `${med.dosage} • ` : ''}{med.time} • {med.afterFood ? 'After Food 🍲' : 'Before Food 🍎'}</span>
                      {med.repeat === 'Alternate Days' && (
                        <span className="text-[10px] font-black bg-purple-100 text-purple-900 px-1.5 py-0.5 rounded border border-purple-200">
                          Alternate Day
                        </span>
                      )}
                    </div>
                  </div>
                </div>

                <div>
                  {med.takenToday ? (
                    <span className="text-xs font-black text-emerald-800 bg-emerald-100 px-3 py-1.5 rounded-xl border border-emerald-200 shadow-sm">
                      {t('completed')} ✓
                    </span>
                  ) : (
                    <button
                      onClick={() => markDoseTaken(med.id)}
                      className="btn-reactive btn-glow-blue text-xs font-black text-sky-900 bg-sky-50/90 hover:bg-sky-100 border border-sky-200/90 px-3.5 py-2 rounded-xl transition-colors cursor-pointer shadow-sm"
                    >
                      {t('take_now')}
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Alternate Day Rest Day Section */}
        {restDayMedicines.length > 0 && (
          <div className="mt-5 pt-4 border-t border-slate-100">
            <div className="text-xs font-black text-slate-500 uppercase tracking-wider mb-2.5 flex items-center gap-1.5">
              <span>⏳ Alternate Day Schedule: Rest Day Today (Due Tomorrow)</span>
            </div>
            <div className="space-y-2">
              {restDayMedicines.map((med) => (
                <div key={med.id} className="glass-card p-3.5 rounded-2xl border border-white/80 flex items-center justify-between opacity-85">
                  <div className="flex items-center gap-3">
                    <span className="w-8 h-8 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center font-black text-xs border border-purple-200">
                      OFF
                    </span>
                    <div>
                      <div className="font-extrabold text-sm text-slate-800">{med.name}</div>
                      <div className="text-xs text-slate-500 font-bold">Alternate Day • No dose needed today</div>
                    </div>
                  </div>
                  <span className="glass-pill text-xs font-bold text-slate-600 px-3 py-1 rounded-xl">
                    Next: Tomorrow ({med.time})
                  </span>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

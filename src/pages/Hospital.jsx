import React, { useState } from 'react';
import { 
  Calendar, 
  Clock, 
  MapPin, 
  Phone, 
  CheckCircle2, 
  AlertCircle, 
  CalendarDays, 
  Building2, 
  Navigation, 
  UserCheck 
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { LargeButton } from '../components/common/LargeButton';

export const Hospital = () => {
  const { 
    activeAppointment, 
    completeAppointment, 
    rescheduleAppointment, 
    hospitalInfo, 
    daysUntilHospital, 
    t 
  } = useApp();

  const [rescheduleModal, setRescheduleModal] = useState(false);
  const [newDate, setNewDate] = useState(activeAppointment?.date || '');

  const handleComplete = () => {
    if (activeAppointment) {
      completeAppointment(activeAppointment.id);
      alert('✓ Check-up marked completed! Next appointment automatically scheduled for next month.');
    }
  };

  const handleRescheduleSubmit = (e) => {
    e.preventDefault();
    if (!newDate) return;
    rescheduleAppointment(activeAppointment.id, newDate);
    setRescheduleModal(false);
    alert(`✓ Rescheduled check-up to ${newDate}`);
  };

  const openGoogleMaps = () => {
    const query = encodeURIComponent(`${hospitalInfo.name}, ${hospitalInfo.address}`);
    window.open(`https://www.google.com/maps/search/?api=1&query=${query}`, '_blank');
  };

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Title */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center shadow-md shadow-blue-500/25">
              <Calendar className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>Monthly Hospital Tracker</span>
          </h1>
          <p className="text-sm font-bold text-slate-500 mt-1">
            Automated monthly visit reminder and hospital navigation.
          </p>
        </div>
      </div>

      {/* Main Appointment Highlight Card */}
      {activeAppointment && (
        <div className="glass-panel rounded-3xl p-6 sm:p-8 border border-blue-300/60 shadow-xl shadow-blue-500/10 space-y-6">
          <div className="flex flex-wrap items-center justify-between gap-3">
            <span className="glass-pill inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-blue-900 text-xs font-black uppercase tracking-wider border border-blue-200">
              <Calendar className="w-3.5 h-3.5 text-blue-600" />
              MONTHLY CHECK-UP
            </span>
            <span className="glass-pill inline-flex items-center gap-1.5 px-4 py-1.5 rounded-full text-emerald-950 text-sm font-black border border-emerald-300">
              <Clock className="w-4 h-4 text-emerald-600" />
              {daysUntilHospital} Days Left
            </span>
          </div>

          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <div className="text-xs font-black text-blue-600 uppercase tracking-wider">
                Specialization
              </div>
              <h2 className="text-2xl sm:text-3xl font-black text-slate-900 mt-0.5">
                {activeAppointment.specialization} Check-up
              </h2>
              <div className="text-base font-bold text-slate-800 mt-1 flex items-center gap-2">
                <UserCheck className="w-4 h-4 text-emerald-600" />
                <span>{activeAppointment.doctorName}</span>
                <span className="text-slate-300">•</span>
                <span>{activeAppointment.hospitalName}</span>
              </div>
            </div>

            <div className="glass-card p-4 rounded-2xl border border-blue-200/80 text-left sm:text-right shrink-0">
              <div className="text-xs font-black text-blue-700">Next Scheduled Visit</div>
              <div className="text-xl font-black text-blue-950 mt-0.5">{activeAppointment.date}</div>
              <div className="text-xs font-extrabold text-blue-600 mt-0.5">{activeAppointment.time || '10:30 AM'}</div>
            </div>
          </div>

          {/* Notes */}
          <div className="glass-card rounded-2xl p-4 text-xs sm:text-sm text-slate-800 font-semibold border border-slate-200/80">
            <strong className="text-slate-950 block mb-1">Prescription & Agenda:</strong>
            {activeAppointment.prescriptionNotes}
          </div>

          {/* Action Buttons: Mark Completed, Reschedule, Call Doctor, GPS */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 pt-2">
            <button
              onClick={handleComplete}
              className="btn-reactive btn-glow-emerald py-3.5 px-4 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-emerald-600/25 border border-white/20 cursor-pointer"
            >
              <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
              <span>Mark Completed</span>
            </button>

            <button
              onClick={() => setRescheduleModal(true)}
              className="btn-reactive glass-btn-white py-3.5 px-4 rounded-2xl text-slate-800 font-black text-sm flex items-center justify-center gap-2 cursor-pointer"
            >
              <CalendarDays className="w-4 h-4 text-blue-600" />
              <span>Reschedule</span>
            </button>

            <a
              href={`tel:${activeAppointment.doctorPhone}`}
              className="btn-reactive glass-card py-3.5 px-4 rounded-2xl bg-emerald-50/70 hover:bg-emerald-100/80 text-emerald-950 border border-emerald-300 font-black text-sm flex items-center justify-center gap-2"
            >
              <Phone className="w-4 h-4 text-emerald-600" />
              <span>Call Doctor</span>
            </a>

            <button
              onClick={openGoogleMaps}
              className="btn-reactive btn-glow-blue py-3.5 px-4 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-blue-600/25 border border-white/20 cursor-pointer"
            >
              <Navigation className="w-4 h-4" />
              <span>Navigate GPS</span>
            </button>
          </div>
        </div>
      )}

      {/* 5-Stage Reminder Schedule */}
      <div className="glass-panel rounded-3xl p-6 sm:p-8 space-y-4 border border-white/80 shadow-md">
        <h3 className="text-lg font-black text-slate-900 tracking-tight flex items-center gap-2">
          <Clock className="w-5 h-5 text-emerald-600" />
          <span>Active 5-Stage Reminder Timeline</span>
        </h3>
        <p className="text-xs sm:text-sm text-slate-600 font-semibold">
          MediNest automatically triggers reminders leading up to your check-up:
        </p>

        <div className="grid grid-cols-1 md:grid-cols-5 gap-3 pt-2">
          {[
            { title: '7 Days Before', desc: 'Arrange transport & past test reports' },
            { title: '3 Days Before', desc: 'Appointment slot reminder' },
            { title: '1 Day Before', desc: 'Prepare prescription history' },
            { title: 'Morning of Visit', desc: '8:00 AM departure prep alert' },
            { title: '1 Hour Before', desc: 'Time to leave for hospital' },
          ].map((step, idx) => (
            <div key={idx} className="glass-card rounded-2xl p-4 flex flex-col justify-between">
              <div className="flex items-center gap-2 text-emerald-800 font-black text-xs mb-1">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>{step.title}</span>
              </div>
              <p className="text-xs text-slate-700 font-semibold">{step.desc}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Hospital Contact Details Card */}
      <div className="glass-panel rounded-3xl p-6 sm:p-8 border border-white/80 shadow-md">
        <div className="flex items-start gap-4 mb-5">
          <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center shrink-0 shadow-md shadow-blue-500/20">
            <Building2 className="w-6 h-6 stroke-[2.2]" />
          </div>
          <div>
            <h3 className="text-xl font-black text-slate-900">{hospitalInfo.name}</h3>
            <p className="text-xs text-slate-600 font-bold flex items-center gap-1.5 mt-0.5">
              <MapPin className="w-3.5 h-3.5 text-slate-500" />
              {hospitalInfo.address}
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-6 text-xs sm:text-sm font-bold text-slate-800">
          <div className="glass-card p-3.5 rounded-2xl border border-slate-200/80">
            <span className="text-slate-500 block text-xs font-black uppercase">Reception Phone</span>
            <span className="text-slate-950 text-sm font-black">{hospitalInfo.phone}</span>
          </div>
          <div className="glass-card p-3.5 rounded-2xl border border-red-200/80 bg-red-50/50">
            <span className="text-red-600 block text-xs font-black uppercase">Emergency (24/7)</span>
            <span className="text-red-950 text-sm font-black">{hospitalInfo.emergencyPhone}</span>
          </div>
          <div className="glass-card p-3.5 rounded-2xl border border-slate-200/80">
            <span className="text-slate-500 block text-xs font-black uppercase">Working Hours</span>
            <span className="text-slate-950 text-xs sm:text-sm font-black">{hospitalInfo.workingHours}</span>
          </div>
        </div>

        <div className="flex flex-wrap gap-3">
          <a
            href={`tel:${hospitalInfo.phone}`}
            className="btn-reactive btn-glow-emerald flex-1 min-h-[48px] rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-emerald-600/20 border border-white/20"
          >
            <Phone className="w-4 h-4" />
            <span>Call Hospital</span>
          </a>
          <button
            onClick={openGoogleMaps}
            className="btn-reactive btn-glow-blue flex-1 min-h-[48px] rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-blue-600/20 border border-white/20 cursor-pointer"
          >
            <Navigation className="w-4 h-4" />
            <span>Open Google Maps</span>
          </button>
        </div>
      </div>

      {/* Reschedule Modal */}
      {rescheduleModal && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-md flex items-center justify-center p-4">
          <div className="glass-panel rounded-3xl p-6 sm:p-8 max-w-md w-full shadow-2xl space-y-5 animate-scaleUp border border-white/90">
            <h3 className="text-xl font-black text-slate-900">Reschedule Appointment</h3>
            <form onSubmit={handleRescheduleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Select New Date</label>
                <input
                  type="date"
                  value={newDate}
                  onChange={(e) => setNewDate(e.target.value)}
                  required
                  className="glass-input w-full rounded-xl p-3 font-bold text-sm outline-none cursor-pointer"
                />
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setRescheduleModal(false)}
                  className="btn-reactive glass-btn-white flex-1 py-3 rounded-xl font-black text-sm text-slate-800"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-reactive btn-glow-blue flex-1 py-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm shadow-md"
                >
                  Confirm Date
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

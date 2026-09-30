import React, { useState } from 'react';
import {
  Calendar,
  Clock,
  MapPin,
  Phone,
  CheckCircle2,
  CalendarDays,
  Building2,
  Navigation,
  UserCheck,
  Plus,
  X,
  Save,
  AlertCircle
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export const Hospital = () => {
  const {
    appointments,
    activeAppointment,
    completeAppointment,
    rescheduleAppointment,
    addAppointment,
    hospitalInfo,
    updateHospitalInfo,
    daysUntilHospital,
    t
  } = useApp();

  const [rescheduleModal, setRescheduleModal] = useState(false);
  const [newDate, setNewDate] = useState(activeAppointment?.date || '');
  const [addModal, setAddModal] = useState(false);
  const [hospitalEditModal, setHospitalEditModal] = useState(false);

  const defaultAppt = {
    doctorName: '',
    specialization: '',
    hospitalName: '',
    doctorPhone: '',
    date: '',
    time: '10:30 AM',
    prescriptionNotes: ''
  };
  const [apptForm, setApptForm] = useState(defaultAppt);
  const [hospitalForm, setHospitalForm] = useState({ ...hospitalInfo });

  const handleComplete = () => {
    if (activeAppointment) {
      completeAppointment(activeAppointment.id);
      alert('✓ Check-up marked completed! Next appointment auto-scheduled for next month.');
    }
  };

  const handleRescheduleSubmit = (e) => {
    e.preventDefault();
    if (!newDate) return;
    rescheduleAppointment(activeAppointment.id, newDate);
    setRescheduleModal(false);
    alert(`✓ Rescheduled to ${newDate}`);
  };

  const handleAddSubmit = (e) => {
    e.preventDefault();
    if (!apptForm.doctorName.trim() || !apptForm.date) {
      alert('Please enter doctor name and appointment date.');
      return;
    }
    addAppointment({
      ...apptForm,
      id: 'apt-' + Date.now(),
      isCompleted: false
    });
    setApptForm(defaultAppt);
    setAddModal(false);
    alert('✓ Appointment added successfully!');
  };

  const handleHospitalSave = (e) => {
    e.preventDefault();
    updateHospitalInfo(hospitalForm);
    setHospitalEditModal(false);
  };

  const openGoogleMaps = () => {
    const query = encodeURIComponent(
      `${hospitalInfo.name}${hospitalInfo.address ? ', ' + hospitalInfo.address : ''}`
    );
    window.open(`https://www.google.com/maps/search/?api=1&query=${query}`, '_blank');
  };

  const completedAppointments = appointments.filter(a => a.isCompleted);

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center shadow-md shadow-blue-500/25">
              <Calendar className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>Hospital Tracker</span>
          </h1>
          <p className="text-sm font-bold text-slate-500 mt-1">
            Manage monthly check-up appointments and hospital navigation.
          </p>
        </div>
        <button
          onClick={() => setAddModal(true)}
          className="btn-reactive btn-glow-blue inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm shadow-md shadow-blue-500/20 self-start sm:self-center cursor-pointer border border-white/20"
        >
          <Plus className="w-5 h-5 stroke-[2.5]" />
          <span>Add Appointment</span>
        </button>
      </div>

      {/* No active appointment state */}
      {!activeAppointment && (
        <div className="glass-panel rounded-3xl border-2 border-dashed border-blue-300 p-10 text-center space-y-4 shadow-sm">
          <div className="w-16 h-16 rounded-3xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center mx-auto shadow-md shadow-blue-500/25">
            <Calendar className="w-8 h-8 stroke-[2]" />
          </div>
          <div>
            <h3 className="text-xl font-black text-slate-900">No Upcoming Appointment</h3>
            <p className="text-sm font-bold text-slate-500 mt-1 max-w-sm mx-auto">
              Schedule your next hospital check-up to get reminders and GPS navigation.
            </p>
          </div>
          <button
            onClick={() => setAddModal(true)}
            className="btn-reactive btn-glow-blue inline-flex items-center gap-2 px-6 py-3 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 text-white font-black text-sm shadow-md shadow-blue-500/20 cursor-pointer border border-white/20"
          >
            <Plus className="w-5 h-5 stroke-[2.5]" />
            <span>Schedule Appointment</span>
          </button>
        </div>
      )}

      {/* Active Appointment Card */}
      {activeAppointment && (
        <div className="glass-panel rounded-3xl p-6 sm:p-8 border border-blue-200 shadow-sm space-y-6">
          <div className="flex flex-wrap items-center justify-between gap-3">
            <span className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-blue-900 text-xs font-black uppercase tracking-wider border border-blue-200 bg-blue-50">
              <Calendar className="w-3.5 h-3.5 text-blue-600" />
              NEXT CHECK-UP
            </span>
            <span className="inline-flex items-center gap-1.5 px-4 py-1.5 rounded-full text-emerald-900 text-sm font-black border border-emerald-300 bg-emerald-50">
              <Clock className="w-4 h-4 text-emerald-600" />
              {daysUntilHospital} Days Left
            </span>
          </div>

          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              {activeAppointment.specialization && (
                <div className="text-xs font-black text-blue-600 uppercase tracking-wider mb-0.5">
                  {activeAppointment.specialization}
                </div>
              )}
              <h2 className="text-2xl sm:text-3xl font-black text-slate-900">
                {activeAppointment.doctorName}
              </h2>
              <div className="text-base font-bold text-slate-600 mt-1 flex items-center gap-2 flex-wrap">
                <UserCheck className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>{activeAppointment.hospitalName}</span>
              </div>
            </div>
            <div className="glass-card p-4 rounded-2xl border border-blue-200 text-left sm:text-right shrink-0">
              <div className="text-xs font-black text-blue-700">Scheduled Visit</div>
              <div className="text-xl font-black text-blue-950 mt-0.5">{activeAppointment.date}</div>
              <div className="text-xs font-extrabold text-blue-600 mt-0.5">{activeAppointment.time || '10:30 AM'}</div>
            </div>
          </div>

          {activeAppointment.prescriptionNotes && (
            <div className="glass-card rounded-2xl p-4 text-xs sm:text-sm text-slate-800 font-semibold border border-slate-200">
              <strong className="text-slate-900 block mb-1">Agenda / Notes:</strong>
              {activeAppointment.prescriptionNotes}
            </div>
          )}

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
            <button
              onClick={handleComplete}
              className="btn-reactive btn-glow-emerald py-3.5 px-4 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-emerald-600/20 cursor-pointer border border-white/20"
            >
              <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
              Mark Completed
            </button>
            <button
              onClick={() => { setNewDate(activeAppointment.date); setRescheduleModal(true); }}
              className="btn-reactive glass-btn-white py-3.5 px-4 rounded-2xl text-slate-800 font-black text-sm flex items-center justify-center gap-2 cursor-pointer border border-slate-200"
            >
              <CalendarDays className="w-4 h-4 text-blue-600" />
              Reschedule
            </button>
            {activeAppointment.doctorPhone && (
              <a
                href={`tel:${activeAppointment.doctorPhone}`}
                className="btn-reactive py-3.5 px-4 rounded-2xl bg-emerald-50 hover:bg-emerald-100 text-emerald-950 border border-emerald-300 font-black text-sm flex items-center justify-center gap-2"
              >
                <Phone className="w-4 h-4 text-emerald-600" />
                Call Doctor
              </a>
            )}
            <button
              onClick={openGoogleMaps}
              className="btn-reactive btn-glow-blue py-3.5 px-4 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-blue-600/20 cursor-pointer border border-white/20"
            >
              <Navigation className="w-4 h-4" />
              Navigate GPS
            </button>
          </div>
        </div>
      )}

      {/* 5-Stage Reminder Timeline */}
      <div className="glass-panel rounded-3xl p-6 sm:p-8 space-y-4 border border-slate-200 shadow-sm">
        <h3 className="text-lg font-black text-slate-900 flex items-center gap-2">
          <Clock className="w-5 h-5 text-emerald-600" />
          5-Stage Reminder Timeline
        </h3>
        <p className="text-xs sm:text-sm text-slate-600 font-semibold">
          MediNest will alert you at these intervals before your check-up:
        </p>
        <div className="grid grid-cols-1 md:grid-cols-5 gap-3 pt-2">
          {[
            { title: '7 Days Before', desc: 'Arrange transport & gather past reports' },
            { title: '3 Days Before', desc: 'Appointment slot reminder' },
            { title: '1 Day Before', desc: 'Prepare prescription history' },
            { title: 'Morning of Visit', desc: '8:00 AM departure prep alert' },
            { title: '1 Hour Before', desc: 'Time to leave for hospital' },
          ].map((step, idx) => (
            <div key={idx} className="glass-card rounded-2xl p-4 border border-slate-200">
              <div className="flex items-center gap-2 text-emerald-800 font-black text-xs mb-1">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>{step.title}</span>
              </div>
              <p className="text-xs text-slate-600 font-semibold">{step.desc}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Hospital Contact Card */}
      <div className="glass-panel rounded-3xl p-6 sm:p-8 border border-slate-200 shadow-sm space-y-5">
        <div className="flex items-start justify-between gap-4">
          <div className="flex items-start gap-4">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-500 text-white flex items-center justify-center shrink-0 shadow-md shadow-blue-500/20">
              <Building2 className="w-6 h-6 stroke-[2.2]" />
            </div>
            <div>
              <h3 className="text-xl font-black text-slate-900">
                {hospitalInfo.name || 'Hospital Not Configured'}
              </h3>
              {hospitalInfo.address && (
                <p className="text-xs text-slate-600 font-bold flex items-center gap-1.5 mt-0.5">
                  <MapPin className="w-3.5 h-3.5 text-slate-400" />
                  {hospitalInfo.address}
                </p>
              )}
            </div>
          </div>
          <button
            onClick={() => { setHospitalForm({ ...hospitalInfo }); setHospitalEditModal(true); }}
            className="btn-reactive glass-btn-white px-3 py-2 rounded-xl text-slate-700 font-black text-xs border border-slate-200 cursor-pointer shrink-0"
          >
            Edit Info
          </button>
        </div>

        {(hospitalInfo.phone || hospitalInfo.emergencyPhone || hospitalInfo.workingHours) && (
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm font-bold text-slate-800">
            <div className="glass-card p-3.5 rounded-2xl border border-slate-200">
              <span className="text-slate-500 block text-xs font-black uppercase">Reception</span>
              <span className="text-slate-900 font-black">{hospitalInfo.phone || '—'}</span>
            </div>
            <div className="glass-card p-3.5 rounded-2xl border border-red-200 bg-red-50">
              <span className="text-red-600 block text-xs font-black uppercase">Emergency 24/7</span>
              <span className="text-red-900 font-black">{hospitalInfo.emergencyPhone || '108'}</span>
            </div>
            <div className="glass-card p-3.5 rounded-2xl border border-slate-200">
              <span className="text-slate-500 block text-xs font-black uppercase">Working Hours</span>
              <span className="text-slate-900 text-xs font-black">{hospitalInfo.workingHours || '—'}</span>
            </div>
          </div>
        )}

        <div className="flex flex-wrap gap-3">
          <a
            href={`tel:${hospitalInfo.phone}`}
            className="btn-reactive btn-glow-emerald flex-1 min-h-[48px] rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-emerald-600/20 border border-white/20"
          >
            <Phone className="w-4 h-4" />
            Call Hospital
          </a>
          <button
            onClick={openGoogleMaps}
            className="btn-reactive btn-glow-blue flex-1 min-h-[48px] rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm flex items-center justify-center gap-2 shadow-md shadow-blue-600/20 cursor-pointer border border-white/20"
          >
            <Navigation className="w-4 h-4" />
            Open Google Maps
          </button>
        </div>
      </div>

      {/* Past Appointments */}
      {completedAppointments.length > 0 && (
        <div className="glass-panel rounded-3xl p-6 sm:p-8 border border-slate-200 shadow-sm space-y-4">
          <h3 className="text-lg font-black text-slate-900">Past Appointments ({completedAppointments.length})</h3>
          <div className="space-y-2.5">
            {completedAppointments.map(appt => (
              <div key={appt.id} className="glass-card p-4 rounded-2xl border border-slate-200 flex items-center justify-between gap-3">
                <div>
                  <div className="font-black text-slate-900 text-sm">{appt.doctorName}</div>
                  <div className="text-xs text-slate-500 font-bold mt-0.5">{appt.hospitalName} • {appt.date}</div>
                </div>
                <span className="text-xs font-black text-emerald-700 bg-emerald-50 border border-emerald-300 px-3 py-1 rounded-xl">
                  Completed ✓
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Add Appointment Modal */}
      {addModal && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <div className="glass-panel bg-white rounded-3xl p-6 sm:p-8 max-w-lg w-full shadow-2xl space-y-5 animate-scaleUp border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-200 pb-3">
              <h3 className="text-xl font-black text-slate-900">Add New Appointment</h3>
              <button onClick={() => setAddModal(false)} className="p-1.5 rounded-full hover:bg-slate-100 text-slate-500 cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>
            <form onSubmit={handleAddSubmit} className="space-y-3.5">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Doctor Name *</label>
                  <input
                    type="text"
                    value={apptForm.doctorName}
                    onChange={(e) => setApptForm(p => ({ ...p, doctorName: e.target.value }))}
                    placeholder="Dr. K. Ramesh"
                    required
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Specialization</label>
                  <input
                    type="text"
                    value={apptForm.specialization}
                    onChange={(e) => setApptForm(p => ({ ...p, specialization: e.target.value }))}
                    placeholder="e.g. Dermatologist"
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Hospital Name *</label>
                  <input
                    type="text"
                    value={apptForm.hospitalName}
                    onChange={(e) => setApptForm(p => ({ ...p, hospitalName: e.target.value }))}
                    placeholder="Apollo Hospitals"
                    required
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Doctor Phone</label>
                  <input
                    type="tel"
                    value={apptForm.doctorPhone}
                    onChange={(e) => setApptForm(p => ({ ...p, doctorPhone: e.target.value }))}
                    placeholder="+91 98480 00001"
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Appointment Date *</label>
                  <input
                    type="date"
                    value={apptForm.date}
                    onChange={(e) => setApptForm(p => ({ ...p, date: e.target.value }))}
                    required
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none cursor-pointer"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Time</label>
                  <input
                    type="text"
                    value={apptForm.time}
                    onChange={(e) => setApptForm(p => ({ ...p, time: e.target.value }))}
                    placeholder="10:30 AM"
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
              </div>
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Notes / Agenda</label>
                <textarea
                  rows={2}
                  value={apptForm.prescriptionNotes}
                  onChange={(e) => setApptForm(p => ({ ...p, prescriptionNotes: e.target.value }))}
                  placeholder="e.g. Bring previous blood reports, scalp scan results"
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setAddModal(false)}
                  className="btn-reactive glass-btn-white flex-1 py-3 rounded-xl font-black text-sm text-slate-800 border border-slate-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-reactive btn-glow-blue flex-1 py-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
                >
                  Save Appointment
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Reschedule Modal */}
      {rescheduleModal && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <div className="glass-panel bg-white rounded-3xl p-6 sm:p-8 max-w-md w-full shadow-2xl space-y-5 animate-scaleUp border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-200 pb-3">
              <h3 className="text-xl font-black text-slate-900">Reschedule Appointment</h3>
              <button onClick={() => setRescheduleModal(false)} className="p-1.5 rounded-full hover:bg-slate-100 text-slate-500 cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>
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
                  className="btn-reactive glass-btn-white flex-1 py-3 rounded-xl font-black text-sm text-slate-800 border border-slate-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-reactive btn-glow-blue flex-1 py-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
                >
                  Confirm Date
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Hospital Info Edit Modal */}
      {hospitalEditModal && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <div className="glass-panel bg-white rounded-3xl p-6 sm:p-8 max-w-lg w-full shadow-2xl space-y-5 animate-scaleUp border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-200 pb-3">
              <h3 className="text-xl font-black text-slate-900">Edit Hospital Information</h3>
              <button onClick={() => setHospitalEditModal(false)} className="p-1.5 rounded-full hover:bg-slate-100 text-slate-500 cursor-pointer">
                <X className="w-5 h-5" />
              </button>
            </div>
            <form onSubmit={handleHospitalSave} className="space-y-3.5">
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Hospital Name</label>
                <input
                  type="text"
                  value={hospitalForm.name}
                  onChange={(e) => setHospitalForm(p => ({ ...p, name: e.target.value }))}
                  placeholder="e.g. Apollo Hospitals"
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Address (for GPS)</label>
                <input
                  type="text"
                  value={hospitalForm.address}
                  onChange={(e) => setHospitalForm(p => ({ ...p, address: e.target.value }))}
                  placeholder="e.g. Jubilee Hills, Hyderabad"
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Reception Phone</label>
                  <input
                    type="tel"
                    value={hospitalForm.phone}
                    onChange={(e) => setHospitalForm(p => ({ ...p, phone: e.target.value }))}
                    placeholder="+91 40 2345 6789"
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-black text-slate-700 uppercase mb-1">Emergency Phone</label>
                  <input
                    type="tel"
                    value={hospitalForm.emergencyPhone}
                    onChange={(e) => setHospitalForm(p => ({ ...p, emergencyPhone: e.target.value }))}
                    placeholder="108"
                    className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                  />
                </div>
              </div>
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Working Hours</label>
                <input
                  type="text"
                  value={hospitalForm.workingHours}
                  onChange={(e) => setHospitalForm(p => ({ ...p, workingHours: e.target.value }))}
                  placeholder="e.g. Mon–Sat 8 AM – 8 PM"
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>
              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => setHospitalEditModal(false)}
                  className="btn-reactive glass-btn-white flex-1 py-3 rounded-xl font-black text-sm text-slate-800 border border-slate-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-reactive btn-glow-blue flex-1 py-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-500 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
                >
                  <Save className="w-4 h-4 inline mr-1.5" />
                  Save
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

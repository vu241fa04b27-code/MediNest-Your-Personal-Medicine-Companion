import React, { useState } from 'react';
import {
  AlertTriangle,
  Phone,
  PhoneCall,
  ShieldAlert,
  HeartPulse,
  UserCheck,
  Hospital,
  Edit3,
  Save,
  X,
  Droplet,
  Pill
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export const Emergency = () => {
  const { emergencyProfile, setEmergencyProfile, medicines, t } = useApp();
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({ ...emergencyProfile });

  const openEdit = () => {
    setFormData({ ...emergencyProfile });
    setIsEditing(true);
  };

  const handleSave = (e) => {
    e.preventDefault();
    setEmergencyProfile(formData);
    setIsEditing(false);
  };

  const field = (label, key, type = 'text', placeholder = '') => (
    <div>
      <label className="block text-xs font-black text-slate-700 uppercase mb-1">{label}</label>
      <input
        type={type}
        value={formData[key] || ''}
        onChange={(e) => setFormData(prev => ({ ...prev, [key]: e.target.value }))}
        placeholder={placeholder}
        className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
      />
    </div>
  );

  return (
    <div className="space-y-6 pb-20 animate-fadeIn">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-100 text-red-800 text-xs font-black tracking-wide uppercase mb-2 border border-red-200">
            <ShieldAlert className="w-4 h-4 text-red-600" />
            Immediate Medical Assistance
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900">
            {t('emergency_card')}
          </h1>
          <p className="text-slate-500 font-medium text-sm mt-1">
            Tap any button to place an immediate emergency call. Show this screen to first responders.
          </p>
        </div>
        <button
          onClick={isEditing ? () => setIsEditing(false) : openEdit}
          className="btn-reactive glass-btn-white flex items-center gap-2 px-5 py-2.5 rounded-2xl text-slate-800 font-black text-sm cursor-pointer border border-slate-200"
        >
          {isEditing ? <X className="w-4 h-4" /> : <Edit3 className="w-4 h-4" />}
          <span>{isEditing ? 'Cancel Edit' : 'Edit Profile'}</span>
        </button>
      </div>

      {/* Speed Dial Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* 108 Ambulance */}
        <a
          href={`tel:${emergencyProfile.ambulancePhone || '108'}`}
          className="btn-reactive btn-glow-red bg-gradient-to-tr from-red-600 to-rose-500 hover:from-red-500 hover:to-rose-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-red-600/25 min-h-[140px] group border border-red-500"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Govt Ambulance
            </span>
            <PhoneCall className="w-6 h-6 group-hover:animate-bounce" />
          </div>
          <div>
            <div className="text-3xl font-black">{emergencyProfile.ambulancePhone || '108'}</div>
            <div className="text-sm font-bold text-red-100 mt-0.5">Free 24x7 Emergency</div>
          </div>
        </a>

        {/* Family Contact */}
        <a
          href={`tel:${emergencyProfile.emergencyContactPhone}`}
          className="btn-reactive btn-glow-emerald bg-gradient-to-tr from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-emerald-600/25 min-h-[140px] group border border-emerald-500"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Family Contact
            </span>
            <Phone className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.emergencyContactName || 'Not Set'}</div>
            <div className="text-sm font-bold text-emerald-100 mt-0.5">{emergencyProfile.emergencyContactPhone || 'Add number in Edit'}</div>
          </div>
        </a>

        {/* Doctor */}
        <a
          href={`tel:${emergencyProfile.doctorPhone}`}
          className="btn-reactive btn-glow-blue bg-gradient-to-tr from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-blue-600/25 min-h-[140px] group border border-blue-500"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Doctor Speed Dial
            </span>
            <UserCheck className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.doctorName || 'Not Set'}</div>
            <div className="text-sm font-bold text-blue-100 mt-0.5">{emergencyProfile.doctorPhone || 'Add number in Edit'}</div>
          </div>
        </a>

        {/* Hospital */}
        <a
          href={`tel:${emergencyProfile.hospitalPhone}`}
          className="btn-reactive btn-glow-blue bg-gradient-to-tr from-indigo-600 to-violet-500 hover:from-indigo-500 hover:to-violet-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-indigo-600/25 min-h-[140px] group border border-indigo-500"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Hospital Desk
            </span>
            <Hospital className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.hospitalName || 'Not Set'}</div>
            <div className="text-sm font-bold text-indigo-100 mt-0.5">{emergencyProfile.hospitalPhone || 'Add number in Edit'}</div>
          </div>
        </a>
      </div>

      {/* Edit Form — all fields */}
      {isEditing && (
        <form onSubmit={handleSave} className="glass-panel rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-5 animate-scaleUp">
          <h2 className="text-lg font-black text-slate-900 border-b border-slate-200 pb-3">
            Edit Emergency Profile
          </h2>

          {/* Patient identity */}
          <div>
            <h3 className="text-xs font-black text-slate-500 uppercase tracking-wider mb-3">Patient Identity</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {field('Full Name', 'userName', 'text', 'e.g. Ammu Reddy')}
              {field('Blood Group', 'bloodGroup', 'text', 'e.g. B+, O-, AB+')}
              <div className="sm:col-span-2">
                {field('Known Allergies', 'allergies', 'text', 'e.g. Penicillin, Sulfa drugs — or "None recorded"')}
              </div>
            </div>
          </div>

          {/* Family contact */}
          <div>
            <h3 className="text-xs font-black text-slate-500 uppercase tracking-wider mb-3">Family Emergency Contact</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {field('Contact Person Name', 'emergencyContactName', 'text', 'e.g. Ramesh (Brother)')}
              {field('Contact Phone', 'emergencyContactPhone', 'tel', '+91 98480 12345')}
            </div>
          </div>

          {/* Doctor */}
          <div>
            <h3 className="text-xs font-black text-slate-500 uppercase tracking-wider mb-3">Treating Doctor</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {field('Doctor Name', 'doctorName', 'text', 'e.g. Dr. K. Ramesh')}
              {field('Doctor Phone', 'doctorPhone', 'tel', '+91 98480 00001')}
            </div>
          </div>

          {/* Hospital */}
          <div>
            <h3 className="text-xs font-black text-slate-500 uppercase tracking-wider mb-3">Hospital</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {field('Hospital Name', 'hospitalName', 'text', 'e.g. Apollo Hospitals')}
              {field('Hospital Phone', 'hospitalPhone', 'tel', '+91 40 2345 6789')}
            </div>
          </div>

          {/* Ambulance */}
          <div>
            <h3 className="text-xs font-black text-slate-500 uppercase tracking-wider mb-3">Ambulance</h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {field('Ambulance Number', 'ambulancePhone', 'tel', '108')}
            </div>
          </div>

          <div className="flex justify-end gap-3 pt-3 border-t border-slate-200">
            <button
              type="button"
              onClick={() => setIsEditing(false)}
              className="btn-reactive glass-btn-white px-5 py-2.5 rounded-xl text-slate-800 font-black text-sm cursor-pointer border border-slate-200"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn-reactive btn-glow-emerald px-6 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
            >
              <Save className="w-4 h-4 inline mr-1.5" />
              Save Changes
            </button>
          </div>
        </form>
      )}

      {/* Clinical Emergency Card */}
      <div className="glass-panel rounded-3xl border border-red-200 p-6 sm:p-8 shadow-sm space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between border-b border-slate-200 pb-5 gap-3">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-red-500 to-rose-400 text-white flex items-center justify-center shadow-md shadow-red-500/20">
              <Droplet className="w-7 h-7 fill-white text-white" />
            </div>
            <div>
              <div className="text-xl font-black text-slate-900">
                {emergencyProfile.userName || 'Patient Name Not Set'}
              </div>
              <div className="text-xs font-bold text-slate-500">Patient Emergency Identification</div>
            </div>
          </div>
          <div className="inline-flex items-center gap-2 bg-red-50 border border-red-200 px-4 py-2 rounded-2xl">
            <span className="text-xs font-black uppercase text-red-700">Blood Group:</span>
            <span className="text-xl font-black text-red-900">{emergencyProfile.bloodGroup || '—'}</span>
          </div>
        </div>

        {/* Allergies */}
        <div className="p-4 rounded-2xl bg-amber-50 border border-amber-300">
          <span className="text-xs font-black text-amber-950 uppercase tracking-wide block mb-1">
            ⚠️ Critical Allergies & Sensitivities:
          </span>
          <p className="text-sm font-black text-amber-900">
            {emergencyProfile.allergies || 'None recorded'}
          </p>
        </div>

        {/* Active Medicines */}
        <div>
          <span className="text-xs font-black text-slate-500 uppercase tracking-wider block mb-3">
            Active Prescriptions ({medicines.length}):
          </span>
          {medicines.length === 0 ? (
            <p className="text-sm text-slate-500 font-bold">No medicines added yet.</p>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              {medicines.map((m) => (
                <div key={m.id} className="glass-card p-3.5 rounded-2xl border border-slate-200">
                  <div className="font-black text-slate-900 text-sm flex items-center gap-1.5">
                    <Pill className="w-4 h-4 text-emerald-600 shrink-0" />
                    <span className="truncate">{m.name}</span>
                  </div>
                  <div className="text-xs text-slate-600 font-bold mt-1">
                    {m.dosage} • {m.time}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

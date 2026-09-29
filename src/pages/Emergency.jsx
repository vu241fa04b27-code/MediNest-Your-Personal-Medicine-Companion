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

  const handleSave = (e) => {
    e.preventDefault();
    setEmergencyProfile(formData);
    setIsEditing(false);
  };

  return (
    <div className="space-y-6 pb-20">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-red-100 text-red-800 text-xs font-black tracking-wide uppercase mb-2">
            <ShieldAlert className="w-4 h-4 text-red-600" />
            Immediate Medical Assistance
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
            {t('emergency_card')}
          </h1>
          <p className="text-slate-500 font-medium text-sm mt-1">
            Tap any button to place an immediate emergency phone call. Show this screen to first responders or paramedics.
          </p>
        </div>

        <button
          onClick={() => setIsEditing(!isEditing)}
          className="btn-reactive glass-btn-white flex items-center gap-2 px-5 py-2.5 rounded-2xl text-slate-800 font-black text-sm cursor-pointer"
        >
          {isEditing ? <X className="w-4 h-4" /> : <Edit3 className="w-4 h-4" />}
          <span>{isEditing ? 'Cancel Edit' : 'Edit Profile'}</span>
        </button>
      </div>

      {/* Speed Dial Grid (Large 56px+ Touch Buttons) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* 108 Ambulance */}
        <a
          href="tel:108"
          className="btn-reactive btn-glow-red bg-gradient-to-tr from-red-600 to-rose-500 hover:from-red-500 hover:to-rose-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-red-600/30 min-h-[140px] group border border-white/20"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Govt Ambulance
            </span>
            <PhoneCall className="w-6 h-6 group-hover:animate-bounce" />
          </div>
          <div>
            <div className="text-3xl font-black">108</div>
            <div className="text-sm font-bold text-red-100 mt-0.5">Free 24x7 Emergency</div>
          </div>
        </a>

        {/* Family Member */}
        <a
          href={`tel:${emergencyProfile.emergencyContactPhone}`}
          className="btn-reactive btn-glow-emerald bg-gradient-to-tr from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-emerald-600/30 min-h-[140px] group border border-white/20"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Family Contact
            </span>
            <Phone className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.emergencyContactName}</div>
            <div className="text-sm font-bold text-emerald-100 mt-0.5">{emergencyProfile.emergencyContactPhone}</div>
          </div>
        </a>

        {/* Doctor */}
        <a
          href={`tel:${emergencyProfile.doctorPhone}`}
          className="btn-reactive btn-glow-blue bg-gradient-to-tr from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-blue-600/30 min-h-[140px] group border border-white/20"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Doctor Speed Dial
            </span>
            <UserCheck className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.doctorName}</div>
            <div className="text-sm font-bold text-blue-100 mt-0.5">{emergencyProfile.doctorPhone}</div>
          </div>
        </a>

        {/* Hospital */}
        <a
          href={`tel:${emergencyProfile.hospitalPhone}`}
          className="btn-reactive btn-glow-blue bg-gradient-to-tr from-indigo-600 to-violet-500 hover:from-indigo-500 hover:to-violet-400 text-white rounded-3xl p-6 flex flex-col justify-between shadow-lg shadow-indigo-600/30 min-h-[140px] group border border-white/20"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-black tracking-widest uppercase bg-white/20 px-2.5 py-1 rounded-lg">
              Hospital Desk
            </span>
            <Hospital className="w-6 h-6 group-hover:scale-110 transition-transform" />
          </div>
          <div>
            <div className="text-xl font-black truncate">{emergencyProfile.hospitalName}</div>
            <div className="text-sm font-bold text-indigo-100 mt-0.5">{emergencyProfile.hospitalPhone}</div>
          </div>
        </a>
      </div>

      {/* Edit Form Modal/Section */}
      {isEditing && (
        <form onSubmit={handleSave} className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-8 shadow-sm space-y-5 animate-scaleUp">
          <h2 className="text-lg font-black text-slate-900 border-b border-slate-200/50 pb-3">Edit Emergency Details</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-1">User Full Name</label>
              <input
                type="text"
                value={formData.userName}
                onChange={(e) => setFormData({ ...formData, userName: e.target.value })}
                className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-1">Blood Group</label>
              <input
                type="text"
                value={formData.bloodGroup}
                onChange={(e) => setFormData({ ...formData, bloodGroup: e.target.value })}
                className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-1">Emergency Contact Person</label>
              <input
                type="text"
                value={formData.emergencyContactName}
                onChange={(e) => setFormData({ ...formData, emergencyContactName: e.target.value })}
                className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-1">Emergency Contact Phone</label>
              <input
                type="tel"
                value={formData.emergencyContactPhone}
                onChange={(e) => setFormData({ ...formData, emergencyContactPhone: e.target.value })}
                className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
              />
            </div>

            <div className="sm:col-span-2">
              <label className="block text-xs font-black text-slate-700 uppercase mb-1">Known Allergies</label>
              <input
                type="text"
                value={formData.allergies}
                onChange={(e) => setFormData({ ...formData, allergies: e.target.value })}
                className="glass-input w-full px-4 py-2.5 rounded-xl font-bold text-sm outline-none"
              />
            </div>
          </div>

          <div className="flex justify-end gap-3 pt-3">
            <button
              type="button"
              onClick={() => setIsEditing(false)}
              className="btn-reactive glass-btn-white px-5 py-2.5 rounded-xl text-slate-800 font-black text-sm cursor-pointer"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn-reactive btn-glow-emerald px-6 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
            >
              Save Changes
            </button>
          </div>
        </form>
      )}

      {/* Main Clinical Emergency Card */}
      <div className="glass-panel rounded-3xl border border-red-200/80 p-6 sm:p-8 shadow-xl shadow-red-500/5 space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between border-b border-slate-200/60 pb-5 gap-3">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-red-500 to-rose-400 text-white flex items-center justify-center font-black shadow-md shadow-red-500/20">
              <Droplet className="w-7 h-7 fill-white text-white" />
            </div>
            <div>
              <div className="text-xl font-black text-slate-900">{emergencyProfile.userName}</div>
              <div className="text-xs font-bold text-slate-500">Patient Emergency Identification</div>
            </div>
          </div>

          <div className="glass-pill inline-flex items-center gap-2 text-red-950 border border-red-200 px-4 py-2 rounded-2xl">
            <span className="text-xs font-black uppercase text-red-700">Blood Group:</span>
            <span className="text-xl font-black text-red-900">{emergencyProfile.bloodGroup}</span>
          </div>
        </div>

        {/* Known Allergies */}
        <div className="p-4 rounded-2xl bg-amber-50/80 border border-amber-300">
          <span className="text-xs font-black text-amber-950 uppercase tracking-wide block mb-1">
            ⚠️ Critical Allergies & Sensitivities:
          </span>
          <p className="text-sm font-black text-amber-900">
            {emergencyProfile.allergies}
          </p>
        </div>

        {/* Current Active Medicines */}
        <div>
          <span className="text-xs font-black text-slate-500 uppercase tracking-wider block mb-3">
            Active Prescriptions ({medicines.length}):
          </span>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            {medicines.map((m) => (
              <div key={m.id} className="glass-card p-3.5 rounded-2xl border border-slate-200/80">
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
        </div>
      </div>
    </div>
  );
};

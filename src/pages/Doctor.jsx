import React, { useState } from 'react';
import { UserCheck, Phone, Plus, Trash2, MapPin, Building2, Stethoscope, MessageSquare, X } from 'lucide-react';
import { useApp } from '../context/AppContext';

export const Doctor = () => {
  const { doctors, addDoctor, deleteDoctor } = useApp();
  const [modalOpen, setModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    name: 'Dr. ',
    specialization: '',
    hospital: '',
    phone: '+91 ',
    address: '',
    notes: ''
  });

  const handleAddSubmit = (e) => {
    e.preventDefault();
    if (!formData.name.trim() || formData.name === 'Dr. ') {
      alert('Please enter doctor name');
      return;
    }
    addDoctor({
      ...formData,
      id: 'doc-' + Date.now()
    });
    setFormData({ name: 'Dr. ', specialization: '', hospital: '', phone: '+91 ', address: '', notes: '' });
    setModalOpen(false);
    alert('✓ Doctor added to your directory!');
  };

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <UserCheck className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>Doctor Directory</span>
          </h1>
          <p className="text-sm font-bold text-slate-500 mt-1">
            Store and call your medical specialists directly with quick dial.
          </p>
        </div>

        <button
          onClick={() => setModalOpen(true)}
          className="btn-reactive btn-glow-emerald inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm sm:text-base shadow-md shadow-emerald-600/25 transition-all self-start sm:self-center cursor-pointer border border-white/20"
        >
          <Plus className="w-5 h-5 stroke-[3]" />
          <span>Add Doctor</span>
        </button>
      </div>

      {/* Doctor Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {doctors.map((doc) => (
          <div key={doc.id} className="glass-card rounded-3xl p-6 border border-white/90 shadow-sm flex flex-col justify-between space-y-4">
            <div>
              <div className="flex items-start justify-between gap-3">
                <div className="flex items-center gap-3.5">
                  <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center font-bold text-xl shrink-0 shadow-md shadow-emerald-500/20">
                    <Stethoscope className="w-6 h-6 stroke-[2.2]" />
                  </div>
                  <div>
                    <h3 className="text-xl font-black text-slate-900 tracking-tight">{doc.name}</h3>
                    <span className="text-xs font-black text-emerald-800 bg-emerald-100/90 border border-emerald-300 px-2.5 py-0.5 rounded-lg inline-block mt-0.5">
                      {doc.specialization}
                    </span>
                  </div>
                </div>

                <button
                  onClick={() => {
                    if (window.confirm(`Delete ${doc.name} from directory?`)) {
                      deleteDoctor(doc.id);
                    }
                  }}
                  className="btn-reactive p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-xl transition-colors cursor-pointer"
                  title="Delete Doctor"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>

              <div className="mt-4 space-y-2 text-xs sm:text-sm text-slate-700 font-bold">
                <div className="flex items-center gap-2">
                  <Building2 className="w-4 h-4 text-slate-400 shrink-0" />
                  <span>{doc.hospital}</span>
                </div>
                {doc.address && (
                  <div className="flex items-center gap-2">
                    <MapPin className="w-4 h-4 text-slate-400 shrink-0" />
                    <span>{doc.address}</span>
                  </div>
                )}
                {doc.notes && (
                  <div className="mt-2.5 p-3 rounded-2xl glass-panel text-slate-700 text-xs border border-white/80">
                    <strong className="text-slate-900">Notes:</strong> {doc.notes}
                  </div>
                )}
              </div>
            </div>

            {/* Action Buttons: Call & SMS with Glass Styling */}
            <div className="grid grid-cols-2 gap-3 pt-3 border-t border-slate-200/50">
              <a
                href={`tel:${doc.phone}`}
                className="btn-reactive btn-glow-emerald py-3 px-4 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-xs sm:text-sm flex items-center justify-center gap-2 shadow-md shadow-emerald-600/20 border border-white/20"
              >
                <Phone className="w-4 h-4" />
                <span>Call ({doc.phone})</span>
              </a>

              <a
                href={`sms:${doc.phone}?body=Hello%20${encodeURIComponent(doc.name)},%20this%20is%20regarding%20my%20prescriptions.`}
                className="btn-reactive glass-btn-white py-3 px-4 rounded-xl text-sky-900 border border-sky-200/90 font-black text-xs sm:text-sm flex items-center justify-center gap-2"
              >
                <MessageSquare className="w-4 h-4 text-sky-600" />
                <span>Message</span>
              </a>
            </div>
          </div>
        ))}
      </div>

      {/* Add Doctor Glass Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <div className="glass-panel rounded-3xl p-6 sm:p-8 max-w-lg w-full shadow-2xl space-y-5 animate-scaleUp border border-white/95">
            <div className="flex items-center justify-between border-b border-slate-200/50 pb-3">
              <h3 className="text-xl font-black text-slate-900">Add Doctor Details</h3>
              <button
                onClick={() => setModalOpen(false)}
                className="p-1.5 rounded-full hover:bg-slate-100 text-slate-500 cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleAddSubmit} className="space-y-3.5">
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Doctor Name *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Dr. K. Ramesh"
                  required
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Specialization *</label>
                <input
                  type="text"
                  value={formData.specialization}
                  onChange={(e) => setFormData({ ...formData, specialization: e.target.value })}
                  placeholder="e.g. Dermatologist, Cardiologist"
                  required
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Phone Number (+91...) *</label>
                <input
                  type="text"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="+91 98480 12345"
                  required
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Hospital / Clinic *</label>
                <input
                  type="text"
                  value={formData.hospital}
                  onChange={(e) => setFormData({ ...formData, hospital: e.target.value })}
                  placeholder="Apollo Hospital"
                  required
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase mb-1">Address</label>
                <input
                  type="text"
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  placeholder="Jubilee Hills, Hyderabad"
                  className="glass-input w-full rounded-xl p-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div className="flex gap-3 pt-3">
                <button
                  type="button"
                  onClick={() => setModalOpen(false)}
                  className="btn-reactive glass-btn-white flex-1 py-3 rounded-xl font-black text-sm text-slate-800"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-reactive btn-glow-emerald flex-1 py-3 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md"
                >
                  Save Doctor
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

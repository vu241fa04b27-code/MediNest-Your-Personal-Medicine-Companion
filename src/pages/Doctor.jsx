import React, { useState } from 'react';
import { UserCheck, Phone, Plus, Trash2, MapPin, Building2, Stethoscope, MessageSquare } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { LargeButton } from '../components/common/LargeButton';

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
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-16">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
            Doctor Directory
          </h1>
          <p className="text-sm font-semibold text-slate-500 mt-1">
            Store and call your medical specialists directly.
          </p>
        </div>
        <button
          onClick={() => setModalOpen(true)}
          className="inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-sm sm:text-base shadow-md shadow-emerald-600/20 transition-all self-start sm:self-center cursor-pointer"
        >
          <Plus className="w-5 h-5 stroke-[3]" />
          <span>Add Doctor</span>
        </button>
      </div>

      {/* Doctor Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {doctors.map((doc) => (
          <div key={doc.id} className="bg-white rounded-3xl p-6 border-2 border-slate-200 shadow-sm flex flex-col justify-between space-y-4">
            <div>
              <div className="flex items-start justify-between gap-3">
                <div className="flex items-center gap-3.5">
                  <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-xl shrink-0">
                    <Stethoscope className="w-6 h-6 stroke-[2.2]" />
                  </div>
                  <div>
                    <h3 className="text-xl font-black text-slate-900 tracking-tight">{doc.name}</h3>
                    <span className="text-xs font-black text-emerald-700 bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-md inline-block mt-0.5">
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
                  className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-xl transition-colors cursor-pointer"
                  title="Delete Doctor"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>

              <div className="mt-4 space-y-1.5 text-xs sm:text-sm text-slate-600 font-semibold">
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
                  <div className="mt-2 p-2.5 rounded-xl bg-slate-50 text-slate-600 text-xs border border-slate-100">
                    <strong>Notes:</strong> {doc.notes}
                  </div>
                )}
              </div>
            </div>

            {/* Action Buttons: Call & SMS */}
            <div className="grid grid-cols-2 gap-3 pt-3 border-t border-slate-100">
              <a
                href={`tel:${doc.phone}`}
                className="py-3 px-4 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-xs sm:text-sm flex items-center justify-center gap-2 shadow-sm"
              >
                <Phone className="w-4 h-4" />
                <span>Call ({doc.phone})</span>
              </a>

              <a
                href={`sms:${doc.phone}?body=Hello%20${encodeURIComponent(doc.name)},%20this%20is%20Ammu%20regarding%20my%20prescriptions.`}
                className="py-3 px-4 rounded-xl bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 font-extrabold text-xs sm:text-sm flex items-center justify-center gap-2"
              >
                <MessageSquare className="w-4 h-4" />
                <span>Message</span>
              </a>
            </div>
          </div>
        ))}
      </div>

      {/* Add Doctor Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 sm:p-8 max-w-lg w-full shadow-2xl space-y-5 animate-scaleUp">
            <h3 className="text-xl font-black text-slate-900">Add Doctor Details</h3>
            <form onSubmit={handleAddSubmit} className="space-y-3.5">
              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Doctor Name *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Dr. K. Ramesh"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Specialization *</label>
                <input
                  type="text"
                  value={formData.specialization}
                  onChange={(e) => setFormData({ ...formData, specialization: e.target.value })}
                  placeholder="e.g. Dermatologist, Cardiologist"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Phone Number (+91...) *</label>
                <input
                  type="text"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="+91 98480 12345"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Hospital / Clinic *</label>
                <input
                  type="text"
                  value={formData.hospital}
                  onChange={(e) => setFormData({ ...formData, hospital: e.target.value })}
                  placeholder="Apollo Hospital"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Address</label>
                <input
                  type="text"
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  placeholder="Jubilee Hills, Hyderabad"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500"
                />
              </div>

              <div className="flex gap-3 pt-3">
                <button
                  type="button"
                  onClick={() => setModalOpen(false)}
                  className="flex-1 py-3 rounded-xl bg-slate-100 font-bold text-sm text-slate-700"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 py-3 rounded-xl bg-emerald-600 text-white font-bold text-sm shadow-md"
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

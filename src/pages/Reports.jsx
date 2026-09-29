import React, { useState } from 'react';
import { 
  FileText, 
  Printer, 
  Download, 
  CheckCircle2, 
  AlertTriangle, 
  Hospital, 
  User, 
  Calendar,
  Camera,
  Plus,
  Trash2,
  Eye,
  X,
  Pill,
  Image as ImageIcon,
  Clock
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { compressImage } from '../utils/imageUtils';

export const Reports = () => {
  const { 
    medicines, 
    activeAppointment, 
    emergencyProfile, 
    adherenceRate, 
    clinicalReports,
    addClinicalReport,
    deleteClinicalReport,
    t 
  } = useApp();

  const [modalOpen, setModalOpen] = useState(false);
  const [selectedPhoto, setSelectedPhoto] = useState(null);
  const [photoUploading, setPhotoUploading] = useState(false);

  const [formData, setFormData] = useState({
    title: '',
    date: new Date().toISOString().split('T')[0],
    notes: '',
    photo: ''
  });

  const handlePrint = () => {
    window.print();
  };

  const handlePhotoUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    try {
      setPhotoUploading(true);
      const dataUrl = await compressImage(file, 1200, 0.8);
      setFormData(prev => ({ ...prev, photo: dataUrl }));
    } catch (err) {
      alert('Error reading image. Please choose another file.');
    } finally {
      setPhotoUploading(false);
    }
  };

  const handleAddReport = (e) => {
    e.preventDefault();
    if (!formData.title.trim()) {
      alert('Please enter a title for the report (e.g. Blood Test, Prescription)');
      return;
    }
    if (!formData.photo) {
      alert('Please upload or capture a photo of your clinical document');
      return;
    }

    addClinicalReport({
      id: 'rep-' + Date.now(),
      ...formData
    });

    setFormData({
      title: '',
      date: new Date().toISOString().split('T')[0],
      notes: '',
      photo: ''
    });
    setModalOpen(false);
  };

  const currentDate = new Date().toLocaleDateString('en-US', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  return (
    <div className="space-y-6 pb-24 animate-fadeIn">
      {/* Top Header Actions (Hidden in Print) */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4 no-print">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <FileText className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>Clinical Reports & Prescriptions</span>
          </h1>
          <p className="text-slate-500 font-bold text-sm mt-1">
            Store clinical lab reports, doctor slips, and medicine photos for physical printout or PDF export.
          </p>
        </div>

        <div className="flex items-center gap-2.5 self-start sm:self-center">
          <button
            onClick={() => setModalOpen(true)}
            className="btn-reactive btn-glow-emerald flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md shadow-emerald-600/20 transition-all cursor-pointer border border-white/20"
          >
            <Camera className="w-4 h-4" />
            <span>+ Add Report Photo</span>
          </button>

          <button
            onClick={handlePrint}
            className="btn-reactive btn-glow-blue flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-500 hover:from-blue-500 hover:to-indigo-400 text-white font-black text-sm shadow-md shadow-blue-500/20 transition-all cursor-pointer border border-white/20"
          >
            <Printer className="w-4 h-4" />
            <span>Print / PDF</span>
          </button>
        </div>
      </div>

      {/* Main Clinical Summary Sheet (Printed) */}
      <div className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-10 shadow-sm space-y-8 print:p-0 print:border-none print:shadow-none print:bg-white">
        {/* Document Header */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center border-b-2 border-slate-900 pb-6 gap-4">
          <div>
            <div className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2">
              <span className="text-emerald-600">Medi</span>
              <span className="text-blue-600">Nest</span>
              <span className="text-xs bg-slate-100 text-slate-700 font-black px-2.5 py-1 rounded-md uppercase ml-2">Clinical Health Record</span>
            </div>
            <p className="text-xs text-slate-500 font-bold mt-1 uppercase tracking-wider">
              Official Patient Medication & Document History For Clinical Consultation
            </p>
          </div>

          <div className="text-left sm:text-right text-xs text-slate-600 font-semibold space-y-0.5">
            <div><span className="text-slate-400">Date Generated:</span> {currentDate}</div>
            <div><span className="text-slate-400">Patient ID:</span> MN-{Date.now().toString().slice(-6)}</div>
            <div><span className="text-slate-400">Storage:</span> 100% Offline Encrypted</div>
          </div>
        </div>

        {/* Patient Profile Demographics */}
        <div className="glass-card rounded-2xl p-5 border border-white/90 grid grid-cols-2 sm:grid-cols-4 gap-4 print:bg-slate-50">
          <div>
            <span className="text-[11px] font-black text-slate-500 uppercase tracking-wider block">Patient Name</span>
            <span className="font-black text-slate-900 text-base">{emergencyProfile.userName || 'Patient'}</span>
          </div>

          <div>
            <span className="text-[11px] font-black text-slate-500 uppercase tracking-wider block">Blood Group</span>
            <span className="font-black text-red-600 text-base">{emergencyProfile.bloodGroup || 'Not Specified'}</span>
          </div>

          <div>
            <span className="text-[11px] font-black text-slate-500 uppercase tracking-wider block">Active Medications</span>
            <span className="font-black text-emerald-800 text-base">{medicines.length} Prescriptions</span>
          </div>

          <div>
            <span className="text-[11px] font-black text-slate-500 uppercase tracking-wider block">Consulting Doctor</span>
            <span className="font-black text-slate-900 text-base">{activeAppointment?.doctorName || emergencyProfile.doctorName || 'Not Assigned'}</span>
          </div>
        </div>

        {/* Allergies & Safety Notice */}
        {emergencyProfile.allergies && (
          <div className="p-4 rounded-2xl bg-red-50 border border-red-200 flex items-start gap-3">
            <AlertTriangle className="w-5 h-5 text-red-600 shrink-0 mt-0.5" />
            <div className="text-xs">
              <span className="font-black text-red-900 uppercase">Documented Allergies: </span>
              <span className="font-extrabold text-red-800">{emergencyProfile.allergies}</span>
            </div>
          </div>
        )}

        {/* Section 1: Prescribed Medications & Medicine Photos */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
              <Pill className="w-5 h-5 text-emerald-600" />
              <span>Current Prescribed Medications & Photos</span>
            </h2>
            <span className="text-xs font-bold text-slate-400">{medicines.length} Medicines</span>
          </div>

          {medicines.length === 0 ? (
            <div className="p-8 text-center bg-slate-50 border border-dashed border-slate-200 rounded-2xl">
              <p className="text-slate-500 font-bold text-sm">No medicines registered in your tracker yet.</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b-2 border-slate-200 text-xs font-black text-slate-500 uppercase tracking-wider">
                    <th className="py-3 px-3">Photo</th>
                    <th className="py-3 px-3">Medicine & Dosage</th>
                    <th className="py-3 px-3">Schedule & Food</th>
                    <th className="py-3 px-3">Purpose</th>
                    <th className="py-3 px-3">Stock</th>
                    <th className="py-3 px-3">Doctor</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 text-sm">
                  {medicines.map((med) => (
                    <tr key={med.id} className="hover:bg-slate-50/50">
                      {/* Photo Thumbnail */}
                      <td className="py-3 px-3">
                        {med.photo ? (
                          <img
                            src={med.photo}
                            alt={med.name}
                            onClick={() => setSelectedPhoto({ src: med.photo, title: med.name, date: 'Medicine Photo' })}
                            className="w-12 h-12 object-cover rounded-xl border border-slate-200 shadow-sm cursor-pointer hover:scale-105 transition-transform"
                          />
                        ) : (
                          <div className="w-12 h-12 rounded-xl bg-slate-100 text-slate-400 flex items-center justify-center">
                            <Pill className="w-5 h-5" />
                          </div>
                        )}
                      </td>

                      <td className="py-3.5 px-3">
                        <div className="font-extrabold text-slate-900">{med.name}</div>
                        <div className="text-xs text-slate-500 font-semibold">{med.dosage} ({med.type})</div>
                      </td>

                      <td className="py-3.5 px-3">
                        <div className="font-bold text-slate-800">{med.time}</div>
                        <div className="text-xs text-slate-500">{med.afterFood ? 'After Food 🍲' : 'Before Food 🍎'}</div>
                      </td>

                      <td className="py-3.5 px-3 font-medium text-slate-700">
                        {med.purpose || '—'}
                      </td>

                      <td className="py-3.5 px-3">
                        <span className="font-extrabold text-xs px-2.5 py-1 rounded-lg bg-slate-100 text-slate-700">
                          {med.remainingStock} left
                        </span>
                      </td>

                      <td className="py-3.5 px-3 text-xs font-bold text-slate-700">
                        {med.doctorName || '—'}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Section 2: Uploaded Clinical Report Photos & Scans */}
        <div className="space-y-4 pt-6 border-t border-slate-200">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
                <Camera className="w-5 h-5 text-blue-600" />
                <span>Clinical Lab Reports & Prescription Slips</span>
              </h2>
              <p className="text-xs text-slate-500 font-medium mt-0.5">
                Saved medical test slips, doctor prescriptions, and scan records stored in your app.
              </p>
            </div>

            <span className="text-xs font-bold text-slate-400">{clinicalReports.length} Documents</span>
          </div>

          {clinicalReports.length === 0 ? (
            <div className="p-8 text-center glass-panel border border-dashed border-emerald-300 rounded-3xl space-y-2">
              <Camera className="w-8 h-8 text-emerald-600/60 mx-auto" />
              <p className="text-slate-800 font-black text-sm">No report photos attached yet.</p>
              <p className="text-xs text-slate-500 font-bold">Click "+ Add Report Photo" above to upload doctor prescription slips or lab reports.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {clinicalReports.map((report) => (
                <div 
                  key={report.id}
                  className="glass-card rounded-3xl border border-white/90 p-4 shadow-sm hover:border-emerald-300 transition-all flex flex-col justify-between"
                >
                  <div className="relative rounded-2xl overflow-hidden bg-slate-900/10 h-44 mb-3 border border-white/80 group">
                    <img
                      src={report.photo}
                      alt={report.title}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                    />
                    <div 
                      onClick={() => setSelectedPhoto({ src: report.photo, title: report.title, date: report.date })}
                      className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center text-white cursor-pointer transition-opacity"
                    >
                      <span className="flex items-center gap-1.5 font-bold text-xs bg-black/60 px-3.5 py-1.5 rounded-full backdrop-blur-md">
                        <Eye className="w-4 h-4" /> View Full
                      </span>
                    </div>
                  </div>

                  <div>
                    <div className="flex items-center justify-between">
                      <h4 className="font-black text-slate-900 text-sm truncate">{report.title}</h4>
                      <span className="text-[11px] font-bold text-slate-500 shrink-0">{report.date}</span>
                    </div>
                    {report.notes && (
                      <p className="text-xs text-slate-600 mt-1 line-clamp-2 font-medium">{report.notes}</p>
                    )}
                  </div>

                  <div className="flex items-center justify-between pt-3 mt-2 border-t border-slate-200/50 no-print">
                    <button
                      onClick={() => setSelectedPhoto({ src: report.photo, title: report.title, date: report.date })}
                      className="text-xs font-black text-emerald-700 hover:text-emerald-800 flex items-center gap-1 cursor-pointer"
                    >
                      <Eye className="w-3.5 h-3.5" />
                      <span>Inspect</span>
                    </button>
                    <button
                      onClick={() => {
                        if (window.confirm(`Delete report "${report.title}"?`)) {
                          deleteClinicalReport(report.id);
                        }
                      }}
                      className="text-xs font-bold text-slate-400 hover:text-red-600 flex items-center gap-1 cursor-pointer"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                      <span>Delete</span>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Next Appointment Section */}
        {activeAppointment && activeAppointment.hospitalName && (
          <div className="border border-slate-200 rounded-2xl p-5 space-y-2">
            <h3 className="font-extrabold text-slate-900 text-sm flex items-center gap-2">
              <Hospital className="w-4 h-4 text-blue-600" />
              Scheduled Hospital Follow-up
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 text-xs font-medium text-slate-700 pt-1">
              <div><strong className="text-slate-900">Hospital:</strong> {activeAppointment.hospitalName}</div>
              <div><strong className="text-slate-900">Appointment Date:</strong> {activeAppointment.date} at {activeAppointment.time}</div>
              <div><strong className="text-slate-900">Doctor:</strong> {activeAppointment.doctorName}</div>
            </div>
          </div>
        )}

        {/* Doctor's Signature Area */}
        <div className="pt-8 border-t border-slate-200 grid grid-cols-2 gap-8">
          <div>
            <span className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Physician's Clinical Observations:</span>
            <div className="h-16 border-b border-dashed border-slate-300"></div>
          </div>
          <div className="text-right">
            <span className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-12">Doctor's Signature & Stamp:</span>
            <div className="text-xs font-bold text-slate-700">Authorized Medical Officer</div>
          </div>
        </div>
      </div>

      {/* Modal: Upload Clinical Report Photo */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <form 
            onSubmit={handleAddReport}
            className="glass-panel rounded-3xl max-w-lg w-full p-6 sm:p-8 space-y-5 shadow-2xl relative animate-scaleUp border border-white/95"
          >
            <div className="flex items-center justify-between border-b border-slate-200/50 pb-3">
              <h3 className="text-lg font-black text-slate-900 flex items-center gap-2">
                <Camera className="w-5 h-5 text-emerald-600" />
                <span>Upload Clinical Report Photo</span>
              </h3>
              <button
                type="button"
                onClick={() => setModalOpen(false)}
                className="p-1.5 rounded-full hover:bg-slate-100 text-slate-500 cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Report Document Title *
                </label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  placeholder="e.g. CBC Blood Test, Doctor Prescription, Scalp Scan"
                  required
                  className="glass-input w-full rounded-xl px-4 py-3 text-sm font-bold text-slate-900 outline-none"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Report Date *
                </label>
                <input
                  type="date"
                  value={formData.date}
                  onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                  required
                  className="glass-input w-full rounded-xl px-4 py-3 text-sm font-bold text-slate-900 outline-none cursor-pointer"
                />
              </div>

              {/* Photo Upload Area */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Attach Report Photo / Document Scan *
                </label>

                {formData.photo ? (
                  <div className="relative rounded-2xl overflow-hidden border-2 border-emerald-300 p-2.5 bg-emerald-50/70 backdrop-blur-md flex items-center justify-between">
                    <img
                      src={formData.photo}
                      alt="Report preview"
                      className="w-20 h-20 object-cover rounded-xl border border-emerald-200"
                    />
                    <div className="flex-1 px-3">
                      <div className="text-xs font-black text-emerald-900">Photo Attached ✓</div>
                      <label className="text-xs text-blue-600 font-bold hover:underline cursor-pointer">
                        Change Photo
                        <input
                          type="file"
                          accept="image/*"
                          capture="environment"
                          className="hidden"
                          onChange={handlePhotoUpload}
                        />
                      </label>
                    </div>
                    <button
                      type="button"
                      onClick={() => setFormData(prev => ({ ...prev, photo: '' }))}
                      className="p-2 text-red-600 hover:bg-red-50 rounded-lg cursor-pointer"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ) : (
                  <label className="border-2 border-dashed border-emerald-400/70 hover:border-emerald-500 hover:bg-emerald-50/50 rounded-2xl p-5 flex flex-col items-center justify-center gap-2 cursor-pointer transition-colors glass-card">
                    <div className="w-10 h-10 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center shadow-xs">
                      <Camera className="w-5 h-5" />
                    </div>
                    <div className="text-center">
                      <span className="text-xs font-black text-slate-800 block">
                        {photoUploading ? 'Compressing photo...' : 'Take Photo or Choose File'}
                      </span>
                      <span className="text-[11px] text-slate-400 font-bold">
                        Supports Camera capture, JPG, PNG
                      </span>
                    </div>
                    <input
                      type="file"
                      accept="image/*"
                      capture="environment"
                      className="hidden"
                      onChange={handlePhotoUpload}
                    />
                  </label>
                )}
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Doctor Notes / Summary (Optional)
                </label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  rows={2}
                  placeholder="e.g. Hemoglobin normal, prescribed vitamin supplements."
                  className="glass-input w-full rounded-xl px-4 py-2.5 text-xs font-bold text-slate-800 outline-none"
                />
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 pt-3 border-t border-slate-200/50">
              <button
                type="button"
                onClick={() => setModalOpen(false)}
                className="btn-reactive glass-btn-white px-5 py-2.5 rounded-xl text-slate-800 font-black text-sm cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={photoUploading}
                className="btn-reactive btn-glow-emerald px-6 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md transition-all cursor-pointer border border-white/20"
              >
                Save Report Photo
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Lightbox: View Full Size Photo Modal */}
      {selectedPhoto && (
        <div className="fixed inset-0 z-50 glass-modal-backdrop flex items-center justify-center p-4">
          <div className="glass-panel rounded-3xl max-w-2xl w-full overflow-hidden shadow-2xl relative flex flex-col max-h-[90vh] border border-white/95">
            <div className="p-4 border-b border-slate-200/50 flex items-center justify-between">
              <div>
                <h3 className="font-black text-slate-900 text-base">{selectedPhoto.title}</h3>
                <p className="text-xs text-slate-500 font-bold">{selectedPhoto.date}</p>
              </div>
              <button
                onClick={() => setSelectedPhoto(null)}
                className="p-2 rounded-full hover:bg-slate-100 text-slate-600 cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="flex-1 bg-slate-950/90 p-4 flex items-center justify-center overflow-auto backdrop-blur-md">
              <img
                src={selectedPhoto.src}
                alt={selectedPhoto.title}
                className="max-h-[75vh] w-auto object-contain rounded-xl shadow-lg"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

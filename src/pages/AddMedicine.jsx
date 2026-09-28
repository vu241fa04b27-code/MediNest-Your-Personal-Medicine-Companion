import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { 
  Pill, 
  Clock, 
  Calendar, 
  Phone, 
  Building2, 
  User, 
  FileText, 
  ArrowLeft, 
  Check, 
  Utensils, 
  Sparkles,
  Save,
  Camera,
  Image as ImageIcon,
  Trash2,
  Plus,
  Layers,
  Repeat
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { compressImage } from '../utils/imageUtils';

export const AddMedicine = () => {
  const { medicines, addMedicine, addMultipleMedicines, updateMedicine, t } = useApp();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const editId = searchParams.get('id');

  // Mode: 'single' or 'multiple'
  const [mode, setMode] = useState(editId ? 'single' : 'multiple');

  // 1. Single Medicine Form State
  const [formData, setFormData] = useState({
    name: '',
    dosage: '',
    type: 'Tablet',
    purpose: '',
    photo: '',
    time: '08:00 AM',
    repeat: 'Daily', // Daily, Alternate Days, Twice a Day, Three times a Day, Weekly, SOS
    startDate: new Date().toISOString().split('T')[0],
    endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    remainingStock: 30,
    beforeFood: false,
    afterFood: true,
    doctorName: '',
    doctorNumber: '',
    hospitalName: '',
    hospitalNumber: '',
    notes: ''
  });

  // 2. Multiple Medicines (Batch Entry) State
  const createEmptyMedicineRow = (index) => ({
    tempId: 'row-' + Date.now() + '-' + index,
    name: '',
    dosage: '',
    type: 'Tablet',
    time: index === 0 ? '08:00 AM' : index === 1 ? '01:30 PM' : '09:00 PM',
    repeat: 'Daily', // 'Daily' or 'Alternate Days'
    afterFood: true,
    beforeFood: false,
    remainingStock: 30,
    purpose: '',
    photo: ''
  });

  const [multipleMeds, setMultipleMeds] = useState([
    createEmptyMedicineRow(0),
    createEmptyMedicineRow(1)
  ]);

  const [isEditing, setIsEditing] = useState(false);
  const [photoLoading, setPhotoLoading] = useState(false);

  useEffect(() => {
    if (editId) {
      const existing = medicines.find(m => m.id === editId);
      if (existing) {
        setFormData(existing);
        setIsEditing(true);
        setMode('single');
      }
    }
  }, [editId, medicines]);

  // Handlers for Single Mode
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleFoodTiming = (isAfter) => {
    setFormData(prev => ({
      ...prev,
      afterFood: isAfter,
      beforeFood: !isAfter
    }));
  };

  const handleSinglePhotoUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    try {
      setPhotoLoading(true);
      const compressedDataUrl = await compressImage(file, 800, 0.75);
      setFormData(prev => ({ ...prev, photo: compressedDataUrl }));
    } catch (err) {
      alert('Error processing image. Please try a different photo.');
    } finally {
      setPhotoLoading(false);
    }
  };

  const handleSingleSubmit = (e) => {
    e.preventDefault();
    if (!formData.name.trim()) {
      alert('Please enter your medicine name');
      return;
    }

    if (isEditing) {
      updateMedicine({
        ...formData,
        id: editId,
        remainingStock: Number(formData.remainingStock) || 0
      });
      alert(`✓ Updated "${formData.name}" successfully!`);
    } else {
      addMedicine({
        ...formData,
        id: 'med-' + Date.now(),
        remainingStock: Number(formData.remainingStock) || 30,
        totalStock: Number(formData.remainingStock) || 30,
        takenToday: false
      });
      alert(`✓ Added "${formData.name}" to your medicine tracker!`);
    }

    navigate('/medicines');
  };

  // Handlers for Multiple / Batch Mode
  const handleMultipleChange = (index, field, value) => {
    setMultipleMeds(prev => {
      const updated = [...prev];
      updated[index] = { ...updated[index], [field]: value };
      return updated;
    });
  };

  const handleMultipleFood = (index, isAfter) => {
    setMultipleMeds(prev => {
      const updated = [...prev];
      updated[index] = { 
        ...updated[index], 
        afterFood: isAfter, 
        beforeFood: !isAfter 
      };
      return updated;
    });
  };

  const handleMultiplePhoto = async (index, file) => {
    if (!file) return;
    try {
      const dataUrl = await compressImage(file, 600, 0.75);
      handleMultipleChange(index, 'photo', dataUrl);
    } catch (_) {
      alert('Error reading image.');
    }
  };

  const addAnotherMedicineRow = () => {
    setMultipleMeds(prev => [...prev, createEmptyMedicineRow(prev.length)]);
  };

  const removeMedicineRow = (index) => {
    if (multipleMeds.length <= 1) {
      alert('You must have at least one medicine row');
      return;
    }
    setMultipleMeds(prev => prev.filter((_, i) => i !== index));
  };

  const handleMultipleSubmit = (e) => {
    e.preventDefault();

    // Filter valid medicines with a name
    const validMeds = multipleMeds.filter(m => m.name && m.name.trim().length > 0);

    if (validMeds.length === 0) {
      alert('Please enter at least one medicine name');
      return;
    }

    const todayStr = new Date().toISOString().split('T')[0];
    const newItems = validMeds.map((m, idx) => ({
      id: 'med-' + Date.now() + '-' + idx,
      name: m.name.trim(),
      dosage: m.dosage.trim() || '1 tablet',
      type: m.type || 'Tablet',
      purpose: m.purpose || '',
      photo: m.photo || '',
      time: m.time || '08:00 AM',
      repeat: m.repeat || 'Daily',
      startDate: todayStr,
      endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      remainingStock: Number(m.remainingStock) || 30,
      totalStock: Number(m.remainingStock) || 30,
      afterFood: m.afterFood,
      beforeFood: m.beforeFood,
      doctorName: '',
      doctorNumber: '',
      hospitalName: '',
      hospitalNumber: '',
      notes: '',
      takenToday: false
    }));

    addMultipleMedicines(newItems);
    alert(`✓ Successfully added ${newItems.length} medicines to your tracker!`);
    navigate('/medicines');
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 animate-fadeIn pb-24">
      {/* Top Header */}
      <div className="glass-panel flex flex-col sm:flex-row sm:items-center justify-between gap-4 p-6 rounded-3xl border border-white/90 shadow-sm">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate(-1)}
            className="btn-reactive p-2.5 rounded-2xl bg-white/90 hover:bg-white border border-slate-200 text-slate-800 shadow-sm cursor-pointer"
          >
            <ArrowLeft className="w-5 h-5 stroke-[2.5]" />
          </button>
          <div>
            <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
              {isEditing 
                ? `Edit: ${formData.name || 'Medicine'}` 
                : mode === 'multiple' 
                ? 'Add Multiple Medicines' 
                : 'Add Single Medicine'}
            </h1>
            <p className="text-xs sm:text-sm font-bold text-slate-500">
              {mode === 'multiple' 
                ? 'Enter your entire daily prescription all at once with alternate day options.' 
                : 'Enter medicine parameters, photo, and timing.'}
            </p>
          </div>
        </div>

        {/* Mode Selector Tabs (Hidden when editing an existing medicine) */}
        {!isEditing && (
          <div className="flex items-center bg-white/70 backdrop-blur-md p-1.5 rounded-2xl border border-slate-200/90 shadow-sm self-start sm:self-center">
            <button
              type="button"
              onClick={() => setMode('multiple')}
              className={`btn-reactive flex items-center gap-2 px-4 py-2 rounded-xl text-xs sm:text-sm font-black transition-all cursor-pointer ${
                mode === 'multiple'
                  ? 'bg-gradient-to-r from-emerald-600 to-teal-500 text-white shadow-md shadow-emerald-600/25'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Layers className="w-4 h-4" />
              <span>Multiple (Batch)</span>
            </button>

            <button
              type="button"
              onClick={() => setMode('single')}
              className={`btn-reactive flex items-center gap-2 px-4 py-2 rounded-xl text-xs sm:text-sm font-black transition-all cursor-pointer ${
                mode === 'single'
                  ? 'bg-gradient-to-r from-emerald-600 to-teal-500 text-white shadow-md shadow-emerald-600/25'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Pill className="w-4 h-4" />
              <span>Single Medicine</span>
            </button>
          </div>
        )}
      </div>

      {/* ============================================================ */}
      {/* MODE 1: MULTIPLE MEDICINES FORM (BATCH ENTRY)               */}
      {/* ============================================================ */}
      {mode === 'multiple' && !isEditing && (
        <form onSubmit={handleMultipleSubmit} className="space-y-6">
          <div className="glass-panel bg-emerald-50/85 border border-emerald-300 rounded-3xl p-5 flex items-center justify-between gap-4 shadow-sm">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shrink-0 shadow-md shadow-emerald-500/25">
                <Layers className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-sm sm:text-base font-black text-emerald-950">
                  Prescription Batch Entry: {multipleMeds.length} Medicines Queued
                </h3>
                <p className="text-xs text-emerald-800 font-bold mt-0.5">
                  Patients often take different medicines at breakfast, lunch, or alternate days. Add them all below in one go!
                </p>
              </div>
            </div>

            <button
              type="button"
              onClick={addAnotherMedicineRow}
              className="btn-reactive btn-glow-emerald px-4 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-xs sm:text-sm flex items-center gap-1.5 shadow-sm shrink-0 cursor-pointer"
            >
              <Plus className="w-4 h-4 stroke-[3]" />
              <span>+ Add Medicine</span>
            </button>
          </div>

          {/* List of Medicine Cards */}
          <div className="space-y-5">
            {multipleMeds.map((med, index) => (
              <div 
                key={med.tempId}
                className="glass-card rounded-3xl p-5 sm:p-6 space-y-4 relative"
              >
                {/* Medicine Card Header */}
                <div className="flex items-center justify-between border-b border-slate-200/60 pb-3">
                  <div className="flex items-center gap-2.5">
                    <span className="w-7 h-7 rounded-xl bg-emerald-100 text-emerald-900 font-black text-xs flex items-center justify-center border border-emerald-200">
                      #{index + 1}
                    </span>
                    <span className="font-black text-slate-900 text-sm sm:text-base">
                      {med.name ? med.name : `Medicine ${index + 1}`}
                    </span>
                  </div>

                  {multipleMeds.length > 1 && (
                    <button
                      type="button"
                      onClick={() => removeMedicineRow(index)}
                      className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-xl transition-colors cursor-pointer"
                      title="Remove this medicine"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  )}
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
                  {/* Name */}
                  <div className="sm:col-span-2">
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Medicine Name *
                    </label>
                    <input
                      type="text"
                      value={med.name}
                      onChange={(e) => handleMultipleChange(index, 'name', e.target.value)}
                      placeholder="e.g. Paracetamol, Metformin, Pantocid"
                      required
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3.5 py-2.5 text-sm font-bold text-slate-900 outline-none focus:border-emerald-500 focus:bg-white"
                    />
                  </div>

                  {/* Dosage */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Dosage / Strength
                    </label>
                    <input
                      type="text"
                      value={med.dosage}
                      onChange={(e) => handleMultipleChange(index, 'dosage', e.target.value)}
                      placeholder="e.g. 500mg, 10mg, 1 tab"
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3.5 py-2.5 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500 focus:bg-white"
                    />
                  </div>

                  {/* Form Type */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Form Type
                    </label>
                    <select
                      value={med.type}
                      onChange={(e) => handleMultipleChange(index, 'type', e.target.value)}
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-800 outline-none focus:border-emerald-500 cursor-pointer"
                    >
                      <option value="Tablet">Tablet 💊</option>
                      <option value="Capsule">Capsule 💊</option>
                      <option value="Syrup">Syrup 🥄</option>
                      <option value="Drops">Drops 💧</option>
                      <option value="Inhaler">Inhaler 💨</option>
                      <option value="Injection">Injection 💉</option>
                      <option value="Ointment">Cream 🧴</option>
                    </select>
                  </div>

                  {/* Scheduled Time */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Time of Day *
                    </label>
                    <input
                      type="text"
                      value={med.time}
                      onChange={(e) => handleMultipleChange(index, 'time', e.target.value)}
                      placeholder="08:00 AM"
                      required
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-800 outline-none focus:border-blue-500"
                    />
                    <div className="flex gap-1 mt-1 flex-wrap">
                      {['08:00 AM', '01:30 PM', '09:00 PM'].map((tVal) => (
                        <button
                          key={tVal}
                          type="button"
                          onClick={() => handleMultipleChange(index, 'time', tVal)}
                          className="text-[10px] font-bold px-1.5 py-0.5 rounded bg-slate-100 hover:bg-blue-50 hover:text-blue-700 text-slate-600 cursor-pointer"
                        >
                          {tVal}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Frequency (Daily vs Alternate Days) */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1 flex items-center gap-1">
                      <Repeat className="w-3.5 h-3.5 text-emerald-600" />
                      <span>Frequency *</span>
                    </label>
                    <select
                      value={med.repeat}
                      onChange={(e) => handleMultipleChange(index, 'repeat', e.target.value)}
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2.5 text-xs font-black text-slate-800 outline-none focus:border-emerald-500 cursor-pointer"
                    >
                      <option value="Daily">Daily (Every Day)</option>
                      <option value="Alternate Days">🔄 Alternate Days (Every 2nd Day)</option>
                      <option value="Twice a Day">Twice a Day (Morning + Night)</option>
                      <option value="Weekly">Weekly (Once a Week)</option>
                    </select>
                    {med.repeat === 'Alternate Days' && (
                      <span className="text-[10px] text-emerald-700 font-extrabold block mt-0.5">
                        ✓ Rest day calculated automatically
                      </span>
                    )}
                  </div>

                  {/* Relation to Food */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Food Relation *
                    </label>
                    <div className="grid grid-cols-2 gap-1.5">
                      <button
                        type="button"
                        onClick={() => handleMultipleFood(index, true)}
                        className={`py-2 px-1 rounded-xl text-xs font-bold border transition-colors cursor-pointer ${
                          med.afterFood 
                            ? 'bg-amber-50 text-amber-800 border-amber-400 font-black' 
                            : 'bg-slate-50 text-slate-500 border-slate-200'
                        }`}
                      >
                        🍲 After Food
                      </button>
                      <button
                        type="button"
                        onClick={() => handleMultipleFood(index, false)}
                        className={`py-2 px-1 rounded-xl text-xs font-bold border transition-colors cursor-pointer ${
                          med.beforeFood 
                            ? 'bg-emerald-50 text-emerald-800 border-emerald-400 font-black' 
                            : 'bg-slate-50 text-slate-500 border-slate-200'
                        }`}
                      >
                        🍎 Before Food
                      </button>
                    </div>
                  </div>

                  {/* Stock */}
                  <div>
                    <label className="block text-xs font-black text-slate-700 uppercase mb-1">
                      Total Tablets
                    </label>
                    <input
                      type="number"
                      value={med.remainingStock}
                      onChange={(e) => handleMultipleChange(index, 'remainingStock', e.target.value)}
                      placeholder="30"
                      min="1"
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs font-bold text-slate-800 outline-none focus:border-emerald-500"
                    />
                  </div>
                </div>

                {/* Photo Upload for this specific medicine */}
                <div className="pt-2 border-t border-slate-100 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    {med.photo ? (
                      <div className="flex items-center gap-2">
                        <img src={med.photo} alt="Strip" className="w-10 h-10 object-cover rounded-lg border border-emerald-300" />
                        <span className="text-xs text-emerald-700 font-black">Photo Added ✓</span>
                      </div>
                    ) : (
                      <span className="text-xs text-slate-400 font-medium">Strip photo optional</span>
                    )}
                  </div>

                  <label className="text-xs font-bold text-emerald-700 bg-emerald-50 hover:bg-emerald-100 border border-emerald-200 px-3 py-1.5 rounded-lg cursor-pointer transition-colors flex items-center gap-1">
                    <Camera className="w-3.5 h-3.5" />
                    <span>{med.photo ? 'Change Photo' : 'Attach Photo'}</span>
                    <input
                      type="file"
                      accept="image/*"
                      capture="environment"
                      className="hidden"
                      onChange={(e) => handleMultiplePhoto(index, e.target.files?.[0])}
                    />
                  </label>
                </div>
              </div>
            ))}
          </div>

          {/* Add Another Row Button & Submit */}
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4">
            <button
              type="button"
              onClick={addAnotherMedicineRow}
              className="btn-reactive glass-panel w-full sm:w-auto px-6 py-3.5 rounded-2xl border-2 border-dashed border-emerald-500/80 hover:bg-emerald-50/70 text-emerald-900 font-black text-sm flex items-center justify-center gap-2 shadow-sm cursor-pointer"
            >
              <Plus className="w-5 h-5 stroke-[2.5]" />
              <span>+ Add Another Medicine Row</span>
            </button>

            <button
              type="submit"
              className="btn-reactive btn-glow-emerald w-full sm:w-auto px-8 py-4 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-base shadow-xl shadow-emerald-600/30 flex items-center justify-center gap-2.5 transition-all cursor-pointer border border-white/20"
            >
              <Save className="w-5 h-5 stroke-[2.5]" />
              <span>Save All ({multipleMeds.filter(m => m.name.trim()).length || multipleMeds.length}) Medicines</span>
            </button>
          </div>
        </form>
      )}

      {/* ============================================================ */}
      {/* MODE 2: SINGLE MEDICINE FORM (DETAILED / EDIT)              */}
      {/* ============================================================ */}
      {(mode === 'single' || isEditing) && (
        <form onSubmit={handleSingleSubmit} className="glass-panel rounded-3xl p-6 sm:p-8 space-y-6 border border-white/90 shadow-md">
          {/* Section 1: Medicine Details */}
          <div>
            <h3 className="text-base font-black text-emerald-900 flex items-center gap-2 mb-4">
              <Pill className="w-5 h-5 text-emerald-600" />
              <span>1. Medicine Details & Photo</span>
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {/* Medicine Name */}
              <div className="sm:col-span-2">
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Medicine Name *
                </label>
                <input
                  type="text"
                  name="name"
                  value={formData.name}
                  onChange={handleChange}
                  placeholder="Enter medicine name (e.g. Paracetamol, Metformin, Thyronorm)"
                  required
                  className="w-full bg-slate-50 border-2 border-slate-200 rounded-2xl px-4 py-3 text-base font-bold text-slate-900 outline-none focus:border-emerald-500 focus:bg-white transition-colors"
                />
              </div>

              {/* Dosage */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Dosage / Strength *
                </label>
                <input
                  type="text"
                  name="dosage"
                  value={formData.dosage}
                  onChange={handleChange}
                  placeholder="e.g. 500mg, 10mg, 5ml"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500 focus:bg-white"
                />
                <div className="flex gap-1.5 mt-2 flex-wrap">
                  {['500mg', '250mg', '100mg', '10mg', '1 tablet', '5ml'].map((d) => (
                    <button
                      key={d}
                      type="button"
                      onClick={() => setFormData({ ...formData, dosage: d })}
                      className="text-[11px] font-bold px-2 py-0.5 rounded-md bg-slate-100 hover:bg-emerald-50 hover:text-emerald-700 text-slate-600 transition-colors cursor-pointer"
                    >
                      +{d}
                    </button>
                  ))}
                </div>
              </div>

              {/* Dosage Form */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Form Type *
                </label>
                <select
                  name="type"
                  value={formData.type}
                  onChange={handleChange}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500 cursor-pointer"
                >
                  <option value="Tablet">Tablet 💊</option>
                  <option value="Capsule">Capsule 💊</option>
                  <option value="Syrup">Syrup 🥄</option>
                  <option value="Drops">Drops 💧</option>
                  <option value="Inhaler">Inhaler 💨</option>
                  <option value="Injection">Injection 💉</option>
                  <option value="Ointment">Cream / Ointment 🧴</option>
                </select>
              </div>

              {/* Stock Count */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Tablets in Strip / Total Stock *
                </label>
                <input
                  type="number"
                  name="remainingStock"
                  value={formData.remainingStock}
                  onChange={handleChange}
                  placeholder="30"
                  min="0"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500 focus:bg-white"
                />
              </div>

              {/* Purpose */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Purpose / Reason
                </label>
                <input
                  type="text"
                  name="purpose"
                  value={formData.purpose}
                  onChange={handleChange}
                  placeholder="e.g. For fever, blood pressure, allergy, thyroid"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-emerald-500 focus:bg-white"
                />
              </div>

              {/* Medicine Photo Upload */}
              <div className="sm:col-span-2 pt-2">
                <div className="flex items-center justify-between mb-1.5">
                  <label className="text-xs font-black text-slate-700 uppercase tracking-wide flex items-center gap-1.5">
                    <Camera className="w-4 h-4 text-emerald-600" />
                    <span>Medicine Box / Strip Photo</span>
                  </label>
                  {formData.photo && (
                    <button
                      type="button"
                      onClick={() => setFormData(prev => ({ ...prev, photo: '' }))}
                      className="text-xs text-red-600 font-bold hover:underline cursor-pointer flex items-center gap-1"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                      <span>Remove Photo</span>
                    </button>
                  )}
                </div>

                {formData.photo ? (
                  <div className="relative rounded-2xl border-2 border-emerald-300 bg-emerald-50/50 p-3 flex items-center gap-4">
                    <img
                      src={formData.photo}
                      alt="Medicine preview"
                      className="w-20 h-20 sm:w-24 sm:h-24 object-cover rounded-xl border border-emerald-200 shadow-sm shrink-0"
                    />
                    <div className="flex-1">
                      <div className="text-sm font-black text-emerald-900">Photo Stored ✓</div>
                      <p className="text-xs text-slate-500 mt-0.5">
                        This photo appears on your medicine card and doctor reports.
                      </p>
                      <label className="inline-block mt-2 text-xs font-black text-emerald-700 bg-white border border-emerald-300 px-3 py-1.5 rounded-lg cursor-pointer hover:bg-emerald-50 shadow-sm transition-colors">
                        Change Photo
                        <input
                          type="file"
                          accept="image/*"
                          capture="environment"
                          className="hidden"
                          onChange={handleSinglePhotoUpload}
                        />
                      </label>
                    </div>
                  </div>
                ) : (
                  <label className="border-2 border-dashed border-slate-300 hover:border-emerald-500 hover:bg-emerald-50/40 rounded-2xl p-5 flex flex-col items-center justify-center gap-2 cursor-pointer transition-colors bg-slate-50">
                    <div className="w-10 h-10 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center shadow-sm">
                      <Camera className="w-5 h-5" />
                    </div>
                    <div className="text-center">
                      <span className="text-xs sm:text-sm font-black text-slate-800 block">
                        {photoLoading ? 'Processing Image...' : 'Take Photo or Choose File'}
                      </span>
                      <span className="text-[11px] text-slate-400 font-medium">
                        Capture the tablet strip, syrup bottle, or packaging
                      </span>
                    </div>
                    <input
                      type="file"
                      accept="image/*"
                      capture="environment"
                      className="hidden"
                      onChange={handleSinglePhotoUpload}
                    />
                  </label>
                )}
              </div>
            </div>
          </div>

          {/* Section 2: Timing & Frequency with Alternate Days */}
          <div className="pt-4 border-t border-slate-100">
            <h3 className="text-base font-extrabold text-blue-700 flex items-center gap-2 mb-4">
              <Clock className="w-5 h-5 text-blue-600" />
              <span>2. Schedule & Alternate Day Option</span>
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {/* Time of Day */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Time of Day *
                </label>
                <input
                  type="text"
                  name="time"
                  value={formData.time}
                  onChange={handleChange}
                  placeholder="e.g. 08:00 AM, 01:30 PM, 09:00 PM"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-blue-500 focus:bg-white"
                />
                <div className="flex gap-1.5 mt-2 flex-wrap">
                  {[
                    { label: 'Morning', t: '08:00 AM' },
                    { label: 'Noon', t: '01:00 PM' },
                    { label: 'Evening', t: '05:00 PM' },
                    { label: 'Night', t: '09:00 PM' }
                  ].map((preset) => (
                    <button
                      key={preset.label}
                      type="button"
                      onClick={() => setFormData({ ...formData, time: preset.t })}
                      className="text-[11px] font-bold px-2 py-0.5 rounded-md bg-slate-100 hover:bg-blue-50 hover:text-blue-700 text-slate-600 transition-colors cursor-pointer"
                    >
                      {preset.label} ({preset.t})
                    </button>
                  ))}
                </div>
              </div>

              {/* Frequency - Explicit Alternate Days */}
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5 flex items-center gap-1.5">
                  <Repeat className="w-4 h-4 text-emerald-600" />
                  <span>Frequency / Repeating Schedule *</span>
                </label>
                <select
                  name="repeat"
                  value={formData.repeat}
                  onChange={handleChange}
                  className="w-full bg-slate-50 border-2 border-emerald-500 rounded-xl px-4 py-3 text-sm font-black text-slate-800 outline-none cursor-pointer"
                >
                  <option value="Daily">Daily (Every Day)</option>
                  <option value="Alternate Days">🔄 Alternate Days (Every Other Day • 1 Day On, 1 Day Off)</option>
                  <option value="Twice a Day">Twice a Day (Morning + Night)</option>
                  <option value="Three times a Day">Three times a Day</option>
                  <option value="Weekly">Weekly (Once a Week)</option>
                  <option value="As Needed (SOS)">As Needed (SOS)</option>
                </select>

                {formData.repeat === 'Alternate Days' && (
                  <div className="mt-2 p-3 bg-emerald-50 border border-emerald-300 rounded-xl text-xs text-emerald-900 font-semibold leading-relaxed">
                    <strong>🔄 Alternate Days Enabled:</strong> The app will automatically schedule this medicine every 2nd day starting from today. On off-days, it marks a rest day so you are not reminded incorrectly!
                  </div>
                )}
              </div>

              {/* Food Relation */}
              <div className="sm:col-span-2">
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Relation to Food *
                </label>
                <div className="grid grid-cols-2 gap-3">
                  <button
                    type="button"
                    onClick={() => handleFoodTiming(true)}
                    className={`py-3.5 px-4 rounded-2xl font-bold text-sm flex items-center justify-center gap-2 transition-all border-2 cursor-pointer ${
                      formData.afterFood
                        ? 'bg-amber-50 text-amber-900 border-amber-400 shadow-sm font-black'
                        : 'bg-slate-50 text-slate-600 border-slate-200'
                    }`}
                  >
                    <Utensils className="w-4 h-4 text-amber-600" />
                    <span>🍲 After Food</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => handleFoodTiming(false)}
                    className={`py-3.5 px-4 rounded-2xl font-bold text-sm flex items-center justify-center gap-2 transition-all border-2 cursor-pointer ${
                      formData.beforeFood
                        ? 'bg-emerald-50 text-emerald-900 border-emerald-400 shadow-sm font-black'
                        : 'bg-slate-50 text-slate-600 border-slate-200'
                    }`}
                  >
                    <Utensils className="w-4 h-4 text-emerald-600" />
                    <span>🍎 Before Food</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Section 3: Prescribed By (Optional) */}
          <div className="pt-4 border-t border-slate-100">
            <h3 className="text-base font-extrabold text-purple-700 flex items-center gap-2 mb-4">
              <Building2 className="w-5 h-5 text-purple-600" />
              <span>3. Doctor & Clinic Details (Optional)</span>
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Prescribing Doctor
                </label>
                <input
                  type="text"
                  name="doctorName"
                  value={formData.doctorName}
                  onChange={handleChange}
                  placeholder="Doctor name (e.g. Dr. Sharma)"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-purple-500"
                />
              </div>

              <div>
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Doctor Phone Number
                </label>
                <input
                  type="text"
                  name="doctorNumber"
                  value={formData.doctorNumber}
                  onChange={handleChange}
                  placeholder="Phone number"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-800 outline-none focus:border-purple-500"
                />
              </div>

              <div className="sm:col-span-2">
                <label className="block text-xs font-black text-slate-700 uppercase tracking-wide mb-1.5">
                  Special Instructions / Notes
                </label>
                <textarea
                  name="notes"
                  value={formData.notes}
                  onChange={handleChange}
                  rows={2}
                  placeholder="e.g. Take with warm water. Avoid dairy products."
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-medium text-slate-800 outline-none focus:border-purple-500"
                />
              </div>
            </div>
          </div>

          {/* Form Actions */}
          <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-200/60">
            <button
              type="button"
              onClick={() => navigate('/medicines')}
              className="btn-reactive glass-btn-white px-6 py-3 rounded-2xl text-slate-800 font-black text-sm cursor-pointer"
            >
              Cancel
            </button>

            <button
              type="submit"
              className="btn-reactive btn-glow-emerald px-8 py-3.5 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm sm:text-base shadow-lg shadow-emerald-600/30 flex items-center gap-2 border border-white/20 cursor-pointer"
            >
              <Save className="w-5 h-5 stroke-[2.5]" />
              <span>{isEditing ? 'Save Changes' : 'Add to My Medicines'}</span>
            </button>
          </div>
        </form>
      )}
    </div>
  );
};

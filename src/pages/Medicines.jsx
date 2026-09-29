import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Pill, Search, Plus, AlertTriangle, Trash2, Sparkles } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { MedicineCard } from '../components/common/MedicineCard';

export const Medicines = () => {
  const { medicines, clearAllMedicines, t } = useApp();
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState('All'); // All, Morning, Afternoon, Night

  const lowStockCount = medicines.filter(m => Number(m.remainingStock) <= 5).length;

  const filteredMedicines = medicines.filter(med => {
    const matchesSearch = (med.name || '').toLowerCase().includes(search.toLowerCase()) ||
                          (med.purpose || '').toLowerCase().includes(search.toLowerCase());
    if (!matchesSearch) return false;

    if (filter === 'All') return true;
    const time = (med.time || '').toUpperCase();
    if (filter === 'Morning') return time.includes('AM') || time.includes('08:') || time.includes('09:');
    if (filter === 'Afternoon') return time.includes('01:') || time.includes('02:') || time.includes('12:');
    if (filter === 'Night') return time.includes('08:') || time.includes('09:') || time.includes('10:') || time.includes('PM');
    return true;
  });

  return (
    <div className="space-y-6 animate-fadeIn pb-24">
      {/* Top Header */}
      <div className="glass-panel flex flex-col sm:flex-row sm:items-center justify-between gap-4 p-6 rounded-3xl border border-white/90 shadow-sm">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <Pill className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>My Medicine Tracker</span>
          </h1>
          <p className="text-sm font-bold text-slate-500 mt-1">
            {medicines.length === 0 
              ? 'No medicines added yet. Enter your medicines to set reminders.' 
              : `Managing ${medicines.length} prescribed medication${medicines.length === 1 ? '' : 's'}. Click Edit anytime to change.`}
          </p>
        </div>

        <div className="flex items-center gap-2.5 self-start sm:self-center">
          {medicines.length > 0 && (
            <button
              onClick={() => {
                if (window.confirm('Are you sure you want to clear all medicines from your tracker?')) {
                  clearAllMedicines();
                }
              }}
              className="btn-reactive flex items-center gap-1.5 px-4 py-2.5 rounded-2xl bg-white/80 hover:bg-red-50 border border-red-200 text-red-600 font-black text-xs sm:text-sm shadow-sm transition-colors cursor-pointer"
              title="Delete all medicines to start fresh"
            >
              <Trash2 className="w-4 h-4" />
              <span>Clear All</span>
            </button>
          )}

          <Link
            to="/add-medicine"
            className="btn-reactive btn-glow-emerald inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm sm:text-base shadow-md shadow-emerald-600/30 transition-all cursor-pointer"
          >
            <Plus className="w-5 h-5 stroke-[3]" />
            <span>{t('add_medicine')}</span>
          </Link>
        </div>
      </div>

      {/* If medicines exist, show Search & Filters with Glass UI */}
      {medicines.length > 0 && (
        <div className="flex flex-col md:flex-row gap-3.5">
          <div className="flex-1 relative">
            <Search className="w-5 h-5 absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search your medicine name or purpose..."
              className="glass-input w-full rounded-2xl py-3.5 pl-12 pr-4 text-sm font-bold text-slate-900 outline-none placeholder:text-slate-400 shadow-xs"
            />
          </div>

          {/* Filters */}
          <div className="flex items-center gap-2 overflow-x-auto pb-1">
            {['All', 'Morning', 'Afternoon', 'Night'].map((f) => (
              <button
                key={f}
                onClick={() => setFilter(f)}
                className={`btn-reactive px-4 py-2.5 rounded-2xl text-xs sm:text-sm font-black whitespace-nowrap transition-all border cursor-pointer ${
                  filter === f
                    ? 'bg-gradient-to-r from-emerald-600 to-teal-500 text-white border-transparent shadow-md shadow-emerald-600/25'
                    : 'glass-card text-slate-700 border-white/90 hover:bg-white'
                }`}
              >
                {f}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Low Stock Alert Banner */}
      {lowStockCount > 0 && (
        <div className="glass-panel bg-amber-50/85 border border-amber-300 rounded-3xl p-5 flex items-center gap-3.5 text-amber-900 shadow-sm">
          <div className="w-10 h-10 rounded-2xl bg-amber-100 text-amber-700 flex items-center justify-center shrink-0 shadow-sm">
            <AlertTriangle className="w-5 h-5 stroke-[2.4]" />
          </div>
          <div>
            <div className="font-black text-sm text-amber-950">
              Low Tablet Stock Notice ({lowStockCount} Medicine Running Out)
            </div>
            <div className="text-xs text-amber-800 font-bold mt-0.5">
              Refill soon to avoid missing daily scheduled doses.
            </div>
          </div>
        </div>
      )}

      {/* Empty State vs Medicines Grid */}
      {medicines.length === 0 ? (
        <div className="glass-panel rounded-3xl p-10 sm:p-16 text-center border-2 border-dashed border-emerald-300 space-y-4 shadow-sm">
          <div className="w-16 h-16 rounded-3xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center mx-auto shadow-md shadow-emerald-500/25">
            <Pill className="w-8 h-8 stroke-[2.2]" />
          </div>
          <div className="max-w-md mx-auto space-y-2">
            <h3 className="text-xl font-black text-slate-900 tracking-tight">
              No Medicines Added Yet
            </h3>
            <p className="text-sm font-bold text-slate-500">
              Enter your medicine names, dosages, and times. You can edit or change them at any time.
            </p>
          </div>
          <div className="pt-2">
            <Link
              to="/add-medicine"
              className="btn-reactive btn-glow-emerald inline-flex items-center gap-2.5 px-6 py-3.5 bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm sm:text-base rounded-2xl shadow-lg shadow-emerald-600/30 transition-all cursor-pointer"
            >
              <Plus className="w-5 h-5 stroke-[3]" />
              <span>Add Your First Medicine</span>
            </Link>
          </div>
        </div>
      ) : filteredMedicines.length === 0 ? (
        <div className="glass-card rounded-3xl p-12 text-center border border-white/90">
          <Pill className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <h3 className="text-lg font-black text-slate-800">No matching medicines found</h3>
          <p className="text-xs font-bold text-slate-500 mt-1">Try adjusting your search query.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-5">
          {filteredMedicines.map((med) => (
            <MedicineCard
              key={med.id}
              medicine={med}
              onEdit={(m) => navigate(`/add-medicine?id=${m.id}`)}
            />
          ))}
        </div>
      )}
    </div>
  );
};

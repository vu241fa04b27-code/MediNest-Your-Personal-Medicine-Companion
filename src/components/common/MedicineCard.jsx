import React, { useState } from 'react';
import { Pill, Clock, Utensils, AlertTriangle, Plus, Trash2, Edit3, CheckCircle2, Eye, X, Repeat } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const MedicineCard = ({ medicine, onEdit }) => {
  const { markDoseTaken, deleteMedicine, refillMedicine, isMedicineDueToday, t } = useApp();
  const [showFullPhoto, setShowFullPhoto] = useState(false);
  const isLowStock = Number(medicine.remainingStock) <= 5;
  const isDueToday = isMedicineDueToday ? isMedicineDueToday(medicine) : true;

  return (
    <div className={`glass-card rounded-3xl p-5 sm:p-6 border transition-all ${isLowStock ? 'border-amber-300/80 bg-amber-50/30' : 'border-white/95'}`}>
      {/* Top Header */}
      <div className="flex items-start justify-between gap-3 mb-4">
        <div className="flex items-center gap-3.5">
          {medicine.photo ? (
            <div 
              onClick={() => setShowFullPhoto(true)}
              className="relative w-14 h-14 rounded-2xl overflow-hidden border-2 border-emerald-300 shadow-sm shrink-0 cursor-pointer group"
              title="Click to view full photo"
            >
              <img
                src={medicine.photo}
                alt={medicine.name}
                className="w-full h-full object-cover group-hover:scale-110 transition-transform"
              />
              <div className="absolute inset-0 bg-black/25 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity text-white">
                <Eye className="w-4 h-4" />
              </div>
            </div>
          ) : (
            <div className={`w-12 h-12 rounded-2xl flex items-center justify-center font-black text-xl shrink-0 ${isLowStock ? 'bg-amber-100 text-amber-700' : 'bg-gradient-to-tr from-emerald-500 to-teal-400 text-white shadow-md shadow-emerald-500/25'}`}>
              <Pill className="w-6 h-6 stroke-[2.4]" />
            </div>
          )}

          <div>
            <h4 className="text-xl font-black text-slate-900 tracking-tight">
              {medicine.name}
            </h4>
            <div className="text-xs font-black text-slate-500 mt-0.5 tracking-tight">
              {medicine.dosage} {medicine.type ? `• ${medicine.type}` : ''}
            </div>
          </div>
        </div>

        {/* Edit / Delete actions with Reactive Buttons */}
        <div className="flex items-center gap-1.5">
          <button
            onClick={() => onEdit && onEdit(medicine)}
            className="btn-reactive flex items-center gap-1 px-3 py-1.5 rounded-xl text-sky-900 bg-sky-50/90 border border-sky-200/90 hover:bg-sky-100 font-black text-xs shadow-sm cursor-pointer"
            title="Edit Medicine Details"
          >
            <Edit3 className="w-3.5 h-3.5 stroke-[2.5]" />
            <span>Edit</span>
          </button>
          <button
            onClick={() => {
              if (window.confirm(`Are you sure you want to delete ${medicine.name}?`)) {
                deleteMedicine(medicine.id);
              }
            }}
            className="btn-reactive p-1.5 rounded-xl text-slate-400 hover:text-red-600 hover:bg-red-50 border border-transparent hover:border-red-200 transition-colors cursor-pointer"
            title="Delete Medicine"
          >
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Badges: Time, Food timing, Frequency / Alternate Day, Stock */}
      <div className="flex flex-wrap items-center gap-2 mb-3.5">
        <span className="inline-flex items-center gap-1 text-xs font-black px-2.5 py-1 rounded-xl bg-sky-50 text-sky-800 border border-sky-200">
          <Clock className="w-3.5 h-3.5" />
          {medicine.time}
        </span>
        <span className={`inline-flex items-center gap-1 text-xs font-black px-2.5 py-1 rounded-xl ${medicine.afterFood ? 'bg-amber-50 text-amber-900 border border-amber-300' : 'bg-emerald-50 text-emerald-900 border border-emerald-300'}`}>
          <Utensils className="w-3.5 h-3.5" />
          {medicine.afterFood ? t('after_food') : t('before_food')}
        </span>

        {/* Alternate Day Badge */}
        {medicine.repeat === 'Alternate Days' ? (
          <span className={`inline-flex items-center gap-1 text-xs font-black px-2.5 py-1 rounded-xl border ${
            isDueToday 
              ? 'bg-purple-100 text-purple-900 border-purple-300 font-black' 
              : 'bg-slate-100 text-slate-700 border-slate-300'
          }`}>
            <Repeat className="w-3.5 h-3.5" />
            {isDueToday ? 'Due Today (Alternate Day)' : 'Rest Day (Due Tomorrow)'}
          </span>
        ) : medicine.repeat && medicine.repeat !== 'Daily' ? (
          <span className="inline-flex items-center gap-1 text-xs font-bold px-2.5 py-1 rounded-xl bg-indigo-50 text-indigo-700 border border-indigo-200">
            {medicine.repeat}
          </span>
        ) : null}

        <span className={`inline-flex items-center gap-1 text-xs font-black px-2.5 py-1 rounded-xl ${isLowStock ? 'bg-red-100 text-red-700 animate-pulse border border-red-300' : 'bg-white/80 text-slate-700 border border-slate-200 shadow-sm'}`}>
          {isLowStock && <AlertTriangle className="w-3.5 h-3.5" />}
          {medicine.remainingStock} {t('remaining_tablets')}
        </span>
      </div>

      {/* Purpose */}
      {medicine.purpose && (
        <p className="text-xs sm:text-sm text-slate-700 font-bold mb-4 bg-white/60 p-3 rounded-2xl border border-slate-100">
          <strong className="text-slate-900">Purpose:</strong> {medicine.purpose}
        </p>
      )}

      {/* Low stock refill alert if <= 5 */}
      {isLowStock && (
        <div className="mb-4 bg-amber-50/90 border border-amber-300 rounded-2xl p-3 flex items-center justify-between gap-2 text-xs font-black text-amber-900">
          <span className="flex items-center gap-1.5">
            <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0" />
            {t('low_stock_alert')}
          </span>
          <button
            onClick={() => refillMedicine(medicine.id, 10)}
            className="btn-reactive px-3 py-1.5 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-black shadow-sm shrink-0 cursor-pointer"
          >
            {t('refill')}
          </button>
        </div>
      )}

      {/* Action Buttons: Take Now & Refill with Reactive Buttons */}
      <div className="grid grid-cols-3 gap-2.5 pt-2 border-t border-slate-100">
        <button
          onClick={() => markDoseTaken(medicine.id)}
          className={`btn-reactive col-span-2 py-3 px-4 rounded-2xl font-black text-sm sm:text-base flex items-center justify-center gap-2 cursor-pointer ${
            medicine.takenToday
              ? 'bg-emerald-100/90 text-emerald-950 border border-emerald-300 shadow-sm'
              : 'btn-glow-emerald bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white shadow-md shadow-emerald-600/25'
          }`}
        >
          <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
          <span>{medicine.takenToday ? 'Taken Today ✓' : t('take_now')}</span>
        </button>

        <button
          onClick={() => refillMedicine(medicine.id, 10)}
          className="btn-reactive col-span-1 py-3 px-2 rounded-2xl font-black text-xs sm:text-sm bg-white/90 hover:bg-white text-slate-800 border border-slate-200 hover:border-slate-300 flex items-center justify-center gap-1 shadow-sm cursor-pointer"
          title="Add 10 Tablets to Stock"
        >
          <Plus className="w-4 h-4" />
          <span>+10 Refill</span>
        </button>
      </div>

      {/* Full Photo Lightbox Modal */}
      {showFullPhoto && medicine.photo && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4">
          <div className="glass-panel rounded-3xl max-w-lg w-full overflow-hidden shadow-2xl relative">
            <div className="p-4 border-b border-slate-100 flex items-center justify-between">
              <div>
                <h3 className="font-black text-slate-900 text-base">{medicine.name}</h3>
                <p className="text-xs text-slate-500 font-bold">{medicine.dosage} • Strip / Bottle Photo</p>
              </div>
              <button
                onClick={() => setShowFullPhoto(false)}
                className="p-2 rounded-full hover:bg-slate-100 text-slate-600 cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="p-4 bg-slate-950 flex items-center justify-center max-h-[70vh]">
              <img
                src={medicine.photo}
                alt={medicine.name}
                className="max-h-[65vh] w-auto object-contain rounded-xl"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

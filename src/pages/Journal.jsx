import React, { useState } from 'react';
import { 
  BookHeart, 
  Smile, 
  Moon, 
  Zap, 
  AlertCircle, 
  CheckCircle2, 
  Plus, 
  Calendar,
  X 
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export const Journal = () => {
  const { journalEntries, addJournalEntry, t } = useApp();
  const [showAddForm, setShowAddForm] = useState(false);

  const [formData, setFormData] = useState({
    date: new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }),
    mood: '😊',
    sleepHours: 8,
    energy: 'Normal',
    itching: 'Mild',
    hairFall: 'Less',
    notes: ''
  });

  const [savedSuccess, setSavedSuccess] = useState(false);

  const moods = [
    { emoji: '😊', label: 'Great' },
    { emoji: '🙂', label: 'Good' },
    { emoji: '😐', label: 'Okay' },
    { emoji: '😣', label: 'Uncomfortable' },
    { emoji: '😴', label: 'Tired' },
  ];

  const handleSubmit = (e) => {
    e.preventDefault();
    addJournalEntry({
      id: 'j-' + Date.now(),
      ...formData,
      sleepHours: Number(formData.sleepHours)
    });
    setSavedSuccess(true);
    setTimeout(() => {
      setSavedSuccess(false);
      setShowAddForm(false);
    }, 1200);
  };

  return (
    <div className="space-y-6 sm:space-y-8 animate-fadeIn pb-24">
      {/* Header */}
      <div className="glass-panel p-6 sm:p-7 rounded-3xl border border-white/90 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight flex items-center gap-2.5">
            <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-md shadow-emerald-500/25">
              <BookHeart className="w-5 h-5 stroke-[2.5]" />
            </div>
            <span>{t('health_journal')}</span>
          </h1>
          <p className="text-slate-500 font-bold text-sm mt-1">
            Track daily mood, recovery comfort, sleep, and observations for your doctor reviews.
          </p>
        </div>

        <button
          onClick={() => setShowAddForm(!showAddForm)}
          className="btn-reactive btn-glow-emerald flex items-center gap-2 px-5 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm sm:text-base shadow-md shadow-emerald-600/25 transition-all self-start sm:self-center cursor-pointer border border-white/20"
        >
          {showAddForm ? <X className="w-5 h-5 stroke-[2.5]" /> : <Plus className="w-5 h-5 stroke-[3]" />}
          <span>{showAddForm ? 'Close Entry Form' : "Write Today's Diary"}</span>
        </button>
      </div>

      {/* Entry Form */}
      {showAddForm && (
        <form 
          onSubmit={handleSubmit}
          className="glass-panel rounded-3xl border border-white/90 p-6 sm:p-8 shadow-sm space-y-6 animate-scaleUp"
        >
          <div className="flex items-center justify-between border-b border-slate-200/50 pb-4">
            <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
              <Calendar className="w-5 h-5 text-emerald-600" />
              New Diary Entry: {formData.date}
            </h2>
            {savedSuccess && (
              <span className="flex items-center gap-1.5 text-sm font-black text-emerald-800 bg-emerald-100/90 px-3.5 py-1.5 rounded-full border border-emerald-300">
                <CheckCircle2 className="w-4 h-4 text-emerald-700" /> Saved!
              </span>
            )}
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Mood */}
            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-2">
                How do you feel today? (Mood)
              </label>
              <div className="flex gap-2 flex-wrap">
                {moods.map((m) => (
                  <button
                    key={m.emoji}
                    type="button"
                    onClick={() => setFormData({ ...formData, mood: m.emoji })}
                    className={`btn-reactive flex items-center gap-2 px-3.5 py-2.5 rounded-2xl border text-xs sm:text-sm font-black transition-all cursor-pointer ${
                      formData.mood === m.emoji
                        ? 'border-emerald-500 bg-emerald-100/90 text-emerald-950 ring-2 ring-emerald-500/25 shadow-sm'
                        : 'glass-card border-white/90 hover:bg-white text-slate-700'
                    }`}
                  >
                    <span className="text-xl">{m.emoji}</span>
                    <span>{m.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Sleep Hours */}
            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-2 flex items-center gap-1.5">
                <Moon className="w-4 h-4 text-indigo-500" />
                <span>Sleep Duration:</span>
                <span className="text-indigo-600 font-black">{formData.sleepHours} Hours</span>
              </label>
              <input
                type="range"
                min="3"
                max="12"
                step="0.5"
                value={formData.sleepHours}
                onChange={(e) => setFormData({ ...formData, sleepHours: e.target.value })}
                className="w-full accent-indigo-600 cursor-pointer h-2 bg-slate-200/80 rounded-lg"
              />
              <div className="flex justify-between text-xs text-slate-400 mt-1.5 font-bold">
                <span>3h</span>
                <span>7-8h (Recommended)</span>
                <span>12h</span>
              </div>
            </div>

            {/* Scalp Itching Level */}
            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-2">
                Scalp Comfort & Itching Level
              </label>
              <div className="grid grid-cols-4 gap-2">
                {['None', 'Mild', 'Moderate', 'Severe'].map((lvl) => (
                  <button
                    key={lvl}
                    type="button"
                    onClick={() => setFormData({ ...formData, itching: lvl })}
                    className={`btn-reactive py-2.5 px-1 text-center rounded-xl border text-xs font-black transition-all cursor-pointer ${
                      formData.itching === lvl
                        ? lvl === 'None'
                          ? 'border-emerald-500 bg-emerald-100/90 text-emerald-950'
                          : lvl === 'Mild'
                          ? 'border-blue-500 bg-blue-100/90 text-blue-950'
                          : lvl === 'Moderate'
                          ? 'border-amber-500 bg-amber-100/90 text-amber-950'
                          : 'border-red-500 bg-red-100/90 text-red-950'
                        : 'glass-card border-white/90 text-slate-700 hover:bg-white'
                    }`}
                  >
                    {lvl}
                  </button>
                ))}
              </div>
            </div>

            {/* Hair Fall Today */}
            <div>
              <label className="block text-xs font-black text-slate-700 uppercase mb-2">
                Hair Fall Observed Today
              </label>
              <div className="grid grid-cols-4 gap-2">
                {['None', 'Less', 'Moderate', 'Heavy'].map((hf) => (
                  <button
                    key={hf}
                    type="button"
                    onClick={() => setFormData({ ...formData, hairFall: hf })}
                    className={`btn-reactive py-2.5 px-1 text-center rounded-xl border text-xs font-black transition-all cursor-pointer ${
                      formData.hairFall === hf
                        ? 'border-emerald-600 bg-emerald-100/90 text-emerald-950 ring-2 ring-emerald-500/25'
                        : 'glass-card border-white/90 text-slate-700 hover:bg-white'
                    }`}
                  >
                    {hf}
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Notes */}
          <div>
            <label className="block text-xs font-black text-slate-700 uppercase mb-2">
              Daily Notes & Observations (Diet, medication taken, scalp state)
            </label>
            <textarea
              rows={3}
              value={formData.notes}
              onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
              placeholder="e.g. Applied lotion before bath, took tablet after food. Feeling comfortable and no itchiness."
              className="glass-input w-full px-4 py-3 rounded-2xl text-slate-800 font-bold text-sm outline-none"
            />
          </div>

          <div className="flex justify-end gap-3 pt-2 border-t border-slate-200/50">
            <button
              type="button"
              onClick={() => setShowAddForm(false)}
              className="btn-reactive glass-btn-white px-5 py-2.5 rounded-xl text-slate-800 font-black text-sm cursor-pointer"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn-reactive btn-glow-emerald px-6 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white font-black text-sm shadow-md cursor-pointer border border-white/20"
            >
              Save Diary Entry
            </button>
          </div>
        </form>
      )}

      {/* Past Entries */}
      <div className="space-y-4">
        <h2 className="text-xl font-black text-slate-900 tracking-tight">Recent Diary Entries</h2>

        {journalEntries.length === 0 ? (
          <div className="glass-panel rounded-3xl p-10 text-center border border-dashed border-emerald-300 space-y-2">
            <p className="text-slate-700 font-black text-base">No diary entries recorded yet.</p>
            <p className="text-xs text-slate-500 font-bold">Write your first update today to keep track of your daily recovery!</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {journalEntries.map((entry) => (
              <div 
                key={entry.id}
                className="glass-card rounded-3xl border border-white/90 p-5 shadow-sm space-y-3.5 hover:border-emerald-300 transition-all"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-3xl p-2 rounded-2xl glass-panel border border-white/90 shadow-xs">{entry.mood}</span>
                    <div>
                      <h3 className="font-black text-slate-900 text-base">{entry.date}</h3>
                      <p className="text-xs text-slate-500 font-bold flex items-center gap-1 mt-0.5">
                        <Moon className="w-3.5 h-3.5 text-indigo-500" />
                        {entry.sleepHours} hours sleep
                      </p>
                    </div>
                  </div>

                  <div className="text-right">
                    <span className={`px-3 py-1 rounded-xl text-xs font-black border ${
                      entry.itching === 'None'
                        ? 'bg-emerald-100/90 text-emerald-950 border-emerald-300'
                        : entry.itching === 'Mild'
                        ? 'bg-blue-100/90 text-blue-950 border-blue-300'
                        : 'bg-amber-100/90 text-amber-950 border-amber-300'
                    }`}>
                      Itch: {entry.itching}
                    </span>
                  </div>
                </div>

                <div className="flex gap-2 text-xs font-black text-slate-700">
                  <span className="glass-pill px-3 py-1 rounded-xl">
                    Hair Fall: {entry.hairFall || 'Less'}
                  </span>
                  {entry.energy && (
                    <span className="glass-pill px-3 py-1 rounded-xl">
                      Energy: {entry.energy}
                    </span>
                  )}
                </div>

                {entry.notes && (
                  <p className="text-xs sm:text-sm text-slate-800 glass-panel p-3.5 rounded-2xl border border-white/80 leading-relaxed font-bold">
                    "{entry.notes}"
                  </p>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

import React, { useState } from 'react';
import { 
  BookHeart, 
  Smile, 
  Moon, 
  Zap, 
  AlertCircle, 
  CheckCircle2, 
  Plus, 
  Calendar 
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
    <div className="space-y-6 pb-20">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2.5">
            <BookHeart className="w-8 h-8 text-emerald-600" />
            {t('health_journal')}
          </h1>
          <p className="text-slate-500 font-medium text-sm mt-1">
            Track daily mood, scalp comfort, sleep, and recovery notes for your doctor visits.
          </p>
        </div>

        <button
          onClick={() => setShowAddForm(!showAddForm)}
          className="flex items-center gap-2 px-5 py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold shadow-sm transition-all"
        >
          <Plus className="w-5 h-5" />
          <span>{showAddForm ? 'Close Entry Form' : 'Write Today\'s Diary'}</span>
        </button>
      </div>

      {/* Entry Form */}
      {showAddForm && (
        <form 
          onSubmit={handleSubmit}
          className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-6 animate-fade-in"
        >
          <div className="flex items-center justify-between border-b border-slate-100 pb-4">
            <h2 className="text-lg font-black text-slate-900 flex items-center gap-2">
              <Calendar className="w-5 h-5 text-emerald-600" />
              New Diary Entry: {formData.date}
            </h2>
            {savedSuccess && (
              <span className="flex items-center gap-1.5 text-sm font-extrabold text-emerald-600 bg-emerald-50 px-3 py-1.5 rounded-full">
                <CheckCircle2 className="w-4 h-4" /> Saved!
              </span>
            )}
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Mood */}
            <div>
              <label className="block text-sm font-extrabold text-slate-700 mb-2">
                How do you feel today? (Mood)
              </label>
              <div className="flex gap-2 flex-wrap">
                {moods.map((m) => (
                  <button
                    key={m.emoji}
                    type="button"
                    onClick={() => setFormData({ ...formData, mood: m.emoji })}
                    className={`flex items-center gap-2 px-4 py-2.5 rounded-2xl border text-sm font-bold transition-all ${
                      formData.mood === m.emoji
                        ? 'border-emerald-600 bg-emerald-50 text-emerald-800 ring-2 ring-emerald-500/20 shadow-sm'
                        : 'border-slate-200 hover:bg-slate-50 text-slate-700'
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
              <label className="block text-sm font-extrabold text-slate-700 mb-2 flex items-center gap-1.5">
                <Moon className="w-4 h-4 text-indigo-500" />
                Sleep Duration: <span className="text-indigo-600 font-black">{formData.sleepHours} Hours</span>
              </label>
              <input
                type="range"
                min="3"
                max="12"
                step="0.5"
                value={formData.sleepHours}
                onChange={(e) => setFormData({ ...formData, sleepHours: e.target.value })}
                className="w-full accent-indigo-600 cursor-pointer h-2 bg-slate-200 rounded-lg"
              />
              <div className="flex justify-between text-xs text-slate-400 mt-1 font-semibold">
                <span>3h</span>
                <span>7-8h (Healthy)</span>
                <span>12h</span>
              </div>
            </div>

            {/* Scalp Itching Level */}
            <div>
              <label className="block text-sm font-extrabold text-slate-700 mb-2">
                Scalp Itching & Irritation Level
              </label>
              <div className="grid grid-cols-4 gap-2">
                {['None', 'Mild', 'Moderate', 'Severe'].map((lvl) => (
                  <button
                    key={lvl}
                    type="button"
                    onClick={() => setFormData({ ...formData, itching: lvl })}
                    className={`py-2 px-1 text-center rounded-xl border text-xs font-black transition-all ${
                      formData.itching === lvl
                        ? lvl === 'None'
                          ? 'border-emerald-500 bg-emerald-50 text-emerald-800'
                          : lvl === 'Mild'
                          ? 'border-blue-500 bg-blue-50 text-blue-800'
                          : lvl === 'Moderate'
                          ? 'border-amber-500 bg-amber-50 text-amber-800'
                          : 'border-red-500 bg-red-50 text-red-800'
                        : 'border-slate-200 text-slate-600 hover:bg-slate-50'
                    }`}
                  >
                    {lvl}
                  </button>
                ))}
              </div>
            </div>

            {/* Hair Fall Today */}
            <div>
              <label className="block text-sm font-extrabold text-slate-700 mb-2">
                Hair Fall Observed Today
              </label>
              <div className="grid grid-cols-4 gap-2">
                {['None', 'Less', 'Moderate', 'Heavy'].map((hf) => (
                  <button
                    key={hf}
                    type="button"
                    onClick={() => setFormData({ ...formData, hairFall: hf })}
                    className={`py-2 px-1 text-center rounded-xl border text-xs font-black transition-all ${
                      formData.hairFall === hf
                        ? 'border-emerald-600 bg-emerald-50 text-emerald-800 ring-2 ring-emerald-500/20'
                        : 'border-slate-200 text-slate-600 hover:bg-slate-50'
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
            <label className="block text-sm font-extrabold text-slate-700 mb-2">
              Daily Notes & Observations (Diet, lotion applied, how scalp felt)
            </label>
            <textarea
              rows={3}
              value={formData.notes}
              onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
              placeholder="e.g. Applied lotion before bath, took tablet after food. No itchiness in the evening."
              className="w-full px-4 py-3 rounded-2xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-emerald-500 text-slate-800 font-medium text-sm"
            />
          </div>

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => setShowAddForm(false)}
              className="px-5 py-2.5 rounded-xl border border-slate-200 text-slate-600 font-bold hover:bg-slate-50"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="px-6 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold shadow-md shadow-emerald-600/20"
            >
              Save Diary Entry
            </button>
          </div>
        </form>
      )}

      {/* Past Entries */}
      <div className="space-y-4">
        <h2 className="text-xl font-black text-slate-900">Recent Diary Entries</h2>

        {journalEntries.length === 0 ? (
          <div className="bg-white rounded-3xl p-10 text-center border border-slate-200">
            <p className="text-slate-500 font-bold">No diary entries yet. Write your first update today!</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {journalEntries.map((entry) => (
              <div 
                key={entry.id}
                className="bg-white rounded-3xl border border-slate-200 p-5 shadow-sm space-y-4 hover:border-slate-300 transition-all"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-3xl p-2 rounded-2xl bg-slate-50 border border-slate-100">{entry.mood}</span>
                    <div>
                      <h3 className="font-extrabold text-slate-900 text-base">{entry.date}</h3>
                      <p className="text-xs text-slate-500 font-medium flex items-center gap-1">
                        <Moon className="w-3.5 h-3.5 text-indigo-500" />
                        {entry.sleepHours} hours sleep
                      </p>
                    </div>
                  </div>

                  <div className="text-right">
                    <span className={`px-2.5 py-1 rounded-full text-xs font-extrabold ${
                      entry.itching === 'None'
                        ? 'bg-emerald-50 text-emerald-700'
                        : entry.itching === 'Mild'
                        ? 'bg-blue-50 text-blue-700'
                        : 'bg-amber-50 text-amber-700'
                    }`}>
                      Itch: {entry.itching}
                    </span>
                  </div>
                </div>

                <div className="flex gap-2 text-xs font-bold text-slate-600">
                  <span className="bg-slate-100 px-2.5 py-1 rounded-lg">
                    Hair Fall: {entry.hairFall || 'Less'}
                  </span>
                  {entry.energy && (
                    <span className="bg-slate-100 px-2.5 py-1 rounded-lg">
                      Energy: {entry.energy}
                    </span>
                  )}
                </div>

                {entry.notes && (
                  <p className="text-sm text-slate-700 bg-slate-50 p-3.5 rounded-2xl border border-slate-100 leading-relaxed font-medium">
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

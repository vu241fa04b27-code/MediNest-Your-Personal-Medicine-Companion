import React from 'react';
import { Link } from 'react-router-dom';
import { Home, Pill } from 'lucide-react';

export const NotFound = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-[60vh] text-center space-y-6 animate-fadeIn">
      <div className="w-20 h-20 rounded-3xl bg-gradient-to-tr from-emerald-500 to-teal-400 text-white flex items-center justify-center shadow-lg shadow-emerald-500/25">
        <Pill className="w-10 h-10 stroke-[2]" />
      </div>
      <div>
        <h1 className="text-5xl font-black text-slate-900">404</h1>
        <h2 className="text-xl font-black text-slate-700 mt-2">Page Not Found</h2>
        <p className="text-sm font-bold text-slate-500 mt-2 max-w-sm mx-auto">
          The page you're looking for doesn't exist. Head back to the dashboard to continue managing your medicines.
        </p>
      </div>
      <Link
        to="/"
        className="btn-reactive btn-glow-emerald inline-flex items-center gap-2 px-6 py-3 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-500 text-white font-black text-sm shadow-md shadow-emerald-600/25"
      >
        <Home className="w-4 h-4" />
        <span>Back to Dashboard</span>
      </Link>
    </div>
  );
};

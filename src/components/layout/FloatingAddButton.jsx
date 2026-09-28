import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Plus } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export const FloatingAddButton = () => {
  const { t } = useApp();
  const location = useLocation();

  // Hide on the Add Medicine page itself or emergency page
  if (location.pathname === '/add-medicine' || location.pathname === '/emergency') {
    return null;
  }

  return (
    <div className="fixed bottom-24 lg:bottom-8 right-6 z-30 pointer-events-auto no-print">
      <Link
        to="/add-medicine"
        className="btn-reactive btn-glow-emerald flex items-center gap-2.5 px-6 py-4 bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white rounded-full font-black text-sm sm:text-base shadow-xl shadow-emerald-600/35 border border-emerald-300/40 cursor-pointer"
      >
        <Plus className="w-5 h-5 stroke-[3]" />
        <span className="tracking-tight">{t('add_medicine')}</span>
      </Link>
    </div>
  );
};

import React from 'react';
import { Routes, Route } from 'react-router-dom';
import { Navbar } from './components/layout/Navbar';
import { Sidebar } from './components/layout/Sidebar';
import { BottomNav } from './components/layout/BottomNav';
import { FloatingAddButton } from './components/layout/FloatingAddButton';

// Pages
import { Home } from './pages/Home';
import { Medicines } from './pages/Medicines';
import { AddMedicine } from './pages/AddMedicine';
import { Hospital } from './pages/Hospital';
import { Doctor } from './pages/Doctor';
import { Journal } from './pages/Journal';
import { History } from './pages/History';
import { Reports } from './pages/Reports';
import { Emergency } from './pages/Emergency';
import { Settings } from './pages/Settings';

export const App = () => {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 flex flex-col font-sans antialiased selection:bg-emerald-100 selection:text-emerald-950 relative">
      {/* Ambient Atmospheric Glow Orbs for Glass Model Refraction */}
      <div className="ambient-glow-wrapper">
        <div className="orb-emerald"></div>
        <div className="orb-blue"></div>
        <div className="orb-purple"></div>
      </div>

      {/* Top Navigation Bar */}
      <Navbar />

      <div className="flex-1 flex max-w-7xl w-full mx-auto">
        {/* Left Sidebar for Desktop (>= 1024px) */}
        <Sidebar />

        {/* Main Content Area */}
        <main className="flex-1 px-4 sm:px-6 lg:px-8 py-6 max-w-full overflow-x-hidden">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/medicines" element={<Medicines />} />
            <Route path="/add-medicine" element={<AddMedicine />} />
            <Route path="/hospital" element={<Hospital />} />
            <Route path="/doctor" element={<Doctor />} />
            <Route path="/journal" element={<Journal />} />
            <Route path="/history" element={<History />} />
            <Route path="/reports" element={<Reports />} />
            <Route path="/emergency" element={<Emergency />} />
            <Route path="/settings" element={<Settings />} />
          </Routes>
        </main>
      </div>

      {/* Floating Add Medicine Button (safe margin, never overlaps) */}
      <FloatingAddButton />

      {/* Mobile Bottom Navigation Bar (< 1024px) */}
      <BottomNav />
    </div>
  );
};

export default App;

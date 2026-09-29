import React, { createContext, useContext, useState, useEffect } from 'react';
import confetti from 'canvas-confetti';
import { notificationService } from '../services/notificationService';
import { translations } from '../utils/translations';

const AppContext = createContext();

export const AppProvider = ({ children }) => {
  // 1. Medicines (Starts empty so user adds their own medicines!)
  const [medicines, setMedicines] = useState(() => {
    const saved = localStorage.getItem('medinest_user_medicines');
    if (saved !== null) {
      try {
        return JSON.parse(saved);
      } catch (_) {
        return [];
      }
    }
    return [];
  });

  // 2. Hospital Appointments
  const [appointments, setAppointments] = useState(() => {
    const saved = localStorage.getItem('medinest_appointments_v3');
    if (saved) return JSON.parse(saved);
    return [];
  });

  // 3. Doctors Directory
  const [doctors, setDoctors] = useState(() => {
    const saved = localStorage.getItem('medinest_doctors_v3');
    if (saved) return JSON.parse(saved);
    return [];
  });

  // 4. Hospital Info
  const [hospitalInfo, setHospitalInfo] = useState(() => {
    const saved = localStorage.getItem('medinest_hospital_info');
    if (saved) return JSON.parse(saved);
    return {
      name: '',
      address: '',
      phone: '',
      emergencyPhone: '108',
      workingHours: '24x7 Emergency'
    };
  });

  // 5. Journal Entries
  const [journalEntries, setJournalEntries] = useState(() => {
    const saved = localStorage.getItem('medinest_journal_v3');
    if (saved) return JSON.parse(saved);
    return [];
  });

  // 5b. Clinical Report Photos & Documents
  const [clinicalReports, setClinicalReports] = useState(() => {
    const saved = localStorage.getItem('medinest_clinical_reports_v3');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (_) {
        return [];
      }
    }
    return [];
  });

  // 6. User Emergency Profile (Customizable by user)
  const [emergencyProfile, setEmergencyProfile] = useState(() => {
    const saved = localStorage.getItem('medinest_profile_v3');
    if (saved) return JSON.parse(saved);
    return {
      userName: '',
      bloodGroup: 'Not Set',
      emergencyContactName: '',
      emergencyContactPhone: '',
      doctorName: '',
      doctorPhone: '',
      hospitalName: '',
      hospitalPhone: '',
      ambulancePhone: '108',
      allergies: 'None recorded',
      currentMedicinesSummary: ''
    };
  });

  // 7. Settings & Accessibility
  const [settings, setSettings] = useState(() => {
    const saved = localStorage.getItem('medinest_settings_v3');
    const base = {
      language: 'en',
      largeText: false,
      highContrast: false,
      sound: true,
      snoozeMinutes: 10,
      glassTheme: 'crystal', // 'crystal' | 'vibrant' | 'midnight'
      glassMode: true
    };
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        return { ...base, ...parsed };
      } catch (_) {}
    }
    return base;
  });

  // Sync to LocalStorage
  useEffect(() => {
    localStorage.setItem('medinest_user_medicines', JSON.stringify(medicines));
  }, [medicines]);

  useEffect(() => {
    localStorage.setItem('medinest_appointments_v3', JSON.stringify(appointments));
  }, [appointments]);

  useEffect(() => {
    localStorage.setItem('medinest_doctors_v3', JSON.stringify(doctors));
  }, [doctors]);

  useEffect(() => {
    localStorage.setItem('medinest_journal_v3', JSON.stringify(journalEntries));
  }, [journalEntries]);

  useEffect(() => {
    localStorage.setItem('medinest_clinical_reports_v3', JSON.stringify(clinicalReports));
  }, [clinicalReports]);

  useEffect(() => {
    localStorage.setItem('medinest_profile_v3', JSON.stringify(emergencyProfile));
  }, [emergencyProfile]);

  useEffect(() => {
    localStorage.setItem('medinest_settings_v3', JSON.stringify(settings));
    if (settings.largeText) {
      document.body.classList.add('large-font');
    } else {
      document.body.classList.remove('large-font');
    }

    const root = document.documentElement;
    root.classList.remove('glass-crystal', 'glass-vibrant', 'glass-midnight', 'glass-off');
    if (settings.glassMode !== false) {
      root.classList.add('glass-mode');
      root.classList.add(`glass-${settings.glassTheme || 'crystal'}`);
    } else {
      root.classList.add('glass-off');
    }
  }, [settings]);

  // Actions: Medicine
  const addMedicine = (newMed) => {
    setMedicines(prev => [newMed, ...prev]);
  };

  const addMultipleMedicines = (newMedsArray) => {
    if (!Array.isArray(newMedsArray) || newMedsArray.length === 0) return;
    setMedicines(prev => [...newMedsArray, ...prev]);
  };

  const updateMedicine = (updated) => {
    setMedicines(prev => prev.map(m => m.id === updated.id ? updated : m));
  };

  const deleteMedicine = (id) => {
    setMedicines(prev => prev.filter(m => m.id !== id));
  };

  const clearAllMedicines = () => {
    setMedicines([]);
  };

  const refillMedicine = (id, count = 10) => {
    setMedicines(prev => prev.map(m => {
      if (m.id === id) {
        return { ...m, remainingStock: (Number(m.remainingStock) || 0) + count };
      }
      return m;
    }));
  };

  // Taking Medicine
  const markDoseTaken = (id) => {
    setMedicines(prev => prev.map(m => {
      if (m.id === id) {
        return {
          ...m,
          takenToday: true,
          remainingStock: Math.max(0, (Number(m.remainingStock) || 0) - 1)
        };
      }
      return m;
    }));

    // Confetti celebration
    try {
      confetti({
        particleCount: 50,
        spread: 60,
        origin: { y: 0.8 },
        colors: ['#4CAF50', '#2196F3', '#8E24AA']
      });
    } catch (_) {}
  };

  const markDoseSnooze = (id) => {
    const med = medicines.find(m => m.id === id);
    if (!med) return;

    notificationService.triggerMedicineNotification({
      medicineName: med.name,
      timing: med.time,
      purpose: med.purpose,
      escalationLevel: 1,
      onTaken: () => markDoseTaken(id),
      onSnooze: () => markDoseSnooze(id)
    });
  };

  // Actions: Hospital Appointments
  const completeAppointment = (id) => {
    const appt = appointments.find(a => a.id === id);
    if (!appt) return;

    const currentDate = new Date(appt.date);
    const nextMonthDate = new Date(currentDate.setMonth(currentDate.getMonth() + 1));
    const nextDateStr = nextMonthDate.toISOString().split('T')[0];

    setAppointments(prev => [
      {
        ...appt,
        id: 'apt-' + Date.now(),
        date: nextDateStr,
        isCompleted: false
      },
      ...prev.map(a => a.id === id ? { ...a, isCompleted: true } : a)
    ]);
  };

  const addAppointment = (newAppt) => {
    setAppointments(prev => [newAppt, ...prev]);
  };

  const rescheduleAppointment = (id, newDate) => {
    setAppointments(prev => prev.map(a => a.id === id ? { ...a, date: newDate } : a));
  };

  // Actions: Clinical Reports & Photos
  const addClinicalReport = (report) => {
    setClinicalReports(prev => [report, ...prev]);
  };

  const deleteClinicalReport = (id) => {
    setClinicalReports(prev => prev.filter(r => r.id !== id));
  };

  // Actions: Journal
  const addJournalEntry = (entry) => {
    setJournalEntries(prev => [entry, ...prev]);
  };

  // Actions: Doctor
  const addDoctor = (doc) => {
    setDoctors(prev => [...prev, doc]);
  };

  const deleteDoctor = (id) => {
    setDoctors(prev => prev.filter(d => d.id !== id));
  };

  // Actions: Settings
  const setLanguage = (lang) => {
    setSettings(prev => ({ ...prev, language: lang }));
  };

  const toggleLargeText = () => {
    setSettings(prev => ({ ...prev, largeText: !prev.largeText }));
  };

  const setGlassTheme = (theme) => {
    setSettings(prev => ({ ...prev, glassTheme: theme, glassMode: true }));
  };

  const toggleGlassMode = () => {
    setSettings(prev => ({ ...prev, glassMode: !prev.glassMode }));
  };

  const updateUserName = (name) => {
    setEmergencyProfile(prev => ({ ...prev, userName: name }));
  };

  const resetToDemo = () => {
    localStorage.clear();
    window.location.reload();
  };

  // Helpers
  const t = (key) => {
    const lang = settings.language || 'en';
    return translations[lang]?.[key] || translations['en']?.[key] || key;
  };

  // Check if a medicine is scheduled for today (handles Alternate Days, Daily, Weekly)
  const isMedicineDueToday = (med, targetDate = new Date()) => {
    if (!med) return false;
    const freq = med.repeat || 'Daily';
    if (freq === 'Daily' || freq === 'Twice a Day' || freq === 'Three times a Day') {
      return true;
    }

    if (freq === 'Alternate Days') {
      const start = med.startDate ? new Date(med.startDate) : new Date();
      const startDay = new Date(start.getFullYear(), start.getMonth(), start.getDate());
      const checkDay = new Date(targetDate.getFullYear(), targetDate.getMonth(), targetDate.getDate());
      const diffTime = checkDay.getTime() - startDay.getTime();
      const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
      return Math.abs(diffDays) % 2 === 0;
    }

    if (freq === 'Weekly') {
      const start = med.startDate ? new Date(med.startDate) : new Date();
      return targetDate.getDay() === start.getDay();
    }

    return true;
  };

  const activeAppointment = appointments.find(a => !a.isCompleted) || null;

  // Filter medicines scheduled for today (e.g. Daily or Alternate Day ON)
  const todayMedicines = medicines.filter(m => isMedicineDueToday(m));
  const restDayMedicines = medicines.filter(m => !isMedicineDueToday(m));

  const nextMedicine = todayMedicines.length > 0 
    ? (todayMedicines.find(m => !m.takenToday) || todayMedicines[0]) 
    : (medicines.length > 0 ? medicines[0] : null);

  // Adherence Calculation (based on today's active medicines)
  const totalDoses = todayMedicines.length;
  const takenDoses = todayMedicines.filter(m => m.takenToday).length;
  const upcomingDoses = totalDoses - takenDoses;
  const adherenceRate = totalDoses > 0 ? Math.round((takenDoses / totalDoses) * 100) : 100;

  // Hospital days left calculation
  const getDaysUntilHospital = () => {
    if (!activeAppointment?.date) return '—';
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const [y, m, d] = activeAppointment.date.split('-');
    const target = new Date(y, m - 1, d);
    const diff = Math.ceil((target - today) / (1000 * 60 * 60 * 24));
    return diff >= 0 ? diff : 0;
  };

  return (
    <AppContext.Provider
      value={{
        medicines,
        addMedicine,
        addMultipleMedicines,
        updateMedicine,
        deleteMedicine,
        clearAllMedicines,
        refillMedicine,
        markDoseTaken,
        markDoseSnooze,
        isMedicineDueToday,
        todayMedicines,
        restDayMedicines,
        appointments,
        activeAppointment,
        addAppointment,
        completeAppointment,
        rescheduleAppointment,
        doctors,
        addDoctor,
        deleteDoctor,
        hospitalInfo,
        setHospitalInfo,
        journalEntries,
        addJournalEntry,
        clinicalReports,
        addClinicalReport,
        deleteClinicalReport,
        emergencyProfile,
        setEmergencyProfile,
        updateUserName,
        settings,
        setLanguage,
        toggleLargeText,
        setGlassTheme,
        toggleGlassMode,
        resetToDemo,
        t,
        nextMedicine,
        totalDoses,
        takenDoses,
        upcomingDoses,
        adherenceRate,
        daysUntilHospital: getDaysUntilHospital()
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => useContext(AppContext);

# 🏥 MediNest - Personal Medicine Companion

> **"Never Miss a Tablet. Never Miss a Check-up."**

MediNest is a modern, elderly-friendly Android mobile application built with Flutter. It is designed to be so simple and intuitive that even an elderly or uneducated user can effortlessly manage their daily tablets, monthly hospital visits, and doctor contacts.

---

## 🌟 Key Features

### 1. Strictly Light Mode & Elderly Accessibility
- **White Background (`#FFFFFF`)** with soothing medical green (`#4CAF50`) and sky blue (`#2196F3`) accents.
- **Large Touch Targets**: Minimum 56px height on all interactive buttons.
- **20px Rounded Cards**: Clean, modern cards with subtle shadows and high contrast typography.
- **Multi-Language Support**:
  - English
  - Telugu (తెలుగు)
  - Hindi (हिंदी)
- **Voice Reading (TTS)**: 1-tap voice audio playback reading today's scheduled medicines aloud.
- **Large Text Mode & High Contrast Mode** toggles.

### 2. Smart Notification System (Highest Priority)
- Real Android notification bar reminders using `flutter_local_notifications`.
- **In-Notification Action Buttons**:
  - `✓ Taken`: Instantly marks the dose as taken, reduces remaining tablet count by 1, and updates adherence history.
  - `⏱ Snooze (10 min)`: Re-schedules alarms with escalating reminders (+10m, +20m, +30m) until marked as taken.
- **Restart Survival**: Configured with `RECEIVE_BOOT_COMPLETED` to reschedule alarms after phone reboot.
- **Android Exact Alarm**: Supports `SCHEDULE_EXACT_ALARM` & `USE_EXACT_ALARM` for Android 12+/14+.

### 3. Home Dashboard & Live Countdown
- Time-aware personalized greeting: `"Good Morning, Ammu 🌸"`
- Four Large Metric Cards:
  - 💊 **Tablets Today**
  - ✅ **Taken**
  - ⏳ **Upcoming**
  - 🏥 **Days Until Hospital Visit**
- **Next Medicine Card**: Real-time live countdown timer, relation to food badge, purpose, and one-tap Taken/Snooze buttons.
- Today's medication checklist with visual strikethrough.

### 4. Medicine Tracker & Stock Refill Alerts
- Detailed card for every medicine showing dosage form, frequency, food timing, and purpose.
- **Low Stock Notification**: Alerts user automatically when `remainingStock <= 5` ("*Only 5 tablets left. Buy refill soon.*").
- Quick refill actions (`+10`, `+30` tablets).

### 5. Add / Edit Medicine (Full 16 Fields)
- Medicine Name, Form dropdown (Tablet/Capsule/Syrup/Drops/Inhaler/Injection)
- Purpose, Doctor Name, Hospital Name, Doctor Phone, Hospital Phone, Hospital Address
- Start Date, End Date (Calendar pickers)
- Before Food / After Food toggles
- Time Picker (multiple times per day)
- Repeat schedule (Daily / Weekly / Custom)
- Medicine photo capture placeholder
- Stock counter & doctor instructions

### 6. Monthly Hospital Tracker & Auto-Scheduling
- Countdown display (e.g. "*October 28 • 12 Days Left*").
- 5-stage reminder checklist (7 days before, 3 days before, 1 day before, morning of visit, 1 hour before leaving).
- **Auto Next Appointment**: Tapping `"Mark Completed"` automatically schedules the next monthly appointment (+1 month).
- One-tap `"Call Doctor"` and `"Navigate GPS"` via Google Maps.

### 7. Doctor Directory & Hospital Contacts
- Doctor cards with specialization, hospital name, and direct phone dialer (`tel:`).
- SMS messaging (`sms:`) and Google Maps hospital navigation.
- Saved consultation dates, next visit dates, and prescription notes.

### 8. Health Journal (Daily Diary)
- Daily symptom logger: Mood (😊 😐 😔 😣), Sleep hours slider, Energy levels.
- Severity tracking for **Itching** (None, Mild, Moderate, Severe) and **Hair Fall** (None, Less, Moderate, Heavy).
- Historical timeline of all past health entries.

### 9. History & Adherence Calendar
- Color-coded calendar:
  - 🟢 **Green** = Taken
  - 🟡 **Yellow** = Snoozed
  - 🔴 **Red** = Missed
- Monthly adherence percentage (e.g. `96% Medicine Adherence`).
- Active streak counter (e.g. `7 Days Streak 🔥`).

### 10. Clinical PDF Reports
- Generates a doctor-friendly, printable medical PDF summary using the `pdf` and `printing` libraries.
- Includes patient details, active prescriptions, dose timestamps, adherence rate, check-up logs, and symptom diaries.

### 11. Emergency Medical Card
- One-tap Speed Dial:
  - 🚨 **Call Family**
  - 👨‍⚕️ **Call Doctor**
  - 🏥 **Call Hospital / Ambulance**
- Large Blood Group badge (`O+ Positive`).
- Prominent allergy warnings and current medications summary.

### 12. Future AI Features Suite
- 📷 **Scan Medicine Strip**: Camera strip scanner mockup with barcode & expiry detection.
- 📄 **Prescription OCR**: Document scanner mockup that extracts written medication regimens.
- 🔬 **Medicine Interaction Checker**: Contraindication evaluator for active drugs.
- 💬 **Doctor AI Chat**: Conversational AI assistant for dosage and food guidelines.
- 📈 **AI Refill Prediction**: Days-remaining calculation based on consumption rates.

---

## 📁 Clean Architecture Folder Structure

```
lib/
├── main.dart                      # App entry point, services initialization
├── app.dart                       # MaterialApp theme and routing
├── models/
│   ├── medicine.dart              # Medicine prescription model
│   ├── dose_log.dart              # Daily dose adherence log
│   ├── hospital_appointment.dart  # Monthly hospital visit model
│   ├── doctor.dart                # Specialist doctor profile
│   ├── health_journal_entry.dart  # Daily symptom and mood diary
│   ├── emergency_profile.dart     # Emergency medical card data
│   └── app_settings.dart          # Accessibility & alarm preferences
├── services/
│   ├── storage_service.dart       # Offline-first persistent storage
│   ├── notification_service.dart  # Real Android notification bar alarms
│   ├── pdf_report_service.dart    # Clinical PDF report generator
│   ├── tts_service.dart           # Elderly voice read-aloud assistant
│   └── call_launcher_service.dart # Phone calling & Google Maps navigation
├── utils/
│   ├── app_colors.dart            # Light mode color palette
│   ├── app_styles.dart            # Typography scale & 20px card radius
│   ├── localization.dart          # English, Telugu, Hindi dictionaries
│   └── dummy_data.dart            # Preloaded patient profile for Ammu
├── widgets/
│   ├── large_button.dart          # High-touch accessible button
│   ├── medicine_card.dart         # Complete medicine card with stock
│   ├── summary_stat_card.dart     # 4 large metric cards
│   ├── next_medicine_banner.dart  # Live countdown & quick action banner
│   └── voice_reading_bar.dart     # 1-tap voice audio player
└── screens/
    ├── splash_screen.dart         # Capsule & heartbeat animation
    ├── login_screen.dart          # Offline-first login with Google option
    ├── main_navigation_screen.dart# 5-tab bottom navigation + FAB
    ├── home_dashboard_screen.dart # Daily health dashboard
    ├── medicine_tracker_screen.dart# Prescription list with filters
    ├── add_edit_medicine_screen.dart# Complete 16-field prescription form
    ├── medicine_details_screen.dart# Side effects, warnings & refill
    ├── hospital_tracker_screen.dart# Monthly check-up countdown & stages
    ├── doctor_directory_screen.dart# Specialist contacts & navigation
    ├── health_journal_screen.dart # Daily mood & symptom diary
    ├── history_screen.dart        # Color-coded calendar & adherence
    ├── reports_screen.dart        # PDF medical report download
    ├── emergency_card_screen.dart # Speed dial & critical medical card
    ├── settings_screen.dart       # Alarms, language & accessibility
    └── ai_features_screen.dart    # Strip scanner, OCR & AI doctor chat
```

---

## 🚀 How to Run the App

1. Install Flutter (3.10+):
   ```bash
   flutter doctor
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run on connected Android device or emulator:
   ```bash
   flutter run
   ```

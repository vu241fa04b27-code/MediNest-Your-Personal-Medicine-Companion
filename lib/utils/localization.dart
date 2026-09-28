class AppLocalization {
  final String languageCode;

  AppLocalization(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'MediNest',
      'tagline': 'Never Miss a Tablet. Never Miss a Check-up.',
      'splash_subtitle': 'Your Personal Medicine Companion',
      'login_title': 'Welcome to MediNest',
      'login_subtitle': 'Keep track of all your tablets, doctor visits and emergency care with peace of mind.',
      'continue_google': 'Continue with Google',
      'start_without_account': 'Start Without Account',
      'cloud_backup_optional': 'Offline ready • Cloud backup optional',
      
      // Greetings
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'user_greeting': 'Good Morning, Ammu 🌸',
      
      // Home Cards
      'tablets_today': 'Tablets Today',
      'taken': 'Taken',
      'upcoming': 'Upcoming',
      'days_until_hospital': 'Days Until Hospital Visit',
      'days_left': 'Days Left',
      'today': 'Today!',
      'tomorrow': 'Tomorrow',
      
      // Next Medicine
      'next_medicine': 'Next Medicine',
      'take_now': 'Take Now',
      'snooze_10m': 'Snooze (10 min)',
      'before_food': 'Before Food',
      'after_food': 'After Food',
      'with_food': 'With Food',
      
      // Navigation
      'nav_home': 'Home',
      'nav_medicines': 'Medicines',
      'nav_hospital': 'Hospital',
      'nav_journal': 'Journal',
      'nav_profile': 'Profile',
      
      // Actions
      'add_medicine': 'Add Medicine',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'call_doctor': 'Call Doctor',
      'call_hospital': 'Call Hospital',
      'call_family': 'Call Family',
      'message': 'Message',
      'open_location': 'Open Hospital Location',
      'mark_completed': 'Mark Completed',
      'reschedule': 'Reschedule',
      'view_appointment': 'View Appointment',
      'view_all': 'View All',
      'refill': 'Refill Stock',
      
      // Medicine Details
      'dosage_form': 'Dosage Form',
      'purpose': 'Purpose',
      'how_to_take': 'How to Take',
      'side_effects': 'Common Side Effects',
      'warnings': 'Important Warnings',
      'warning_text': "Don't stop or change dose without doctor's advice.",
      'remaining_tablets': 'Remaining Tablets',
      'low_stock_warning': 'Only 5 tablets left. Buy refill soon.',
      
      // Hospital Tracker
      'hospital_tracker': 'Monthly Hospital Tracker',
      'monthly_checkup': 'Monthly Hospital Check-up',
      'appointment_countdown': 'Countdown',
      'reminders_set': 'Active Reminders: 7d, 3d, 1d, morning of visit, 1hr before',
      
      // Health Journal
      'health_journal': 'Daily Health Diary',
      'how_are_you': 'How are you feeling today?',
      'mood': 'Mood',
      'sleep': 'Sleep (Hours)',
      'energy': 'Energy Level',
      'symptoms': 'Symptoms',
      'itching': 'Itching',
      'hair_fall': 'Hair Fall',
      'none': 'None',
      'mild': 'Mild',
      'moderate': 'Moderate',
      'severe': 'Severe',
      'less': 'Less',
      'heavy': 'Heavy',
      'notes': 'Notes / Remarks',
      'save_journal': 'Save Today\'s Entry',
      
      // History & Reports
      'history': 'Medicine History',
      'adherence_rate': 'Medicine Adherence',
      'current_streak': 'Current Streak',
      'missed_medicines': 'Missed Doses',
      'generate_pdf': 'Download Doctor PDF Report',
      
      // Emergency Card
      'emergency_card': 'Emergency Medical Card',
      'blood_group': 'Blood Group',
      'emergency_contact': 'Emergency Contact',
      'allergies': 'Allergies & Sensitivities',
      'current_meds': 'Current Medications',
      
      // Settings
      'settings': 'Settings',
      'sound': 'Medicine Reminder Ringtone',
      'vibration': 'Vibration',
      'snooze_duration': 'Snooze Duration',
      'language': 'Language',
      'voice_reading': 'Voice Reader (Read aloud)',
      'large_text': 'Large Text Mode (Elderly)',
      'high_contrast': 'High Contrast Mode',
      'exact_alarm_status': 'Exact Alarm Permission (Granted)',
      'backup_restore': 'Cloud Backup & Restore',
      
      // Voice Reader text
      'voice_today_readout': 'Here are your medicines for today. Tap on any medicine card or say Taken when done.',
    },

    'te': {
      'app_name': 'మెడి-నెస్ట్ (MediNest)',
      'tagline': 'టాబ్లెట్ మరచిపోకండి. డాక్టర్ చెకప్ మిస్ కావద్దు.',
      'splash_subtitle': 'మీ నమ్మకమైన మందుల తోడు',
      'login_title': 'మెడి-నెస్ట్ కు స్వాగతం',
      'login_subtitle': 'మీ రోజువారీ మందులు, డాక్టర్ అపాయింట్‌మెంట్లు మరియు అత్యవసర వివరాలు సులభంగా చూసుకోండి.',
      'continue_google': 'గూగుల్ తో కొనసాగించండి',
      'start_without_account': 'ఖాతా లేకుండా వెంటనే ప్రారంభించండి',
      'cloud_backup_optional': 'ఆఫ్‌లైన్ పని చేస్తుంది • క్లౌడ్ బ్యాకప్ ఐచ్ఛికం',
      
      // Greetings
      'good_morning': 'శుభోదయం',
      'good_afternoon': 'శుభ మధ్యాహ్నం',
      'good_evening': 'శుభ సాయంత్రం',
      'user_greeting': 'శుభోదయం, అమ్ము 🌸',
      
      // Home Cards
      'tablets_today': 'ఈ రోజు టాబ్లెట్లు',
      'taken': 'వేసుకున్నవి',
      'upcoming': 'రాబోయేవి',
      'days_until_hospital': 'ఆసుపత్రి సందర్శనకు మిగిలిన రోజులు',
      'days_left': 'రోజులు మిగిలి ఉన్నాయి',
      'today': 'ఈ రోజే!',
      'tomorrow': 'రేపు',
      
      // Next Medicine
      'next_medicine': 'తర్వాతి మందు',
      'take_now': 'ఇప్పుడే తీసుకోండి',
      'snooze_10m': '10 నిమిషాలు ఆపండి (స్నూజ్)',
      'before_food': 'భోజనానికి ముందు',
      'after_food': 'భోజనం తర్వాత',
      'with_food': 'భోజనంతో పాటు',
      
      // Navigation
      'nav_home': 'హోమ్',
      'nav_medicines': 'మందులు',
      'nav_hospital': 'ఆసుపత్రి',
      'nav_journal': 'డైరీ',
      'nav_profile': 'ప్రొఫైల్',
      
      // Actions
      'add_medicine': 'మందు జోడించండి',
      'edit': 'సవరించండి',
      'delete': 'తొలగించండి',
      'save': 'భద్రపరచండి',
      'cancel': 'రద్దు చేయండి',
      'call_doctor': 'డాక్టర్‌కు కాల్ చేయండి',
      'call_hospital': 'ఆసుపత్రికి కాల్ చేయండి',
      'call_family': 'కుటుంబానికి కాల్ చేయండి',
      'message': 'సందేశం పంపండి',
      'open_location': 'ఆసుపత్రి లొకేషన్ చూడండి',
      'mark_completed': 'పూర్తయినట్లు గుర్తించండి',
      'reschedule': 'తేదీ మార్చండి',
      'view_appointment': 'అపాయింట్‌మెంట్ చూడండి',
      'view_all': 'అన్నీ చూడండి',
      'refill': 'మందుల నిల్వ నింపండి',
      
      // Medicine Details
      'dosage_form': 'మందు రకం',
      'purpose': 'ఉపయోగం / ప్రయోజనం',
      'how_to_take': 'ఎలా వేసుకోవాలి',
      'side_effects': 'సాధారణ దుష్ప్రభావాలు',
      'warnings': 'ముఖ్యమైన హెచ్చరికలు',
      'warning_text': "డాక్టర్ సలహా లేకుండా మందును ఆపకండి లేదా మోతాదు మార్చవద్దు.",
      'remaining_tablets': 'మిగిలిన టాబ్లెట్లు',
      'low_stock_warning': 'కేవలం 5 టాబ్లెట్లు మాత్రమే మిగిలి ఉన్నాయి. త్వరగా కొనండి.',
      
      // Hospital Tracker
      'hospital_tracker': 'నెలవారీ ఆసుపత్రి ట్రాకర్',
      'monthly_checkup': 'నెలవారీ డాక్టర్ చెకప్',
      'appointment_countdown': 'కౌంట్‌డౌన్',
      'reminders_set': 'రిమైండర్లు: 7 రోజులు, 3 రోజులు, 1 రోజు, ఉదయం & 1 గంట ముందు',
      
      // Health Journal
      'health_journal': 'రోజువారీ ఆరోగ్య డైరీ',
      'how_are_you': 'ఈ రోజు మీ ఆరోగ్యం ఎలా ఉంది?',
      'mood': 'మూడ్ (ఉల్లాసం)',
      'sleep': 'నిద్ర (గంటలు)',
      'energy': 'శక్తి స్థాయి',
      'symptoms': 'లక్షణాలు',
      'itching': 'దురద',
      'hair_fall': 'జుట్టు రాలడం',
      'none': 'లేదు',
      'mild': 'తక్కువ',
      'moderate': 'మధ్యస్థం',
      'severe': 'ఎక్కువ',
      'less': 'తక్కువ',
      'heavy': 'చాలా ఎక్కువ',
      'notes': 'గమనికలు',
      'save_journal': 'ఈ రోజు వివరాలు భద్రపరచండి',
      
      // History & Reports
      'history': 'మందుల చరిత్ర',
      'adherence_rate': 'క్రమం తప్పకుండా వాడిన శాతం',
      'current_streak': 'వరుస రోజులు',
      'missed_medicines': 'మిస్ అయిన మోతాదులు',
      'generate_pdf': 'డాక్టర్ PDF రిపోర్ట్ డౌన్‌లోడ్',
      
      // Emergency Card
      'emergency_card': 'అత్యవసర వైద్య కార్డు',
      'blood_group': 'రక్త గ్రూప్',
      'emergency_contact': 'అత్యవసర పరిచయం',
      'allergies': 'అలెర్జీలు',
      'current_meds': 'ప్రస్తుతం వాడుతున్న మందులు',
      
      // Settings
      'settings': 'సెట్టింగ్‌లు',
      'sound': 'మందుల రిమైండర్ రింగ్‌టోన్',
      'vibration': 'వైబ్రేషన్',
      'snooze_duration': 'స్నూజ్ సమయం',
      'language': 'భాష (Language)',
      'voice_reading': 'వాయిస్ రీడర్ (చదివి వినిపించు)',
      'large_text': 'పెద్ద అక్షరాల మోడ్ (వృద్ధులకు)',
      'high_contrast': 'హై కాంట్రాస్ట్ మోడ్',
      'exact_alarm_status': 'ఖచ్చితమైన అలారం అనుమతి (లభించింది)',
      'backup_restore': 'క్లౌడ్ బ్యాకప్ & రీస్టోర్',
      
      'voice_today_readout': 'ఈ రోజు మీరు వేసుకోవలసిన మందుల వివరాలు ఇక్కడ ఉన్నాయి.',
    },

    'hi': {
      'app_name': 'मेडी-नेस्ट (MediNest)',
      'tagline': 'दवा कभी न भूलें। डॉक्टर चेक-अप कभी न छोड़ें।',
      'splash_subtitle': 'आपका निजी दवा साथी',
      'login_title': 'मेडी-नेस्ट में आपका स्वागत है',
      'login_subtitle': 'अपनी दैनिक दवाएं, डॉक्टर अपॉइंटमेंट और आपातकालीन देखभाल आसानी से संभालें।',
      'continue_google': 'गूगल के साथ जारी रखें',
      'start_without_account': 'बिना खाते के तुरंत शुरू करें',
      'cloud_backup_optional': 'ऑफ़लाइन काम करता है • क्लाउड बैकअप वैकल्पिक',
      
      // Greetings
      'good_morning': 'शुभ प्रभात',
      'good_afternoon': 'शुभ दोपहर',
      'good_evening': 'शुभ संध्या',
      'user_greeting': 'शुभ प्रभात, अम्मू 🌸',
      
      // Home Cards
      'tablets_today': 'आज की दवाएं',
      'taken': 'ली गई दवाएं',
      'upcoming': 'आने वाली खुराक',
      'days_until_hospital': 'अस्पताल जाने में बचे दिन',
      'days_left': 'दिन शेष',
      'today': 'आज ही!',
      'tomorrow': 'कल',
      
      // Next Medicine
      'next_medicine': 'अगली दवा',
      'take_now': 'अभी लें',
      'snooze_10m': '10 मिनट बाद याद दिलाएं (स्नूज़)',
      'before_food': 'भोजन से पहले',
      'after_food': 'भोजन के बाद',
      'with_food': 'भोजन के साथ',
      
      // Navigation
      'nav_home': 'होम',
      'nav_medicines': 'दवाएं',
      'nav_hospital': 'अस्पताल',
      'nav_journal': 'डायरी',
      'nav_profile': 'प्रोफाइल',
      
      // Actions
      'add_medicine': 'दवा जोड़ें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'save': 'सुरक्षित करें',
      'cancel': 'रद्द करें',
      'call_doctor': 'डॉक्टर को कॉल करें',
      'call_hospital': 'अस्पताल को कॉल करें',
      'call_family': 'परिवार को कॉल करें',
      'message': 'संदेश भेजें',
      'open_location': 'अस्पताल का नक्शा देखें',
      'mark_completed': 'पूर्ण चिह्नित करें',
      'reschedule': 'तारीख बदलें',
      'view_appointment': 'अपॉइंटमेंट देखें',
      'view_all': 'सभी देखें',
      'refill': 'दवा स्टॉक भरें',
      
      // Medicine Details
      'dosage_form': 'दवा का प्रकार',
      'purpose': 'उपयोग / लाभ',
      'how_to_take': 'कैसे लें',
      'side_effects': 'सामान्य दुष्प्रभाव',
      'warnings': 'महत्वपूर्ण चेतावनियां',
      'warning_text': "डॉक्टर की सलाह के बिना दवा बंद न करें या खुराक न बदलें।",
      'remaining_tablets': 'बची हुई गोलियां',
      'low_stock_warning': 'केवल 5 गोलियां बची हैं। जल्द ही नया पैकेट खरीदें।',
      
      // Hospital Tracker
      'hospital_tracker': 'मासिक अस्पताल ट्रैकर',
      'monthly_checkup': 'मासिक डॉक्टर चेक-अप',
      'appointment_countdown': 'उलटी गिनती',
      'reminders_set': 'सक्रिय रिमाइंडर: 7 दिन, 3 दिन, 1 दिन, सुबह और 1 घंटा पहले',
      
      // Health Journal
      'health_journal': 'दैनिक स्वास्थ्य डायरी',
      'how_are_you': 'आज आप कैसा महसूस कर रहे हैं?',
      'mood': 'मूड (मनोदशा)',
      'sleep': 'नींद (घंटे)',
      'energy': 'ऊर्जा स्तर',
      'symptoms': 'लक्षण',
      'itching': 'खुजली',
      'hair_fall': 'बाल झड़ना',
      'none': 'कुछ नहीं',
      'mild': 'हल्का',
      'moderate': 'मध्यम',
      'severe': 'गंभीर',
      'less': 'कम',
      'heavy': 'बहुत अधिक',
      'notes': 'टिप्पणी / नोट्स',
      'save_journal': 'आज की डायरी सुरक्षित करें',
      
      // History & Reports
      'history': 'दवा इतिहास',
      'adherence_rate': 'नियमितता प्रतिशत',
      'current_streak': 'लगातार दिन',
      'missed_medicines': 'छूटी हुई दवाएं',
      'generate_pdf': 'डॉक्टर PDF रिपोर्ट डाउनलोड करें',
      
      // Emergency Card
      'emergency_card': 'आपातकालीन चिकित्सा कार्ड',
      'blood_group': 'ब्लड ग्रुप',
      'emergency_contact': 'आपातकालीन संपर्क',
      'allergies': 'एलर्जी',
      'current_meds': 'वर्तमान दवाएं',
      
      // Settings
      'settings': 'सेटिंग्स',
      'sound': 'दवा रिमाइंडर रिंगटोन',
      'vibration': 'कंपन (वाइब्रेशन)',
      'snooze_duration': 'स्नूज़ समय',
      'language': 'भाषा (Language)',
      'voice_reading': 'आवाज से पढ़कर सुनाएं',
      'large_text': 'बड़ा फॉन्ट मोड (बुजुर्गों के लिए)',
      'high_contrast': 'उच्च कंट्रास्ट मोड',
      'exact_alarm_status': 'सटीक अलार्म अनुमति (सक्रिय)',
      'backup_restore': 'क्लाउड बैकअप व रीस्टोर',
      
      'voice_today_readout': 'यहाँ आपकी आज की दवाएं हैं।',
    },
  };

  String tr(String key) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

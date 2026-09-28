import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/localization.dart';
import 'emergency_card_screen.dart';
import 'doctor_directory_screen.dart';
import 'history_screen.dart';
import 'reports_screen.dart';
import 'ai_features_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _storage.addListener(_onStorageChanged);
  }

  void _onStorageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageChanged);
    super.dispose();
  }

  void _testAlarmNotification() async {
    await NotificationService().showMedicineAlert(
      id: 9999,
      medicineId: 'test_alarm',
      medicineName: 'Ketoconazole 200mg (Test Alarm)',
      timing: 'After Lunch',
      purpose: 'Controls dandruff and fungal infection',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('🔔 Notification bar alarm sent! Check your Android notification shade with Taken & Snooze buttons.'),
        ),
      );
    }
  }

  void _resetDemoData() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Demo Data?'),
        content: const Text('This will reload Ammu\'s pre-seeded prescriptions, monthly check-up, and diary entries.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () async {
              Navigator.pop(ctx);
              await _storage.resetToDemoData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Demo patient data reloaded!')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _storage.settings;
    final loc = AppLocalization(settings.language);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Settings & Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreenLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '🌸',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _storage.emergencyProfile.userName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Blood Group: ${_storage.emergencyProfile.bloodGroup}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.textSecondary),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const EmergencyCardScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Feature Navigation Hub
              _buildSectionTitle('Medical Hub & Records'),
              const SizedBox(height: 10),
              _buildNavCard(
                icon: Icons.emergency_rounded,
                iconColor: AppColors.danger,
                title: 'Emergency Medical Card',
                subtitle: 'Speed dial family, doctor & hospital',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyCardScreen())),
              ),
              _buildNavCard(
                icon: Icons.medical_services_rounded,
                iconColor: AppColors.primaryGreen,
                title: 'Doctor Directory & Hospital Contact',
                subtitle: 'Manage specialist contacts and navigation',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DoctorDirectoryScreen())),
              ),
              _buildNavCard(
                icon: Icons.history_rounded,
                iconColor: AppColors.accentBlue,
                title: 'Medicine History & Adherence',
                subtitle: 'Calendar color tracking and monthly score',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
              ),
              _buildNavCard(
                icon: Icons.picture_as_pdf_rounded,
                iconColor: const Color(0xFF8E24AA),
                title: 'Clinical PDF Reports',
                subtitle: 'Download doctor-friendly printable summaries',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsScreen())),
              ),
              _buildNavCard(
                icon: Icons.auto_awesome_rounded,
                iconColor: const Color(0xFFFF6D00),
                title: 'Future AI Features',
                subtitle: 'Strip scanner, OCR & AI refill prediction',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiFeaturesScreen())),
              ),
              const SizedBox(height: 20),

              // Accessibility Section (Telugu, English, Hindi)
              _buildSectionTitle('Language & Accessibility'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Language Switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                            SizedBox(width: 10),
                            Text('App Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        DropdownButton<String>(
                          value: settings.language,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'te', child: Text('తెలుగు (Telugu)')),
                            DropdownMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
                          ],
                          onChanged: (val) {
                            if (val != null) _storage.setLanguage(val);
                          },
                        ),
                      ],
                    ),
                    const Divider(),

                    // Voice Reading Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Voice Reading (Elderly)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: const Text('Read today\'s schedule aloud via voice reader', style: TextStyle(fontSize: 12)),
                      value: settings.voiceReaderEnabled,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => _storage.updateSettings(settings.copyWith(voiceReaderEnabled: val)),
                    ),
                    const Divider(),

                    // Large Font Mode
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Large Text Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: const Text('Enlarge headings and buttons for elderly readability', style: TextStyle(fontSize: 12)),
                      value: settings.largeFontEnabled,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => _storage.updateSettings(settings.copyWith(largeFontEnabled: val)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notifications & Alarms Settings
              _buildSectionTitle('Smart Notifications & Alarms'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Exact Alarm Status
                    Row(
                      children: [
                        const Icon(Icons.security_rounded, color: AppColors.primaryGreen),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Android Exact Alarm Permission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Granted • Heads-up alarms active', style: TextStyle(fontSize: 12, color: AppColors.primaryGreenDark)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryGreenLight, borderRadius: BorderRadius.circular(8)),
                          child: const Text('Active ✓', style: TextStyle(color: AppColors.primaryGreenDark, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Ringtone Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reminder Ringtone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        DropdownButton<String>(
                          value: settings.ringtoneName,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'Gentle Chime', child: Text('Gentle Chime')),
                            DropdownMenuItem(value: 'Medicine Bell', child: Text('Medicine Bell')),
                            DropdownMenuItem(value: 'Hospital Harp', child: Text('Hospital Harp')),
                          ],
                          onChanged: (val) {
                            if (val != null) _storage.updateSettings(settings.copyWith(ringtoneName: val));
                          },
                        ),
                      ],
                    ),
                    const Divider(),

                    // Snooze Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Snooze Duration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        DropdownButton<int>(
                          value: settings.snoozeDurationMinutes,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 5, child: Text('5 minutes')),
                            DropdownMenuItem(value: 10, child: Text('10 minutes (Recommended)')),
                            DropdownMenuItem(value: 15, child: Text('15 minutes')),
                            DropdownMenuItem(value: 30, child: Text('30 minutes')),
                          ],
                          onChanged: (val) {
                            if (val != null) _storage.updateSettings(settings.copyWith(snoozeDurationMinutes: val));
                          },
                        ),
                      ],
                    ),
                    const Divider(),

                    // Vibration Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Vibration Pattern', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      value: settings.vibrationEnabled,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => _storage.updateSettings(settings.copyWith(vibrationEnabled: val)),
                    ),

                    // Test Alarm Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.alarm_on_rounded, color: AppColors.primaryGreen),
                      label: const Text('Test Notification Bar Alarm (Taken & Snooze)', style: TextStyle(color: AppColors.primaryGreenDark, fontWeight: FontWeight.bold)),
                      onPressed: _testAlarmNotification,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Backup & Reset Section
              _buildSectionTitle('Storage & Backup'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Cloud Backup (Google)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: const Text('Offline mode active. Cloud backup is optional.', style: TextStyle(fontSize: 12)),
                      value: settings.cloudBackupEnabled,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) => _storage.updateSettings(settings.copyWith(cloudBackupEnabled: val)),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.refresh_rounded, color: AppColors.warning),
                      title: const Text('Reload Demo Patient Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Restores Ammu\'s initial medicines, check-ups & diary', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _resetDemoData,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildNavCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}

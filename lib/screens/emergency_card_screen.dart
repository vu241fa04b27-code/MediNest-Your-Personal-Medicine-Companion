import 'package:flutter/material.dart';
import '../models/emergency_profile.dart';
import '../services/storage_service.dart';
import '../services/call_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class EmergencyCardScreen extends StatefulWidget {
  const EmergencyCardScreen({super.key});

  @override
  State<EmergencyCardScreen> createState() => _EmergencyCardScreenState();
}

class _EmergencyCardScreenState extends State<EmergencyCardScreen> {
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

  void _editEmergencyDetails() {
    final profile = _storage.emergencyProfile;
    final nameCtrl = TextEditingController(text: profile.userName);
    final bloodCtrl = TextEditingController(text: profile.bloodGroup);
    final familyPhoneCtrl = TextEditingController(text: profile.emergencyContactPhone);
    final familyNameCtrl = TextEditingController(text: profile.emergencyContactName);
    final allergiesCtrl = TextEditingController(text: profile.allergies);
    final docNameCtrl = TextEditingController(text: profile.doctorName);
    final docPhoneCtrl = TextEditingController(text: profile.doctorPhone);
    final hospNameCtrl = TextEditingController(text: profile.hospitalName);
    final hospPhoneCtrl = TextEditingController(text: profile.hospitalPhone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Emergency Card', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Patient Name')),
              const SizedBox(height: 8),
              TextField(controller: bloodCtrl, decoration: const InputDecoration(labelText: 'Blood Group (e.g. O+ Positive)')),
              const SizedBox(height: 8),
              TextField(controller: familyNameCtrl, decoration: const InputDecoration(labelText: 'Family Contact Relation/Name')),
              const SizedBox(height: 8),
              TextField(controller: familyPhoneCtrl, decoration: const InputDecoration(labelText: 'Family Phone (+91...)')),
              const SizedBox(height: 8),
              TextField(controller: allergiesCtrl, decoration: const InputDecoration(labelText: 'Known Allergies')),
              const SizedBox(height: 8),
              TextField(controller: docNameCtrl, decoration: const InputDecoration(labelText: 'Doctor Name')),
              const SizedBox(height: 8),
              TextField(controller: docPhoneCtrl, decoration: const InputDecoration(labelText: 'Doctor Phone')),
              const SizedBox(height: 8),
              TextField(controller: hospNameCtrl, decoration: const InputDecoration(labelText: 'Hospital Name')),
              const SizedBox(height: 8),
              TextField(controller: hospPhoneCtrl, decoration: const InputDecoration(labelText: 'Hospital Phone')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () async {
              final updated = profile.copyWith(
                userName: nameCtrl.text.trim(),
                bloodGroup: bloodCtrl.text.trim(),
                emergencyContactName: familyNameCtrl.text.trim(),
                emergencyContactPhone: familyPhoneCtrl.text.trim(),
                allergies: allergiesCtrl.text.trim(),
                doctorName: docNameCtrl.text.trim(),
                doctorPhone: docPhoneCtrl.text.trim(),
                hospitalName: hospNameCtrl.text.trim(),
                hospitalPhone: hospPhoneCtrl.text.trim(),
              );
              await _storage.updateEmergencyProfile(updated);
              Navigator.pop(ctx);
            },
            child: const Text('Save Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _storage.emergencyProfile;
    final medicinesList = _storage.medicines.map((m) => m.name).join(', ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.emergency_rounded, color: AppColors.danger, size: 24),
            SizedBox(width: 8),
            Text(
              'Emergency Medical Card',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: AppColors.accentBlue, size: 26),
            tooltip: 'Edit Emergency Details',
            onPressed: _editEmergencyDetails,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Speed Dial Action Buttons (3 Large Buttons)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.danger.withOpacity(0.5), width: 1.8),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_rounded, color: AppColors.danger, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ONE-TAP EMERGENCY SPEED DIAL',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.danger,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Button 1: Call Family
                    LargeButton(
                      label: 'Call Family: ${profile.emergencyContactPhone}',
                      icon: Icons.phone_in_talk_rounded,
                      type: ButtonType.primaryGreen,
                      height: 54,
                      fontSize: 16,
                      onPressed: () => CallLauncherService.makePhoneCall(profile.emergencyContactPhone),
                    ),
                    const SizedBox(height: 10),

                    // Button 2: Call Doctor
                    LargeButton(
                      label: 'Call Doctor: ${profile.doctorPhone}',
                      icon: Icons.medical_services_rounded,
                      type: ButtonType.secondaryBlue,
                      height: 54,
                      fontSize: 16,
                      onPressed: () => CallLauncherService.makePhoneCall(profile.doctorPhone),
                    ),
                    const SizedBox(height: 10),

                    // Button 3: Call Hospital / Ambulance
                    LargeButton(
                      label: 'Call Hospital: ${profile.hospitalPhone}',
                      icon: Icons.local_hospital_rounded,
                      type: ButtonType.danger,
                      height: 54,
                      fontSize: 16,
                      onPressed: () => CallLauncherService.makePhoneCall(profile.hospitalPhone),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Patient Identification Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Patient Name',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            Text(
                              profile.userName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            profile.bloodGroup,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Allergies Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.warning.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Known Allergies & Contraindications',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warning),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            profile.allergies,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Current Medications
                    const Text('Current Medications Being Taken:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(
                      medicinesList.isNotEmpty ? medicinesList : profile.currentMedicinesSummary,
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                    ),
                    const SizedBox(height: 16),

                    // Doctor Contact
                    _buildInfoTile(
                      icon: Icons.person_rounded,
                      title: 'Primary Doctor',
                      subtitle: '${profile.doctorName} • ${profile.doctorPhone}',
                    ),
                    const SizedBox(height: 10),

                    // Hospital Contact
                    _buildInfoTile(
                      icon: Icons.local_hospital_rounded,
                      title: 'Registered Hospital',
                      subtitle: '${profile.hospitalName} • Phone: ${profile.hospitalPhone} • ER: ${profile.hospitalEmergencyPhone}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.edit_rounded, color: AppColors.accentBlue),
                  label: const Text('Update Emergency Information', style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  onPressed: _editEmergencyDetails,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

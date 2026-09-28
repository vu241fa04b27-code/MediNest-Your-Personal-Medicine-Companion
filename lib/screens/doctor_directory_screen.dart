import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/uuid_util.dart';
import '../models/doctor.dart';
import '../services/storage_service.dart';
import '../services/call_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class DoctorDirectoryScreen extends StatefulWidget {
  const DoctorDirectoryScreen({super.key});

  @override
  State<DoctorDirectoryScreen> createState() => _DoctorDirectoryScreenState();
}

class _DoctorDirectoryScreenState extends State<DoctorDirectoryScreen> {
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

  void _showAddDoctorDialog() {
    final nameCtrl = TextEditingController(text: 'Dr. ');
    final specCtrl = TextEditingController();
    final hospCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: '+91 ');
    final addrCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Doctor Details', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Doctor Name *')),
              const SizedBox(height: 8),
              TextField(controller: specCtrl, decoration: const InputDecoration(labelText: 'Specialization (e.g. Dermatologist)')),
              const SizedBox(height: 8),
              TextField(controller: hospCtrl, decoration: const InputDecoration(labelText: 'Hospital Name *')),
              const SizedBox(height: 8),
              TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number (+91...)')),
              const SizedBox(height: 8),
              TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'Hospital Address / Location')),
              const SizedBox(height: 8),
              TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Prescription Notes')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final newDoc = Doctor(
                id: const Uuid().v4(),
                name: nameCtrl.text.trim(),
                specialization: specCtrl.text.trim().isNotEmpty ? specCtrl.text.trim() : 'Specialist',
                hospital: hospCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                address: addrCtrl.text.trim(),
                lastConsultationDate: DateTime.now(),
                nextVisitDate: DateTime.now().add(const Duration(days: 30)),
                prescriptionNotes: notesCtrl.text.trim(),
              );
              await _storage.addDoctor(newDoc);
              Navigator.pop(ctx);
            },
            child: const Text('Save Doctor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _storage.doctors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Doctor Directory',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primaryGreen, size: 26),
            onPressed: _showAddDoctorDialog,
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
              const Text(
                'Your Medical Specialists',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'One-tap direct calling, SMS messaging, and Google Maps hospital location.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              ...doctors.map((doc) => _buildDoctorCard(doc)),

              const SizedBox(height: 20),
              LargeButton(
                label: '+ Add Another Doctor',
                icon: Icons.add_rounded,
                type: ButtonType.outline,
                height: 52,
                fontSize: 16,
                onPressed: _showAddDoctorDialog,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doc) {
    final lastConsultStr = DateFormat('dd MMM yyyy').format(doc.lastConsultationDate);
    final nextVisitStr = DateFormat('dd MMM yyyy').format(doc.nextVisitDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.cardRadius,
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Header: Avatar, Name, Specialization
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_services_rounded, color: AppColors.primaryGreen, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doc.specialization,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreenDark),
                    ),
                    Text(
                      doc.hospital,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Phone Number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_rounded, color: AppColors.primaryGreen, size: 18),
                const SizedBox(width: 8),
                Text(
                  doc.phone,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dates: Consultation Date & Next Visit Date
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Consulted', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(lastConsultStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next Visit Date', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(nextVisitStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentBlueDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Prescription Notes
          if (doc.prescriptionNotes.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardBgTintedGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Notes: ${doc.prescriptionNotes}',
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Action Buttons: Call Doctor, Message, Open Hospital Location
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  onPressed: () => CallLauncherService.makePhoneCall(doc.phone),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accentBlue, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.accentBlue, size: 18),
                  label: const Text('Message', style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                  onPressed: () => CallLauncherService.sendSms(doc.phone, body: 'Hello ${doc.name}, this is Ammu regards my medicine prescription.'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accentBlueLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                tooltip: 'Open Hospital Location on Google Maps',
                icon: const Icon(Icons.location_on_rounded, color: AppColors.accentBlueDark),
                onPressed: () => CallLauncherService.openMapLocation('${doc.hospital} ${doc.address}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

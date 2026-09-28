import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import '../services/call_launcher_service.dart';
import '../services/notification_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';
import '../widgets/voice_reading_bar.dart';
import 'add_edit_medicine_screen.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  final StorageService _storage = StorageService();
  late Medicine _med;

  @override
  void initState() {
    super.initState();
    _med = widget.medicine;
    _storage.addListener(_onStorageUpdate);
  }

  void _onStorageUpdate() {
    final updated = _storage.medicines.firstWhere(
      (m) => m.id == _med.id,
      orElse: () => _med,
    );
    if (mounted) setState(() => _med = updated);
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageUpdate);
    super.dispose();
  }

  void _refillStock(int added) async {
    await _storage.refillMedicineStock(_med.id, added);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Added $added tablets. New stock: ${_med.remainingStock + added} tablets!'),
        ),
      );
    }
  }

  void _takeDose() async {
    final time = _med.doseTimes.isNotEmpty ? _med.doseTimes.first : '08:00 AM';
    await _storage.markDoseTaken(_med.id, time);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Marked dose as Taken. Remaining: ${_med.remainingStock - 1} tablets.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLow = _med.isLowStock;

    final voiceReadout = '${_med.name}. Dosage form is ${_med.type}. '
        'Purpose: ${_med.purpose}. '
        'How to take: ${_med.afterFood ? "Take after food" : "Take before food"}. '
        'Remaining stock is ${_med.remainingStock} tablets. '
        'Important warning: ${_med.warnings.isNotEmpty ? _med.warnings.first : "Do not stop without doctor advice"}.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _med.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.accentBlue),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditMedicineScreen(medicineToEdit: _med)),
              );
            },
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
              // Voice Reader
              VoiceReadingBar(textToSpeak: voiceReadout),
              const SizedBox(height: 14),

              // Medicine Highlight Card
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreenLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.medication_rounded, size: 36, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _med.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_med.type} • ${_med.repeat} schedule',
                                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Stock Counter Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isLow ? AppColors.dangerLight : AppColors.cardBgTintedGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLow ? AppColors.danger : AppColors.primaryGreen.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isLow ? Icons.warning_rounded : Icons.inventory_2_rounded,
                                    color: isLow ? AppColors.danger : AppColors.primaryGreenDark,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Medicine Stock Tracker',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ],
                              ),
                              Text(
                                '${_med.remainingStock} Tablets Left',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isLow ? AppColors.danger : AppColors.primaryGreenDark,
                                ),
                              ),
                            ],
                          ),
                          if (isLow) ...[
                            const SizedBox(height: 8),
                            const Text(
                              '⚠️ Only 5 tablets left. Buy refill soon.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text('Quick Refill: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              const SizedBox(width: 8),
                              ActionChip(
                                label: const Text('+10 Tablets'),
                                backgroundColor: Colors.white,
                                onPressed: () => _refillStock(10),
                              ),
                              const SizedBox(width: 8),
                              ActionChip(
                                label: const Text('+30 Tablets (1 Mo)'),
                                backgroundColor: Colors.white,
                                onPressed: () => _refillStock(30),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Purpose
              _buildInfoSection(
                title: 'Purpose',
                icon: Icons.lightbulb_outline_rounded,
                iconColor: AppColors.accentBlue,
                items: [
                  'Controls dandruff and flaking',
                  'Reduces fungal infection and itching',
                  'Relieves scalp inflammation and redness',
                  _med.purpose,
                ],
              ),
              const SizedBox(height: 16),

              // Section: How to Take
              _buildInfoSection(
                title: 'How to Take',
                icon: Icons.checklist_rounded,
                iconColor: AppColors.primaryGreen,
                items: [
                  _med.afterFood
                      ? 'Take after meals (prevents stomach upset)'
                      : (_med.beforeFood ? 'Take 30 mins before food' : 'Can be taken with or without food'),
                  'Take at the same time every day: ${_med.doseTimes.join(", ")}',
                  'Swallow whole with a full glass of plain water',
                  'Do not crush or chew the tablet unless instructed',
                ],
              ),
              const SizedBox(height: 16),

              // Section: Common Side Effects
              _buildInfoSection(
                title: 'Common Side Effects',
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.warning,
                items: _med.commonSideEffects.isNotEmpty
                    ? _med.commonSideEffects
                    : [
                        'Mild headache (usually temporary)',
                        'Mild stomach upset if taken without food',
                        'Slight nausea',
                      ],
              ),
              const SizedBox(height: 16),

              // Section: Warnings (Red Highlight)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.danger.withOpacity(0.4), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Important Warnings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...(_med.warnings.isNotEmpty
                            ? _med.warnings
                            : ["Don't stop without doctor's advice.", "Complete full prescribed duration."])
                        .map((w) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      w,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Prescribing Doctor & Hospital Card
              if (_med.doctorName.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppStyles.cardRadius,
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prescribing Doctor & Hospital',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _med.doctorName,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        _med.hospitalName,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              icon: const Icon(Icons.phone_rounded, color: AppColors.primaryGreen, size: 18),
                              label: const Text('Call Doctor', style: TextStyle(color: AppColors.primaryGreenDark, fontWeight: FontWeight.bold)),
                              onPressed: () => CallLauncherService.makePhoneCall(_med.doctorPhone),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.accentBlue, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              icon: const Icon(Icons.local_hospital_rounded, color: AppColors.accentBlue, size: 18),
                              label: const Text('Call Hospital', style: TextStyle(color: AppColors.accentBlueDark, fontWeight: FontWeight.bold)),
                              onPressed: () => CallLauncherService.makePhoneCall(_med.hospitalPhone),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Mark Taken Action
              LargeButton(
                label: 'Take This Medicine Now ✓',
                icon: Icons.check_circle_rounded,
                type: ButtonType.primaryGreen,
                height: 56,
                fontSize: 17,
                onPressed: _takeDose,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.cardRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.35),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

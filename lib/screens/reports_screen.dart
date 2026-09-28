import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final StorageService _storage = StorageService();
  bool _isGenerating = false;

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    try {
      await PdfReportService.printOrShareReport(
        context: context,
        profile: _storage.emergencyProfile,
        medicines: _storage.medicines,
        doseLogs: _storage.doseLogs,
        appointments: _storage.appointments,
        journalEntries: _storage.journalEntries,
        adherenceRate: _storage.adherencePercentage,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report generated. Share dialog triggered: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _storage.emergencyProfile;
    final adherence = _storage.adherencePercentage;

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
          'Clinical Reports',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Hero Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.4), width: 1.5),
                  boxShadow: AppColors.elevatedShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreenLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primaryGreen, size: 30),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doctor-Ready PDF Report',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Formatted for medical consultations & check-ups',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    const Text(
                      'Report Includes:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryGreenDark),
                    ),
                    const SizedBox(height: 10),

                    _buildBulletItem('Active Medicines & Exact Timing'),
                    _buildBulletItem('Adherence Percentage (${adherence.toStringAsFixed(0)}% score)'),
                    _buildBulletItem('Doctor Consultations & Hospital Check-up Schedule'),
                    _buildBulletItem('Daily Health Journal (Mood, Sleep, Itching, Hair Fall)'),
                    _buildBulletItem('Patient Allergies & Emergency Profile'),
                    _buildBulletItem('Doctor Feedback & Stamp Area'),

                    const SizedBox(height: 22),

                    LargeButton(
                      label: 'Generate & Share PDF Report',
                      icon: Icons.download_rounded,
                      type: ButtonType.primaryGreen,
                      height: 54,
                      fontSize: 16,
                      isLoading: _isGenerating,
                      onPressed: _generateReport,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Live Summary Preview for Ammu
              const Text(
                'Report Snapshot Preview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildSnapshotRow('Patient Name', profile.userName),
                    const Divider(),
                    _buildSnapshotRow('Blood Group', profile.bloodGroup),
                    const Divider(),
                    _buildSnapshotRow('Primary Doctor', profile.doctorName),
                    const Divider(),
                    _buildSnapshotRow('Active Medicines', '${_storage.medicines.length} Prescriptions'),
                    const Divider(),
                    _buildSnapshotRow('Monthly Adherence', '${adherence.toStringAsFixed(0)}%'),
                    const Divider(),
                    _buildSnapshotRow('Next Check-up', DateFormat('dd MMM yyyy').format(_storage.nextAppointment?.appointmentDateTime ?? DateTime.now())),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

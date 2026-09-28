import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hospital_appointment.dart';
import '../services/storage_service.dart';
import '../services/call_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/large_button.dart';
import '../widgets/voice_reading_bar.dart';

class HospitalTrackerScreen extends StatefulWidget {
  const HospitalTrackerScreen({super.key});

  @override
  State<HospitalTrackerScreen> createState() => _HospitalTrackerScreenState();
}

class _HospitalTrackerScreenState extends State<HospitalTrackerScreen> {
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

  void _markCompleted(HospitalAppointment appt) async {
    await _storage.completeAppointmentAndScheduleNext(appt.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Marked completed! Next monthly check-up automatically scheduled for next month.'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _reschedule(HospitalAppointment appt) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: appt.appointmentDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appt.appointmentDateTime),
    );
    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    await _storage.rescheduleAppointment(appt.id, newDateTime);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.accentBlueDark,
          content: Text('✓ Appointment rescheduled to ${DateFormat('dd MMM yyyy, hh:mm a').format(newDateTime)}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appt = _storage.nextAppointment;
    final pastAppointments = _storage.appointments.where((a) => a.isCompleted).toList();

    final daysLeft = appt?.daysUntil ?? 0;
    final formattedDate = appt != null
        ? DateFormat('MMMM dd, yyyy (EEEE)').format(appt.appointmentDateTime)
        : 'No upcoming check-up';
    final formattedTime = appt != null
        ? DateFormat('hh:mm a').format(appt.appointmentDateTime)
        : '';

    final voiceReadout = appt != null
        ? 'Your next hospital visit is on $formattedDate at $formattedTime with ${appt.doctorName} at ${appt.hospitalName}. '
          'You have $daysLeft days left. Reminder alerts are active.'
        : 'You do not have any upcoming hospital visits scheduled.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Monthly Hospital Tracker',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
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

              if (appt != null) ...[
                // Big Countdown Highlight Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppStyles.cardRadius,
                    border: Border.all(color: AppColors.accentBlue, width: 2.0),
                    boxShadow: AppColors.elevatedShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlueLight,
                          borderRadius: AppStyles.pillRadius,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.accentBlueDark),
                            SizedBox(width: 6),
                            Text(
                              'MONTHLY CHECK-UP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentBlueDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Countdown Number
                      Text(
                        daysLeft == 0
                            ? 'Today!'
                            : (daysLeft == 1 ? 'Tomorrow' : '$daysLeft Days Left'),
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accentBlueDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$formattedDate at $formattedTime',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Doctor & Hospital
                      Text(
                        appt.doctorName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      Text(
                        '${appt.specialization} • ${appt.hospitalName}',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // 3 Action Buttons: Mark Completed, Reschedule, Call Doctor
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: LargeButton(
                              label: 'Completed ✓',
                              icon: Icons.check_circle_rounded,
                              type: ButtonType.primaryGreen,
                              height: 50,
                              fontSize: 15,
                              onPressed: () => _markCompleted(appt),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: LargeButton(
                              label: 'Reschedule',
                              icon: Icons.edit_calendar_rounded,
                              type: ButtonType.outline,
                              height: 50,
                              fontSize: 13,
                              onPressed: () => _reschedule(appt),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LargeButton(
                        label: 'Call Doctor: ${appt.doctorPhone}',
                        icon: Icons.phone_rounded,
                        type: ButtonType.neutral,
                        height: 48,
                        fontSize: 14,
                        onPressed: () => CallLauncherService.makePhoneCall(appt.doctorPhone),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Multi-stage Reminder Schedule Timeline Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppStyles.cardRadius,
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_rounded, color: AppColors.primaryGreen, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Active Reminder Schedule',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'MediNest automatically alerts you on Android notification bar:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 14),

                      _buildReminderStep('7 Days Before', 'Early heads-up to arrange transport & reports', daysLeft <= 7),
                      _buildReminderStep('3 Days Before', 'Confirmation reminder for your slot', daysLeft <= 3),
                      _buildReminderStep('1 Day Before', 'Prepare past prescription notes and test results', daysLeft <= 1),
                      _buildReminderStep('Morning of Visit', '8:00 AM departure prep alert', daysLeft == 0),
                      _buildReminderStep('1 Hour Before', 'Time to leave for hospital check-up', daysLeft == 0, isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Hospital Contact Section
                Container(
                  padding: const EdgeInsets.all(18),
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.accentBlueLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.local_hospital_rounded, color: AppColors.accentBlueDark, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.hospitalName,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Hours: ${appt.workingHours}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              appt.hospitalAddress,
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Hospital: ${appt.hospitalPhone}', style: const TextStyle(fontSize: 14)),
                          const Spacer(),
                          const Icon(Icons.emergency_outlined, size: 18, color: AppColors.danger),
                          const SizedBox(width: 6),
                          Text('ER: ${appt.emergencyPhone}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.danger)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Buttons: Call Hospital & Navigate Google Maps
                      Row(
                        children: [
                          Expanded(
                            child: LargeButton(
                              label: 'Call Hospital',
                              icon: Icons.phone_in_talk_rounded,
                              type: ButtonType.primaryGreen,
                              height: 48,
                              fontSize: 14,
                              onPressed: () => CallLauncherService.makePhoneCall(appt.hospitalPhone),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LargeButton(
                              label: 'Navigate GPS',
                              icon: Icons.map_rounded,
                              type: ButtonType.secondaryBlue,
                              height: 48,
                              fontSize: 14,
                              onPressed: () => CallLauncherService.openMapLocation('${appt.hospitalName} ${appt.hospitalAddress}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Prescription Notes
                if (appt.prescriptionNotes.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgTintedGreen,
                      borderRadius: AppStyles.cardRadius,
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prescription Notes for this Visit:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryGreenDark),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appt.prescriptionNotes,
                          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],

              // Past Check-ups History
              if (pastAppointments.isNotEmpty) ...[
                const Text(
                  'Past Completed Check-ups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                ...pastAppointments.map((p) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${p.specialization} Check-up', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${p.doctorName} • ${DateFormat("dd MMM yyyy").format(p.appointmentDateTime)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderStep(String title, String desc, bool isReached, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isReached ? AppColors.primaryGreen : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isReached ? AppColors.primaryGreen : AppColors.border,
                  width: 2,
                ),
              ),
              child: isReached
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isReached ? AppColors.primaryGreen : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isReached ? AppColors.primaryGreenDark : AppColors.textPrimary,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

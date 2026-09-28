import 'dart:async';
import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/dose_log.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'large_button.dart';

class NextMedicineBanner extends StatefulWidget {
  final Medicine? medicine;
  final DoseLog? nextDose;
  final VoidCallback onTaken;
  final VoidCallback onSnooze;
  final VoidCallback onTapDetails;

  const NextMedicineBanner({
    super.key,
    required this.medicine,
    required this.nextDose,
    required this.onTaken,
    required this.onSnooze,
    required this.onTapDetails,
  });

  @override
  State<NextMedicineBanner> createState() => _NextMedicineBannerState();
}

class _NextMedicineBannerState extends State<NextMedicineBanner> {
  Timer? _countdownTimer;
  String _countdownString = 'Upcoming Soon';

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) => _updateCountdown());
  }

  @override
  void didUpdateWidget(covariant NextMedicineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    if (widget.medicine == null || widget.nextDose == null) {
      if (mounted) setState(() => _countdownString = 'All done for today! 🎉');
      return;
    }

    try {
      final timeStr = widget.nextDose!.scheduledTime; // e.g. "01:30 PM"
      final parts = timeStr.split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      final now = DateTime.now();
      var target = DateTime(now.year, now.month, now.day, hour, minute);
      if (target.isBefore(now)) {
        if (mounted) setState(() => _countdownString = 'Due Now');
        return;
      }

      final diff = target.difference(now);
      final hours = diff.inHours;
      final mins = diff.inMinutes % 60;

      if (mounted) {
        setState(() {
          if (hours > 0) {
            _countdownString = 'In ${hours}h ${mins}m';
          } else {
            _countdownString = 'In ${mins} minutes';
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _countdownString = 'Upcoming Soon');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.medicine == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryGreenLight,
          borderRadius: AppStyles.cardRadius,
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.4), width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Caught Up! 🌸',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreenDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Great job! All prescribed medicines for today have been taken.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final med = widget.medicine!;
    final dose = widget.nextDose!;

    return InkWell(
      onTap: widget.onTapDetails,
      borderRadius: AppStyles.cardRadius,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppStyles.cardRadius,
          border: Border.all(color: AppColors.primaryGreen, width: 2.0),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Header tag & countdown badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenLight,
                    borderRadius: AppStyles.pillRadius,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alarm_on_rounded, size: 16, color: AppColors.primaryGreenDark),
                      SizedBox(width: 6),
                      Text(
                        'NEXT MEDICINE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreenDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlueLight,
                    borderRadius: AppStyles.pillRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.accentBlueDark),
                      const SizedBox(width: 4),
                      Text(
                        _countdownString,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentBlueDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Medicine Name & Type Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    med.type.toLowerCase() == 'capsule'
                        ? Icons.medication_liquid_rounded
                        : Icons.medication_rounded,
                    color: AppColors.primaryGreen,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, size: 16, color: AppColors.accentBlue),
                          const SizedBox(width: 4),
                          Text(
                            dose.scheduledTime,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentBlueDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: med.afterFood ? AppColors.warningLight : AppColors.primaryGreenLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              med.afterFood
                                  ? 'After Food 🍲'
                                  : (med.beforeFood ? 'Before Food 🍎' : 'Anytime'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: med.afterFood ? AppColors.warning : AppColors.primaryGreenDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Purpose pill
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Purpose: ${med.purpose}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons: Taken & Snooze (10 min)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: LargeButton(
                    label: 'Taken ✓',
                    icon: Icons.check_circle_outline_rounded,
                    type: ButtonType.primaryGreen,
                    height: 52,
                    fontSize: 16,
                    onPressed: widget.onTaken,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: LargeButton(
                    label: 'Snooze',
                    icon: Icons.snooze_rounded,
                    type: ButtonType.outline,
                    height: 52,
                    fontSize: 15,
                    onPressed: widget.onSnooze,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

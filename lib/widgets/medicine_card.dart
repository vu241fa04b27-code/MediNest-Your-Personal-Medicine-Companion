import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'large_button.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTakeNow;
  final VoidCallback onSnooze;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTakeNow,
    required this.onSnooze,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'capsule':
        return Icons.medication_liquid_rounded;
      case 'syrup':
        return Icons.water_drop_rounded;
      case 'drops':
        return Icons.opacity_rounded;
      case 'inhaler':
        return Icons.air_rounded;
      case 'injection':
        return Icons.vaccines_rounded;
      case 'tablet':
      default:
        return Icons.medication_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = medicine.isLowStock;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyles.cardRadius,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.cardRadius,
            border: Border.all(
              color: isLowStock ? AppColors.warning : AppColors.border,
              width: isLowStock ? 1.8 : 1.2,
            ),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, Name, Type, Edit/Delete menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isLowStock ? AppColors.warningLight : AppColors.primaryGreenLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getTypeIcon(medicine.type),
                      size: 28,
                      color: isLowStock ? AppColors.warning : AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${medicine.type} • ${medicine.repeat}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (val) {
                      if (val == 'edit') onEdit();
                      if (val == 'delete') onDelete();
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_rounded, size: 18, color: AppColors.accentBlue),
                            SizedBox(width: 10),
                            Text('Edit Medicine', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.danger)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Badges row: Times, Before/After food, Stock
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlueLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 14, color: AppColors.accentBlueDark),
                        const SizedBox(width: 4),
                        Text(
                          medicine.doseTimes.join(', '),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentBlueDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: medicine.afterFood ? AppColors.warningLight : AppColors.primaryGreenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medicine.afterFood ? 'After Food 🍲' : (medicine.beforeFood ? 'Before Food 🍎' : 'Anytime'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: medicine.afterFood ? AppColors.warning : AppColors.primaryGreenDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isLowStock ? AppColors.dangerLight : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                          size: 14,
                          color: isLowStock ? AppColors.danger : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${medicine.remainingStock} Tablets Left',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLowStock ? AppColors.danger : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Purpose text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.borderLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Purpose: ${medicine.purpose}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Low stock alert if applicable
              if (isLowStock) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_rounded, color: AppColors.warning, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Only 5 tablets left. Buy refill soon.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // Action Buttons: Take Now & Snooze
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: LargeButton(
                      label: 'Take Now',
                      icon: Icons.check_circle_rounded,
                      type: ButtonType.primaryGreen,
                      height: 48,
                      fontSize: 15,
                      onPressed: onTakeNow,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: LargeButton(
                      label: 'Snooze',
                      icon: Icons.alarm_rounded,
                      type: ButtonType.outline,
                      height: 48,
                      fontSize: 14,
                      onPressed: onSnooze,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

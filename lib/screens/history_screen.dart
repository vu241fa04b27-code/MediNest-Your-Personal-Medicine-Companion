import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dose_log.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storage = StorageService();
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final double adherenceRate = _storage.adherencePercentage;
    final allLogs = _storage.doseLogs;
    final int totalTaken = allLogs.where((l) => l.isTaken).length;
    final int missedCount = allLogs.where((l) => l.isMissed).length;
    final int streakDays = 7; // Current active streak

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
          'Medicine History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adherence Hero Card with Progress Ring
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.4), width: 1.5),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: adherenceRate / 100.0,
                            strokeWidth: 8,
                            backgroundColor: AppColors.primaryGreenLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                          ),
                        ),
                        Text(
                          '${adherenceRate.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Medicine Adherence',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Excellent routine! You are maintaining strong compliance.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department_rounded, color: AppColors.warning, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '$streakDays Days Active Streak 🔥',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warning),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Statistics Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatMiniCard(
                      label: 'Total Taken',
                      value: '$totalTaken',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatMiniCard(
                      label: 'Missed Doses',
                      value: '$missedCount',
                      icon: Icons.cancel_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatMiniCard(
                      label: 'Adherence',
                      value: '${adherenceRate.toStringAsFixed(0)}%',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Calendar Legend
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('Taken', AppColors.primaryGreen),
                    _buildLegendItem('Snoozed', AppColors.warning),
                    _buildLegendItem('Missed', AppColors.danger),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Calendar Grid for Current Month
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(_selectedMonth),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const Text('30 Days Monitored', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Days Grid (Mon-Sun)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
                        return SizedBox(
                          width: 32,
                          child: Center(
                            child: Text(
                              d,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Calendar days mockup with real dots
                    _buildCalendarDaysGrid(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Dose Log Entries
              const Text(
                'Recent Dose History Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...allLogs.map((log) {
                Color statusColor;
                IconData statusIcon;
                String statusLabel;

                if (log.isTaken) {
                  statusColor = AppColors.primaryGreen;
                  statusIcon = Icons.check_circle_rounded;
                  statusLabel = 'Taken';
                } else if (log.isSnoozed) {
                  statusColor = AppColors.warning;
                  statusIcon = Icons.snooze_rounded;
                  statusLabel = 'Snoozed';
                } else {
                  statusColor = AppColors.accentBlue;
                  statusIcon = Icons.schedule_rounded;
                  statusLabel = 'Upcoming';
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.medicineName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('${log.dateString} at ${log.scheduledTime}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatMiniCard({required String label, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCalendarDaysGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.1,
      ),
      itemCount: 28,
      itemBuilder: (ctx, idx) {
        final dayNum = idx + 1;
        // Mock day compliance colors
        Color dotColor = AppColors.primaryGreen;
        if (dayNum == 12 || dayNum == 19) dotColor = AppColors.warning;
        if (dayNum == 25) dotColor = AppColors.danger;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNum',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 3),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
          ],
        );
      },
    );
  }
}

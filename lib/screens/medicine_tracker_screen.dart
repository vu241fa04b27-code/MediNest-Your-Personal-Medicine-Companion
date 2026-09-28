import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/localization.dart';
import '../widgets/medicine_card.dart';
import '../widgets/voice_reading_bar.dart';
import 'add_edit_medicine_screen.dart';
import 'medicine_details_screen.dart';

class MedicineTrackerScreen extends StatefulWidget {
  const MedicineTrackerScreen({super.key});

  @override
  State<MedicineTrackerScreen> createState() => _MedicineTrackerScreenState();
}

class _MedicineTrackerScreenState extends State<MedicineTrackerScreen> {
  final StorageService _storage = StorageService();
  String _selectedFilter = 'All'; // All, Morning, Afternoon, Night
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  void _takeNow(Medicine med) async {
    final defaultTime = med.doseTimes.isNotEmpty ? med.doseTimes.first : '08:00 AM';
    await _storage.markDoseTaken(med.id, defaultTime);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Took ${med.name}! Remaining: ${med.remainingStock - 1} tablets.'),
        ),
      );
    }
  }

  void _snooze(Medicine med) async {
    final defaultTime = med.doseTimes.isNotEmpty ? med.doseTimes.first : '08:00 AM';
    await _storage.markDoseSnoozed(med.id, defaultTime);
    // Fire smart notification alarm
    NotificationService().showMedicineAlert(
      id: med.id.hashCode,
      medicineId: med.id,
      medicineName: med.name,
      timing: 'Snoozed 10 mins',
      purpose: med.purpose,
      repeatAttempt: 1,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.warning,
          content: Text('⏱ Snoozed ${med.name} for 10 minutes. Reminder active.'),
        ),
      );
    }
  }

  void _deleteMedicine(Medicine med) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Medicine?'),
        content: Text('Are you sure you want to remove ${med.name} from your schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              await _storage.deleteMedicine(med.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editMedicine(Medicine med) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEditMedicineScreen(medicineToEdit: med)),
    );
  }

  List<Medicine> _getFilteredMedicines() {
    return _storage.medicines.where((med) {
      final matchesSearch = med.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          med.purpose.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;

      // Filter by morning / afternoon / night
      final times = med.doseTimes.join(' ').toLowerCase();
      if (_selectedFilter == 'Morning') {
        return times.contains('am') || times.contains('08:') || times.contains('09:');
      } else if (_selectedFilter == 'Afternoon') {
        return times.contains('01:') || times.contains('02:') || times.contains('12:');
      } else if (_selectedFilter == 'Night') {
        return times.contains('08:') || times.contains('09:') || times.contains('10:') || times.contains('pm');
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization(_storage.settings.language);
    final medicines = _getFilteredMedicines();
    final lowStockMedicines = _storage.medicines.where((m) => m.isLowStock).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Medicine Tracker',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Medicine',
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryGreen, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEditMedicineScreen()),
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
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search tablet by name or purpose...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Filter Chips (All, Morning, Afternoon, Night)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Morning', 'Afternoon', 'Night'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.primaryGreen : AppColors.border,
                          ),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedFilter = filter);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Low Stock Alert banner if any tablet <= 5
              if (lowStockMedicines.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: AppStyles.cardRadius,
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: AppColors.warning, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Low Stock Alert (${lowStockMedicines.length} Medicine)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                            Text(
                              '${lowStockMedicines.map((m) => m.name).join(', ')} has 5 or fewer tablets remaining. Refill soon!',
                              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Medicines List
              if (medicines.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.medication_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          'No medicines found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        const Text('Tap "+ Add Medicine" to add your prescription'),
                      ],
                    ),
                  ),
                )
              else
                ...medicines.map((med) => MedicineCard(
                      medicine: med,
                      onTakeNow: () => _takeNow(med),
                      onSnooze: () => _snooze(med),
                      onEdit: () => _editMedicine(med),
                      onDelete: () => _deleteMedicine(med),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MedicineDetailsScreen(medicine: med)),
                        );
                      },
                    )),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

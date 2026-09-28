import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import 'home_dashboard_screen.dart';
import 'medicine_tracker_screen.dart';
import 'hospital_tracker_screen.dart';
import 'health_journal_screen.dart';
import 'settings_screen.dart';
import 'add_edit_medicine_screen.dart';
import 'emergency_card_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _openAddMedicine() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEditMedicineScreen()),
    );
  }

  void _openEmergencyCard() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EmergencyCardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current locale from storage service or fallback
    final loc = AppLocalization('en');

    final screens = [
      const HomeDashboardScreen(),
      const MedicineTrackerScreen(),
      const HospitalTrackerScreen(),
      const HealthJournalScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: _currentIndex == 1 || _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openAddMedicine,
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text(
                'Add Medicine',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primaryGreenLight,
          height: 68,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryGreenDark),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.medication_rounded, color: AppColors.primaryGreenDark),
              label: 'Medicines',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.local_hospital_rounded, color: AppColors.primaryGreenDark),
              label: 'Hospital',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.book_rounded, color: AppColors.primaryGreenDark),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryGreenDark),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

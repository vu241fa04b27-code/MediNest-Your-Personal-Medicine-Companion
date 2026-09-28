import 'package:flutter/material.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline storage service
  final storageService = StorageService();
  await storageService.init();

  // Initialize notifications with action button callbacks
  final notificationService = NotificationService();
  await notificationService.init(
    onAction: (medicineId, action) async {
      debugPrint("Action received from Android Notification Bar: $action for $medicineId");
      if (action == 'taken') {
        final med = storageService.medicines.firstWhere(
          (m) => m.id == medicineId,
          orElse: () => storageService.medicines.first,
        );
        final defaultTime = med.doseTimes.isNotEmpty ? med.doseTimes.first : '08:00 AM';
        await storageService.markDoseTaken(medicineId, defaultTime);
      } else if (action == 'snooze') {
        final med = storageService.medicines.firstWhere(
          (m) => m.id == medicineId,
          orElse: () => storageService.medicines.first,
        );
        final defaultTime = med.doseTimes.isNotEmpty ? med.doseTimes.first : '08:00 AM';
        await storageService.markDoseSnoozed(medicineId, defaultTime);
      }
    },
  );

  runApp(const MediNestApp());
}

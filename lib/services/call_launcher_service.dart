import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallLauncherService {
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching call: $e");
    }
    return false;
  }

  static Future<bool> sendSms(String phoneNumber, {String? body}) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(
      scheme: 'sms',
      path: cleanNumber,
      queryParameters: body != null ? {'body': body} : null,
    );
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error sending SMS: $e");
    }
    return false;
  }

  static Future<bool> openMapLocation(String addressOrQuery) async {
    final encoded = Uri.encodeComponent(addressOrQuery);
    final mapUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    try {
      if (await canLaunchUrl(mapUri)) {
        return await launchUrl(mapUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error opening maps: $e");
    }
    return false;
  }
}

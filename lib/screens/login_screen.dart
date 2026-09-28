import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/localization.dart';
import '../widgets/large_button.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedLang = 'en';
  bool _isGoogleLoading = false;

  void _onContinueWithoutAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  Future<void> _onContinueWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    // Simulate seamless Google sign in
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isGoogleLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('Google Account connected. Cloud backup enabled!'),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization(_selectedLang);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Language selector pill
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardBgTintedGreen,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryGreen.withOpacity(0.4)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLang,
                icon: const Icon(Icons.language_rounded, color: AppColors.primaryGreenDark, size: 20),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreenDark,
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLang = val);
                },
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
                  DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Visual Welcome Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3), width: 2),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  size: 50,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 20),

              // App Name & Tagline
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Medi',
                    style: AppStyles.headingLarge.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    'Nest',
                    style: AppStyles.headingLarge.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                loc.tr('login_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                loc.tr('login_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // 3 Value Proposition Cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.borderLight.withOpacity(0.6),
                  borderRadius: AppStyles.cardRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  children: [
                    _FeatureRow(
                      icon: Icons.wifi_off_rounded,
                      title: '100% Offline Ready',
                      desc: 'Works without internet, anytime, anywhere.',
                    ),
                    Divider(height: 16),
                    _FeatureRow(
                      icon: Icons.notification_important_rounded,
                      title: 'Reliable Alarm Reminders',
                      desc: 'Never miss a dose even if the phone restarts.',
                    ),
                    Divider(height: 16),
                    _FeatureRow(
                      icon: Icons.phone_in_talk_rounded,
                      title: 'One-Tap Doctor & Hospital Calling',
                      desc: 'Quick help for elderly peace of mind.',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary: Start Without Account
              LargeButton(
                label: loc.tr('start_without_account'),
                icon: Icons.arrow_forward_rounded,
                type: ButtonType.primaryGreen,
                height: 56,
                fontSize: 17,
                onPressed: _onContinueWithoutAccount,
              ),
              const SizedBox(height: 14),

              // Secondary: Continue with Google
              LargeButton(
                label: loc.tr('continue_google'),
                icon: Icons.account_circle_outlined,
                type: ButtonType.outline,
                height: 56,
                fontSize: 16,
                isLoading: _isGoogleLoading,
                onPressed: _onContinueWithGoogle,
              ),
              const SizedBox(height: 12),

              // Cloud backup optional note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_done_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    loc.tr('cloud_backup_optional'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

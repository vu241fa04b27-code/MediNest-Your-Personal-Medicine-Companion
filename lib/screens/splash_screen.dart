import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _capsuleController;
  late AnimationController _heartbeatController;
  late Animation<double> _capsuleRotation;
  late Animation<double> _capsuleScale;
  late Animation<double> _heartbeatPulse;

  @override
  void initState() {
    super.initState();

    // Capsule animation: gentle rotation and bounce
    _capsuleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _capsuleRotation = Tween<double>(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(parent: _capsuleController, curve: Curves.easeInOutSine),
    );

    _capsuleScale = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _capsuleController, curve: Curves.easeInOut),
    );

    // Heartbeat line pulse animation
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartbeatPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeOutBack),
    );

    // Auto-navigate to Login after splash
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, anim, secAnim) => const LoginScreen(),
            transitionsBuilder: (context, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _capsuleController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Capsule & Logo
              AnimatedBuilder(
                animation: _capsuleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _capsuleScale.value,
                    child: Transform.rotate(
                      angle: _capsuleRotation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular soft aura
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Capsule Icon
                      const Icon(
                        Icons.medication_rounded,
                        size: 64,
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Animated Heartbeat ECG line
              AnimatedBuilder(
                animation: _heartbeatPulse,
                builder: (context, child) {
                  return Transform.scale(
                    scaleX: _heartbeatPulse.value,
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(180, 40),
                  painter: HeartbeatPainter(color: AppColors.accentBlue),
                ),
              ),
              const SizedBox(height: 24),

              // App Name: MediNest
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Medi',
                    style: AppStyles.headingLarge.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    'Nest',
                    style: AppStyles.headingLarge.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Subtitle & Tagline
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Your Personal Medicine Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Never Miss a Tablet. Never Miss a Check-up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const Spacer(),

              // Simple bottom loading indicator & offline guarantee
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '100% Offline Ready • Fast & Secure',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Heartbeat ECG line
class HeartbeatPainter extends CustomPainter {
  final Color color;

  HeartbeatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.25, h * 0.5);
    path.lineTo(w * 0.35, h * 0.2);
    path.lineTo(w * 0.45, h * 0.85);
    path.lineTo(w * 0.55, h * 0.1);
    path.lineTo(w * 0.65, h * 0.6);
    path.lineTo(w * 0.75, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

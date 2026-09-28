import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

enum ButtonType { primaryGreen, secondaryBlue, danger, outline, neutral }

class LargeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double height;
  final double? width;
  final double fontSize;

  const LargeButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.type = ButtonType.primaryGreen,
    this.isLoading = false,
    this.height = 56.0,
    this.width,
    this.fontSize = 17.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide borderSide = BorderSide.none;

    switch (type) {
      case ButtonType.primaryGreen:
        bgColor = AppColors.primaryGreen;
        fgColor = Colors.white;
        break;
      case ButtonType.secondaryBlue:
        bgColor = AppColors.accentBlue;
        fgColor = Colors.white;
        break;
      case ButtonType.danger:
        bgColor = AppColors.danger;
        fgColor = Colors.white;
        break;
      case ButtonType.outline:
        bgColor = Colors.white;
        fgColor = AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.border, width: 1.5);
        break;
      case ButtonType.neutral:
        bgColor = AppColors.borderLight;
        fgColor = AppColors.textPrimary;
        break;
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: type == ButtonType.outline ? 0 : 2,
          shadowColor: bgColor.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.buttonRadius,
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 22, color: fgColor),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: fgColor,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

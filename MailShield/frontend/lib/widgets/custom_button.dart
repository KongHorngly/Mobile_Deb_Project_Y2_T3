import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum ButtonStyleType { green, blue, red, outlinedLight }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonStyleType type;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonStyleType.green,
    this.isLoading = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case ButtonStyleType.green:
        return AppColors.buttonGreen;
      case ButtonStyleType.blue:
        return AppColors.buttonBlue;
      case ButtonStyleType.red:
        return AppColors.buttonRed;
      case ButtonStyleType.outlinedLight:
        return Colors.white;
    }
  }

  Color get _foregroundColor {
    return type == ButtonStyleType.outlinedLight
        ? AppColors.textPrimary
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: type == ButtonStyleType.outlinedLight ? 0 : 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

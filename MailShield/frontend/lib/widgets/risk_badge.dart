import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// Small colored label used for verdicts (Safe / Suspicious Detected),
// and for security-check values (Trusted / Suspicious / Found / Not found).
class RiskBadge extends StatelessWidget {
  final String label;
  final bool isSafe;
  final double fontSize;

  const RiskBadge({
    super.key,
    required this.label,
    required this.isSafe,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: isSafe ? AppColors.safe : AppColors.suspicious,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

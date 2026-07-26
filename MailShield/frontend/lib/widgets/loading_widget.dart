import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import 'custom_button.dart';

class LoadingWidget extends StatelessWidget {
  final VoidCallback onCancel;

  const LoadingWidget({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            AppStrings.analyzing,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            label: AppStrings.cancel,
            type: ButtonStyleType.red,
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

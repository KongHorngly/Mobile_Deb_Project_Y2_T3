import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../models/analysis_result_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/risk_badge.dart';

//Email/Image Result (safe/unsafe) 
// registered and guest users 
class ResultScreen extends StatelessWidget {
  final String type; // 'email' | 'image'
  final AnalysisResultModel result;

  const ResultScreen({super.key, required this.type, required this.result});

  bool get _isEmail => type == 'email';
  bool get _isSafe => result.isSafe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                    ),
                    const Text(
                      AppStrings.analysisResult,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isEmail
                                    ? AppStrings.emailVerdict
                                    : AppStrings.imageVerdict,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RiskBadge(
                                label: _isSafe
                                    ? AppStrings.verdictSafe
                                    : AppStrings.verdictSuspicious,
                                isSafe: _isSafe,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isEmail
                                    ? AppStrings.emailInformation
                                    : AppStrings.imageInformation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('Sender: ${result.sender}'),
                              Text('Subject: ${result.subject}'),
                              Text(
                                '${_isEmail ? 'File' : 'Image'}: ${result.fileOrImageName}',
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                AppStrings.securityCheck,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              _InfoRow(
                                label: AppStrings.senderDomain,
                                value: result.senderDomainStatus,
                                isSafe: result.senderDomainStatus == 'Trusted',
                              ),
                              _InfoRow(
                                label: AppStrings.suspiciousWords,
                                value: result.suspiciousWordsFound
                                    ? 'Found'
                                    : 'Not found',
                                isSafe: !result.suspiciousWordsFound,
                              ),
                              _InfoRow(
                                label: AppStrings.maliciousLinks,
                                value: result.maliciousLinksFound
                                    ? 'Found'
                                    : 'Not found',
                                isSafe: !result.maliciousLinksFound,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                AppStrings.recommendation,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              ...result.recommendations.map(
                                (r) => Text('• $r'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: AppStrings.analyzeAnother,
                        type: ButtonStyleType.blue,
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.analyze,
                          arguments: {'type': type, 'isGuest': false},
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        label: AppStrings.backToDashboard,
                        type: ButtonStyleType.blue,
                        onPressed: () => Navigator.popUntil(
                          context,
                          ModalRoute.withName(AppRoutes.dashboard),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSafe;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isSafe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          RiskBadge(label: value, isSafe: isSafe, fontSize: 13),
        ],
      ),
    );
  }
}

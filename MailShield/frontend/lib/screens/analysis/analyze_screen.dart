import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_router.dart';
import '../../models/email_model.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_widget.dart';

enum _AnalyzeCheckOption { attachment, containsLink }

// Email Analysis form, progressing (registered & guest)
// Image Analysis form, progressing  
class AnalyzeScreen extends StatefulWidget {
  final String type; // 'email' | 'image'
  final bool isGuest;

  const AnalyzeScreen({super.key, required this.type, required this.isGuest});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final _senderController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  _AnalyzeCheckOption _checkOption = _AnalyzeCheckOption.containsLink;

  bool _isAnalyzing = false;

  @override
  void dispose() {
    _senderController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _isEmail => widget.type == 'email';

  Future<void> _startAnalysis() async {
    setState(() => _isAnalyzing = true);

    final analysisProvider = context.read<AnalysisProvider>();
    final uid = widget.isGuest
        ? null
        : context.read<AuthProvider>().currentUser?.id;

    final result = _isEmail
        ? await analysisProvider.analyzeEmail(
            EmailModel(
              senderEmail: _senderController.text.trim(),
              subject: _subjectController.text.trim(),
              body: _bodyController.text.trim(),
              hasAttachment: _checkOption == _AnalyzeCheckOption.attachment,
              containsLink: _checkOption == _AnalyzeCheckOption.containsLink,
            ),
            uidToSaveHistory: uid,
          )
        : await analysisProvider.analyzeImage(
            const [], 
            uidToSaveHistory: uid,
          );

    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    if (result == null) {
      if (analysisProvider.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(analysisProvider.errorMessage!)));
      }
      return; 
    }

    Navigator.pushNamed(
      context,
      AppRoutes.result,
      arguments: {'type': widget.type, 'result': result},
    );
  }

  void _cancelAnalysis() {
    context.read<AnalysisProvider>().cancelAnalysis();
    setState(() => _isAnalyzing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                    ),
                    Text(
                      _isEmail
                          ? AppStrings.emailAnalysis
                          : AppStrings.imageAnalysis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isAnalyzing
                    ? LoadingWidget(onCancel: _cancelAnalysis)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _isEmail ? _buildEmailForm() : _buildImageForm(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _senderController,
          labelText: AppStrings.senderEmail,
          hintText: 'sender@gmail.com',
        ),
        CustomTextField(
          controller: _subjectController,
          labelText: AppStrings.subject,
          hintText: '"URGENT"',
        ),
        CustomTextField(
          controller: _bodyController,
          labelText: AppStrings.emailBody,
          hintText: 'Paste email body here',
          maxLines: 4,
        ),
        const CustomTextField(
          labelText: AppStrings.uploadFiles,
          hintText: 'sender_file.eml',
          prefixIcon: Icon(Icons.attach_file, size: 18),
        ),
        RadioListTile<_AnalyzeCheckOption>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text(
            AppStrings.attachment,
            style: TextStyle(color: Colors.white),
          ),
          value: _AnalyzeCheckOption.attachment,
          groupValue: _checkOption,
          onChanged: (value) => setState(() => _checkOption = value!),
        ),
        RadioListTile<_AnalyzeCheckOption>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text(
            AppStrings.containsLink,
            style: TextStyle(color: Colors.white),
          ),
          value: _AnalyzeCheckOption.containsLink,
          groupValue: _checkOption,
          onChanged: (value) => setState(() => _checkOption = value!),
        ),
        const SizedBox(height: 16),
        CustomButton(label: AppStrings.analyze, onPressed: _startAnalysis),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildImageForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.uploadImage,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.black38),
        ),
        const SizedBox(height: 16),
        const Text(
          AppStrings.takeAPhoto,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: () {
              // open camera
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text(''),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        CustomButton(label: AppStrings.analyze, onPressed: _startAnalysis),
        const SizedBox(height: 24),
      ],
    );
  }
}

class AnalysisResultModel {
// Result returned after analyzing an email or image, shown on
// the Analysis Result screen.

  final bool isSafe;
  final String sender;
  final String subject;
  final String fileOrImageName;
  final String senderDomainStatus; // "Trusted" | "Suspicious"
  final bool suspiciousWordsFound;
  final bool maliciousLinksFound;
  final List<String> recommendations;

  const AnalysisResultModel({
    required this.isSafe,
    required this.sender,
    required this.subject,
    required this.fileOrImageName,
    required this.senderDomainStatus,
    required this.suspiciousWordsFound,
    required this.maliciousLinksFound,
    required this.recommendations,
  });

  factory AnalysisResultModel.placeholder({required bool isSafe}) {
  // Placeholder result so result_screen.dart is viewable before the

    return AnalysisResultModel(
      isSafe: isSafe,
      sender: 'sender@gmail.com',
      subject: '"URGENT"',
      fileOrImageName: 'sender_file.eml',
      senderDomainStatus: isSafe ? 'Trusted' : 'Suspicious',
      suspiciousWordsFound: !isSafe,
      maliciousLinksFound: !isSafe,
      recommendations: isSafe
          ? const [
              'This email appears to be safe.',
              'Continue to verify unexpected request.',
            ]
          : const [
              'Do NOT click the Link and file.',
              'Block and Report the sender.',
              'Delete the email.',
            ],
    );
  }
}

class HistoryItem {

  final String id;
  final String title;
  final String verdictLabel; // "Safe" | "Malicious" | "Suspicious Detected"
  final bool isSafe;
  final DateTime scannedAt;

  // Detail fields 
  final String? sender;
  final String? subject;
  final String? fileOrImageName;
  final String? senderDomainStatus;
  final bool? suspiciousWordsFound;
  final bool? maliciousLinksFound;
  final List<String>? recommendations;

  const HistoryItem({
    required this.id,
    required this.title,
    required this.verdictLabel,
    required this.isSafe,
    required this.scannedAt,
    this.sender,
    this.subject,
    this.fileOrImageName,
    this.senderDomainStatus,
    this.suspiciousWordsFound,
    this.maliciousLinksFound,
    this.recommendations,
  });
}

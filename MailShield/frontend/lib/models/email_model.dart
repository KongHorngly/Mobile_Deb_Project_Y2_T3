class EmailModel {
  final String senderEmail;
  final String subject;
  final String body;
  final String? fileName;
  final bool hasAttachment;
  final bool containsLink;

  const EmailModel({
    required this.senderEmail,
    required this.subject,
    required this.body,
    this.fileName,
    this.hasAttachment = false,
    this.containsLink = false,
  });

  Map<String, dynamic> toJson() => {
    'senderEmail': senderEmail,
    'subject': subject,
    'body': body,
    'fileName': fileName,
    'hasAttachment': hasAttachment,
    'containsLink': containsLink,
  };
}

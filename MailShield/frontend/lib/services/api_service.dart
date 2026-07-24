import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/email_model.dart';
import '../models/analysis_result_model.dart';

/// Generic REST client for the backend that performs email/image
/// phishing analysis. Swap [baseUrl] for your actual API host.
class ApiService {
  ApiService({this.baseUrl = 'https://'});

  final String baseUrl;

  Future<AnalysisResultModel> analyzeEmail(EmailModel email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/analyze/email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(email.toJson()),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Email analysis failed (${response.statusCode})',
        response.statusCode,
      );
    }

    return _parseResult(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// [imageBytes] is the raw image file content (from image_picker/camera).
  Future<AnalysisResultModel> analyzeImage(List<int> imageBytes) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/v1/analyze/image'))
          ..files.add(
            http.MultipartFile.fromBytes(
              'image',
              imageBytes,
              filename: 'scan.png',
            ),
          );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw ApiException(
        'Image analysis failed (${response.statusCode})',
        response.statusCode,
      );
    }

    return _parseResult(jsonDecode(response.body) as Map<String, dynamic>);
  }

  AnalysisResultModel _parseResult(Map<String, dynamic> json) {
    return AnalysisResultModel(
      isSafe: json['isSafe'] as bool? ?? false,
      sender: json['sender'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      fileOrImageName: json['fileOrImageName'] as String? ?? '',
      senderDomainStatus: json['senderDomainStatus'] as String? ?? 'Suspicious',
      suspiciousWordsFound: json['suspiciousWordsFound'] as bool? ?? false,
      maliciousLinksFound: json['maliciousLinksFound'] as bool? ?? false,
      recommendations:
          (json['recommendations'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

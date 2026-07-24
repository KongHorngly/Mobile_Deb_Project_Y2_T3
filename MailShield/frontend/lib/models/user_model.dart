class UserModel {
// Represents the logged-in user, shown on Dashboard and Profile screens.
  final String id;
  final String username;
  final String email;
  final int totalScan;
  final int safeCount;
  final int suspiciousCount;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.totalScan = 0,
    this.safeCount = 0,
    this.suspiciousCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      totalScan: json['totalScan'] as int? ?? 0,
      safeCount: json['safeCount'] as int? ?? 0,
      suspiciousCount: json['suspiciousCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'totalScan': totalScan,
    'safeCount': safeCount,
    'suspiciousCount': suspiciousCount,
  };

  UserModel copyWith({int? totalScan, int? safeCount, int? suspiciousCount}) {
    return UserModel(
      id: id,
      username: username,
      email: email,
      totalScan: totalScan ?? this.totalScan,
      safeCount: safeCount ?? this.safeCount,
      suspiciousCount: suspiciousCount ?? this.suspiciousCount,
    );
  }
}

class Cookie {
  final String domain;
  final double? expirationDate;
  final bool hostOnly;
  final bool httpOnly;
  final String name;
  final String path;
  final String? sameSite;
  final bool secure;
  final bool session;
  final String? storeId;
  final String value;

  Cookie({
    required this.domain,
    this.expirationDate,
    required this.hostOnly,
    required this.httpOnly,
    required this.name,
    required this.path,
    this.sameSite,
    required this.secure,
    required this.session,
    this.storeId,
    required this.value,
  });

  factory Cookie.fromJson(Map<String, dynamic> json) {
    return Cookie(
      domain: json['domain'] ?? '',
      expirationDate: json['expirationDate']?.toDouble(),
      hostOnly: json['hostOnly'] ?? false,
      httpOnly: json['httpOnly'] ?? false,
      name: json['name'] ?? '',
      path: json['path'] ?? '/',
      sameSite: json['sameSite'],
      secure: json['secure'] ?? false,
      session: json['session'] ?? false,
      storeId: json['storeId'],
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'expirationDate': expirationDate,
      'hostOnly': hostOnly,
      'httpOnly': httpOnly,
      'name': name,
      'path': path,
      'sameSite': sameSite,
      'secure': secure,
      'session': session,
      'storeId': storeId,
      'value': value,
    };
  }

  String get displayExpiry {
    if (session) return 'Session Cookie';
    if (expirationDate == null) return 'No Expiry';
    
    final date = DateTime.fromMillisecondsSinceEpoch((expirationDate! * 1000).toInt());
    return 'Expires: ${date.toIso8601String()}';
  }
}

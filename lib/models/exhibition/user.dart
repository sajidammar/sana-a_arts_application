class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final UserRole role;
  final DateTime joinDate;
  final DateTime? lastLogin;
  final List<String> favoriteArtworks;
  final List<String> favoriteArtists;
  final List<String> favoriteExhibitions;
  final List<PurchaseHistory> purchaseHistory;
  final UserPreferences preferences;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final int points;
  final String membershipLevel;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.role,
    required this.joinDate,
    this.lastLogin,
    this.favoriteArtworks = const [],
    this.favoriteArtists = const [],
    this.favoriteExhibitions = const [],
    this.purchaseHistory = const [],
    required this.preferences,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.points = 0,
    this.membershipLevel = 'عادي',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: _parseUserRole(json['role'] ?? 'user'),
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      favoriteArtworks: List<String>.from(json['favoriteArtworks'] ?? []),
      favoriteArtists: List<String>.from(json['favoriteArtists'] ?? []),
      favoriteExhibitions: List<String>.from(json['favoriteExhibitions'] ?? []),
      purchaseHistory: List<Map<String, dynamic>>.from(json['purchaseHistory'] ?? [])
          .map((purchase) => PurchaseHistory.fromJson(purchase))
          .toList(),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      points: json['points'] ?? 0,
      membershipLevel: json['membershipLevel'] ?? 'عادي',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role.toString(),
      'joinDate': joinDate.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'favoriteArtworks': favoriteArtworks,
      'favoriteArtists': favoriteArtists,
      'favoriteExhibitions': favoriteExhibitions,
      'purchaseHistory': purchaseHistory.map((purchase) => purchase.toJson()).toList(),
      'preferences': preferences.toJson(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'points': points,
      'membershipLevel': membershipLevel,
    };
  }

  static UserRole _parseUserRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'artist':
        return UserRole.artist;
      case 'moderator':
        return UserRole.moderator;
      case 'user':
      default:
        return UserRole.user;
    }
  }
}

enum UserRole {
  user,
  artist,
  moderator,
  admin,
}

class UserPreferences {
  final bool darkMode;
  final bool notifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final String language;
  final String currency;
  final String themeColor;

  UserPreferences({
    this.darkMode = false,
    this.notifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.language = 'ar',
    this.currency = '\$',
    this.themeColor = 'gold',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      darkMode: json['darkMode'] ?? false,
      notifications: json['notifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      language: json['language'] ?? 'ar',
      currency: json['currency'] ?? '\$',
      themeColor: json['themeColor'] ?? 'gold',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'notifications': notifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'language': language,
      'currency': currency,
      'themeColor': themeColor,
    };
  }
}

class PurchaseHistory {
  final String id;
  final String artworkId;
  final String artworkTitle;
  final double price;
  final String currency;
  final DateTime purchaseDate;
  final String status;
  final String transactionId;

  PurchaseHistory({
    required this.id,
    required this.artworkId,
    required this.artworkTitle,
    required this.price,
    required this.currency,
    required this.purchaseDate,
    required this.status,
    required this.transactionId,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      id: json['id'] ?? '',
      artworkId: json['artworkId'] ?? '',
      artworkTitle: json['artworkTitle'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? '\$',
      purchaseDate: DateTime.parse(json['purchaseDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'completed',
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artworkId': artworkId,
      'artworkTitle': artworkTitle,
      'price': price,
      'currency': currency,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
      'transactionId': transactionId,
    };
  }
}
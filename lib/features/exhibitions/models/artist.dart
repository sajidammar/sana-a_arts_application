class Artist {
  final String id;
  final String name;
  final String bio;
  final String specialization;
  final int yearsOfExperience;
  final String location;
  final String email;
  final String phone;
  final String website;
  final String profileImage;
  final List<String> socialMedia;
  final List<String> exhibitions;
  final List<String> artworks;
  final double rating;
  final int ratingCount;
  final int followers;
  final DateTime joinDate;
  final bool isVerified;

  Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialization,
    required this.yearsOfExperience,
    required this.location,
    required this.email,
    required this.phone,
    required this.website,
    required this.profileImage,
    this.socialMedia = const [],
    this.exhibitions = const [],
    this.artworks = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.followers = 0,
    required this.joinDate,
    this.isVerified = false,
  });

  String get formattedExperience {
    if (yearsOfExperience == 0) return 'مبتدئ';
    if (yearsOfExperience == 1) return 'سنة واحدة';
    if (yearsOfExperience == 2) return 'سنتين';
    if (yearsOfExperience <= 10) return '$yearsOfExperience سنوات';
    return 'أكثر من 10 سنوات';
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      specialization: json['specialization'] ?? '',
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      location: json['location'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      profileImage: json['profileImage'] ?? '',
      socialMedia: List<String>.from(json['socialMedia'] ?? []),
      exhibitions: List<String>.from(json['exhibitions'] ?? []),
      artworks: List<String>.from(json['artworks'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      followers: json['followers'] ?? 0,
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'specialization': specialization,
      'yearsOfExperience': yearsOfExperience,
      'location': location,
      'email': email,
      'phone': phone,
      'website': website,
      'profileImage': profileImage,
      'socialMedia': socialMedia,
      'exhibitions': exhibitions,
      'artworks': artworks,
      'rating': rating,
      'ratingCount': ratingCount,
      'followers': followers,
      'joinDate': joinDate.toIso8601String(),
      'isVerified': isVerified,
    };
  }
}


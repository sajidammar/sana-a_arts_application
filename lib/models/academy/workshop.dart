// models/workshop.dart
class Workshop {
  final int id;
  final String title;
  final String category;
  final String instructor;
  final String instructorId;
  final String description;
  final int duration;
  final int price;
  final int originalPrice;
  final int seats;
  final int enrolled;
  final String startDate;
  final String endDate;
  final String schedule;
  final String location;
  final String level;
  final String language;
  final String materials;
  final bool certificate;
  final double rating;
  final int reviews;
  final bool featured;
  final List<String> tags;
  final List<String> requirements;
  final List<String> learningOutcomes;

  final String image;

  const Workshop({
    required this.id,
    required this.title,
    required this.category,
    required this.instructor,
    required this.instructorId,
    required this.description,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.seats,
    required this.enrolled,
    required this.startDate,
    required this.endDate,
    required this.schedule,
    required this.location,
    required this.level,
    required this.language,
    required this.materials,
    required this.certificate,
    required this.rating,
    required this.reviews,
    required this.featured,
    required this.tags,
    required this.requirements,
    required this.learningOutcomes,
    required this.image,
  });

  double get progress => enrolled / seats;
  int get remainingSeats => seats - enrolled;
  int get discount => originalPrice > 0
      ? ((originalPrice - price) / originalPrice * 100).round()
      : 0;

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      instructor: json['instructor'],
      instructorId: json['instructorId'],
      description: json['description'],
      duration: json['duration'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      seats: json['seats'],
      enrolled: json['enrolled'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      schedule: json['schedule'],
      location: json['location'],
      level: json['level'],
      language: json['language'],
      materials: json['materials'],
      certificate: json['certificate'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      featured: json['featured'],
      tags: List<String>.from(json['tags']),
      requirements: List<String>.from(json['requirements']),
      learningOutcomes: List<String>.from(json['learningOutcomes']),
      image: json['image'] ?? 'assets/images/image1.jpg',
    );
  }

  void updateEnrollment(int i) {}
}

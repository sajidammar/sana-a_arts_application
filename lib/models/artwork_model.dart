class Artwork {
  final String id;
  final String title;
  final String artist;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DateTime createdAt;

  const Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
  });
}

class Exhibition {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;

  const Exhibition({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
  });
}

class Artist {
  final String id;
  final String name;
  final String bio;
  final String profileImage;
  final String specialty;

  const Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImage,
    required this.specialty,
  });
}
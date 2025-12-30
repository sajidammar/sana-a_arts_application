class UserModel {
  final String id;
  final String name;
  final String? imageUrl;
  String bio='فنان تشكيلي ومتخصص في الفنون التشكيلية المعاصرة.';


  UserModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

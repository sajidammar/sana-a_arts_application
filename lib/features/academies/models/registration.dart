// models/registration.dart
class Registration {
  final String id;
  final int workshopId;
  final String workshopTitle;
  final Map<String, dynamic> userData;
  final DateTime registrationDate;
  final String status;
  final String paymentStatus;

  const Registration({
    required this.id,
    required this.workshopId,
    required this.workshopTitle,
    required this.userData,
    required this.registrationDate,
    required this.status,
    required this.paymentStatus,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: json['id'],
      workshopId: json['workshopId'],
      workshopTitle: json['workshopTitle'],
      userData: Map<String, dynamic>.from(json['userData']),
      registrationDate: DateTime.parse(json['registrationDate']),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workshopId': workshopId,
      'workshopTitle': workshopTitle,
      'userData': userData,
      'registrationDate': registrationDate.toIso8601String(),
      'status': status,
      'paymentStatus': paymentStatus,
    };
  }
}


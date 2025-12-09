// models/instructor.dart
import 'package:flutter/material.dart';

class Instructor with ChangeNotifier {
  String id;
  String name;
  String title;
  String avatar;
  int experience;
  List<String> specialties;
  double rating;
  int reviews;
  int students;
  int workshops;
  String status;
  String imageUrl;
  String bio;
  List<String> education;
  List<String> achievements;

  Instructor({
    required this.id,
    required this.name,
    required this.title,
    required this.avatar,
    required this.experience,
    required this.specialties,
    required this.rating,
    required this.reviews,
    required this.students,
    required this.workshops,
    required this.status,
    required this.bio,
    required this.education,
    required this.achievements,
    required this.imageUrl,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      avatar: json['avatar'],
      experience: json['experience'],
      specialties: List<String>.from(json['specialties']),
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      students: json['students'],
      workshops: json['workshops'],
      status: json['status'],
      bio: json['bio'],

      education: List<String>.from(json['education']),
      achievements: List<String>.from(json['achievements']),
      imageUrl: json['imageUrl'] ?? 'assets/images/image2.jpg',
    );
  }
}

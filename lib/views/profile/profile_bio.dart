import 'package:flutter/material.dart';

class ProfileBio extends StatelessWidget {
  final String bio;
  const ProfileBio({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    if (bio.trim().isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding:const EdgeInsets.only(top: 8),
      child: Text(
        bio,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Colors.black,
          fontFamily: 'Tajawal',
        ),

      ),
      );
  }
}
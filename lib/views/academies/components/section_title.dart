import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const SectionTitle({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFFB8860B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Color(0xFF5D4E37)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

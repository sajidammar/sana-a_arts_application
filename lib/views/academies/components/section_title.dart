import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String description;
  final bool? isDark;

  const SectionTitle({
    super.key,
    required this.title,
    required this.description,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        isDark ?? Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
            fontFamily: 'Tajawal',
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
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey[400] : const Color(0xFF5D4E37),
            fontFamily: 'Tajawal',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

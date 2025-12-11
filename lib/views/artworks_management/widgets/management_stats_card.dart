import 'package:flutter/material.dart';

class ManagementStatsCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const ManagementStatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  State<ManagementStatsCard> createState() => _ManagementStatsCardState();
}

class _ManagementStatsCardState extends State<ManagementStatsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Colors
    final surfaceColor = widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryColor = const Color(0xFFB8860B);

    final textSecondary = widget.isDark
        ? Colors.grey[400]
        : const Color(0xFF5D4E37);
    final shadowColor = const Color(0xFF8B4513).withOpacity(0.1);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        constraints: const BoxConstraints(minWidth: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF8B4513).withOpacity(0.2)
                  : shadowColor,
              blurRadius: _isHovered ? 25 : 15,
              offset: _isHovered ? const Offset(0, 10) : const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                    Color(0xFF8B6914),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 28),
            ),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

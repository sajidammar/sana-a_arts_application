import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';


class AcademyPage extends StatefulWidget {
  const AcademyPage({Key? key}) : super(key: key);

  @override
  State<AcademyPage> createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: Text(
          'الأكاديمية',
          style: TextStyle(
            color: themeProvider.isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
          ),
        ),
        backgroundColor: themeProvider.isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        foregroundColor: themeProvider.isDarkMode
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
      ),
      body: Center(
        child: Text(
          "قيد التطوير",
          style: TextStyle(
            fontSize: 50,
            color: themeProvider.isDarkMode
                ? const Color(0xFFD4AF37)
                : Colors.red,
          ),
        ),
      ),
    );
  }
}
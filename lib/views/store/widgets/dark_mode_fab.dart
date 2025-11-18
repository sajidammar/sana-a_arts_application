import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../themes/store/theme_provider.dart';
import '../../../utils/store/app_constants.dart';



class DarkModeFAB extends StatelessWidget {
  const DarkModeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return FloatingActionButton(
      onPressed: () {
        themeProvider.toggleTheme(!isDark);
      },
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      elevation: 6,
      child: AnimatedSwitcher(
        duration: AppConstants.animationDuration,
        child: isDark
            ? Icon(Icons.light_mode, key: ValueKey('light'))
            : Icon(Icons.dark_mode, key: ValueKey('dark')),
      ),
    );
  }
}
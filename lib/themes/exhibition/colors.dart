import 'package:flutter/material.dart';

class AppColors {
  // ================== ألوان أساسية ==================

  // ألوان الوضع النهاري
  static const Color lightPrimary = Color(0xFFB8860B); // ذهبي داكن
  static const Color lightSecondary = Color(0xFF8B6914); // ذهبي أغمق
  static const Color lightBackground = Color(0xFFFDF6E3); // بيج فاتح
  static const Color lightCardBackground = Color(0xFFFFFFFF); // أبيض
  static const Color lightTextPrimary = Color(0xFF2C1810); // بني داكن
  static const Color lightTextSecondary = Color(0xFF6B5D52); // بني فاتح

  // ألوان الوضع الليلي
  static const Color darkPrimary = Color(0xFFD4AF37); // ذهبي فاتح
  static const Color darkSecondary = Color(0xFFB8860B); // ذهبي متوسط
  static const Color darkBackground = Color(0xFF121212); // أسود
  static const Color darkCardBackground = Color(0xFF1E1E1E); // رمادي داكن
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // أبيض
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // رمادي فاتح

  // ================== أسماء متوافقة مع الكود القديم ==================

  // ألوان رئيسية
  static const Color primaryColor = Color(0xFFB8860B);
  static const Color primaryDark = Color(0xFF8B6914);
  static const Color secondaryColor = Color(0xFFD4AF37);
  static const Color accentColor = Color(0xFFFFD700);

  // ألوان النص
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF6B5D52);

  // ألوان الخلفية
  static const Color backgroundMain = Color(0xFFFDF6E3);
  static const Color backgroundSecondary = Color(0xFFF5EDD8);

  // ألوان عامة
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // ================== تدرجات لونية ==================

  // تدرجات ذهبية للوضع النهاري
  static const LinearGradient lightGoldGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37), // ذهبي فاتح
      Color(0xFFB8860B), // ذهبي داكن
      Color(0xFF8B6914), // ذهبي أغمق
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرجات ذهبية للوضع الليلي
  static const LinearGradient darkGoldGradient = LinearGradient(
    colors: [
      Color(0xFFFFD700), // ذهبي ساطع
      Color(0xFFD4AF37), // ذهبي فاتح
      Color(0xFFB8860B), // ذهبي متوسط
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرج ذهبي عام
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرج VR للوضع النهاري
  static const LinearGradient lightVirtualGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37), // ذهبي فاتح
      Color(0xFFB8860B), // ذهبي داكن
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // تدرج VR للوضع الليلي
  static const LinearGradient darkVirtualGradient = LinearGradient(
    colors: [
      Color(0xFF2A2A2A), // رمادي داكن
      Color(0xFF1E1E1E), // أسود خفيف
      Color(0xFF121212), // أسود عميق
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // تدرج VR عام (متوافق مع الكود القديم)
  static const LinearGradient virtualGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // تدرجات إضافية (متوافقة مع الكود القديم)
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFF4500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient realityGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient openGradient = LinearGradient(
    colors: [Color(0xFF38ef7d), Color(0xFF11998e)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ================== دوال مساعدة ==================

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimary
        : lightPrimary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCardBackground
        : lightCardBackground;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static LinearGradient getGoldGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkGoldGradient
        : lightGoldGradient;
  }

  static LinearGradient getVirtualGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkVirtualGradient
        : lightVirtualGradient;
  }
}

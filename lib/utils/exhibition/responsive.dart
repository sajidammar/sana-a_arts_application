import 'package:flutter/widgets.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveValue(BuildContext context, 
      {required double mobile, double? tablet, required double desktop}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? (mobile + desktop) / 2;
    } else {
      return desktop;
    }
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  static double getPaddingValue(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  static double getFontSize(BuildContext context, 
      {required double mobile, double? tablet, required double desktop}) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

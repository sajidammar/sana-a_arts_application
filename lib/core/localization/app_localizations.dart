import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = {
    'ar': {
      'app_title': 'فنون صنعاء',
      'messages': 'الرسائل',
      'academy': 'الأكاديمية',
      'exhibitions': 'المعارض',
      'store': 'المتجر',
      'community': 'المجتمع',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'مظهر التطبيق',
      'dark_mode': 'الوضع الليلي',
      'light_mode': 'الوضع النهاري',
      'system_mode': 'تلقائي (النظام)',
      'logout': 'تسجيل الخروج',
      'about_us': 'من نحن',
      'contact_us': 'اتصل بنا',
      'share_app': 'مشاركة التطبيق',
      'help_support': 'المساعدة والدعم',
      'rate_app': 'تقييم التطبيق',
      'admin_panel': 'إدارة النظام',
      'notifications': 'الإشعارات',
      'privacy': 'الخصوصية',
      'order_history': 'طلباتي',
      'artworks_management': 'إدارة الأعمال الفنية',
      'my_exhibitions': 'معارضي',
      'certificates': 'الشهادات والإنجازات',
      'favorites': 'المفضلة',
      'account': 'الحساب',
      'app': 'التطبيق',
      'search': 'بحث...',
      'write_message': 'اكتب رسالتك...',
      'online_now': 'متصل الآن',
      'no_conversations': 'لا توجد محادثات مثيرة حتى الآن',
      'start_messaging': 'ابدأ مراسلة فنانيك المفضلين من بروفايلهم الشخصي',
      'filter': 'تصفية',
      'direct_chats': 'المحادثات المباشرة',
      'edit_profile': 'تعديل الملف الشخصي',
      'follow': 'متابعة',
      'following': 'متابَع',
      'message': 'رسالة',
      'view_cv': 'عرض السيرة الذاتية',
      'posts': 'منشورات',
      'followers': 'متابعين',
      'follows': 'أتابع',
      'send_first_message': 'أرسل أول رسالة...',
      'now': 'الآن',
      'day_short': 'ي',
      'hour_short': 'سا',
      'minute_short': 'د',
    },
    'en': {
      'app_title': 'Sana\'a Arts',
      'messages': 'Messages',
      'academy': 'Academy',
      'exhibitions': 'Exhibitions',
      'store': 'Store',
      'community': 'Community',
      'profile': 'Profile',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'App Appearance',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'system_mode': 'System Default',
      'logout': 'Logout',
      'about_us': 'About Us',
      'contact_us': 'Contact Us',
      'share_app': 'Share App',
      'help_support': 'Help & Support',
      'rate_app': 'Rate App',
      'admin_panel': 'Admin Panel',
      'notifications': 'Notifications',
      'privacy': 'Privacy',
      'order_history': 'My Orders',
      'artworks_management': 'Artwork Management',
      'my_exhibitions': 'My Exhibitions',
      'certificates': 'Certificates & Achievements',
      'favorites': 'Favorites',
      'account': 'Account',
      'app': 'Application',
      'search': 'Search...',
      'write_message': 'Type your message...',
      'online_now': 'Online Now',
      'no_conversations': 'No active conversations yet',
      'start_messaging':
          'Start messaging your favorite artists from their profiles',
      'filter': 'Filter',
      'direct_chats': 'Direct Chats',
      'edit_profile': 'Edit Profile',
      'follow': 'Follow',
      'following': 'Following',
      'message': 'Message',
      'view_cv': 'View CV',
      'posts': 'Posts',
      'followers': 'Followers',
      'follows': 'Following',
      'send_first_message': 'Send first message...',
      'now': 'Now',
      'day_short': 'd',
      'hour_short': 'h',
      'minute_short': 'm',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension to make it easier to use
extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}

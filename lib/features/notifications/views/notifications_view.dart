import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

// نموذج بيانات الإشعار
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final String type; // 'offer', 'support', 'general'
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // بيانات تجريبية للإشعارات
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'خصم خاص 50%',
      message:
          'احصل على خصم 50% على جميع اللوحات الزيتية. العرض ساري لمدة 24 ساعة فقط!',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      type: 'offer',
    ),
    NotificationItem(
      id: '2',
      title: 'مرحبًا بك في مجتمعنا',
      message: 'شكرًا لانضمامك إلى تطبيق سناء للفنون. نتمنى لك تجربة ممتعة!',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'general',
    ),
    NotificationItem(
      id: '3',
      title: 'تم الرد على استفسارك',
      message:
          'قام فريق الدعم بالرد على تذكرتك رقم #12345. يرجى التحقق من الرد.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: 'support',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'معرض جديد: ألوان الطيف',
      message:
          'لا تفوت فرصة زيارة أحدث معارضنا الافتراضية "ألوان الطيف" للفنان أحمد.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: 'general',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'شحن مجاني',
      message:
          'استمتع بشحن مجاني على طلبك القادم عند الشراء بقيمة 500 ريال أو أكثر.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      type: 'offer',
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final Color primaryColor = AppColors.getPrimaryColor(isDark);
    final Color backgroundColor = AppColors.getBackgroundColor(isDark);
    final Color cardColor = AppColors.getCardColor(isDark);
    final Color textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'مركز الإشعارات',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              foregroundColor: primaryColor,
              elevation: 0,
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: AppColors.getSubtextColor(
                  isDark,
                ).withValues(alpha: 0.6),
                indicatorColor: primaryColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'الكل'),
                  Tab(text: 'العروض'),
                  Tab(text: 'الدعم'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationList(
              _notifications,
              isDark,
              cardColor,
              textColor,
              primaryColor,
            ),
            _buildNotificationList(
              _notifications.where((n) => n.type == 'offer').toList(),
              isDark,
              cardColor,
              textColor,
              primaryColor,
            ),
            _buildNotificationList(
              _notifications.where((n) => n.type == 'support').toList(),
              isDark,
              cardColor,
              textColor,
              primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    List<NotificationItem> items,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color primaryColor,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.backgroundSecondary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 80,
                color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد إشعارات حالياً',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                color: AppColors.getSubtextColor(isDark),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isUnread = !item.isRead;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isUnread
                ? (isDark
                      ? primaryColor.withValues(alpha: 0.1)
                      : AppColors.backgroundSecondary)
                : cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black45
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isUnread
                  ? primaryColor.withValues(alpha: 0.3)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(item.type, primaryColor, isDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Text(
                              _formatTime(item.time),
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12,
                                color: AppColors.getSubtextColor(
                                  isDark,
                                ).withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.message,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            color: AppColors.getSubtextColor(isDark),
                            height: 1.5,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(String type, Color primaryColor, bool isDark) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'offer':
        iconData = Icons.local_offer;
        color = AppColors.accentColor;
        break;
      case 'support':
        iconData = Icons.support_agent;
        color = const Color(0xFF17A2B8);
        break;
      default:
        iconData = Icons.notifications;
        color = primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}





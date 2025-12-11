import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

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

    final Color primaryColor = isDark
        ? const Color(0xFFD4AF37)
        : const Color(0xFFB8860B);
    final Color backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFFDF6E3);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF2C1810);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'مركز الإشعارات',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              foregroundColor: primaryColor,
              elevation: 2,
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                labelStyle: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
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
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إشعارات حالياً',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: item.isRead
              ? cardColor
              : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFFF8E1)),
          elevation: item.isRead ? 1 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(item.type, primaryColor),
                const SizedBox(width: 12),
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
                                fontWeight: item.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(item.time),
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.message,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(String type, Color primaryColor) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'offer':
        iconData = Icons.local_offer;
        color = const Color(0xFFFF6B35); // برتقالي للعروض
        break;
      case 'support':
        iconData = Icons.support_agent;
        color = const Color(0xFF17A2B8); // أزرق سماوي للدعم
        break;
      default:
        iconData = Icons.notifications;
        color = primaryColor; // اللون الأساسي للعام
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
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

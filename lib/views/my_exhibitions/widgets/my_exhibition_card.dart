import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/app_colors.dart';
import '../my_exhibitions_view.dart'; // For ExhibitionStatus enum

class MyExhibitionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const MyExhibitionCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final surfaceColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final secondaryTextColor = AppColors.getSubtextColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                    child: Image.asset(
                      data['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Icon(
                        Icons.image,
                        size: 50,
                        color: secondaryTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(
                    context,
                    primaryColor,
                    textColor,
                    secondaryTextColor,
                    true,
                    isDark,
                  ),
                ),
              ],
            );
          } else {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      data['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: isDark ? Colors.grey[900] : Colors.grey[200],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: secondaryTextColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _buildContent(
                        context,
                        primaryColor,
                        textColor,
                        secondaryTextColor,
                        false,
                        isDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
    bool isMobile,
    bool isDark,
  ) {
    final status = data['status'] as ExhibitionStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Badge
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getStatusColor(status).withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              _getStatusLabel(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          data['title'],
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 16, color: secondaryTextColor),
            const SizedBox(width: 6),
            Text(
              data['location'],
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Dates Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.backgroundSecondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              if (status != ExhibitionStatus.draft) ...[
                _buildDateRow(
                  'تاريخ البداية:',
                  data['startDate'],
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildDateRow(
                  'تاريخ الانتهاء:',
                  data['endDate'],
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildDateRow(
                  status == ExhibitionStatus.completed
                      ? 'مدة المعرض:'
                      : 'متبقي:',
                  status == ExhibitionStatus.completed
                      ? data['duration']
                      : (data['remainingDays'] != null
                            ? '${data['remainingDays']} يوم'
                            : data['remainingTime']),
                  textColor,
                  secondaryTextColor,
                  isHighlight: true,
                  highlightColor: primaryColor,
                ),
              ] else ...[
                _buildDateRow(
                  'البداية المخططة:',
                  data['plannedStartDate'],
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildDateRow(
                  'حالة التحضير:',
                  '${(data['progress'] * 100).toInt()}%',
                  textColor,
                  secondaryTextColor,
                  isHighlight: true,
                  highlightColor: primaryColor,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMiniStat(
              'عمل معروض',
              '${data['preparedArtworks'] ?? data['artworksCount']}',
              primaryColor,
              secondaryTextColor,
            ),
            _buildMiniStat(
              'زائر',
              '${data['visitors']}',
              primaryColor,
              secondaryTextColor,
            ),
            _buildMiniStat(
              status == ExhibitionStatus.upcoming ? 'طلب حجز' : 'مباع',
              '${data['requests'] ?? data['soldCount']}',
              primaryColor,
              secondaryTextColor,
            ),
          ],
        ),

        const SizedBox(height: 24),
        // Actions
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _buildActions(context, status, isDark),
        ),
      ],
    );
  }

  Widget _buildDateRow(
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor, {
    bool isHighlight = false,
    Color? highlightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? (highlightColor ?? textColor) : textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    Color primaryColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ExhibitionStatus status) {
    switch (status) {
      case ExhibitionStatus.active:
        return const Color(0xFF28a745);
      case ExhibitionStatus.upcoming:
        return const Color(0xFF17a2b8);
      case ExhibitionStatus.completed:
        return AppColors.textPrimary;
      case ExhibitionStatus.draft:
        return const Color(0xFFffc107);
    }
  }

  String _getStatusLabel(ExhibitionStatus status) {
    switch (status) {
      case ExhibitionStatus.active:
        return 'معرض نشط';
      case ExhibitionStatus.upcoming:
        return 'معرض قادم';
      case ExhibitionStatus.completed:
        return 'معرض مكتمل';
      case ExhibitionStatus.draft:
        return 'مسودة';
    }
  }

  List<Widget> _buildActions(
    BuildContext context,
    ExhibitionStatus status,
    bool isDark,
  ) {
    List<Widget> actions = [
      _buildActionButton(
        context,
        'عرض',
        Icons.visibility,
        isDark,
        isPrimary: true,
      ),
    ];

    if (status == ExhibitionStatus.active ||
        status == ExhibitionStatus.upcoming) {
      actions.add(_buildActionButton(context, 'تعديل', Icons.edit, isDark));
      actions.add(
        _buildActionButton(
          context,
          'إضافة عمل',
          Icons.add,
          isDark,
          isSuccess: true,
        ),
      );
    }

    if (status == ExhibitionStatus.upcoming) {
      actions.add(
        _buildActionButton(
          context,
          'نشر',
          Icons.broadcast_on_personal,
          isDark,
          isWarning: true,
        ),
      );
    }

    if (status == ExhibitionStatus.completed) {
      actions.add(
        _buildActionButton(context, 'التقرير', Icons.bar_chart, isDark),
      );
      actions.add(_buildActionButton(context, 'تحميل', Icons.download, isDark));
    }

    if (status == ExhibitionStatus.draft) {
      actions.add(_buildActionButton(context, 'إكمال', Icons.edit, isDark));
      actions.add(
        _buildActionButton(
          context,
          'إضافة عمل',
          Icons.add,
          isDark,
          isSuccess: true,
        ),
      );
      actions.add(
        _buildActionButton(context, 'حفظ', Icons.save, isDark, isWarning: true),
      );
    }

    return actions;
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isDark, {
    bool isPrimary = false,
    bool isSuccess = false,
    bool isWarning = false,
  }) {
    Color? bgColor;
    Color? fgColor;
    Gradient? gradient;

    if (isPrimary) {
      gradient = AppColors.exhibitionGradient;
      fgColor = Colors.white;
    } else if (isSuccess) {
      bgColor = const Color(0xFF28a745);
      fgColor = Colors.white;
    } else if (isWarning) {
      bgColor = const Color(0xFFffc107);
      fgColor = Colors.white;
    } else {
      bgColor = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : AppColors.backgroundSecondary.withValues(alpha: 0.8);
      fgColor = AppColors.getTextColor(isDark);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: gradient != null
            ? [
                BoxShadow(
                  color: AppColors.exhibitionColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient != null ? Colors.transparent : bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

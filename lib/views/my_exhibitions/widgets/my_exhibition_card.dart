import 'package:flutter/material.dart';
import '../my_exhibitions_view.dart'; // For ExhibitionStatus enum

class MyExhibitionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const MyExhibitionCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);
    final secondaryTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF5D4E37);
    final primaryColor = const Color(0xFFB8860B);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.1),
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
                Container(
                  height: 200,
                  color: Colors.grey[300], // Image placeholder bg
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        Icon(Icons.image, size: 50, color: Colors.grey[600]),
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
                  ),
                ),
              ],
            );
          } else {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 300,
                    child: Image.asset(
                      data['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildContent(
                        context,
                        primaryColor,
                        textColor,
                        secondaryTextColor,
                        false,
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
    context,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
    bool isMobile,
  ) {
    final status = data['status'] as ExhibitionStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Badge
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusLabel(status),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          data['title'],
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 16, color: secondaryTextColor),
            const SizedBox(width: 5),
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

        const SizedBox(height: 20),

        // Dates Box
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5E6D3),
            borderRadius: BorderRadius.circular(10),
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
                const SizedBox(height: 5),
                _buildDateRow(
                  'تاريخ الانتهاء:',
                  data['endDate'],
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 5),
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
                ),
              ] else ...[
                _buildDateRow(
                  'البداية المخططة:',
                  data['plannedStartDate'],
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 5),
                _buildDateRow(
                  'حالة التحضير:',
                  '${(data['progress'] * 100).toInt()}%',
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

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

        const SizedBox(height: 20),
        // Actions
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildActions(context, status),
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: textColor,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
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
        return const Color(0xFF5D4E37); // secondary
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

  List<Widget> _buildActions(BuildContext context, ExhibitionStatus status) {
    List<Widget> actions = [
      _buildActionButton(context, 'عرض', Icons.visibility, isPrimary: true),
    ];

    if (status == ExhibitionStatus.active ||
        status == ExhibitionStatus.upcoming) {
      actions.add(_buildActionButton(context, 'تعديل', Icons.edit));
      actions.add(
        _buildActionButton(context, 'إضافة عمل', Icons.add, isSuccess: true),
      );
    }

    if (status == ExhibitionStatus.upcoming) {
      actions.add(
        _buildActionButton(
          context,
          'نشر',
          Icons.broadcast_on_personal,
          isWarning: true,
        ),
      );
    }

    if (status == ExhibitionStatus.completed) {
      actions.add(_buildActionButton(context, 'التقرير', Icons.bar_chart));
      actions.add(_buildActionButton(context, 'تحميل', Icons.download));
    }

    if (status == ExhibitionStatus.draft) {
      actions.add(_buildActionButton(context, 'إكمال', Icons.edit));
      actions.add(
        _buildActionButton(context, 'إضافة عمل', Icons.add, isSuccess: true),
      );
      actions.add(
        _buildActionButton(context, 'حفظ', Icons.save, isWarning: true),
      );
    }

    return actions;
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon, {
    bool isPrimary = false,
    bool isSuccess = false,
    bool isWarning = false,
  }) {
    Color bgColor;
    Color fgColor;

    if (isPrimary) {
      bgColor = const Color(0xFFFECFEF); // Gradient mock
      fgColor = const Color(
        0xFFB8860B,
      ); // Actually gradient usually has white text but let's stick to design
      // The CSS says primary is gradient. Let's use primary color for simplicity or gradient container
      bgColor = const Color(0xFFB8860B);
      fgColor = Colors.white;
    } else if (isSuccess) {
      bgColor = const Color(0xFF28a745);
      fgColor = Colors.white;
    } else if (isWarning) {
      bgColor = const Color(0xFFffc107);
      fgColor = Colors.white;
    } else {
      bgColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
      fgColor = isDark ? Colors.white : Colors.black87;
    }

    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

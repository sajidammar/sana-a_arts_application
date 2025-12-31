import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);

    return AlertDialog(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Text(
        'مشاركة المعرض',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'اختر منصة للمشاركة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareIcon(
                context,
                Icons.facebook,
                'Facebook',
                const Color(0xFF1877F2),
                textColor,
              ),
              _buildShareIcon(
                context,
                Icons.chat,
                'WhatsApp',
                const Color(0xFF25D366),
                textColor,
              ),
              _buildShareIcon(
                context,
                Icons.alternate_email,
                'Twitter',
                const Color(0xFF1DA1F2),
                textColor,
              ),
              _buildShareIcon(
                context,
                Icons.link,
                'نسخ الرابط',
                Colors.grey,
                textColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShareIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Color textColor,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تمت المشاركة عبر $label (محاكاة)',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Tajawal',
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';
import '../../../providers/theme_provider.dart';

class ManagementArtworkCard extends StatefulWidget {
  final String title;
  final String image;
  final int views;
  final int likes;
  final String date;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onView;

  const ManagementArtworkCard({
    super.key,
    required this.title,
    required this.image,
    required this.views,
    required this.likes,
    required this.date,
    required this.statusLabel,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onView,
  });

  @override
  State<ManagementArtworkCard> createState() => _ManagementArtworkCardState();
}

class _ManagementArtworkCardState extends State<ManagementArtworkCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final surfaceColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final textSecondary = AppColors.getSubtextColor(isDark);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: _isHovered
            ? Matrix4.translationValues(0, -10, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.secondaryColor.withValues(alpha: 0.2)
                  : AppColors.secondaryColor.withValues(alpha: 0.1),
              blurRadius: _isHovered ? 35 : 15,
              offset: _isHovered ? const Offset(0, 15) : const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.backgroundSecondary,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (_isHovered)
                    Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildOverlayBtn(Icons.visibility, widget.onView),
                          const SizedBox(width: 10),
                          _buildOverlayBtn(Icons.edit, widget.onEdit),
                          const SizedBox(width: 10),
                          _buildOverlayBtn(Icons.share, widget.onShare),
                          const SizedBox(width: 10),
                          _buildOverlayBtn(Icons.delete, widget.onDelete),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: widget.statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: widget.statusColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat(
                        Icons.remove_red_eye,
                        widget.views.toString(),
                        textSecondary,
                      ),
                      _buildStat(
                        Icons.favorite,
                        widget.likes.toString(),
                        textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons for mobile touch / non-hover
                  if (!_isHovered)
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionBtn(
                            'تعديل',
                            Icons.edit,
                            const Color(0xFF17a2b8),
                            const Color(0xFF17a2b8).withValues(alpha: 0.1),
                            widget.onEdit,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionBtn(
                            'حذف',
                            Icons.delete,
                            const Color(0xFFdc3545),
                            const Color(0xFFdc3545).withValues(alpha: 0.1),
                            widget.onDelete,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayBtn(IconData icon, VoidCallback onTap) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryColor, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, Color? color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: color, fontFamily: 'Tajawal'),
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    String label,
    IconData icon,
    Color color,
    Color bg,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


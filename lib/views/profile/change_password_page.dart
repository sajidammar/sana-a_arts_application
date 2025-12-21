import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../themes/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            foregroundColor: primaryColor,
            elevation: 0,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // رسالة تعليمات
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: textColor,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // كلمة المرور الحالية
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      label: 'كلمة المرور الحالية',
                      obscureText: _obscureCurrentPassword,
                      onToggleVisibility: () {
                        setState(
                          () => _obscureCurrentPassword =
                              !_obscureCurrentPassword,
                        );
                      },
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // كلمة المرور الجديدة
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: 'كلمة المرور الجديدة',
                      obscureText: _obscureNewPassword,
                      onToggleVisibility: () {
                        setState(
                          () => _obscureNewPassword = !_obscureNewPassword,
                        );
                      },
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // تأكيد كلمة المرور
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور',
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                      isDark: isDark,
                      primaryColor: primaryColor,
                      isConfirm: true,
                    ),
                    const SizedBox(height: 40),

                    // زر الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'تم تغيير كلمة المرور بنجاح',
                                  style: TextStyle(fontFamily: 'Tajawal'),
                                ),
                                backgroundColor: primaryColor,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: primaryColor.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'تغيير كلمة المرور',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isDark,
    required Color primaryColor,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'Tajawal',
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: AppColors.getSubtextColor(isDark),
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: primaryColor.withValues(alpha: 0.7),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.6),
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white10
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white12
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        if (value.length < 8) {
          return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
        }
        if (isConfirm && value != _newPasswordController.text) {
          return 'كلمة المرور غير متطابقة';
        }
        return null;
      },
    );
  }
}

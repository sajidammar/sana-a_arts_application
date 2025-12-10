import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

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

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text(
          'تغيير كلمة المرور',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // رسالة تعليمات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFFB8860B))
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: isDark
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFFB8860B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // كلمة المرور الحالية
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'كلمة المرور الحالية',
                obscureText: _obscureCurrentPassword,
                onToggleVisibility: () {
                  setState(
                    () => _obscureCurrentPassword = !_obscureCurrentPassword,
                  );
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // كلمة المرور الجديدة
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'كلمة المرور الجديدة',
                obscureText: _obscureNewPassword,
                onToggleVisibility: () {
                  setState(() => _obscureNewPassword = !_obscureNewPassword);
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // تأكيد كلمة المرور
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'تأكيد كلمة المرور',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
                isDark: isDark,
                isConfirm: true,
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تغيير كلمة المرور بنجاح'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFFB8860B),
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isDark,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'Tajawal',
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
            width: 2,
          ),
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

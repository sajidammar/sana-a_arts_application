import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'أحمد محمد');
  final _emailController = TextEditingController(text: 'ahmed@example.com');
  final _phoneController = TextEditingController(text: '+967 777 123 456');
  final _cityController = TextEditingController(text: 'صنعاء');
  final _bioController = TextEditingController(text: 'فنان تشكيلي');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _bioController.dispose();
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'تعديل الملف الشخصي',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            foregroundColor: isDark
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
            elevation: 2,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // صورة الملف الشخصي
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFFB8860B),
                              width: 3,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/image1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFFB8860B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // الاسم
                    _buildTextField(
                      controller: _nameController,
                      label: 'الاسم الكامل',
                      icon: Icons.person,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // البريد الإلكتروني
                    _buildTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email,
                      isDark: isDark,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // رقم الهاتف
                    _buildTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      icon: Icons.phone,
                      isDark: isDark,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // المدينة
                    _buildTextField(
                      controller: _cityController,
                      label: 'المدينة',
                      icon: Icons.location_on,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),

                    // النبذة
                    _buildTextField(
                      controller: _bioController,
                      label: 'النبذة الشخصية',
                      icon: Icons.description,
                      isDark: isDark,
                      maxLines: 3,
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
                                content: Text('تم حفظ التعديلات بنجاح'),
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
                          'حفظ التعديلات',
                          style: TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
          icon,
          color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
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
        return null;
      },
    );
  }
}

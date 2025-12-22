import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/providers/exhibition/auth_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/views/auth/login_page.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';

/// صفحة إضافة منشور جديد
class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  /// اختيار صورة من المعرض
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
      }
    }
  }

  /// التقاط صورة من الكاميرا
  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في التقاط الصورة: $e')));
      }
    }
  }

  /// إظهار خيارات الصورة
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text('إضافة صورة', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('اختيار من المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.green),
                ),
                title: const Text('التقاط صورة'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// نشر المنشور
  Future<void> _submitPost() async {
    // التحقق من المحتوى
    if (_contentController.text.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة محتوى أو صورة')),
      );
      return;
    }

    // التحقق من تسجيل الدخول
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      _showLoginRequired();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // إضافة المنشور
      await context.read<CommunityProvider>().addPost(
        _contentController.text,
        _selectedImage?.path, // مسار الصورة المختارة
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نشر المنشور بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في نشر المنشور: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// إظهار رسالة تسجيل الدخول
  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('يجب تسجيل الدخول لنشر منشور جديد'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('إضافة منشور'),
            backgroundColor: AppColors.getCardColor(isDark),
            foregroundColor: isDark ? Colors.white : Colors.black,
            elevation: 0,
            pinned: true,
            actions: [
              TextButton(
                onPressed: _isSubmitting ? null : _submitPost,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'نشر',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        backgroundImage:
                            authProvider.currentUser?.profileImage.isNotEmpty ==
                                true
                            ? AssetImage(authProvider.currentUser!.profileImage)
                            : null,
                        child:
                            authProvider.currentUser?.profileImage.isEmpty !=
                                false
                            ? Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.currentUser?.name ?? 'مستخدم',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(isDark),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _contentController,
                              maxLines: 5,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'بماذا تفكر؟',
                                hintStyle: TextStyle(
                                  color: AppColors.getSubtextColor(isDark),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // عرض الصورة المختارة
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  const Spacer(),
                  Divider(color: Colors.grey[300]),

                  // أزرار إضافة الوسائط
                  Row(
                    children: [
                      _MediaButton(
                        icon: Icons.photo_library,
                        label: 'معرض الصور',
                        color: Colors.green,
                        onTap: _pickImage,
                      ),
                      const SizedBox(width: 16),
                      _MediaButton(
                        icon: Icons.camera_alt,
                        label: 'الكاميرا',
                        color: Colors.blue,
                        onTap: _takePhoto,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// زر الوسائط
class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

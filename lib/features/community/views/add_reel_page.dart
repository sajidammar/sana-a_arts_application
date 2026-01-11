import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';
import 'package:sanaa_artl/features/community/views/video_trimmer_view.dart';
import 'package:sanaa_artl/core/services/storage_service.dart';
import 'package:sanaa_artl/core/services/connectivity_service.dart';
import 'package:sanaa_artl/core/services/notification_service.dart';
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';

class AddReelPage extends StatefulWidget {
  const AddReelPage({super.key});

  @override
  State<AddReelPage> createState() => _AddReelPageState();
}

class _AddReelPageState extends State<AddReelPage> {
  final _descriptionController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _urlController = TextEditingController();
  String? _selectedVideoPath;
  bool _isSubmitting = false;
  bool _isPickingVideo = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _authorNameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    // التأكد من الصلاحيات أولاً
    final statusProvider = Provider.of<AppStatusProvider>(
      context,
      listen: false,
    );
    final storageService = StorageService();
    bool hasPermission = await storageService.requestPermissions(
      statusProvider,
    );
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('نحتاج لصلاحية الوصول للملفات لاختيار فيديو'),
          ),
        );
      }
      return;
    }

    setState(() => _isPickingVideo = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        compressionQuality: 0,
      );

      if (result != null && result.files.single.path != null) {
        final videoPath = result.files.single.path!;
        final videoFile = File(videoPath);

        // التحقق من مدة الفيديو
        final controller = VideoPlayerController.file(videoFile);
        await controller.initialize();
        final duration = controller.value.duration;
        await controller.dispose();

        if (duration.inSeconds > 90) {
          if (mounted) {
            // توجيه المستخدم لصفحة القص تلقائياً إذا كان الفيديو طويلاً
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'الفيديو طويل جداً، سيتم توجيهك لقص 90 ثانية منه',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            );

            final trimmedPath = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => VideoTrimmerView(file: videoFile),
              ),
            );

            if (trimmedPath != null) {
              setState(() {
                _selectedVideoPath = trimmedPath;
                _urlController.clear();
              });
            }
          }
        } else {
          setState(() {
            _selectedVideoPath = videoPath;
            _urlController.clear();
          });
        }
      }
    } catch (e) {
      // If file_picker fails, try image_picker as fallback
      try {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
        if (video != null) {
          setState(() {
            _selectedVideoPath = video.path;
            _urlController.clear();
          });
        }
      } catch (e2) {
        // Fallback picker error
      }
    } finally {
      setState(() => _isPickingVideo = false);
    }
  }

  Future<void> _submit() async {
    final videoUrl = _urlController.text.trim();
    if (_descriptionController.text.isEmpty ||
        _authorNameController.text.isEmpty ||
        (_selectedVideoPath == null && videoUrl.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول واختيار فيديو')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String finalVideoUrl = '';

      if (_selectedVideoPath != null) {
        // حفظ الملف في المجلد المخصص SanaaArt Videos
        final storageService = StorageService();
        final savedFile = await storageService.saveMediaFile(
          File(_selectedVideoPath!),
          StorageService.videosFolder,
        );

        if (savedFile == null) {
          throw Exception('فشل في حفظ الفيديو في المجلد المخصص');
        }
        finalVideoUrl = savedFile.path;
      } else {
        finalVideoUrl = videoUrl;
      }

      final isOnline = await ConnectivityService().checkCurrentStatus();

      final newReel = Reel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        authorName: _authorNameController.text,
        authorAvatar: 'assets/images/sanaa_img_01.jpg',
        videoUrl: finalVideoUrl,
        description: _descriptionController.text,
        likes: 0,
        commentsCount: 0,
        views: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
        syncStatus: isOnline ? 'synced' : 'pending',
      );

      if (!isOnline) {
        // إشعار للمستخدم في حالة عدم وجود إنترنت
        await NotificationService().showNotification(
          id: 1,
          title: 'جاري الانتظار للاتصال',
          body: 'سيتم نشر الريلز تلقائياً عند الاتصال بالانترنت',
          isPersistent: true,
        );
      }

      if (mounted && context.mounted) {
        await Provider.of<ReelProvider>(
          context,
          listen: false,
        ).addReel(newReel);
      }

      if (mounted && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة الريلز بنجاح!')));
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في الإضافة: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        title: const Text(
          'إضافة ريلز جديد',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: AppColors.getCardColor(isDark),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              controller: _authorNameController,
              label: 'اسم المؤلف',
              icon: Icons.person,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            // قسم اختيار الفيديو
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _selectedVideoPath != null
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedVideoPath != null
                        ? Icons.check_circle
                        : Icons.video_library,
                    size: 50,
                    color: _selectedVideoPath != null
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedVideoPath != null
                        ? 'تم اختيار الفيديو بنجاح'
                        : 'اختر فيديو من جهازك',
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedVideoPath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        path.basename(_selectedVideoPath!),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _isPickingVideo ? null : _pickVideo,
                    icon: _isPickingVideo
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_a_photo, color: Colors.white),
                    label: Text(
                      _selectedVideoPath != null
                          ? 'تغيير الفيديو'
                          : 'اختيار فيديو',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'الحد الأقصى للمدة في الريلز: 90 ثانية',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (_selectedVideoPath != null) ...[
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final videoFile = File(_selectedVideoPath!);
                        final trimmedPath = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoTrimmerView(file: videoFile),
                          ),
                        );

                        if (trimmedPath != null) {
                          setState(() {
                            _selectedVideoPath = trimmedPath;
                          });
                        }
                      },
                      icon: const Icon(Icons.content_cut),
                      label: const Text(
                        'قص/تعديل المقطع',
                        style: TextStyle(fontFamily: 'Tajawal'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'أو أضف رابط فيديو مباشر:',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _urlController,
              label: 'رابط الفيديو (URL)',
              icon: Icons.link,
              isDark: isDark,
              hint: 'https://example.com/video.mp4',
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    _selectedVideoPath = null;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'الوصف',
              icon: Icons.description,
              isDark: isDark,
              maxLines: 3,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'نشر الريلز',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    int maxLines = 1,
    String? hint,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.getTextColor(isDark)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

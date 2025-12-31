import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';

class AddReelPage extends StatefulWidget {
  const AddReelPage({super.key});

  @override
  State<AddReelPage> createState() => _AddReelPageState();
}

class _AddReelPageState extends State<AddReelPage> {
  final _descriptionController = TextEditingController();
  final _authorNameController = TextEditingController();
  String? _selectedVideoPath;
  String? _videoUrl;
  bool _isSubmitting = false;
  bool _isPickingVideo = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _authorNameController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    setState(() => _isPickingVideo = true);
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        // التحقق من مدة الفيديو
        final controller = VideoPlayerController.file(File(video.path));
        await controller.initialize();
        final duration = controller.value.duration;
        await controller.dispose();

        if (duration.inSeconds > 90) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'عذراً، يجب ألا يتجاوز طول الريلز دقيقة ونصف (90 ثانية)',
                ),
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedVideoPath = video.path;
          _videoUrl = null; // نُفضل الملف المحلي
        });
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    } finally {
      setState(() => _isPickingVideo = false);
    }
  }

  Future<void> _submit() async {
    if (_descriptionController.text.isEmpty ||
        _authorNameController.text.isEmpty ||
        (_selectedVideoPath == null && _videoUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول واختيار فيديو')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String finalVideoUrl = '';

      if (_selectedVideoPath != null) {
        // حفظ الملف محلياً في مجلد التطبيق
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'reel_${DateTime.now().millisecondsSinceEpoch}${path.extension(_selectedVideoPath!)}';
        final savedFile = await File(
          _selectedVideoPath!,
        ).copy(path.join(directory.path, fileName));
        finalVideoUrl = savedFile.path;
      } else {
        finalVideoUrl = _videoUrl!;
      }

      final newReel = Reel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        authorName: _authorNameController.text,
        authorAvatar: 'assets/images/placeholder_avatar.jpg',
        videoUrl: finalVideoUrl,
        description: _descriptionController.text,
        likes: 0,
        commentsCount: 0,
        views: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [],
      );

      await Provider.of<ReelProvider>(context, listen: false).addReel(newReel);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة الريلز بنجاح!')));
      }
    } catch (e) {
      if (mounted) {
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
                    'الحد الأقصى للمدة: 90 ثانية',
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
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
              controller: TextEditingController(text: _videoUrl),
              label: 'رابط الفيديو (URL)',
              icon: Icons.link,
              isDark: isDark,
              hint: 'https://example.com/video.mp4',
              onChanged: (val) => _videoUrl = val,
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

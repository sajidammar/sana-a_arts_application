import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentController = TextEditingController();
  String? _selectedImage;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_contentController.text.isEmpty && _selectedImage == null) {
      return;
    }

    context.read<CommunityProvider>().addPost(
      _contentController.text,
      _selectedImage,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نشر المنشور بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text('إضافة منشور'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: Text(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/image7.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: 5,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'بماذا تفكر؟',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedImage != null)
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 15,
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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Simulating image selection
                    setState(() {
                      // Picking a random image from existing assets for demo
                      _selectedImage =
                          'assets/images/image${(DateTime.now().second % 6) + 1}.jpg';
                    });
                  },
                  icon: const Icon(Icons.image, color: Colors.green),
                ),
                const Text('صور/فيديو'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

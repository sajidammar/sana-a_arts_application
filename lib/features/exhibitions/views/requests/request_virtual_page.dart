import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/profile/views/user_editing.dart';

class RequestVirtualPage extends StatefulWidget {
  const RequestVirtualPage({super.key});

  @override
  State<RequestVirtualPage> createState() => _RequestVirtualPageState();
}

class _RequestVirtualPageState extends State<RequestVirtualPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _themeController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider1>().currentUser;
      final provider = context.read<ExhibitionProvider>();

      final newExhibition = Exhibition(
        id: 'virt_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        curator: user?.name ?? 'Unknown',
        type: ExhibitionType.virtual,
        status: 'قيد المراجعة',
        description: _descriptionController.text,
        date: 'قريباً',
        location: 'معرض افتراضي',
        artworksCount: 0,
        visitorsCount: 0,
        imageUrl: 'assets/images/image1.jpg', // Placeholder
        isFeatured: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        tags: ['افتراضي', _themeController.text],
        rating: 0,
        ratingCount: 0,
        isActive: true,
      );

      provider.addExhibition(newExhibition);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب المعرض الافتراضي بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(title: const Text('طلب معرض افتراضي')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المعرض',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف المعرض',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _themeController,
                decoration: const InputDecoration(
                  labelText: 'النمط الفني (مثال: تراثي، حديث)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getPrimaryColor(isDark),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



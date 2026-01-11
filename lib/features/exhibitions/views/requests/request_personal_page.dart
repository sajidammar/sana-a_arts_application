import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/auth/controllers/user_controller.dart';

class RequestPersonalPage extends StatefulWidget {
  const RequestPersonalPage({super.key});

  @override
  State<RequestPersonalPage> createState() => _RequestPersonalPageState();
}

class _RequestPersonalPageState extends State<RequestPersonalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _portfolioController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider>().currentUser;
      final provider = context.read<ExhibitionProvider>();

      final newExhibition = Exhibition(
        id: 'pers_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        curator: user?.name ?? 'Unknown',
        type: ExhibitionType.personal,
        status: 'قيد المراجعة',
        description:
            'معرض شخصي للفنان ${user?.name ?? ""}: ${_bioController.text}',
        date: 'قريباً',
        location: 'صالة العرض الرئيسية',
        artworksCount: 0,
        visitorsCount: 0,
        imageUrl: 'assets/images/image2.jpg',
        isFeatured: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 14)),
        tags: ['شخصي', 'فنون'],
        rating: 0,
        ratingCount: 0,
        isActive: true,
      );

      provider.addExhibition(newExhibition);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب المعرض الشخصي بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(title: const Text('طلب معرض شخصي')),
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
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'نبذة عن الفنان',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portfolioController,
                decoration: const InputDecoration(
                  labelText: 'رابط الأعمال السابقة (اختياري)',
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

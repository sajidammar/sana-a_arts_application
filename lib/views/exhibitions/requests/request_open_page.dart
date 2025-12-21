import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/user_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';

class RequestOpenPage extends StatefulWidget {
  const RequestOpenPage({super.key});

  @override
  State<RequestOpenPage> createState() => _RequestOpenPageState();
}

class _RequestOpenPageState extends State<RequestOpenPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController =
      TextEditingController(); // e.g., Photography, Painting
  final _countController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider>().currentUser;
      final provider = context.read<ExhibitionProvider>();

      final count = int.tryParse(_countController.text) ?? 5;

      final newExhibition = Exhibition(
        id: 'open_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        curator: user?.name ?? 'Unknown',
        type: ExhibitionType.open,
        status: 'قيد المراجعة',
        description: 'معرض مفتوح: ${_categoryController.text}',
        date: 'قريباً',
        location: 'الساحة المفتوحة',
        artworksCount: count,
        visitorsCount: 0,
        imageUrl: 'assets/images/image4.jpg',
        isFeatured: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        tags: ['مفتوح', _categoryController.text],
        rating: 0,
        ratingCount: 0,
        isActive: true,
      );

      provider.addExhibition(newExhibition);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب المعرض المفتوح بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(title: const Text('طلب معرض مفتوح')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المشاركة',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'التصنيف الفني',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(
                  labelText: 'عدد الأعمال المتوقعة',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
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

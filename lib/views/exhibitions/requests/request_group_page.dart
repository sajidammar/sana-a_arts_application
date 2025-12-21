import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/user_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';

class RequestGroupPage extends StatefulWidget {
  const RequestGroupPage({super.key});

  @override
  State<RequestGroupPage> createState() => _RequestGroupPageState();
}

class _RequestGroupPageState extends State<RequestGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _membersController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider>().currentUser;
      final provider = context.read<ExhibitionProvider>();

      final newExhibition = Exhibition(
        id: 'group_${DateTime.now().millisecondsSinceEpoch}',
        title: _groupNameController.text,
        curator: user?.name ?? 'Unknown',
        type: ExhibitionType.group,
        status: 'قيد المراجعة',
        description: _descriptionController.text,
        date: 'قريباً',
        location: 'قاعة المعارض الجماعية',
        artworksCount: 0,
        visitorsCount: 0,
        imageUrl: 'assets/images/image3.jpg',
        isFeatured: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 20)),
        tags: ['جماعي', 'تعاوني'],
        rating: 0,
        ratingCount: 0,
        isActive: true,
      );

      provider.addExhibition(newExhibition);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب المعرض الجماعي بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(title: const Text('طلب معرض جماعي')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المجموعة / المعرض',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _membersController,
                decoration: const InputDecoration(
                  labelText: 'أسماء الأعضاء المشاركين',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'رؤية المعرض الجماعي',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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

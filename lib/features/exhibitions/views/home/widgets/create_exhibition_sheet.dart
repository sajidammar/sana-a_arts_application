import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CreateExhibitionSheet extends StatefulWidget {
  final ExhibitionType type;
  const CreateExhibitionSheet({super.key, this.type = ExhibitionType.open});

  @override
  State<CreateExhibitionSheet> createState() => _CreateExhibitionSheetState();
}

class _CreateExhibitionSheetState extends State<CreateExhibitionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _curatorController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedImage = 'assets/images/image1.jpg';
  final List<String> _availableImages = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _curatorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ExhibitionProvider>(context, listen: false);

      final newExhibition = Exhibition(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        curator: _curatorController.text,
        type: widget.type,
        status: 'جديد',
        description: _descriptionController.text,
        date: 'مستمر',
        location: 'منصة رقمية',
        artworksCount: 0,
        visitorsCount: 0,
        imageUrl: _selectedImage,
        isFeatured: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        tags: ['جديد', 'مشارك', 'مفتوح'],
        rating: 0,
        ratingCount: 0,
        isActive: true,
      );

      provider.addExhibition(newExhibition);

      Navigator.pop(context); // Close sheet

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم رفع عملك وإنشاء المعرض بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundColor(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إنشاء ${widget.type.displayName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان المعرض/العمل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال العنوان' : null,
              ),
              const SizedBox(height: 16),

              // Curator Field
              TextFormField(
                controller: _curatorController,
                decoration: InputDecoration(
                  labelText: 'اسم الفنان/المنسق',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'وصف العمل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال الوصف' : null,
              ),
              const SizedBox(height: 16),

              // Image Selection (Mock)
              Text(
                'اختر صورة الغلاف',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableImages.length,
                  itemBuilder: (context, index) {
                    final image = _availableImages[index];
                    final isSelected = image == _selectedImage;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.getPrimaryColor(isDark),
                                  width: 3,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getPrimaryColor(isDark),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إنشاء المعرض',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}



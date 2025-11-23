// views/components/registration_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/registration_provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';

class RegistrationModal extends StatelessWidget {
  final int workshopId;
  final String workshopTitle;

  const RegistrationModal({
    super.key,
    required this.workshopId,
    required this.workshopTitle,
  });

  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    Provider.of<WorkshopProvider>(context);

    return GestureDetector(
      onTap: () => registrationProvider.closeRegistrationModal(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking on modal
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تسجيل في الورشة',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              workshopTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () =>
                                registrationProvider.closeRegistrationModal(),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: RegistrationForm(
                      workshopId: workshopId,
                      workshopTitle: workshopTitle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  final int workshopId;
  final String workshopTitle;

  const RegistrationForm({
    super.key,
    required this.workshopId,
    required this.workshopTitle,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    final workshopProvider = Provider.of<WorkshopProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name
          _buildFormField(
            controller: registrationProvider.getController('name'),
            label: 'الاسم الكامل *',
            validator: (value) =>
                registrationProvider.validateField('name', value!),
          ),
          const SizedBox(height: 16),

          // Email
          _buildFormField(
            controller: registrationProvider.getController('email'),
            label: 'البريد الإلكتروني *',
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                registrationProvider.validateField('email', value!),
          ),
          const SizedBox(height: 16),

          // Phone
          _buildFormField(
            controller: registrationProvider.getController('phone'),
            label: 'رقم الهاتف *',
            keyboardType: TextInputType.phone,
            validator: (value) =>
                registrationProvider.validateField('phone', value!),
          ),
          const SizedBox(height: 16),

          // Experience Level
          _buildDropdownField(
            controller: registrationProvider.getController('experience'),
            label: 'مستوى الخبرة',
            items: const [
              DropdownMenuItem(value: 'beginner', child: Text('مبتدئ')),
              DropdownMenuItem(value: 'intermediate', child: Text('متوسط')),
              DropdownMenuItem(value: 'advanced', child: Text('متقدم')),
            ],
          ),
          const SizedBox(height: 16),

          // Motivation
          _buildTextAreaField(
            controller: registrationProvider.getController('motivation'),
            label: 'لماذا تريد الانضمام لهذه الورشة؟',
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: registrationProvider.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await registrationProvider
                            .submitRegistration(workshopProvider);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم تسجيلك بنجاح في الورشة!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          registrationProvider.closeRegistrationModal();
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'حدث خطأ في التسجيل. يرجى المحاولة مرة أخرى.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: registrationProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'تأكيد التسجيل',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required List<DropdownMenuItem<String>> items,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      onChanged: (value) {
        controller.text = value ?? '';
      },
      items: items,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTextAreaField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

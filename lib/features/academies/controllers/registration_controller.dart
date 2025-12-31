// controllers/registration_controller.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/academies/models/registration.dart';
import 'package:sanaa_artl/core/utils/academy/validators.dart' show Validators;

class RegistrationController with ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _errors = {};
  bool _isLoading = false;

  Map<String, String> get errors => _errors;
  bool get isLoading => _isLoading;

  TextEditingController getController(String field) {
    if (!_controllers.containsKey(field)) {
      _controllers[field] = TextEditingController();
    }
    return _controllers[field]!;
  }

  String? validateField(String field, String value) {
    _errors.remove(field);
    
    if (value.isEmpty) {
      _errors[field] = 'هذا الحقل مطلوب';
      return _errors[field];
    }

    switch (field) {
      case 'email':
        if (!Validators.isValidEmail(value)) {
          _errors[field] = 'يرجى إدخال بريد إلكتروني صحيح';
        }
        break;
      case 'phone':
        if (!Validators.isValidPhone(value)) {
          _errors[field] = 'يرجى إدخال رقم هاتف صحيح (9 أرقام)';
        }
        break;
      case 'age':
        final age = int.tryParse(value);
        if (age == null || age < 16 || age > 65) {
          _errors[field] = 'العمر يجب أن يكون بين 16 و 65 سنة';
        }
        break;
    }

    notifyListeners();
    return _errors[field];
  }

  Future<bool> submitRegistration(int workshopId, String workshopTitle) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate all fields
      bool isValid = true;
      for (final field in ['name', 'email', 'phone', 'workshop_id']) {
        final controller = _controllers[field];
        if (controller != null) {
          final error = validateField(field, controller.text);
          if (error != null) isValid = false;
        }
      }

      if (!isValid) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create registration data
      final registrationData = {
        'name': _controllers['name']?.text ?? '',
        'email': _controllers['email']?.text ?? '',
        'phone': _controllers['phone']?.text ?? '',
        'experience': _controllers['experience']?.text ?? '',
        'motivation': _controllers['motivation']?.text ?? '',
      };

      // ignore: unused_local_variable
      final registration = Registration(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workshopId: workshopId,
        workshopTitle: workshopTitle,
        userData: registrationData,
        registrationDate: DateTime.now(),
        status: 'pending',
        paymentStatus: 'pending',
      );

      // Store registration (in a real app, this would be an API call)
      // WorkshopUtils.storage.set('registration_${registration.id}', registration);

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearForm() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
    _errors.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}



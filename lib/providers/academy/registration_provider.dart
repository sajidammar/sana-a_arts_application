// providers/registration_provider.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/utils/academy/validators.dart';

class RegistrationProvider with ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _errors = {};
  bool _isLoading = false;
  bool _isModalOpen = false;
  int? _selectedWorkshopId;
  String? _selectedWorkshopTitle;

  Map<String, String> get errors => _errors;
  bool get isLoading => _isLoading;
  bool get isModalOpen => _isModalOpen;
  int? get selectedWorkshopId => _selectedWorkshopId;
  String? get selectedWorkshopTitle => _selectedWorkshopTitle;

  TextEditingController getController(String field) {
    if (!_controllers.containsKey(field)) {
      _controllers[field] = TextEditingController();
      _controllers[field]!.addListener(() {
        validateField(field, _controllers[field]!.text);
      });
    }
    return _controllers[field]!;
  }

  String? validateField(String field, String value) {
    _errors.remove(field);
    
    if (value.isEmpty && field != 'motivation') {
      _errors[field] = 'هذا الحقل مطلوب';
      notifyListeners();
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

  void openRegistrationModal(int workshopId, String workshopTitle) {
    _selectedWorkshopId = workshopId;
    _selectedWorkshopTitle = workshopTitle;
    _isModalOpen = true;
    notifyListeners();
  }

  void closeRegistrationModal() {
    _isModalOpen = false;
    _selectedWorkshopId = null;
    _selectedWorkshopTitle = null;
    _errors.clear();
    notifyListeners();
  }

  Future<bool> submitRegistration(WorkshopProvider workshopProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate all required fields
      bool isValid = true;
      for (final field in ['name', 'email', 'phone']) {
        final controller = _controllers[field];
        if (controller != null) {
          final error = validateField(field, controller.text);
          if (error != null) isValid = false;
        } else {
          _errors[field] = 'هذا الحقل مطلوب';
          isValid = false;
        }
      }

      if (!isValid) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (_selectedWorkshopId == null) {
        throw Exception('لم يتم تحديد ورشة');
      }

      // Register for workshop
      await workshopProvider.registerForWorkshop(
        _selectedWorkshopId!,
        {
          'name': _controllers['name']?.text ?? '',
          'email': _controllers['email']?.text ?? '',
          'phone': _controllers['phone']?.text ?? '',
          'experience': _controllers['experience']?.text ?? '',
          'motivation': _controllers['motivation']?.text ?? '',
        },
      );

      _isLoading = false;
      clearForm();
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
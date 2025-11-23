// utils/validators.dart
class Validators {
  static final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp phoneRegex = RegExp(r'^[0-9]{9}$');

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return phoneRegex.hasMatch(phone);
  }

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    final monthDiff = now.month - birthDate.month;
    
    if (monthDiff < 0 || (monthDiff == 0 && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
}
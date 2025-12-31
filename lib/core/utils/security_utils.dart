import 'dart:convert';


class SecurityUtils {
  // تشفير البيانات البسيطة
  static String encryptData(String data) {
    final bytes = utf8.encode(data + _getSecretKey());
    return base64.encode(bytes);
  }

  static String decryptData(String encryptedData) {
    try {
      final bytes = base64.decode(encryptedData);
      final decrypted = utf8.decode(bytes);
      return decrypted.replaceAll(_getSecretKey(), '');
    } catch (e) {
      throw Exception('Failed to decrypt data');
    }
  }

  // إنشاء هاش آمن للبيانات
  // static String generateHash(String data) {
  //   final bytes = utf8.encode(data);
  //   return sha256.convert(bytes).toString();
  // }

  // التحقق من صحة البيانات
  // static bool validateData(String data, String hash) {
  //   return generateHash(data) == hash;
  // }

  static String _getSecretKey() {
    return 'sanaa_arts_secret_2024';
  }

  // تنظيف البيانات من الأحرف الخطرة
  static String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>{}]'), '');
  }
}


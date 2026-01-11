import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

class EmailOrPhoneInput extends StatefulWidget {
  const EmailOrPhoneInput({super.key});

  @override
  State<EmailOrPhoneInput> createState() => _EmailOrPhoneInputState();
}

class _EmailOrPhoneInputState extends State<EmailOrPhoneInput> {
  late TextEditingController controller;
  String selectedCountryCode = '+967'; // رمز الدولة الافتراضي (اليمن)
  bool showCountryCodePicker = false;
  String inputText = '';
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // تحقق من البريد الإلكتروني باستخدام Regex بسيط
  bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  // تحقق إذا الإدخال هو رقم هاتف (يبدأ برقم أو +)
  bool isPhoneNumberInput(String input) {
    return input.isNotEmpty && RegExp(r'^[0-9\+]').hasMatch(input[0]);
  }

  // تحقق رقم الهاتف: أرقام فقط، غير فارغ
  bool isValidPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^\d{6,15}$'); // يسمح من 6 إلى 15 رقم
    return phoneRegex.hasMatch(input);
  }

  void onInputChanged(String input) {
    setState(() {
      inputText = input;

      if (isPhoneNumberInput(input)) {
        showCountryCodePicker = true;
      } else {
        showCountryCodePicker = false;
      }
    });
  }

  void onSendCodePressed() {
    if (showCountryCodePicker) {
      // رقم هاتف
      String phoneNumber = inputText.replaceAll(
        RegExp(r'\D'),
        '',
      ); // إزالة أي شيء غير رقم

      if (!isValidPhoneNumber(phoneNumber)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ'),
            content: Text('الرجاء إدخال رقم هاتف صحيح مكون من 6 إلى 15 رقم.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('حسناً'),
              ),
            ],
          ),
        );
        return;
      }

      String fullPhone = selectedCountryCode + phoneNumber;
      // هنا يمكنك إرسال رمز التحقق إلى fullPhone

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال رمز التحقق إلى الهاتف $fullPhone')),
      );
    } else {
      // بريد إلكتروني
      if (!isValidEmail(inputText)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ'),
            content: Text('الرجاء إدخال بريد إلكتروني صحيح.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('حسناً'),
              ),
            ],
          ),
        );
        return;
      }

      // هنا يمكنك إرسال رمز التحقق إلى البريد الإلكتروني
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال رمز التحقق إلى البريد الإلكتروني $inputText'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // نحدد الـ inputFormatters حسب نوع الإدخال الحالي
    List<TextInputFormatter> currentInputFormatters = [];
    TextInputType keyboardType = TextInputType.emailAddress;
    if (showCountryCodePicker) {
      currentInputFormatters = [FilteringTextInputFormatter.digitsOnly];
      keyboardType = TextInputType.number;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                if (showCountryCodePicker)
                  CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        selectedCountryCode = country.dialCode ?? '+967';
                      });
                    },
                    initialSelection: 'YE',
                    favorite: ['+967', 'EG', 'SA'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو رقم الهاتف',
                      hintText: showCountryCodePicker
                          ? 'أدخل رقم الهاتف'
                          : 'أدخل البريد الإلكتروني',
                    ),
                    keyboardType: keyboardType,
                    inputFormatters: currentInputFormatters,
                    onChanged: onInputChanged,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSendCodePressed,
              child: Text('إرسال رمز التحقق'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupLogic {
  // التحقق من الاسم الرباعي
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "ادخل اسمك الرباعي ";
    }
    RegExp nameReq = RegExp(r"([A-Za-z\u0600-\u06FF]{2,}\s*){4}");
    if (!nameReq.hasMatch(value.trim())) {
      return "الاسم قصير";
    }
    return null;
  }

  // التحقق من الإيميل
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty)
      return 'الرجاء إدخال البريد الإلكتروني.';
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$",
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صحيح.';
    }
    return null;
  }

  // التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Invalid Password";
    final n = RegExp(r"^[\d\w_]");
    if (!n.hasMatch(value)) return "Weak Password";
    if (value.length < 10) return "The Passwore is Short";
    return null;
  }

  // رسالة التنبيه الافتراضية
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class LoginValidators {
  // التحقق من رقم الهاتف
  static String? validatePhone(dynamic ph) {
    if (ph == null || ph.number.isEmpty) {
      return "الرجاء ادخل رقم الهاتف";
    }
    return null;
  }

  // التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور غير صالحة";
    }
    final n = RegExp(r"^[\d\w_]");
    if (!n.hasMatch(value)) {
      return "كلمة المرور ضعيفة";
    }
    if (value.length < 8) {
      return "كلمة المرور قصيرة";
    }
    return null;
  }
}

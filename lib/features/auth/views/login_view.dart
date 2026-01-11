import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../views/signup_view.dart';
import '../utils/auth_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController password_1;
  late TextEditingController numberphone;
  int _phNum = 0;

  final GlobalKey<FormState> kForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    password_1 = TextEditingController();
  }

  @override
  void dispose() {
    password_1.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الموجة العليا
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 235,
              color: Colors.orange.shade700,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40,
                child: Image.asset("photo/sh2.jpg"),
              ),
            ),
          ),

          // الموجة السفلى
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 230,
                color: Colors.orange.shade700,
                alignment: Alignment.center,
                child: Text("00000000000"),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: kForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 80),
                      ),
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // حقل رقم الهاتف
                      _buildLabel("رقم الهاتف"),
                      const SizedBox(height: 5),
                      IntlPhoneField(
                        decoration: _buildInputDecoration(
                          "Enter Number Phone",
                          "7xxxxxxxx",
                          Icons.phone,
                        ),
                        initialCountryCode: "YE",
                        languageCode: "ar",
                        onChanged: (ph) {
                          _phNum = int.parse(ph.completeNumber);
                        },
                        validator: LoginValidators
                            .validatePhone, // تم الربط بـ kk.dart
                      ),
                      const SizedBox(height: 15),

                      // حقل كلمة المرور
                      _buildLabel("كلمة المرور"),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: password_1,
                        obscureText: true,
                        validator: LoginValidators
                            .validatePassword, // تم الربط بـ kk.dart
                        decoration: _buildInputDecoration(
                          "Enter Password",
                          "",
                          Icons.lock,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // زر تسجيل الدخول
                      _buildButton("دخول", () {
                        if (kForm.currentState!.validate()) {
                          log("Phone: $_phNum");
                          log("Password: ${password_1.text}");
                        }
                      }),
                      const SizedBox(height: 15),

                      // نص التحويل لإنشاء الحساب
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Don’t Have An Account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "إنشاء حساب",
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupView(),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------- رسم الموجة العلوية --------
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// -------- رسم الموجة السفلية --------
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _buildLabel(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

InputDecoration _buildInputDecoration(
  String label,
  String hint,
  IconData icon,
) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    labelText: label,
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );
}

Widget _buildButton(String title, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

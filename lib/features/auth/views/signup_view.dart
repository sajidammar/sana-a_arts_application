import '../controllers/provieder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import './conformity_code_view.dart';
import '../controllers/email_controller.dart';
import '../utils/auth_handler.dart';
import '../utils/privacy_policy_screen.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final kForm = GlobalKey<FormState>(); // ✅ هنا المفتاح ثابت ولا يتغير
  late TextEditingController nameFo;
  late TextEditingController password_1;
  late TextEditingController numberphone;
  late TextEditingController password_2;
  late TextEditingController email;

  bool isChecked = false;
  int _phNum = 0;
  String country = "";
  String? selectedOption;
  final List<String> options = ['واتشاب', 'Email'];

  @override
  void initState() {
    super.initState();
    nameFo = TextEditingController();
    password_1 = TextEditingController();
    numberphone = TextEditingController();
    password_2 = TextEditingController();
    email = TextEditingController();
  }

  @override
  void dispose() {
    nameFo.dispose();
    password_1.dispose();
    numberphone.dispose();
    password_2.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: const Text(
              "إنشاء الحساب",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.nightlight_round)),
          ],
        ),
        body: Stack(
          children: [
            ClipPath(
              clipper: TopWaveClipper(),
              child: Container(height: 200, color: Colors.orange.shade700),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(height: 200, color: Colors.orange.shade700),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 80),
                        ),

                        Text(
                          "تسجيل جديد",
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // الاسم
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "الاسم",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: nameFo,
                          inputFormatters: [
                            FilteringTextInputFormatter(
                              RegExp(r"[a-zA-Z\u0600-\u06FF\s]"),
                              allow: true,
                            ),
                          ],
                          validator: SignupLogic
                              .validateFullName, // استخدام المنطق الخارجي
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: "ادخل اسمك الرباعي",
                            labelText: " ادخل اسمك الرباعي",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // رقم الهاتف
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "رقم الهاتف",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: "ادخل رقم الهاتف",
                            hintText: "7xxxxxxxx",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          initialCountryCode: "YE",
                          languageCode: "ar",
                          onChanged: (ph) {
                            _phNum = int.parse(ph.completeNumber);
                            country = ph.toString();
                          },
                        ),
                        const SizedBox(height: 15),

                        // الايميل
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "الايميل",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: email,
                          validator: SignupLogic
                              .validateEmail, // استخدام المنطق الخارجي
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "ادخل الايميل",
                            labelText: " ادخل الايميل",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // كلمة المرور
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "كلمة المرور",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: password_1,
                          validator: SignupLogic
                              .validatePassword, // استخدام المنطق الخارجي
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Enter The Password",
                            labelText: "**********",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "اعد كلمة المرور",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: password_2,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "اعد ادخال كلمة المرور",
                            labelText: "**********",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // طريقة التحقق
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "طريقة التحقق المفضلة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 2,
                          runSpacing: 8,
                          children: options.map((option) {
                            final bool isSelected = option == selectedOption;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = option;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.orange.shade400
                                      : Colors.orange.shade200,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: isSelected
                                          ? Colors.black45
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // مربع الشروط
                        Row(
                          children: [
                            Consumer<CheckboxProvider>(
                              builder: (context, checkboxProvider, child) {
                                return Checkbox(
                                  value: checkboxProvider.isChecked,
                                  onChanged: (bool? value) {
                                    // هذا سيحدث فقط المطلوب ... ... وليس الصفحة بالكامل
                                    checkboxProvider.setChecked(value ?? false);
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 26,
                              width: 270,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'انت توافق على  ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: 'السياسات والخصوصية',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  // const TermsPag(),
                                                  PrivacyPolicyScreen(),
                                            ),
                                          ).then((agreed) {
                                            if (agreed == true &&
                                                context.mounted) {
                                              // استخدام Provider بدلاً من setState
                                              Provider.of<CheckboxProvider>(
                                                context,
                                                listen: false,
                                              ).setChecked(true);
                                            }
                                          });
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // زر التسجيل
                        Consumer<CheckboxProvider>(
                          builder: (context, checkboxProvider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: checkboxProvider.isChecked
                                    ? () {
                                        if (kForm.currentState!.validate()) {
                                          if (selectedOption != null) {
                                            if (password_1.text ==
                                                password_2.text) {
                                              String sendco = sendCode();
                                              List<dynamic> allData = [
                                                selectedOption.toString(),
                                                nameFo.text,
                                                password_1.text,
                                                email.text,
                                                _phNum,
                                                sendco,
                                              ];

                                              if (selectedOption == "Email") {
                                                SignupLogic.showMessage(
                                                  context,
                                                  "جاري الإرسال للإيميل...",
                                                );
                                                sendSimpleEmail(
                                                  email.text,
                                                  sendco,
                                                );
                                              } else {
                                                SignupLogic.showMessage(
                                                  context,
                                                  "جاري الإرسال للواتساب...",
                                                );
                                                sendWhatsAppMessage(
                                                  _phNum.toString(),
                                                  sendco,
                                                );
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConformityCodeView(
                                                        allData: allData,
                                                      ),
                                                ),
                                              );
                                            } else {
                                              SignupLogic.showMessage(
                                                context,
                                                "كلمات المرور لا تتطابق",
                                              );
                                            }
                                          } else {
                                            SignupLogic.showMessage(
                                              context,
                                              "الرجاء اختيار طريقة التحقق",
                                            );
                                          }
                                        }
                                      }
                                    : null,
                                child: const Text(
                                  "Sign UP",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

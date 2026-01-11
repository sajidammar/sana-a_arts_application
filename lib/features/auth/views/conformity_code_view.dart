import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/email_controller.dart'; // تم تعديل المسار
import './login_view.dart'; // تم تعديل المسار

class ConformityCodeView extends StatefulWidget {
  final List<dynamic> allData;

  const ConformityCodeView({super.key, required this.allData});

  @override
  State<ConformityCodeView> createState() => _ConformityCodeViewState();
}

class _ConformityCodeViewState extends State<ConformityCodeView> {
  // ---------الاسم كامل---------
  // ---------------كلمة المرور--------------
  late TextEditingController password_1;

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
    final kForm = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Stack(
          children: [
            // الموجة العليا
            ClipPath(
              clipper: TopWaveClipper(),
              child: Container(height: 250, color: Colors.orange.shade700),
            ),

            // الموجة السفلى
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(height: 200, color: Colors.orange.shade700),
              ),
            ),

            // المحتوى في المنتصف
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 330,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            "أدخل الرمز الذي أرسل إلى:\n${widget.allData[3]}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                        // ---------- الرقم ------------
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "ادخل رمز التحقق",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter(
                              RegExp(r"[0-9]"),
                              allow: true,
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "كلمة المرور غير صالحة";
                            }
                            return null;
                          },
                          enableInteractiveSelection: false,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: password_1,
                          // textDirection:TextDirecton.rtl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: "ادخل كلمة المرور",
                            labelText: "**********",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // -------- كلمة المرور --------

                        // -------- زر تسجيل الدخول --------
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // --------------ما يخز في قاعدة البايانات

                              // تنفيذ العملية عند المو فقة

                              if (password_1.text == widget.allData[5]) {
                                //////يحول مباشرة الى التطبيق
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("الرمز صحيح"),
                                    behavior: SnackBarBehavior
                                        .floating, // لجعلها تظهر بشكل أجمل (عائمة)
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "الرمز غير صحيح، أو اضغط على إعادة الإرسال للحصول على رمز جديد",
                                    ),
                                    behavior: SnackBarBehavior
                                        .floating, // لجعلها تظهر بشكل أجمل (عائمة)
                                  ),
                                );
                              }
                            },

                            child: const Text(
                              "تأكيد",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // -------- النص السفلي --------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.allData[0] == "Email") {
                                  setState(() {
                                    widget.allData[5] = sendCode();
                                  });

                                  sendSimpleEmail(
                                    widget.allData[3],
                                    widget.allData[5],
                                  );
                                } else {
                                  setState(() {
                                    widget.allData[5] = sendCode();
                                  });
                                  sendWhatsAppMessage(
                                    widget.allData[3],
                                    widget.allData[5],
                                  );
                                }
                              },
                              icon: Icon(Icons.autorenew),
                            ),
                            Text(
                              "اعد ارسال الرمز",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade700,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_forward),
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
      ),
    );
  }
}

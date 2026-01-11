import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// import 'package:libphonenumber_plugin/libphonenumber_plugin.dart';

// 1. تعريف الدالة
Future<String?> sendSimpleEmail(String em, String pas) async {
  //  إعداد
  final smtpServer = gmail('djbr168@gmail.com', 'ikptlrtstcpmkacn');
  //^^هذالبريد الاكتروني يغير ال مايحوي متغير pass
  // 3. إنشاء رسالة البريد
  final message = Message()
    ..from = const Address('h733116738@gmail.com', 'ملاحظة...')
    ..recipients.add(em)
    ..text = "the messag is /\n$pas";
  try {
    await send(message, smtpServer);
    return null;
  } on MailerException {
    return "error check netwok..........";
  } catch (e) {
    return e.toString();
  }
}

Future<void> sendWhatsAppMessage(String number, String cod) async {
  final url = Uri.parse('https://wasenderapi.com/api/send-message');
  final headers = {
    //ارسال الكود اس ام اس
    //ولتحقق من رقم الهاتف
    'Authorization':
        'Bearer f512e6dd9117e50751b13f8c7b0e7cdc7c97732f3b4df87c8d7c5577acc84562',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    'to': '+$number', // ضع رقم المستلم هنا بصيغة دولية
    'text': '$codرمز التحقق الخاص بك في تطبيق فنون صنعاء',
  });
  await http.post(url, headers: headers, body: body);
}
// قائمة الخيارات التي سنحوّل كل منها إلى زر

sendCode() {
  final String code2 = (1000000 + Random().nextInt(9000000)).toString();
  return code2;
}

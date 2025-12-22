import 'package:flutter/material.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'مشاركة المعرض',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Tajawal'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'اختر منصة للمشاركة',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareIcon(context, Icons.facebook, 'Facebook', Colors.blue),
              _buildShareIcon(context, Icons.chat, 'WhatsApp', Colors.green),
              _buildShareIcon(
                context,
                Icons.alternate_email,
                'Twitter',
                Colors.lightBlue,
              ),
              _buildShareIcon(context, Icons.link, 'نسخ الرابط', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تمت المشاركة عبر $label (محاكاة)')),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }
}

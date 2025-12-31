import 'package:flutter/material.dart';
import 'package:sanaa_artl/management/themes/management_colors.dart';

class ExhibitionManagementView extends StatelessWidget {
  final bool isDark;
  const ExhibitionManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatBanner(),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                color: ManagementColors.getCard(isDark),
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.palette, color: Colors.amber),
                      title: Text(
                        'معرض فنون تهامة #$index',
                        style: TextStyle(
                          color: ManagementColors.getText(isDark),
                        ),
                      ),
                      subtitle: const Text('الحالة: نشط - الزوار: 450'),
                      trailing: const Icon(Icons.more_horiz),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(
          'إنشاء معرض جديد',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: ManagementColors.getPrimary(isDark),
      ),
    );
  }

  Widget _buildStatBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'معارض نشطة', value: '12'),
          _StatItem(label: 'إجمالي الزوار', value: '1.2k'),
          _StatItem(label: 'طلبات الانضمام', value: '3'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
        ),
      ],
    );
  }
}




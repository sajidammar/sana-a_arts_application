import 'package:flutter/material.dart';
import '../../controllers/global_management_controller.dart';
import '../../themes/management_colors.dart';

class UsersManagementView extends StatefulWidget {
  final bool isDark;
  const UsersManagementView({super.key, required this.isDark});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  final GlobalManagementController _controller = GlobalManagementController();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _controller.getAllUsers();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  color: ManagementColors.getCard(widget.isDark),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                      user['name'] ?? 'بدون اسم',
                      style: TextStyle(
                        color: ManagementColors.getText(widget.isDark),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    subtitle: Text(
                      user['email'] ?? '',
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user['role'] ?? 'user',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

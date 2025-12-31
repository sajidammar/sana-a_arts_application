import 'package:flutter/material.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:provider/provider.dart';

class UsersManagementView extends StatefulWidget {
  final bool isDark;
  const UsersManagementView({super.key, required this.isDark});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final users = adminProvider.users;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: adminProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.getPrimaryColor(isDark),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.getCardColor(isDark),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.getPrimaryColor(
                        isDark,
                      ).withValues(alpha: 0.05),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.getPrimaryColor(
                        isDark,
                      ).withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        color: AppColors.getPrimaryColor(isDark),
                      ),
                    ),
                    title: Text(
                      user['name'] ?? 'بدون اسم',
                      style: TextStyle(
                        color: AppColors.getTextColor(isDark),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      user['email'] ?? '',
                      style: TextStyle(
                        color: AppColors.getSubtextColor(isDark),
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryColor(
                              isDark,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (user['role'] ?? 'user').toUpperCase(),
                            style: TextStyle(
                              color: AppColors.getPrimaryColor(isDark),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

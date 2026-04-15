import 'package:flutter/material.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/app_language.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../data/repositories/auth_repository.dart';
import '../../app/route_names.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final appLanguge = AppLanguge.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguge.get('settingsTitle')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLanguge.get('theme'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButton<ThemeMode>(
              value: controller.themeMode,
              isExpanded: true,
              onChanged: controller.updateThemeMode,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(appLanguge.get('systemTheme')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(appLanguge.get('lightTheme')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(appLanguge.get('darkTheme')),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              appLanguge.get('language'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButton<Locale>(
              value: controller.locale,
              isExpanded: true,
              onChanged: controller.updateLocale,
              items: [
                DropdownMenuItem(
                  value: const Locale('vi'),
                  child: Text(appLanguge.get('vietnamese')),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(appLanguge.get('english')),
                ),
              ],
            ),
            const Spacer(),
            AuthPrimaryButton(
              text: appLanguge.get('logout'),
              onPressed: () async {
                try {
                  final authRepository = AuthRepository();
                  await authRepository.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.login,
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi đăng xuất: $e')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

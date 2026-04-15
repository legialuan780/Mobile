import 'package:Mobile/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/app_language.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final appLanguge = AppLanguge.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguge.get('homeTitle')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.settings);
            },
            icon: const Icon(Icons.settings),
            tooltip: appLanguge.get('settingsTitle'),
          ),
          IconButton(
            onPressed: () async {
              try {
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
            icon: const Icon(Icons.logout),
            tooltip: appLanguge.get('logout'),
          ),
        ],
      ),
      body: Center(
        child: Text(appLanguge.get('loginSuccess')),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'controllers/settings_controller.dart';

late final SettingsController settingsController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();
  settingsController = SettingsController(prefs);
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
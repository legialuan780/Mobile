import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._prefs) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _syncFromFirestore(user.uid);
      }
    });
  }

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Locale _locale = const Locale('vi');
  Locale get locale => _locale;

  Future<void> loadSettings() async {
    final themeStr = _prefs.getString('themeMode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeStr,
      orElse: () => ThemeMode.system,
    );

    final langStr = _prefs.getString('language') ?? 'vi';
    _locale = Locale(langStr);

    notifyListeners();
  }

  Future<void> _syncFromFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        bool changed = false;

        if (data.containsKey('themeMode')) {
          final themeStr = data['themeMode'] as String;
          final theme = ThemeMode.values.firstWhere(
            (e) => e.name == themeStr,
            orElse: () => ThemeMode.system,
          );
          if (_themeMode != theme) {
            _themeMode = theme;
            _prefs.setString('themeMode', theme.name);
            changed = true;
          }
        }

        if (data.containsKey('language')) {
          final langStr = data['language'] as String;
          final loc = Locale(langStr);
          if (_locale != loc) {
            _locale = loc;
            _prefs.setString('language', loc.languageCode);
            changed = true;
          }
        }

        if (changed) notifyListeners();
      }
    } catch (e) {
      debugPrint('Sync settings error: $e');
    }
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _prefs.setString('themeMode', newThemeMode.name);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'themeMode': newThemeMode.name,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Update theme firestore error: $e');
      }
    }
  }

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;
    if (newLocale == _locale) return;

    _locale = newLocale;
    notifyListeners();
    await _prefs.setString('language', newLocale.languageCode);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'language': newLocale.languageCode,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Update language firestore error: $e');
      }
    }
  }
}

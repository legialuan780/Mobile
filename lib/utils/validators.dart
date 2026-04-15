import 'app_language.dart';

class Validators {
  static String? validateEmailOrUsername(String? value, AppLanguge appLanguge) {
    if (value == null || value.trim().isEmpty) {
      return appLanguge.get('val_email_username_empty');
    }

    if (!value.contains('@')) {
      if (value.trim().length < 6) {
        return appLanguge.get('val_username_length');
      }
      return null;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return appLanguge.get('val_email_invalid');
    }

    return null;
  }

  static String? validateEmail(String? value, AppLanguge appLanguge) {
    if (value == null || value.trim().isEmpty) {
      return appLanguge.get('val_email_empty');
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return appLanguge.get('val_email_invalid');
    }

    return null;
  }

  static String? validatePassword(String? value, AppLanguge appLanguge) {
    if (value == null || value.isEmpty) {
      return appLanguge.get('val_password_empty');
    }

    if (value.length < 6) {
      return appLanguge.get('val_password_length');
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialCharacters = RegExp(r'[^a-zA-Z0-9]').hasMatch(value);

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return appLanguge.get('val_password_complexity');
    }

    return null;
  }

  static String? validateUsername(String? value, AppLanguge appLanguge) {
    if (value == null || value.trim().isEmpty) {
      return appLanguge.get('val_username_empty');
    }
    if (value.trim().length < 6) {
      return appLanguge.get('val_username_length');
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password, AppLanguge appLanguge) {
    if (value == null || value.isEmpty) {
      return appLanguge.get('val_confirm_password_empty');
    }

    if (value != password) {
      return appLanguge.get('val_password_mismatch');
    }

    return null;
  }

  static String? validateFullName(String? value, AppLanguge appLanguge){
    if (value == null || value.isEmpty){
      return appLanguge.get('val_fullname_empty');
    }
    return null;
  }
}

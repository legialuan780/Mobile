import 'package:flutter/material.dart';

class AppLanguge {
  AppLanguge(this.locale);

  final Locale locale;

  static AppLanguge? of(BuildContext context) {
    return Localizations.of<AppLanguge>(context, AppLanguge);
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'settingsTitle': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'homeTitle': 'Home',
      'logout': 'Logout',
      'loginSuccess': 'Login successfully',
      'login': 'Login',
      'loginSubtitle': 'Enter your email and password to continue',
      'usernameOrEmail': 'Username or Email',
      'password': 'Password',
      'forgotPasswordPrompt': 'Forgot password?',
      'orContinueWith': 'Or continue with',
      'noAccountPrompt': 'Don\'t have an account? ',
      'registerNow': 'Register now',
      'google': 'Google',
      'facebook': 'Facebook',
      'registerInfo': 'Fill the information below to register',
      'fullName': 'Full Name',
      'username': 'Username',
      'email': 'Email',
      'confirmPassword': 'Confirm Password',
      'register': 'Register',
      'alreadyHaveAccount': 'Already have an account? ',
      'forgotPasswordTitle': 'Forgot Password?',
      'forgotPasswordSubtitle': 'Enter the email associated with your account to receive a reset link.',
      'enterYourEmail': 'Enter your email',
      'sendLink': 'Send Link',
      'backToLogin': 'Back to Login',
      'facebookNotDeveloped': 'Facebook login is in development',
      
      'val_email_username_empty': 'Please enter username or email',
      'val_username_length': 'Username must be at least 6 characters',
      'val_email_invalid': 'Invalid email format',
      'val_email_empty': 'Please enter your email',
      'val_password_empty': 'Please enter your password',
      'val_password_length': 'Password must be at least 6 characters',
      'val_password_complexity': 'Password must contain uppercase, lowercase, numbers, and special chars',
      'val_username_empty': 'Please enter your username',
      'val_confirm_password_empty': 'Please confirm your password',
      'val_password_mismatch': 'Passwords do not match',
      'val_fullname_empty': 'Full name cannot be empty',
    },
    'vi': {
      'settingsTitle': 'Cài đặt',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'lightTheme': 'Sáng',
      'darkTheme': 'Tối',
      'systemTheme': 'Hệ thống',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'homeTitle': 'Trang chủ',
      'logout': 'Đăng xuất',
      'loginSuccess': 'Đăng nhập thành công',
      'login': 'Đăng nhập',
      'loginSubtitle': 'Nhập email và mật khẩu của bạn để tiếp tục',
      'usernameOrEmail': 'Tên đăng nhập hoặc Email',
      'password': 'Mật khẩu',
      'forgotPasswordPrompt': 'Quên mật khẩu?',
      'orContinueWith': 'Hoặc tiếp tục với',
      'noAccountPrompt': 'Chưa có tài khoản? ',
      'registerNow': 'Đăng ký ngay',
      'google': 'Google',
      'facebook': 'Facebook',
      'registerInfo': 'Điền thông tin dưới đây để đăng ký',
      'fullName': 'Họ và tên',
      'username': 'Tên đăng nhập',
      'email': 'Email',
      'confirmPassword': 'Nhập lại mật khẩu',
      'register': 'Đăng ký',
      'alreadyHaveAccount': 'Đã có tài khoản? ',
      'forgotPasswordTitle': 'Quên mật khẩu?',
      'forgotPasswordSubtitle': 'Hãy nhập email liên kết với tài khoản của bạn để nhận liên kết đặt lại mật khẩu.',
      'enterYourEmail': 'Nhập email của bạn',
      'sendLink': 'Gửi liên kết',
      'backToLogin': 'Quay lại trang đăng nhập',
      'facebookNotDeveloped': 'Đăng nhập Facebook đang được phát triển',
      
      'val_email_username_empty': 'Vui lòng nhập tên đăng nhập hoặc email',
      'val_username_length': 'Tên đăng nhập phải từ 6 ký tự',
      'val_email_invalid': 'Email không hợp lệ',
      'val_email_empty': 'Vui lòng nhập email',
      'val_password_empty': 'Vui lòng nhập mật khẩu',
      'val_password_length': 'Mật khẩu phải từ 6 ký tự',
      'val_password_complexity': 'Mật khẩu phải chứa chữ hoa, thường, số và ký tự đặc biệt',
      'val_username_empty': 'Vui lòng nhập tên đăng nhập',
      'val_confirm_password_empty': 'Vui lòng nhập lại mật khẩu',
      'val_password_mismatch': 'Mật khẩu xác nhận không khớp',
      'val_fullname_empty': 'Họ tên không được để trống',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class AppLangugeDelegate extends LocalizationsDelegate<AppLanguge> {
  const AppLangugeDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLanguge> load(Locale locale) async => AppLanguge(locale);

  @override
  bool shouldReload(AppLangugeDelegate old) => false;
}

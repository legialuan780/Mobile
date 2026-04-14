class Validators {
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên đăng nhập hoặc email';
    }

    if (!value.contains('@')) {
      if (value.trim().length < 6) {
        return 'Tên đăng nhập phải từ 6 ký tự';
      }
      return null;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải từ 6 ký tự';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialCharacters = RegExp(r'[^a-zA-Z0-9]').hasMatch(value);

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return 'Mật khẩu phải chứa chữ hoa, thường, số và ký tự đặc biệt';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    if (value.trim().length < 6) {
      return 'Tên đăng nhập phải từ 6 ký tự';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }

    if (value != password) {
      return 'Mật khẩu xác nhận không khớp';
    }

    return null;
  }

  static String? validateFullName(String? value){
    if (value == null || value.isEmpty){
      return 'Họ tên không được để trống';
    }
    return null;
  }
}
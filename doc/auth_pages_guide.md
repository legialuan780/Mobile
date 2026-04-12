# Hướng dẫn tạo giao diện Đăng ký và Quên mật khẩu

Để giữ sự đồng nhất với giao diện Đăng nhập (với phong cách sáng sủa, basic giống mẫu), tôi đã thiết
kế trước mã nguồn cho hai màn hình **Đăng ký** và **Quên mật khẩu**.
Hệ thống tận dụng lại các widget đã được trích xuất như `AuthTextField`, `AuthPrimaryButton`,
`SocialLoginButton`.

Bạn chỉ cần tạo file mới hoặc copy và ghi đè vào các file tương ứng trong thư mục `lib/views/auth/`.

---

## 1. Màn hình Đăng ký (`lib/views/auth/register_view.dart`)

```dart
import 'package:Mobile/services/auth_service.dart';
import 'package:Mobile/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/snackbars.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_primary_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      AppSnackbars.showSuccess(
        context,
        'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.',
      );

      Navigator.pushReplacementNamed(context, RouteNames.login);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AppSnackbars.showError(context, _firebaseErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      AppSnackbars.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email này đã được sử dụng.';
      case 'weak-password':
        return 'Mật khẩu quá yếu.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      default:
        return e.message ?? 'Đăng ký thất bại.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 80,
                      color: const Color(0xFF0062FF).withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Điền thông tin dưới đây để đăng ký',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          hint: 'Họ và tên',
                          icon: Icons.badge_outlined,
                          validator: (val) =>
                          val != null && val.isEmpty
                              ? 'Vui lòng nhập họ tên'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _emailController,
                          hint: 'Email',
                          icon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          hint: 'Mật khẩu',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: Validators.validatePassword,
                        ),

                        const SizedBox(height: 32),

                        AuthPrimaryButton(
                          text: 'Đăng ký',
                          isLoading: _isLoading,
                          onPressed: _register,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Đã có tài khoản? ',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Color(0xFF0062FF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 2. Màn hình Quên mật khẩu (`lib/views/auth/forgot_password_view.dart`)

```dart
import 'package:Mobile/services/auth_service.dart';
import 'package:Mobile/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/snackbars.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_primary_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(_emailController.text.trim());

      if (!mounted) return;

      AppSnackbars.showSuccess(
        context,
        'Email lấy lại mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư.',
      );

      Navigator.pop(context); // Quay lại trang đăng nhập
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AppSnackbars.showError(context, e.message ?? 'Đã có lỗi xảy ra.');
    } catch (e) {
      if (!mounted) return;
      AppSnackbars.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.lock_reset_outlined,
                      size: 80,
                      color: const Color(0xFF0062FF).withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đừng lo lắng. Hãy nhập email liên kết với tài khoản của bạn để nhận liên kết đặt lại mật khẩu.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _emailController,
                          hint: 'Nhập email của bạn',
                          icon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                        ),

                        const SizedBox(height: 32),

                        AuthPrimaryButton(
                          text: 'Gửi liên kết',
                          isLoading: _isLoading,
                          onPressed: _resetPassword,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Nhớ mật khẩu rồi? ',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: Color(0xFF0062FF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

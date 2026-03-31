import 'package:Mobile/services/auth_service.dart';
import 'package:Mobile/utils/validator.dart';
import 'package:Mobile/widgets/auth/google_sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/snackbars.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (!user.emailVerified) {
        AppSnackbars.showError(
          context,
          'Email chưa được xác minh. Vui lòng kiểm tra email.',
        );
        return;
      }

      Navigator.pushReplacementNamed(context, RouteNames.home);
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

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await _authService.loginWithGoogle();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.home);
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
      case 'user-not-found':
        return 'Không tìm thấy tài khoản.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'too-many-requests':
        return 'Thao tác quá nhiều lần. Thử lại sau.';
      default:
        return e.message ?? 'Đăng nhập thất bại.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Mật khẩu',
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Đăng nhập',
                onPressed: _login,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 12),
              GoogleSignInButton(
                onPressed: _loginWithGoogle,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.forgotPassword);
                },
                child: const Text('Quên mật khẩu?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.register);
                },
                child: const Text('Chưa có tài khoản? Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
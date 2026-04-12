import 'package:Mobile/services/auth_service.dart';
import 'package:Mobile/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/snackbars.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../widgets/auth/social_login_button.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  Container(
                    height: 160,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.devices_outlined,
                      size: 100,
                      color: const Color(0xFF0062FF).withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhập email và mật khẩu của bạn để tiếp tục',
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
                          hint: 'Tên đăng nhập hoặc Email',
                          icon: Icons.person_outline,
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
                        
                        const SizedBox(height: 4),
                        
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, RouteNames.forgotPassword),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0062FF),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        AuthPrimaryButton(
                          text: 'Đăng nhập',
                          isLoading: _isLoading,
                          onPressed: _login,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Hoặc tiếp tục với',
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Social Login Buttons
                        Row(
                          children: [
                            SocialLoginButton(
                              text: 'Google',
                              iconPath: 'google',
                              isLoading: _isLoading,
                              onPressed: _loginWithGoogle,
                            ),
                            const SizedBox(width: 16),
                            SocialLoginButton(
                              text: 'Facebook',
                              iconPath: 'facebook',
                              isLoading: _isLoading,
                              onPressed: () {
                                AppSnackbars.showError(context, 'Đăng nhập Facebook đang được phát triển');
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Bottom Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Chưa có tài khoản? ',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, RouteNames.register),
                              child: const Text(
                                'Đăng ký ngay',
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
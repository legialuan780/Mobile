import 'package:Mobile/data/repositories/auth_repository.dart';
import 'package:Mobile/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/snackbars.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../widgets/auth/social_login_button.dart';
import '../../utils/app_language.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();

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
      final user = await _authRepository.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

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

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await _authRepository.loginWithGoogle();
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
    final appLanguge = AppLanguge.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                      color: colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    appLanguge.get('login'),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appLanguge.get('loginSubtitle'),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
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
                          hint: appLanguge.get('usernameOrEmail'),
                          icon: Icons.person_outline,
                          validator: (val) => Validators.validateEmailOrUsername(val, appLanguge),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          hint: appLanguge.get('password'),
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (val) => Validators.validatePassword(val, appLanguge),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, RouteNames.forgotPassword),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              appLanguge.get('forgotPasswordPrompt'),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        AuthPrimaryButton(
                          text: appLanguge.get('login'),
                          isLoading: _isLoading,
                          onPressed: _login,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Row(
                          children: [
                            Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                appLanguge.get('orContinueWith'),
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Row(
                          children: [
                            SocialLoginButton(
                              text: appLanguge.get('google'),
                              iconPath: 'google',
                              isLoading: _isLoading,
                              onPressed: _loginWithGoogle,
                            ),
                            const SizedBox(width: 16),
                            SocialLoginButton(
                              text: appLanguge.get('facebook'),
                              iconPath: 'facebook',
                              isLoading: _isLoading,
                              onPressed: () {
                                AppSnackbars.showError(context, appLanguge.get('facebookNotDeveloped'));
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              appLanguge.get('noAccountPrompt'),
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, RouteNames.register),
                              child: Text(
                                appLanguge.get('registerNow'),
                                style: TextStyle(
                                  color: colorScheme.primary,
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

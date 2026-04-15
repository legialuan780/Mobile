import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/data/repositories/auth_repository.dart';
import 'package:Mobile/utils/snackbars.dart';
import 'package:Mobile/utils/validators.dart';
import 'package:Mobile/widgets/auth/auth_primary_button.dart';
import 'package:Mobile/widgets/auth/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/app_language.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authRepository.register(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      AppSnackbars.showSuccess(
        context,
        'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản', // We can translate this fully in app_localizations if needed
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
        return 'Email đã được sử dụng.';
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
    final appLanguge = AppLanguge.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      color: colorScheme.primary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    appLanguge.get('registerInfo'),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          hint: appLanguge.get('fullName'),
                          icon: Icons.badge_outlined,
                          validator: (val) => Validators.validateFullName(val, appLanguge),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _usernameController,
                          hint: appLanguge.get('username'),
                          icon: Icons.person_outline,
                          validator: (val) => Validators.validateUsername(val, appLanguge),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _emailController,
                          hint: appLanguge.get('email'),
                          icon: Icons.email_outlined,
                          validator: (val) => Validators.validateEmail(val, appLanguge),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          hint: appLanguge.get('password'),
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (val) => Validators.validatePassword(val, appLanguge),
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          hint: appLanguge.get('confirmPassword'),
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text, appLanguge),
                        ),
                        const SizedBox(height: 24),
                        AuthPrimaryButton(
                          text: appLanguge.get('register'),
                          isLoading: _isLoading,
                          onPressed: _register,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              appLanguge.get('alreadyHaveAccount'),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                appLanguge.get('login'),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
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

import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/services/auth_service.dart';
import 'package:Mobile/utils/snackbars.dart';
import 'package:Mobile/utils/validator.dart';
import 'package:Mobile/widgets/auth/auth_primary_button.dart';
import 'package:Mobile/widgets/auth/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

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
    //kiem tra form hop le
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      AppSnackbars.showSuccess(
        context,
        'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản',
      );

      Navigator.pushReplacementNamed(context, RouteNames.login);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AppSnackbars.showError(context, _firebaseErrorMessage(e));
    } catch (e) {
      //Bắt các loại lỗi "lạ" khác (mất mạng, lỗi logic code...).
      if (!mounted) return;
      AppSnackbars.showError(context, e.toString());
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
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      alignment:Alignment.center,
                      child: Icon(
                        Icons.person_add_alt_1_outlined,
                        size:80,
                        color: (Colors.blueAccent).withOpacity(0.8),
                      ),
                    ),

                    SizedBox(height: 24,),

                    Text(
                      'Điền thông tin dưới đây để đăng ký',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32,),

                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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

                          SizedBox(height: 16,),

                          AuthTextField(
                            controller: _usernameController,
                            hint: 'Tên đăng nhập',
                            icon: Icons.person_outline,
                            validator: Validators.validateUsername,
                          ),

                          SizedBox(height: 16,),

                          AuthTextField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            validator: Validators.validateEmail,
                          ),

                          SizedBox(height: 16,),

                          AuthTextField(
                            controller: _passwordController,
                            hint: 'Mật khẩu',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: Validators.validatePassword,
                          ),

                          SizedBox(height: 16,),

                          AuthTextField(
                            controller: _confirmPasswordController,
                            hint: 'Nhập lại mật khẩu',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text),
                          ),

                          SizedBox(height: 24,),

                          AuthPrimaryButton(
                              text: 'Đăng ký',
                              isLoading: _isLoading,
                              onPressed: _register
                          ),

                          SizedBox(height: 24,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đã có tài khoản?',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 14,
                                ),
                              ),

                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    color: Colors.blue,
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

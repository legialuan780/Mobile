import 'package:Mobile/data/repositories/auth_repository.dart';
import 'package:Mobile/utils/snackbars.dart';
import 'package:Mobile/utils/validators.dart';
import 'package:Mobile/widgets/auth/auth_primary_button.dart';
import 'package:Mobile/widgets/auth/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget{
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>{
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _forgotPassword() async{
    if (!_formKey.currentState!.validate()) return ;

    setState(() => _isLoading = true);

    try{
      await _authRepository.forgotPassword(email: _emailController.text.trim());

      if (!mounted) return;

      AppSnackbars.showSuccess(context, 'Email lấy lại mật khẩu đã gửi. Vui lòng kiểm tra hộp thư.');

      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      if (!mounted) return ;
      AppSnackbars.showError(context, e.message ?? 'Đã có lỗi xảy ra.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //     onPressed: () => Navigator.pop(context),
        //     icon: Icon(Icons.arrow_back_ios, color: Colors.black45,),
        // ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.lock_reset_outlined,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                  ),

                  SizedBox(height: 24,),

                  Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize:28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 8,),

                  Text(
                    'Hãy nhập email liên kết với tài khoản của bạn để nhận liên kết đặt lại mật khẩu.',
                    style: TextStyle(
                      fontSize:14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32,),

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

                        SizedBox(height: 32,),

                        AuthPrimaryButton(
                            text: 'Gửi liên kết',
                            isLoading: _isLoading,
                            onPressed: _forgotPassword,
                        ),

                        SizedBox(height: 24,),

                        GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Text(
                            'Quay lại trang đăng nhập',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,

                            ),
                          ),
                        ),

                        SizedBox(height: 64,),
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
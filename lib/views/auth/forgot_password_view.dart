// import 'package:Mobile/services/auth_service.dart';
// import 'package:Mobile/utils/validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../utils/snackbars.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_text_field.dart';
//
// class ForgotPasswordView extends StatefulWidget {
//   const ForgotPasswordView({super.key});
//
//   @override
//   State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
// }
//
// class _ForgotPasswordViewState extends State<ForgotPasswordView> {
//   final _formKey = GlobalKey<FormState>();
//   final _authService = AuthService();
//   final _emailController = TextEditingController();
//
//   bool _isLoading = false;
//
//   Future<void> _sendResetEmail() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       await _authService.forgotPassword(_emailController.text.trim());
//
//       if (!mounted) return;
//       AppSnackbars.showSuccess(
//         context,
//         'Đã gửi email đặt lại mật khẩu.',
//       );
//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return;
//       AppSnackbars.showError(context, _firebaseErrorMessage(e));
//     } catch (e) {
//       if (!mounted) return;
//       AppSnackbars.showError(context, e.toString());
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   String _firebaseErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'user-not-found':
//         return 'Không tìm thấy email này.';
//       case 'invalid-email':
//         return 'Email không hợp lệ.';
//       default:
//         return e.message ?? 'Gửi email thất bại.';
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quên mật khẩu')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator: Validators.validateEmail,
//               ),
//               const SizedBox(height: 16),
//               CustomButton(
//                 text: 'Gửi email đặt lại mật khẩu',
//                 onPressed: _sendResetEmail,
//                 isLoading: _isLoading,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
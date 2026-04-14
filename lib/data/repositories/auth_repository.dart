import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  AppUser? get currentUser {
    final user = _authService.currentFirebaseUser;
    if (user == null) return null;
    return _mapFirebaseUserToAppUser(user);
  }

  Stream<AppUser?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return _mapFirebaseUserToAppUser(user);
    });
  }

  Future<AppUser> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        throw Exception('Tên đăng nhập đã tồn tại.');
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Bỏ qua nếu chưa cấu hình rules Firestore
        print('Firestore permission denied: unable to check username uniqueness');
      } else {
        rethrow;
      }
    }

    final credential = await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng ký thất bại.');
    }

    await _authService.updateDisplayName(name: name);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'username': username,
        'email': email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Firestore permission denied: unable to save user doc');
      } else {
        rethrow;
      }
    }
    
    await _authService.reloadCurrentUser();

    //gửi mã xác nhận
    // await _authService.sendEmailVerification(user);

    final refreshedUser = _authService.currentFirebaseUser;

    return _mapFirebaseUserToAppUser(refreshedUser ?? user);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    String loginEmail = email;

    if (!email.contains('@')) {
      try {
        final userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isEmpty) {
          throw Exception('Không tìm thấy tài khoản với tên đăng nhập này.');
        }

        loginEmail = userQuery.docs.first.data()['email'] as String;
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          throw Exception('Lỗi quyền Firestore: Hãy cấu hình Rules cho bảng "users" để tìm email theo tên đăng nhập.');
        } else {
          rethrow;
        }
      }
    }

    final credential = await _authService.signInWithEmailAndPassword(
      email: loginEmail,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng nhập thất bại.');
    }

    await _authService.reloadCurrentUser();

    final refreshedUser = _authService.currentFirebaseUser;
    if (refreshedUser == null) {
      throw Exception('Không lấy được thông tin người dùng.');
    }

    //kiểm tra email đã xác nhận chưa
    // if (!refreshedUser.emailVerified) {
    //   throw FirebaseAuthException(
    //     code: 'email-not-verified',
    //     message: 'Email chưa được xác minh.',
    //   );
    // }

    return _mapFirebaseUserToAppUser(refreshedUser);
  }

  Future<AppUser> loginWithGoogle() async {
    final credential = await _authService.signInWithGoogle();

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng nhập Google thất bại.');
    }

    return _mapFirebaseUserToAppUser(user);
  }

  Future<void> forgotPassword({
    required String email,
  }) {
    return _authService.sendPasswordResetEmail(email: email);
  }

  Future<void> resendVerificationEmail() async {
    final user = _authService.currentFirebaseUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Không có người dùng đang đăng nhập.',
      );
    }

    if (user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email đã được xác minh.',
      );
    }

    await _authService.sendEmailVerification(user);
  }

  Future<void> changePassword({
    required String newPassword,
  }) {
    return _authService.updatePassword(newPassword: newPassword);
  }

  Future<void> logout() {
    return _authService.signOut();
  }

  AppUser _mapFirebaseUserToAppUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
    );
  }
}
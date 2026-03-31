import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService({
    AuthRepository? authRepository,
  }) : _authRepository = authRepository ?? AuthRepository();

  AppUser? get currentUser {
    final user = _authRepository.currentFirebaseUser;
    if (user == null) return null;
    return _mapFirebaseUserToAppUser(user);
  }

  Stream<AppUser?> get authStateChanges {
    return _authRepository.authStateChanges.map((user) {
      if (user == null) return null;
      return _mapFirebaseUserToAppUser(user);
    });
  }

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    final credential = await _authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng ký thất bại.');
    }

    await _authRepository.sendEmailVerification(user);

    return _mapFirebaseUserToAppUser(user);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng nhập thất bại.');
    }

    await _authRepository.reloadCurrentUser();

    final refreshedUser = _authRepository.currentFirebaseUser;
    if (refreshedUser == null) {
      throw Exception('Không lấy được thông tin người dùng.');
    }

    if (!refreshedUser.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Email chưa được xác minh.',
      );
    }

    return _mapFirebaseUserToAppUser(refreshedUser);
  }

  Future<AppUser> loginWithGoogle() async {
    final credential = await _authRepository.signInWithGoogle();

    final user = credential.user;
    if (user == null) {
      throw Exception('Đăng nhập Google thất bại.');
    }

    return _mapFirebaseUserToAppUser(user);
  }

  Future<void> forgotPassword({
    required String email,
  }) {
    return _authRepository.sendPasswordResetEmail(email: email);
  }

  Future<void> resendVerificationEmail() async {
    final user = _authRepository.currentFirebaseUser;

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

    await _authRepository.sendEmailVerification(user);
  }

  Future<void> changePassword({
    required String newPassword,
  }) {
    return _authRepository.updatePassword(newPassword: newPassword);
  }

  Future<void> logout() {
    return _authRepository.signOut();
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
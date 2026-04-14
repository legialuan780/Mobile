class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final bool emailVerified;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    required this.emailVerified,
  });
}
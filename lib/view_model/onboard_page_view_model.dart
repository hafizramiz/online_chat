import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class OnBoardPageViewModel{
  AuthService _authService = AuthService.authService;
  @override
  Stream<User?> authStateChanges() {
    Stream<User?> authStream = _authService.authStateChanges();
    return authStream;
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  var _auth = FirebaseAuth.instance;

  bool check() => _auth.currentUser != null;

  String get uid => _auth.currentUser.uid;

  void login(
    String email,
    String password,
    Function(AuthProviderState, {String error}) observe,
  ) async {
    try {
      observe(AuthProviderState.start);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      observe(AuthProviderState.success);
    } catch (e) {
      observe(AuthProviderState.fail, error: e.toString());
    } finally {
      observe(AuthProviderState.finish);
    }
  }

  AccountType accountType() => _auth.currentUser.email.contains('sec')
      ? AccountType.security
      : _auth.currentUser.email.contains('manager')
          ? AccountType.manager
          : AccountType.employee;

  Future<void> signOut() => _auth.signOut();
}

enum AccountType {
  security,
  manager,
  employee,
}

enum AuthProviderState {
  start,
  success,
  fail,
  finish,
}

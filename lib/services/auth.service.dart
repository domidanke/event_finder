import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();
  static final AuthService _singleton = AuthService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/user.birthday.read',
      'https://www.googleapis.com/auth/user.gender.read'
    ],
  );

  bool _loginLoading = false;
  bool _registerLoading = false;

  bool get loginLoading => _loginLoading;
  bool get registerLoading => _registerLoading;

  set loginLoading(bool loading) {
    _loginLoading = loading;
    notifyListeners();
  }

  set registerLoading(bool loading) {
    _registerLoading = loading;
    notifyListeners();
  }

  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return await _googleSignIn.signIn();
  }

  /// TODO: Check if this is needed when logging out from google provider
  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> signInNative(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInAsGuest() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> activateAccountWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _firebaseAuth.currentUser?.linkWithCredential(credential);
  }

  Future<void> activateAccountWithEmail(String email, String password) async {
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await _firebaseAuth.currentUser?.linkWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendEmailVerificationEmail() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

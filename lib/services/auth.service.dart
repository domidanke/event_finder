import 'package:event_finder/models/app_user.dart';
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

  /// TODO: Move to separate User service class
  AppUser? currentUser;

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

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> signInNative(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
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

  Future<String>? getToken() {
    return _firebaseAuth.currentUser?.getIdToken();
  }

  Future<void> sendEmailVerificationEmail() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  /// TODO: Move to separate User service class
  void toggleSavedEvent(String eventUid) {
    if (currentUser!.savedEvents.contains(eventUid)) {
      currentUser!.savedEvents.remove(eventUid);
    } else {
      currentUser!.savedEvents.add(eventUid);
    }
  }

  /// TODO: Move to separate User service class
  void toggleSavedArtist(String artistUid) {
    if (currentUser!.savedArtists.contains(artistUid)) {
      currentUser!.savedArtists.remove(artistUid);
    } else {
      currentUser!.savedArtists.add(artistUid);
    }
    notifyListeners();
  }
}

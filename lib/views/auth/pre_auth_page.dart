import 'package:event_finder/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../home_page.dart';
import 'login_page.dart';

class PreAuthPage extends StatelessWidget {
  test() async {
    var user = AuthService().getCurrentFirebaseUser();
    IdTokenResult? idTokenResult = await user?.getIdTokenResult();
    debugPrint('claims : ${idTokenResult?.claims}');
  }

  const PreAuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    var user = AuthService().getCurrentFirebaseUser();
    if (user == null) {
      return const LoginPage();
    } else {
      debugPrint('User is logged in as ${user.displayName} with ${user.email}');
      return const HomePage();
    }
  }
}

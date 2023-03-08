import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../home_page.dart';
import 'login_page.dart';

class PreAuthPage extends StatelessWidget {
  const PreAuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    var user = AuthService().getCurrentFirebaseUser();
    if (user == null) {
      return const LoginPage();
    } else if (!user.emailVerified) {
      return const VerifyEmailPage();
    } else {
      debugPrint('User is logged in as ${user.displayName} with ${user.email}');
      FirestoreService().setInitialUserData();
      return const HomePage();
    }
  }
}

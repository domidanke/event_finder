import 'package:event_finder/views/auth/user_routing_page.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import 'login_page.dart';

class AuthStartupPage extends StatefulWidget {
  const AuthStartupPage({super.key});

  @override
  State<AuthStartupPage> createState() => _AuthStartupPageState();
}

class _AuthStartupPageState extends State<AuthStartupPage> {
  @override
  Widget build(BuildContext context) {
    var user = AuthService().getCurrentFirebaseUser();
    if (user == null) {
      return const LoginPage();
    } else if (!user.isAnonymous && !user.emailVerified) {
      return const VerifyEmailPage();
    } else {
      debugPrint('User is logged in as ${user.uid} with email ${user.email}');
      return const UserRoutingPage();
    }
  }
}

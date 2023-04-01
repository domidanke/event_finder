import 'package:event_finder/views/auth/user_routing_page.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import 'login_page.dart';

class AuthStartupPage extends StatefulWidget {
  const AuthStartupPage({super.key});

  @override
  State<AuthStartupPage> createState() => _AuthStartupPageState();
}

class _AuthStartupPageState extends State<AuthStartupPage> {
  late User? _user;

  @override
  void initState() {
    _user = AuthService().getCurrentFirebaseUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const LoginPage();
    } else if (!_user!.isAnonymous && !_user!.emailVerified) {
      return const VerifyEmailPage();
    } else {
      debugPrint(
          'User is logged in as ${_user!.uid} with email ${_user!.email}');
      return const UserRoutingPage();
    }
  }
}

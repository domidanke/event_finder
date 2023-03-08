import 'dart:async';

import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../../models/theme.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startVerification();
  }

  void startVerification() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await AuthService().getCurrentFirebaseUser()!.reload();
      var user = AuthService().getCurrentFirebaseUser()!;
      if (user.emailVerified) {
        await FirestoreService().addUserDocument(user);
        if (mounted) Navigator.pushNamed(context, '/');
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
          gradient: primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Bestaetigungsemail geschickt an:'),
              Text(
                '${AuthService().getCurrentFirebaseUser()!.email}',
                style: const TextStyle(fontSize: 24),
              ),
              const Text('Bitte verifizieren Sie Ihre Email'),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  child: const LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: primaryWhite,
                  ))
            ],
          ),
        ),
      )),
    );
  }
}

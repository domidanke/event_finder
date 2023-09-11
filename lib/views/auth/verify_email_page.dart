import 'dart:async';

import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool emailSent = false;

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
        await UserDocService().addUserDocument(user);
        StateService().currentUser =
            await UserDocService().getCurrentUserData();
        if (mounted) Navigator.pushNamed(context, '/');
        timer.cancel();
      }
      if (!emailSent) {
        await AuthService().getCurrentFirebaseUser()!.sendEmailVerification();
        emailSent = true;
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
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.mail,
                size: 100,
              ),
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

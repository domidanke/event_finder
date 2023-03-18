import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:event_finder/views/feature/artist/artist_home_page.dart';
import 'package:event_finder/views/feature/host/host_home_page.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../feature/base/base_home_page.dart';
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
      return FutureBuilder(
          future: FirestoreService().getUserData(),
          builder: (context, snapshot) {
            AuthService().currentUser = snapshot.data;
            if (AuthService().currentUser != null) {
              switch (AuthService().currentUser!.type) {
                case UserType.base:
                  return const BaseHomePage();
                case UserType.artist:
                  return const ArtistHomePage();
                case UserType.host:
                  return const HostHomePage();
              }
            } else {
              return const Scaffold(
                body: Center(),
              );
            }
          });
    }
  }
}

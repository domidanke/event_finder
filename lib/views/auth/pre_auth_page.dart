import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:event_finder/views/feature/artist/artist_home_page.dart';
import 'package:event_finder/views/feature/host/host_home_page.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../feature/base/base_home_page.dart';
import 'login_page.dart';

class PreAuthPage extends StatefulWidget {
  const PreAuthPage({super.key});

  @override
  State<PreAuthPage> createState() => _PreAuthPageState();
}

class _PreAuthPageState extends State<PreAuthPage> {
  late Future<AppUser?> _user;

  @override
  void initState() {
    _user = UserDocService().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = AuthService().getCurrentFirebaseUser();
    if (user == null) {
      return const LoginPage();
    } else if (!user.isAnonymous && !user.emailVerified) {
      return const VerifyEmailPage();
    } else {
      debugPrint('User is logged in as ${user.displayName} with ${user.email}');
      return FutureBuilder(
          future: _user,
          builder: (context, snapshot) {
            StateService().currentUser = snapshot.data;
            final currentUser = StateService().currentUser;
            if (currentUser != null) {
              switch (currentUser.type) {
                case UserType.guest:
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

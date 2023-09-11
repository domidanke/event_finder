import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/artist/artist_home_page.dart';
import 'package:event_finder/views/feature/guest/guest_home_page.dart';
import 'package:event_finder/views/feature/host/host_home_page.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../../theme/theme.dart';
import '../../widgets/custom_button.dart';
import '../feature/base/base_home_page.dart';

class UserRoutingPage extends StatefulWidget {
  const UserRoutingPage({super.key});

  @override
  State<UserRoutingPage> createState() => _UserRoutingPageState();
}

class _UserRoutingPageState extends State<UserRoutingPage> {
  late Future<AppUser?> _user;

  @override
  void initState() {
    _user = UserDocService().getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: StateService().currentUser != null
              ? _getUserRoute()
              : FutureBuilder(
                  future: _user,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      StateService().setCurrentUserSilent = snapshot.data!;
                      return _getUserRoute();
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Etwas ist schiefgelaufen.'),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 150,
                            child: CustomButton(
                                onPressed: () async {
                                  await AuthService()
                                      .signOut()
                                      .then((value) => {
                                            StateService()
                                                .resetCurrentUserSilent(),
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> route) =>
                                                    route.settings.name == '/'),
                                            Navigator.pushNamed(context, '/')
                                          });
                                },
                                buttonText: 'Neustarten'),
                          )
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  Widget _getUserRoute() {
    switch (StateService().currentUser!.type) {
      case UserType.guest:
        return const GuestHomePage();
      case UserType.base:
        return const BaseHomePage();
      case UserType.artist:
        return const ArtistHomePage();
      case UserType.host:
        return const HostHomePage();
    }
  }
}

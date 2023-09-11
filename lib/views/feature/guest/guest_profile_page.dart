import 'package:event_finder/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../services/auth.service.dart';
import '../../../services/state.service.dart';

class GuestProfilePage extends StatefulWidget {
  const GuestProfilePage({Key? key}) : super(key: key);

  @override
  State<GuestProfilePage> createState() => _GuestProfilePageState();
}

class _GuestProfilePageState extends State<GuestProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'activate_account');
                        },
                        buttonText: 'Activate Account'),
                    const SizedBox(
                      height: 30,
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: ListTile(
                        leading: const Icon(Icons.receipt),
                        title: const Text('Meine Tickets'),
                        onTap: () {},
                      ),
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: ListTile(
                        leading: const Icon(Icons.event_available),
                        title: const Text('Gespeicherte Veranstaltungen'),
                        onTap: () {},
                      ),
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: ListTile(
                        leading: const Icon(Icons.house),
                        title: const Text('Meine Hosts'),
                        onTap: () {},
                      ),
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Meine Artists'),
                        onTap: () {},
                      ),
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Support'),
                        onTap: () {},
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        await AuthService().signOut().then((value) => {
                              StateService().resetCurrentUserSilent(),
                              Navigator.pushNamedAndRemoveUntil(context, '/',
                                  (Route<dynamic> route) => false),
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

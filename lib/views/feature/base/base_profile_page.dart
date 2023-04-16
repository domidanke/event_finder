import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseProfilePage extends StatefulWidget {
  const BaseProfilePage({Key? key}) : super(key: key);

  @override
  State<BaseProfilePage> createState() => _BaseProfilePageState();
}

class _BaseProfilePageState extends State<BaseProfilePage> {
  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(currentUser.displayName.isEmpty
                        ? '- kein Name'
                        : currentUser.displayName),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  Opacity(
                    opacity: currentUser.allTickets.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.receipt),
                      title: const Text('Meine Tickets'),
                      onTap: () {
                        if (currentUser.allTickets.isEmpty) return;
                        Navigator.pushNamed(context, 'tickets');
                      },
                    ),
                  ),
                  Opacity(
                    opacity: currentUser.savedArtists.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Meine Künstler'),
                      onTap: () {
                        if (currentUser.savedArtists.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_artists');
                      },
                    ),
                  ),
                  Opacity(
                    opacity: currentUser.savedHosts.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.house),
                      title: const Text('Meine Hosts'),
                      onTap: () {
                        if (currentUser.savedHosts.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_hosts');
                      },
                    ),
                  ),
                  Opacity(
                    opacity: currentUser.savedEvents.isEmpty ? 0.4 : 1,
                    child: ListTile(
                      leading: const Icon(Icons.event_available),
                      title: const Text('Gespeicherte Veranstaltungen'),
                      onTap: () {
                        if (currentUser.savedEvents.isEmpty) {
                          return;
                        }
                        Navigator.pushNamed(context, 'saved_events');
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.password),
                    title: const Text('Passwort ändern'),
                    onTap: () {
                      print('edit password');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.question_mark),
                    title: const Text('Support'),
                    onTap: () {
                      Navigator.pushNamed(context, 'support_page');
                    },
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: KKButton(
                    onPressed: () async {
                      await AuthService().signOut().then((value) => {
                            StateService().resetCurrentUserSilent(),
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false),
                          });
                    },
                    buttonText: 'Abmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

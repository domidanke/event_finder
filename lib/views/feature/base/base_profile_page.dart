import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/base/ratings_page.dart';
import 'package:event_finder/views/feature/base/saved_events_page.dart';
import 'package:event_finder/views/feature/shared/saved_artists_page.dart';
import 'package:event_finder/views/feature/shared/saved_hosts_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';

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
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                      showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const SavedArtistsPage(),
                      );
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
                      showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const SavedHostsPage(),
                      );
                    },
                  ),
                ),
                Opacity(
                  opacity: currentUser.savedEvents.isEmpty ? 0.4 : 1,
                  child: ListTile(
                    leading: const Icon(Icons.event_available),
                    title: const Text('Gespeicherte Events'),
                    onTap: () {
                      if (currentUser.savedEvents.isEmpty) {
                        return;
                      }
                      showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            const SavedEventsPage(),
                      );
                    },
                  ),
                ),
                Opacity(
                  opacity: currentUser.eventsToBeRated.isEmpty ? 0.4 : 1,
                  child: ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Ratings'),
                    onTap: () {
                      if (currentUser.eventsToBeRated.isEmpty) return;
                      showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) => const RatingsPage(),
                      );
                    },
                  ),
                ),
                //const ChangePasswordTile(),
                ListTile(
                  leading: const Icon(Icons.question_mark),
                  title: const Text('Support'),
                  onTap: () {
                    Navigator.pushNamed(context, 'support_page');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await AuthService().signOut().then((value) => {
                          StateService().resetCurrentUserSilent(),
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false),
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

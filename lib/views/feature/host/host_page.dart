import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/location_snippet.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  @override
  Widget build(BuildContext context) {
    final AppUser host = Provider.of<StateService>(context).lastSelectedHost!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: host.imageUrl != null
                  ? NetworkImage(host.imageUrl!)
                  : Image.asset('assets/images/profile_placeholder.png').image,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(host.displayName),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KKIcon(
                  icon: const Icon(Icons.facebook),
                  onPressed: () async {
                    if (host.externalLinks.facebook.isEmpty) return;
                    final url = Uri.parse(host.externalLinks.facebook);
                    await launchUrl(url);
                  },
                ),
                KKIcon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    if (host.externalLinks.instagram.isEmpty) return;
                    final url = Uri.parse(host.externalLinks.instagram);
                    await launchUrl(url);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await FirestoreService().toggleSaveHostForUser(host.uid);
                await FirestoreService().toggleFollowerForHost(host.uid);
                setState(() {
                  AuthService().toggleSavedHost(host.uid);
                });
              },
              backgroundColor:
                  AuthService().currentUser!.savedHosts.contains(host.uid)
                      ? Colors.grey
                      : null,
              elevation: 0,
              label: AuthService().currentUser!.savedHosts.contains(host.uid)
                  ? const Text('Unfollow')
                  : const Text('Follow'),
              icon: AuthService().currentUser!.savedHosts.contains(host.uid)
                  ? const Icon(Icons.cancel_outlined)
                  : const Icon(Icons.person_add_alt_1),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Follower '),

                /// Maybe not the best solution, but shows live number of followers
                StreamBuilder(
                    stream: FirestoreService()
                        .usersCollection
                        .doc(host.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          'No Data...',
                        );
                      } else {
                        final x = snapshot.data!.data()!;
                        return Text('${x.follower.length}');
                      }
                    })
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'host_events_page');
                },
                icon: const Icon(Icons.event)),
            const SizedBox(
              height: 20,
            ),
            if (host.mainLocationCoordinates.longitude != 0 &&
                host.mainLocationCoordinates.latitude != 0)
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  height: 200,
                  child: LocationSnippet(
                      coordinates: host.mainLocationCoordinates)),
          ],
        ),
      ),
    );
  }
}

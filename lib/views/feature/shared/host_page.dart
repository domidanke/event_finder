import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/location_snippet.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.facebook),
                  onPressed: () async {
                    if (host.externalLinks.facebook.isEmpty) return;
                    final url = Uri.parse(host.externalLinks.facebook);
                    await launchUrl(url);
                  },
                ),
                CircleAvatar(
                  radius: 75,
                  backgroundImage: host.imageUrl != null
                      ? NetworkImage(host.imageUrl!)
                      : Image.asset('assets/images/profile_placeholder.png')
                          .image,
                ),
                CustomIconButton(
                  color: Colors.pinkAccent,
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
              height: 8,
            ),
            Text(
              host.displayName,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            if (StateService().currentUser!.savedHosts.contains(host.uid))
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {
                    _showUnfollowSheet();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: primaryGreen,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Following',
                        style: TextStyle(
                            color: primaryGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: EventDocService()
                              .eventsCollection
                              .where('creatorId', isEqualTo: host.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text(
                                '',
                              );
                            } else {
                              final x = snapshot.data;
                              return Text(
                                '${x == null ? '0' : x.docs.length}',
                                style: const TextStyle(fontSize: 20),
                              );
                            }
                          }),
                      const Text(
                        'Events',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: UserDocService()
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
                              return Text(
                                '${x.follower.length}',
                                style: const TextStyle(fontSize: 20),
                              );
                            }
                          }),
                      const Text(
                        'Follower',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: const [
                      Text(
                        '-',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Artist Collabs',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (!StateService().currentUser!.savedHosts.contains(host.uid))
              GestureDetector(
                onTap: () async {
                  StateService().isLoadingFollow = true;
                  await UserDocService().toggleFollowHost(host);
                  StateService().isLoadingFollow = false;
                  setState(() {
                    StateService().toggleSavedHost(host.uid);
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: primaryGreen, width: 1),
                    ),
                    child: Center(
                        child: StateService().isLoadingFollow
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: primaryGreen,
                                ))
                            : const Text(
                                'Follow',
                                style: TextStyle(color: primaryGreen),
                              )),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            if (host.mainLocation.geoHash.isNotEmpty)
              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: LocationSnippet(
                        coordinates: LatLng(host.mainLocation.geoPoint.latitude,
                            host.mainLocation.geoPoint.longitude))),
              ),
          ],
        ),
      ),
    );
  }

  void _showUnfollowSheet() {
    final AppUser host = StateService().lastSelectedHost!;
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 100,
        child: ListTile(
          leading: const Icon(Icons.cancel_outlined),
          onTap: () async {
            await UserDocService().toggleFollowHost(host);
            setState(() {
              StateService().toggleSavedHost(host.uid);
            });
            if (mounted) Navigator.pop(context);
          },
          title: const Text('Unfollow'),
        ),
      ),
    );
  }
}

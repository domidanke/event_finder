import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/location_snippet.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/event.dart';
import '../../../widgets/event_tile.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppUser host = Provider.of<StateService>(context).lastSelectedHost!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              size: 2,
                              color: primaryWhite,
                              icon: const Icon(
                                Icons.facebook,
                                size: 16,
                              ),
                              onPressed: () async {
                                if (host.externalLinks.facebook.isEmpty) return;
                                final url =
                                    Uri.parse(host.externalLinks.facebook);
                                await launchUrl(url);
                              },
                            ),
                            CustomIconButton(
                              size: 2,
                              color: primaryWhite,
                              icon: const Icon(Icons.whatshot, size: 16),
                              onPressed: () async {
                                if (host.externalLinks.soundCloud.isEmpty) {
                                  return;
                                }
                                final url =
                                    Uri.parse(host.externalLinks.soundCloud);
                                await launchUrl(url);
                              },
                            ),
                            CustomIconButton(
                              size: 2,
                              color: primaryWhite,
                              icon: const Icon(Icons.camera_alt_outlined,
                                  size: 16),
                              onPressed: () async {
                                if (host.externalLinks.instagram.isEmpty) {
                                  return;
                                }
                                final url =
                                    Uri.parse(host.externalLinks.instagram);
                                await launchUrl(url);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: host.imageUrl != null
                        ? NetworkImage(host.imageUrl!)
                        : Image.asset('assets/images/profile_placeholder.png')
                            .image,
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
                  if (!StateService()
                      .currentUser!
                      .savedHosts
                      .contains(host.uid))
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
                        height: 40,
                        child: Card(
                          color: secondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                                color: secondaryColor, width: 1),
                          ),
                          child: Center(
                              child: StateService().isLoadingFollow
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: primaryBackgroundColor,
                                      ))
                                  : const Text(
                                      'Follow',
                                      style: TextStyle(
                                          color: primaryBackgroundColor),
                                    )),
                        ),
                      ),
                    ),
                  if (StateService().currentUser!.savedHosts.contains(host.uid))
                    GestureDetector(
                      onTap: () {
                        _showUnfollowSheet();
                      },
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                                color: secondaryColor, width: 1),
                          ),
                          child: Center(
                              child: StateService().isLoadingFollow
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: secondaryColor,
                                      ))
                                  : const Text(
                                      'Following',
                                      style: TextStyle(color: secondaryColor),
                                    )),
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
                        child: Opacity(
                          opacity:
                              host.mainLocation.geoHash.isNotEmpty ? 1 : 0.2,
                          child: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {
                              if (host.mainLocation.geoHash.isEmpty) return;
                              _showLocationBottomSheet(host);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      text: 'Nächste Events',
                    ),
                    Tab(text: 'Vergangene Events'),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FirestoreListView<Event>(
                      emptyBuilder: (context) {
                        return const Center(
                          child: Text('Keine Events'),
                        );
                      },
                      query: _getHostCurrentEventsQuery(host),
                      itemBuilder: (context, snapshot) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Column(
                              children: [
                                EventTile(event: snapshot.data()),
                              ],
                            ));
                      },
                    ),
                    SizedBox(
                      height: 100,
                      child: FirestoreListView<Event>(
                        emptyBuilder: (context) {
                          return const Center(
                            child: Text('Keine Events'),
                          );
                        },
                        query: _getHostPastEventsQuery(host),
                        itemBuilder: (context, snapshot) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: EventTile(event: snapshot.data()));
                        },
                      ),
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

  Query<Event> _getHostCurrentEventsQuery(AppUser host) {
    final now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService().eventsCollection.orderBy('startDate');
    query = query.where('startDate', isGreaterThanOrEqualTo: startOfDay);
    return query.where('creatorId', isEqualTo: host.uid);
  }

  Query<Event> _getHostPastEventsQuery(AppUser host) {
    final now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService().eventsCollection.orderBy('startDate');
    query = query.where('startDate', isLessThan: startOfDay);
    return query.where('creatorId', isEqualTo: host.uid);
  }

  void _showUnfollowSheet() {
    final AppUser host = StateService().lastSelectedHost!;
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
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

  void _showLocationBottomSheet(AppUser host) {
    showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
          height: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: primaryGradient,
          ),
          child: LocationSnippet(
              coordinates: LatLng(host.mainLocation.geoPoint.latitude,
                  host.mainLocation.geoPoint.longitude))),
    );
  }
}

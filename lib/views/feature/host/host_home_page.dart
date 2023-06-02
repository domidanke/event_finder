import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class HostHomePage extends StatefulWidget {
  const HostHomePage({super.key});
  @override
  State<HostHomePage> createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'current_events');
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: primaryWhite, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Aktuelle Events',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.event),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'artist_search');
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: primaryWhite, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Künstlersuche',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.people),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'past_events');
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: primaryWhite, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Alte Events',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.event),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'host_profile');
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: primaryWhite, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Mein Profil',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.person),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

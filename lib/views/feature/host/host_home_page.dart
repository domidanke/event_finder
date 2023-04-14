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
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'current_events');
                    },
                    child: Card(
                        color: primaryColorTransparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.event),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Aktuelle Events',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'host_profile');
                    },
                    child: Card(
                        color: primaryColorTransparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Mein Profil',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'artist_search');
                    },
                    child: Card(
                        color: primaryColorTransparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.people),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Kuenstlersuche',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'past_events');
                    },
                    child: Card(
                        color: primaryColorTransparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.event),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Alte Events',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(Icons.arrow_forward_ios)
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

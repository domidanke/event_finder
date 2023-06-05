import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_icon_button.dart';

class HostProfilePage extends StatefulWidget {
  const HostProfilePage({Key? key}) : super(key: key);

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  late Future<String> _imageUrl;

  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    _imageUrl = StorageService().getProfileImageUrl();
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: _imageUrl,
              builder: (context, snapshot) {
                currentUser.imageUrl = snapshot.data;
                if (snapshot.hasData) {
                  return Container(
                      height: 400,
                      width: 1000,
                      decoration: BoxDecoration(
                        image: currentUser.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  currentUser.imageUrl!,
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                            : null,
                      ),
                      child: _getImageContent());
                } else {
                  return SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: const SizedBox(
                          height: 400,
                          width: 1000,
                          child: Center(child: CircularProgressIndicator())),
                    ),
                  );
                }
              }),
          Expanded(
              flex: 8,
              child: ListView(
                children: [
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
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Profil bearbeiten'),
                    onTap: () {
                      Navigator.pushNamed(context, 'host_edit_profile');
                    },
                  ),
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
              )),
        ],
      ),
    );
  }

  Widget _getImageContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StateService().currentUser!.displayName,
                        style: const TextStyle(
                          fontSize: 32,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

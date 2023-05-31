import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
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
  void initState() {
    _imageUrl = StorageService().getProfileImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    currentUser.imageUrl != null
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                NetworkImage(currentUser.imageUrl!))
                        : FutureBuilder(
                            future: _imageUrl,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return CircleAvatar(
                                  radius: 100,
                                  backgroundImage: Image.asset(
                                          'assets/images/profile_placeholder.png')
                                      .image,
                                );
                              }
                              currentUser.imageUrl = snapshot.data;
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 100,
                                  backgroundImage: snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? null
                                      : currentUser.imageUrl != null
                                          ? NetworkImage(currentUser.imageUrl!)
                                          : Image.asset(
                                                  'assets/images/profile_placeholder.png')
                                              .image,
                                  child: snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? const CircularProgressIndicator()
                                      : null,
                                );
                              } else {
                                return const SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CircularProgressIndicator());
                              }
                            }),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(currentUser.displayName),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                  ],
                ),
              ),
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
                    ],
                  )),
              KKButton(
                  onPressed: () async {
                    await AuthService().signOut().then((value) => {
                          StateService().resetCurrentUserSilent(),
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false),
                        });
                  },
                  buttonText: 'Abmelden'),
            ],
          ),
        ),
      ),
    );
  }
}

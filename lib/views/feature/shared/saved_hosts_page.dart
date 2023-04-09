import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedHostsPage extends StatefulWidget {
  const SavedHostsPage({super.key});

  @override
  State<SavedHostsPage> createState() => _SavedHostsPageState();
}

class _SavedHostsPageState extends State<SavedHostsPage> {
  late Future<String> _imageUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Doing this, so in case of unfollow of an host, the list gets refetched
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: FirestoreListView<AppUser>(
          emptyBuilder: (context) {
            return const Center(
              child: Text('Keine Hosts'),
            );
          },
          query: currentUser.savedHosts.isEmpty
              ? UserDocService()
                  .usersCollection
                  .where(FieldPath.documentId, whereIn: ['EMPTY'])
              : UserDocService()
                  .usersCollection
                  .where(FieldPath.documentId, whereIn: currentUser.savedHosts),
          itemBuilder: (context, snapshot) {
            AppUser host = snapshot.data();
            _imageUrl = StorageService().getUserImageUrl(host.uid);
            return GestureDetector(
              onTap: () {
                StateService().lastSelectedHost = host;
                Navigator.pushNamed(context, 'host_page');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: 4),
                  leading: FutureBuilder(
                      future: _imageUrl,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: Image.asset(
                                    'assets/images/profile_placeholder.png')
                                .image,
                          );
                        }
                        host.imageUrl = snapshot.data;
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? null
                              : host.imageUrl != null
                                  ? NetworkImage(host.imageUrl!)
                                  : Image.asset(
                                          'assets/images/profile_placeholder.png')
                                      .image,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(),
                                )
                              : null,
                        );
                      }),
                  title: Text(host.displayName),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

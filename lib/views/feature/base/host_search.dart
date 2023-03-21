import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';
import '../../../services/state.service.dart';
import '../../../services/storage.service.dart';

class HostSearch extends StatefulWidget {
  const HostSearch({super.key});

  @override
  State<HostSearch> createState() => _HostSearchState();
}

class _HostSearchState extends State<HostSearch> {
  late Future<String> _imageUrl;

  void _showFilters() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Host Filters'),
                  KKButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    buttonText: 'Anwenden',
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      _showFilters();
                    },
                    icon: const Icon(Icons.filter_alt))
              ],
            )),
        Expanded(
          flex: 9,
          child: FirestoreListView<AppUser>(
            emptyBuilder: (context) {
              return const Center(
                child: Text('Keine Hosts'),
              );
            },
            query: FirestoreService().usersCollection.where(
                  'type',
                  isEqualTo: 'host',
                ),
            itemBuilder: (context, snapshot) {
              final host = snapshot.data();
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
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/state.service.dart';
import '../../../services/storage/storage.service.dart';

class HostSearch extends StatefulWidget {
  const HostSearch({super.key});

  @override
  State<HostSearch> createState() => _HostSearchState();
}

class _HostSearchState extends State<HostSearch> {
  late Future<String> _imageUrl;
  final _hostSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hostSearchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Suche',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    },
                    child: const Icon(Icons.search)),
              )
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: FirestoreListView<AppUser>(
            emptyBuilder: (context) {
              return const Center(
                child: Text('Keine Hosts'),
              );
            },
            query: _getQuery(),
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Query<AppUser> _getQuery() {
    var query = UserDocService()
        .usersCollection
        .where(
          'type',
          isEqualTo: 'host',
        )
        .orderBy('displayName');
    if (_hostSearchController.text.isNotEmpty) {
      query = query
          .where('displayName',
              isGreaterThanOrEqualTo: _hostSearchController.text)
          .where('displayName', isLessThan: '${_hostSearchController.text}z');
    }
    return query;
  }
}

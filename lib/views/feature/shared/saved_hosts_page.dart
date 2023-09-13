import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/user_tile.dart';

class SavedHostsPage extends StatefulWidget {
  const SavedHostsPage({super.key});

  @override
  State<SavedHostsPage> createState() => _SavedHostsPageState();
}

class _SavedHostsPageState extends State<SavedHostsPage> {
  // Doing this so the modal sheet doesn't glitch weirdly
  Future<int> fetchNumber() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    /// Doing this, so in case of unfollow of an host, the list gets refetched
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return Container(
      decoration: BoxDecoration(gradient: primaryGradient),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 42),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 32,
                    )),
              ],
            ),
          ),
          FutureBuilder(
            future: fetchNumber(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Expanded(
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
                        : UserDocService().usersCollection.where(
                            FieldPath.documentId,
                            whereIn: currentUser.savedHosts),
                    itemBuilder: (context, snapshot) {
                      return UserTile(
                        user: snapshot.data(),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/theme.dart';

class QrCode extends StatelessWidget {
  const QrCode({Key? key, required this.data, required this.size})
      : super(key: key);
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    var userId = data.split('_')[0];
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          QrImageView(
            size: size,
            data: data,
            padding: const EdgeInsets.all(12),
            backgroundColor: primaryWhite,
          ),
          StreamBuilder(
              stream: UserDocService().usersCollection.doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  final user = snapshot.data!.data()!;
                  if (user.usedTickets.contains(data)) {
                    return Container(
                      decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.9),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      width: 130,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Gescanned'),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(Icons.check_circle_outline)
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              }),
        ],
      ),
    );
  }
}

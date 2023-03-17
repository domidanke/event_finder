import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const UserAvatar(),
              const SizedBox(
                height: 50,
              ),
              Text(AuthService().getCurrentFirebaseUser()!.displayName ?? '-'),
              const SizedBox(
                height: 20,
              ),
              Text(AuthService().getCurrentFirebaseUser()!.email!),
              Row(
                children: const [
                  KKIcon(icon: Icon(Icons.facebook)),
                  KKIcon(icon: Icon(Icons.whatshot)),
                  KKIcon(icon: Icon(Icons.camera_alt_outlined)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

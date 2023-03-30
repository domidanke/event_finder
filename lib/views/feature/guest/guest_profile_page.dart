import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';

class GuestProfilePage extends StatefulWidget {
  const GuestProfilePage({Key? key}) : super(key: key);

  @override
  State<GuestProfilePage> createState() => _GuestProfilePageState();
}

class _GuestProfilePageState extends State<GuestProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListView(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage:
                    Image.asset('assets/images/profile_placeholder.png').image,
              ),
              const Spacer(),
              KKButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'activate_account');
                  },
                  buttonText: 'Activate Account'),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.receipt),
                title: const Text('Meine Tickets'),
                onTap: () {},
              ),
              Opacity(
                opacity: 0.2,
                child: ListTile(
                  leading: const Icon(Icons.event_available),
                  title: const Text('Gespeicherte Veranstaltungen'),
                  onTap: () {},
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: ListTile(
                  leading: const Icon(Icons.house),
                  title: const Text('Meine Hosts'),
                  onTap: () {},
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Meine Artists'),
                  onTap: () {},
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Support'),
                  onTap: () {},
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

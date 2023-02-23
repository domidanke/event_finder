import 'dart:async';

import 'package:event_finder/route_generator.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/auth/pre_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => FirestoreService()),
    ],
    child: const EventFinder(),
  ));
}

class EventFinder extends StatelessWidget {
  const EventFinder({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator().generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const PreAuthPage(),
    );
  }
}

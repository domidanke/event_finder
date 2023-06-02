import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:event_finder/route_generator.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/create_event.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/auth/auth_startup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (kDebugMode) {
  //   try {
  //     const ip = '192.168.2.191';
  //     FirebaseFirestore.instance.useFirestoreEmulator(ip, 8080);
  //     await FirebaseStorage.instance.useStorageEmulator(ip, 9199);
  //     await FirebaseAuth.instance.useAuthEmulator(ip, 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => StateService()),
      ChangeNotifierProvider(create: (_) => CreateEventService()),
    ],
    child: EventFinder(),
  ));
}

class EventFinder extends StatelessWidget {
  EventFinder({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          scaffoldMessengerKey: _scaffoldKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator().generateRoute,
          theme: primaryThemeData,
          home: const AuthStartupPage(),
        );
      },
    );
  }
}

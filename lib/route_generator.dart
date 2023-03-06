import 'package:event_finder/views/auth/login_page.dart';
import 'package:event_finder/views/auth/pre_auth_page.dart';
import 'package:event_finder/views/auth/register_page.dart';
import 'package:event_finder/views/feature/event_organizer/event_form.dart';
import 'package:event_finder/views/feature/shared/buy_tickets_page.dart';
import 'package:event_finder/views/feature/shared/event_details_page.dart';
import 'package:event_finder/views/feature/shared/profile_page.dart';
import 'package:event_finder/views/feature/shared/saved_events_page.dart';
import 'package:event_finder/views/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PreAuthPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'event_form':
        return MaterialPageRoute(builder: (_) => const EventForm());
      case 'profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case 'saved_events':
        return MaterialPageRoute(builder: (_) => const SavedEventsPage());
      case 'event_details':
        return MaterialPageRoute(builder: (_) => const EventDetailsPage());
      case 'buy_tickets':
        return MaterialPageRoute(builder: (_) => const BuyTicketsPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          'Diese Route existiert nicht: ${settings.name}')),
                ));
    }
  }
}

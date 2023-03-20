import 'package:event_finder/views/auth/activate_account_page.dart';
import 'package:event_finder/views/auth/login_page.dart';
import 'package:event_finder/views/auth/pre_auth_page.dart';
import 'package:event_finder/views/auth/register_page.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:event_finder/views/feature/artist/artist_page.dart';
import 'package:event_finder/views/feature/base/base_home_page.dart';
import 'package:event_finder/views/feature/base/saved_events_page.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_wrapper.dart';
import 'package:event_finder/views/feature/host/created_events_page.dart';
import 'package:event_finder/views/feature/host/edit_event_form.dart';
import 'package:event_finder/views/feature/host/event_form.dart';
import 'package:event_finder/views/feature/shared/buy_tickets_page.dart';
import 'package:event_finder/views/feature/shared/event_details_page.dart';
import 'package:event_finder/views/feature/shared/profile_page.dart';
import 'package:flutter/material.dart';

import 'views/feature/base/saved_artists_page.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PreAuthPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'activate_account':
        return MaterialPageRoute(builder: (_) => const ActivateAccountPage());
      case 'verify_email':
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => const BaseHomePage());
      case 'event_form':
        return MaterialPageRoute(builder: (_) => const EventForm());
      case 'create_event':
        return MaterialPageRoute(builder: (_) => const CreateEventWrapper());
      case 'edit_event':
        return MaterialPageRoute(builder: (_) => const EditEventForm());
      case 'profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case 'artist_page':
        return MaterialPageRoute(builder: (_) => const ArtistPage());
      case 'saved_events':
        return MaterialPageRoute(builder: (_) => const SavedEventsPage());
      case 'saved_artists':
        return MaterialPageRoute(builder: (_) => const SavedArtistsPage());
      case 'created_events':
        return MaterialPageRoute(builder: (_) => const CreatedEventsPage());
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

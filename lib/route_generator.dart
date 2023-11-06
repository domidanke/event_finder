import 'package:event_finder/views/auth/activate_account_page.dart';
import 'package:event_finder/views/auth/auth_startup_page.dart';
import 'package:event_finder/views/auth/login_page.dart';
import 'package:event_finder/views/auth/register_page.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:event_finder/views/feature/artist/artist_events_page.dart';
import 'package:event_finder/views/feature/artist/artist_home_page.dart';
import 'package:event_finder/views/feature/base/base_home_page.dart';
import 'package:event_finder/views/feature/base/buy_tickets_page.dart';
import 'package:event_finder/views/feature/base/event_rating_page.dart';
import 'package:event_finder/views/feature/base/genre_search_result_page.dart';
import 'package:event_finder/views/feature/base/ticket_details_page.dart';
import 'package:event_finder/views/feature/base/tickets_page.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page.dart';
import 'package:event_finder/views/feature/host/current_events_page.dart';
import 'package:event_finder/views/feature/host/edit_event_artists_page.dart';
import 'package:event_finder/views/feature/host/host_events_page.dart';
import 'package:event_finder/views/feature/host/host_home_page.dart';
import 'package:event_finder/views/feature/host/scan_qr_code_page.dart';
import 'package:event_finder/views/feature/host/set_main_location_page.dart';
import 'package:event_finder/views/feature/shared/artist_page.dart';
import 'package:event_finder/views/feature/shared/artist_search.dart';
import 'package:event_finder/views/feature/shared/edit_display_name_page.dart';
import 'package:event_finder/views/feature/shared/event_details_page.dart';
import 'package:event_finder/views/feature/shared/events_map_page.dart';
import 'package:event_finder/views/feature/shared/host_page.dart';
import 'package:event_finder/views/feature/shared/support_page.dart';
import 'package:flutter/material.dart';

import 'views/feature/host/past_events_page.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AuthStartupPage());
      case 'login':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginPage());
      case 'register':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const RegisterPage());
      case 'activate_account':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ActivateAccountPage());
      case 'verify_email':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const VerifyEmailPage());
      case 'base_home':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const BaseHomePage());
      case 'host_home':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HostHomePage());
      case 'artist_home':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ArtistHomePage());
      case 'create_event_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CreateEventPage());
      case 'edit_event_artists':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditEventArtistsPage());
      case 'edit_display_name':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditDisplayNamePage());
      case 'genre_search_result':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const GenreSearchResultPage());
      case 'set_main_location':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SetMainLocationPage());
      case 'artist_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ArtistPage());
      case 'artist_search':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ArtistSearch());
      case 'artist_events_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ArtistEventsPage());
      case 'host_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HostPage());
      case 'host_events_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HostEventsPage());
      case 'tickets':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TicketsPage());
      case 'event_rating':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EventRatingPage());
      case 'ticket_details':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TicketDetailsPage());
      case 'current_events':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CurrentEventsPage());
      case 'past_events':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const PastEventsPage());
      case 'event_details':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EventDetailsPage());
      case 'buy_tickets':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const BuyTicketsPage());
      case 'scan_qr_code':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ScanQrCodePage());
      case 'maps_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EventsMapPage());
      case 'support_page':
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SupportPage());
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          'Diese Route existiert nicht: ${settings.name}')),
                ));
    }
  }
}

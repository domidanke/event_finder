import 'package:event_finder/views/auth/activate_account_page.dart';
import 'package:event_finder/views/auth/auth_startup_page.dart';
import 'package:event_finder/views/auth/login_page.dart';
import 'package:event_finder/views/auth/register_page.dart';
import 'package:event_finder/views/auth/verify_email_page.dart';
import 'package:event_finder/views/feature/artist/artist_edit_profile_page.dart';
import 'package:event_finder/views/feature/artist/artist_events_page.dart';
import 'package:event_finder/views/feature/artist/artist_home_page.dart';
import 'package:event_finder/views/feature/base/base_home_page.dart';
import 'package:event_finder/views/feature/base/buy_tickets_page.dart';
import 'package:event_finder/views/feature/base/saved_events_page.dart';
import 'package:event_finder/views/feature/base/ticket_details_page.dart';
import 'package:event_finder/views/feature/base/tickets_page.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page_1.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page_2.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page_3.dart';
import 'package:event_finder/views/feature/host/current_events_page.dart';
import 'package:event_finder/views/feature/host/edit_event_artists_page.dart';
import 'package:event_finder/views/feature/host/edit_event_form.dart';
import 'package:event_finder/views/feature/host/host_edit_profile_page.dart';
import 'package:event_finder/views/feature/host/host_events_page.dart';
import 'package:event_finder/views/feature/host/host_home_page.dart';
import 'package:event_finder/views/feature/host/host_profile_page.dart';
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

import 'views/feature/base/base_edit_profile_page.dart';
import 'views/feature/host/past_events_page.dart';
import 'views/feature/shared/saved_artists_page.dart';
import 'views/feature/shared/saved_hosts_page.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthStartupPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case 'activate_account':
        return MaterialPageRoute(builder: (_) => const ActivateAccountPage());
      case 'verify_email':
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case 'base_home':
        return MaterialPageRoute(builder: (_) => const BaseHomePage());
      case 'host_home':
        return MaterialPageRoute(builder: (_) => const HostHomePage());
      case 'host_profile':
        return MaterialPageRoute(builder: (_) => const HostProfilePage());
      case 'artist_home':
        return MaterialPageRoute(builder: (_) => const ArtistHomePage());
      case 'create_event_page_1':
        return MaterialPageRoute(builder: (_) => const CreateEventPage1());
      case 'create_event_page_2':
        return MaterialPageRoute(builder: (_) => const CreateEventPage2());
      case 'create_event_page_3':
        return MaterialPageRoute(builder: (_) => const CreateEventPage3());
      case 'edit_event':
        return MaterialPageRoute(builder: (_) => const EditEventForm());
      case 'edit_event_artists':
        return MaterialPageRoute(builder: (_) => const EditEventArtistsPage());
      case 'host_edit_profile':
        return MaterialPageRoute(builder: (_) => const HostEditProfilePage());
      case 'artist_edit_profile':
        return MaterialPageRoute(builder: (_) => const ArtistEditProfilePage());
      case 'base_edit_profile':
        return MaterialPageRoute(builder: (_) => const BaseEditProfilePage());
      case 'edit_display_name':
        return MaterialPageRoute(builder: (_) => const EditDisplayNamePage());
      case 'set_main_location':
        return MaterialPageRoute(builder: (_) => const SetMainLocationPage());
      case 'artist_page':
        return MaterialPageRoute(builder: (_) => const ArtistPage());
      case 'artist_search':
        return MaterialPageRoute(builder: (_) => const ArtistSearch());
      case 'artist_events_page':
        return MaterialPageRoute(builder: (_) => const ArtistEventsPage());
      case 'host_page':
        return MaterialPageRoute(builder: (_) => const HostPage());
      case 'host_events_page':
        return MaterialPageRoute(builder: (_) => const HostEventsPage());
      case 'saved_events':
        return MaterialPageRoute(builder: (_) => const SavedEventsPage());
      case 'saved_artists':
        return MaterialPageRoute(builder: (_) => const SavedArtistsPage());
      case 'saved_hosts':
        return MaterialPageRoute(builder: (_) => const SavedHostsPage());
      case 'tickets':
        return MaterialPageRoute(builder: (_) => const TicketsPage());
      case 'ticket_details':
        return MaterialPageRoute(builder: (_) => TicketDetailsPage());
      case 'current_events':
        return MaterialPageRoute(builder: (_) => const CurrentEventsPage());
      case 'past_events':
        return MaterialPageRoute(builder: (_) => const PastEventsPage());
      case 'event_details':
        return MaterialPageRoute(builder: (_) => const EventDetailsPage());
      case 'buy_tickets':
        return MaterialPageRoute(builder: (_) => const BuyTicketsPage());
      case 'scan_qr_code':
        return MaterialPageRoute(builder: (_) => const ScanQrCodePage());
      case 'maps_page':
        return MaterialPageRoute(builder: (_) => const EventsMapPage());
      case 'support_page':
        return MaterialPageRoute(builder: (_) => const SupportPage());
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

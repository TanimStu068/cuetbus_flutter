// import 'package:cuetbus/features/bus/live_bus_tracker_screen.dart';
// import 'package:cuetbus/features/bus/popular_routes_screen.dart';
import 'package:cuetbus/features/change_password/change_password_screen.dart';
import 'package:cuetbus/features/lost_and_found/lost_and_found_screen.dart';
import 'package:cuetbus/features/privacy_policy/privacy_policy_screen.dart';
import 'package:cuetbus/features/safety_tips/safety_tips_screen.dart';
import 'package:cuetbus/features/service_updates/service_updates_screen.dart';
import 'package:cuetbus/features/terms_and_conditions/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';

// Screens
import 'package:cuetbus/features/splash/splash_screen.dart';
import 'package:cuetbus/features/auth/login_screen.dart';
import 'package:cuetbus/features/auth/signup_screen.dart';
import 'package:cuetbus/features/home/home_screen.dart';
import 'package:cuetbus/features/auth/forgot_password_screen.dart';
import 'package:cuetbus/features/bottom_nav_bar/main_layout.dart';

// Booking
import 'package:cuetbus/features/booking/booking_screen.dart';
import 'package:cuetbus/features/booking/booking_details_screen.dart';
import 'package:cuetbus/features/booking/seat_selection_screen.dart';
import 'package:cuetbus/features/booking/booking_confirmation_screen.dart';
import 'package:cuetbus/features/booking/digital_pass_screen.dart';

// Bus
import 'package:cuetbus/features/bus/bus_list_screen.dart';
import 'package:cuetbus/features/bus/bus_detail_screen.dart';
import 'package:cuetbus/features/bus/bus_schedule_screen.dart';

// Profile / Settings
import 'package:cuetbus/features/profile/profile_screen.dart';
import 'package:cuetbus/features/settings/settings_screen.dart';
// import 'package:cuetbus/features/profile/edit_profile_screen.dart';

//help and support and about app
import 'package:cuetbus/features/help_and_support/help_support_screen.dart';
import 'package:cuetbus/features/about_app/about_app_screen.dart';

//notifications
import 'package:cuetbus/features/notification/notifications_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Main
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgetPassword = '/forgot-password';
  static const String mainNavBar = '/nav-bar';
  static const String changePassword = 'change-password';
  static const String otpverification = 'otp-verification';

  // Booking
  static const String bookingList = '/booking-list';
  static const String bookingDetails = '/booking-details';
  static const String seatSelection = '/seat-selection';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String digitalPass = '/digital-pas';

  // Bus
  static const String busList = '/bus-list';
  static const String busDetails = '/bus-details';
  static const String busSchedule = '/bus-schedule';
  static const String liveBusTracker = '/live-bus-trakcer';
  static const String popularRoutes = '/popular-routes';

  // Profile / Settings
  static const String profile = '/profile';
  static const String settings = '/settings';

  //edit profile && help & support && aboutapp && notification
  static const String editProfile = '/edit-profile';
  static const String helpSupport = '/help-support';
  static const String aboutApp = '/about-app';
  static const String notification = '/notification';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String serviceUpdates = '/service-updates';
  static const String lostAndFound = '/lost-and-found';
  static const String safetyTips = '/safety-tips';

  // 🔥 Route Generator
  static Route<dynamic> generateRoute(RouteSettings routesettings) {
    final args = routesettings.arguments;

    switch (routesettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case changePassword:
        final data = args as Map<String, dynamic>;
        final String userId = data['userId'];
        return MaterialPageRoute(
          builder: (_) => ChangePasswordScreen(studentId: userId),
        );

      case bookingList:
        return MaterialPageRoute(builder: (_) => const BookingsScreen());

      case bookingDetails:
        final data = args as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(
            busName: data['busName'],
            route: data['route'],
            time: data['time'],
            seat: data['seat'],
            date: data['date'],
          ),
        );

      case seatSelection:
        final data = args as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => SeatSelectionScreen(
            busNo: data['busNo'],
            route: data['route'],
            time: data['date'],
          ),
        );

      case bookingConfirmation:
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(
            busName: data['busName'],
            route: data['route'],
            date: data['date'],
            time: data['time'],
            selectedSeats: data['selectedSeats'],
          ),
        );

      // Bus
      case busList:
        return MaterialPageRoute(builder: (_) => const BusListScreen());

      case busDetails:
        final bus = args as Map<String, dynamic>;

        return MaterialPageRoute(builder: (_) => BusDetailsScreen(bus: bus));
      // case liveBusTracker:
      //   return MaterialPageRoute(builder: (_) => LiveBusTrackerScreen());
      // case popularRoutes:
      //   return MaterialPageRoute(builder: (_) => PopularRoutesScreen());

      // Profile / Settings
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case settings:
        final data = args as Map<String, dynamic>;
        final String userId = data['userId'];
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(studentId: userId),
        );
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case termsConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsAndConditionsScreen(),
        );
      case serviceUpdates:
        return MaterialPageRoute(builder: (_) => const ServiceUpdatesScreen());
      case lostAndFound:
        return MaterialPageRoute(builder: (_) => const LostAndFoundScreen());
      case safetyTips:
        return MaterialPageRoute(builder: (_) => const SafetyTipsScreen());
      case digitalPass:
        final data = args as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => DigitalPassScreen(
            busNumber: data['busNumber'],
            route: data['route'],
            seats: data['seat'],
            date: data['date'],
            time: data['time'],
          ),
        );
      case busSchedule:
        return MaterialPageRoute(builder: (_) => const BusScheduleScreen());
      // case editProfile:
      //   return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case mainNavBar:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case aboutApp:
        return MaterialPageRoute(builder: (_) => const AboutAppScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}

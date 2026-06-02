import 'package:go_router/go_router.dart';
import '../../presentation/screens/landing_screen.dart';
import '../../presentation/screens/chat_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/discovery_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/lawyer_profile_screen.dart';
import '../../presentation/screens/booking_requests_screen.dart';
import '../../presentation/screens/my_schedule_screen.dart';
import '../../data/models/user_model.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/lawyer_profile',
        builder: (context, state) {
          final lawyer = state.extra as UserModel;
          return LawyerProfileScreen(lawyer: lawyer);
        },
      ),
      GoRoute(
        path: '/booking_requests',
        builder: (context, state) => const BookingRequestsScreen(),
      ),
      GoRoute(
        path: '/my_schedule',
        builder: (context, state) => const MyScheduleScreen(),
      ),
    ],
  );
}

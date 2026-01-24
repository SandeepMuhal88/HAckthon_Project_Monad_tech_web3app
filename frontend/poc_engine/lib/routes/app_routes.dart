import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/events/screens/events_screen.dart';
import '../features/proof/screens/qr_scanner_screen.dart';
import '../features/proof/screens/proof_status_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String events = '/events';
  static const String qrScanner = '/qr-scanner';
  static const String proofStatus = '/proof-status';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    events: (_) => const EventsScreen(),
    qrScanner: (_) => const QrScannerScreen(),
    proofStatus: (_) => const ProofStatusScreen(),
    profile: (_) => const ProfileScreen(),
  };
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/trading_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/settings_screen.dart';

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF6C5CE7),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C5CE7),
          secondary: Color(0xFF00D4FF),
          surface: Color(0xFF1A1F3A),
          background: Color(0xFF0A0E27),
          error: Color(0xFFFF6B6B),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1A1F3A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/wallet': (context) => const WalletScreen(),
        '/trading': (context) => const TradingScreen(),
        '/portfolio': (context) => const PortfolioScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

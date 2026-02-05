import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'services/wallet_service.dart';
import 'services/crypto_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0E27),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize services
  final walletService = WalletService();
  final cryptoService = CryptoService();
  
  await walletService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: walletService),
        ChangeNotifierProvider.value(value: cryptoService),
      ],
      child: const CryptoApp(),
    ),
  );
}

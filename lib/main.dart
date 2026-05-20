import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/hero_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF180800),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const KoffiqaPitchApp());
}

class KoffiqaPitchApp extends StatelessWidget {
  const KoffiqaPitchApp({super.key});

  static const Color espresso = Color(0xFF180800);
  static const Color deepBrown = Color(0xFF2A1005);
  static const Color gold = Color(0xFFC9922A);
  static const Color cream = Color(0xFFF5E6CC);

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: espresso,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: cream,
        surface: deepBrown,
        onPrimary: espresso,
        onSurface: cream,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: cream, displayColor: cream),
    );

    return MaterialApp(
      title: 'Koffiqa by STACX',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: const HeroScreen(),
    );
  }
}

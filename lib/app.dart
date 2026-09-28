import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

class MediNestApp extends StatelessWidget {
  const MediNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediNest',
      debugShowCheckedModeBanner: false,
      // Strictly Light Mode Only as required
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryGreen,
          onPrimary: Colors.white,
          secondary: AppColors.accentBlue,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
          error: AppColors.danger,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('te', 'IN'),
        Locale('hi', 'IN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}

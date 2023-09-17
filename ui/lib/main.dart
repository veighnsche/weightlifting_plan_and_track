import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weightlifting_plan_and_track/screens/user_details_edit_screen.dart';

import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          bool isSignedIn = snapshot.data != null;

          return MaterialApp(
            title: 'Weightlifting Plan & Track',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('nl', 'NL'), // Dutch
              Locale('en', 'US'), // English
            ],
            home: isSignedIn ? const SplashScreen() : LoginScreen(),
            routes: {
              '/chat': (context) => const ChatScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/user/edit': (context) => UserDetailsEditScreen(
                  userDetails: ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>),
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

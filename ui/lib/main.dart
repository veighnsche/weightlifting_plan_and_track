import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          bool isSignedIn = snapshot.data != null;

          return MaterialApp(
            title: 'Chat App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
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
            onGenerateRoute: (settings) {
              if (isSignedIn) {
                switch (settings.name) {
                  case '/':
                    return MaterialPageRoute(
                        builder: (context) => const SplashScreen());
                  case '/onboarding':
                    return MaterialPageRoute(
                        builder: (context) => const OnboardingScreen());
                  case '/chat':
                    return MaterialPageRoute(
                        builder: (context) => const ChatScreen());
                  // case '/user/edit':
                  //   return MaterialPageRoute(
                  //       builder: (context) => const EditUserForm());
                }
              } else {
                return MaterialPageRoute(builder: (context) => LoginScreen());
              }
              return null;
            },
          );
        }
        // While waiting for the stream to emit data, show a loading indicator
        return const CircularProgressIndicator();
      },
    );
  }
}

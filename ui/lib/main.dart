import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'providers/function_definition_provider.dart';
import 'routes.dart';
import 'screens/app/workout_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/init_service.dart';
import 'themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FunctionDefinitionProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Weightlifting Plan & Track',
        theme: chatAppTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('nl', 'NL'),
          Locale('en', 'US'),
        ],
        routes: routes,
        home: StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen(splashText: "Loading...");
            }
            if (snapshot.data == null) {
              return const LoginScreen();
            }
            return FutureBuilder<Map<String, dynamic>>(
              future: InitService().init(),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen(splashText: "initializing...");
                }
                if (futureSnapshot.hasError) {
                  return const Center(
                      child: Text('Error loading initialization data.'));
                }
                return const AppWorkoutScreen();
              },
            );
          },
        ),
      ),
    );
  }
}

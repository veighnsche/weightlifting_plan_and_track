import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'providers/function_calls_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/user_details_edit_screen.dart';
import 'services/auth_service.dart';
import 'services/init_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  final InitService _initService = InitService();

  MyApp({super.key});

  void setInitData(BuildContext context, Map<String, dynamic>? data) {
    if (data != null && data.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final functionCallsProvider =
            Provider.of<FunctionCallsProvider>(context, listen: false);

        if (data['functionCallInfos'] != null) {
          functionCallsProvider.setFunctionCallsInfo(data['functionCallInfos']);
        }

        if (data['onboarded'] == false) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FunctionCallsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Weightlifting Plan & Track',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('nl', 'NL'), Locale('en', 'US')],
        home: StreamBuilder<User?>(
          stream: _authService.authStateChanges,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState != ConnectionState.active) {
              return const CircularProgressIndicator();
            }

            final isSignedIn = userSnapshot.data != null;
            return FutureBuilder<Map<String, dynamic>>(
              future: isSignedIn ? _initService.init() : Future.value({}),
              builder: (context, initSnapshot) {
                if (initSnapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }

                setInitData(context, initSnapshot.data);
                return isSignedIn ? ChatScreen() : LoginScreen();
              },
            );
          },
        ),
        routes: {
          '/chat': (context) => ChatScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/user/edit': (context) => UserDetailsEditScreen(
              userDetails: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
        },
      ),
    );
  }
}

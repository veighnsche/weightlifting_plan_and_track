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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  final InitService _initService = InitService();

  User? _user;
  Map<String, dynamic>? _initData;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _user = user;
        });
      });
      if (user != null) {
        var data = await _initService.init();

        setState(() {
          _initData = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => FunctionDefinitionProvider()),
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
        supportedLocales: const [Locale('nl', 'NL'), Locale('en', 'US')],
        routes: routes,
        home: _buildHome(),
      ),
    );
  }

  Widget _buildHome() {
    if (_user == null) {
      return const LoginScreen();
    } else if (_initData == null) {
      return const SplashScreen(splashText: "initializing...");
    } else {
      return AppWorkoutScreen();
    }
  }
}

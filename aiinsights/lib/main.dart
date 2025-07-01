import 'package:aiinsights/Views/AppHome.dart';
import 'package:aiinsights/Views/auth.dart';
import 'package:appearance/appearance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.instance.init();
  final isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AppearanceState {
  @override
  Widget build(BuildContext context) {
    return BuildWithAppearance(
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'aiinsights',
        themeMode: Appearance.of(context)?.mode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        builder: (context, child) {
          // Ensures all dialogs, overlays, etc. use the correct theme
          return MediaQuery(
            data: MediaQuery.of(context),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: widget.isLoggedIn ? const Apphome() : const AuthScreen(),
      ),
    );
  }
}

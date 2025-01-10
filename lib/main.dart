import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_myntua/widgets/appbar.dart' as appbar;
import 'package:flutter_myntua/presentation/home/home.dart';
import 'package:flutter_myntua/presentation/friends/friends.dart';
import 'package:flutter_myntua/presentation/profile/profile.dart';
import 'package:flutter_myntua/presentation/events/events.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color photoThemeColor = Color(0xFF373737); // Photo theme color
  static const Color friendColor = Color(0xFF0529A8); // Friend color
  static const Color eventColor = Color(0xFFB40320); // Event color
  static const Color mainBarColor = Color(0xFF115E72); // Main bar color
  static const Color topBarColor = Color(0xFF721121); // Top bar color
  static const Color textColor = Color(0xFF000000); // Text color

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/friends': (context) => const FriendsScreen(),
        '/events_home': (context) => const EventsScreen(),
      },
      title: 'MyNTUA Life',
      theme: ThemeData(
        primaryColor: mainBarColor,
        appBarTheme: const AppBarTheme(backgroundColor: topBarColor),
      ),
    );
  }
}

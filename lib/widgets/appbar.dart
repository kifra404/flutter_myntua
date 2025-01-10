import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomeScreen;

  const TopBar({super.key, required this.isHomeScreen});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Image.asset(
        'assets/images/Molecule Top Bar To Main Menu.png',
        fit: BoxFit.cover,
      ),
      leading: isHomeScreen
          ? null
          : IconButton(
              icon: Image.asset(
                'assets/images/Atom back icon.png', // Back button asset
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          if (!isHomeScreen) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home', // The route name of your Home screen
              (route) => false, // Clears all previous routes
            );
          }
        },
        child: Text(
          'MyNTUA Life',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0); // Standard AppBar height
}

class BottomBar extends StatelessWidget {
  final int currentIndex;

  const BottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index != -1) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/profile');
              break;
            case 1:
              Navigator.pushNamed(context, '/friends');
              break;
            case 2:
              Navigator.pushNamed(context, '/events_home');
              break;
          }
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/Molecule Menu Bar Button Profile.png', // Profile asset
            width: 30,
            height: 30,
          ),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/Molecule Menu Bar Button Friends.png', // Friends asset
            width: 30,
            height: 30,
          ),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/Molecule Menu Bar Button Events.png', // Events asset
            width: 30,
            height: 30,
          ),
          label: 'Events',
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(isHomeScreen: false),
      body: Center(
        child: Text('This is the Profile Screen'),
      ),
      bottomNavigationBar: BottomBar(currentIndex: 0),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(isHomeScreen: false),
      body: Center(
        child: Text('This is the Events Screen'),
      ),
      bottomNavigationBar: BottomBar(currentIndex: 2),
    );
  }
}

import 'package:cuetbus/features/bus/bus_list_screen.dart';
import 'package:cuetbus/features/bus/bus_schedule_screen.dart';
import 'package:cuetbus/features/home/home_screen.dart';
import 'package:cuetbus/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BusListScreen(),
    const BusScheduleScreen(),
    const ProfileScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).textTheme.bodySmall?.color?.withOpacity(0.6),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_rounded),
            label: "Buses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_rounded),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

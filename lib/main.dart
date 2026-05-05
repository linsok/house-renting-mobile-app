import 'package:flutter/material.dart';
import 'package:house_renting_mobile/screens/onboarding_screen.dart';
import 'package:house_renting_mobile/screens/home_screen.dart';
import 'package:house_renting_mobile/screens/search_results_screen.dart';
import 'package:house_renting_mobile/screens/saved_screen.dart';
import 'package:house_renting_mobile/screens/rent_screen.dart';
import 'package:house_renting_mobile/screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const HousingAnalyzerApp());
}

class HousingAnalyzerApp extends StatelessWidget {
  const HousingAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SG Estate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF59E0B),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _showOnboarding = true;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchResultsScreen(),
    SavedScreen(),
    RentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        onGetStarted: () {
          setState(() {
            _showOnboarding = false;
          });
        },
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Rent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'My Profile',
          ),
        ],
      ),
    );
  }
}

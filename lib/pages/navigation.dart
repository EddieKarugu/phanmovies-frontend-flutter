import 'package:flutter/material.dart';
import 'package:phan_movies/pages/home_page.dart';
import 'package:phan_movies/pages/settings.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _tabs = [
    const HomePage(),
    Text('Search'),
    Text('Downloads'),
    const Settings()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            label: 'Downloads',
            activeIcon: Icon(Icons.download),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            activeIcon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

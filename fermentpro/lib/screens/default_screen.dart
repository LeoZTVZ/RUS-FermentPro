import 'package:animations/animations.dart';
import 'package:FermentPro/pages/data_page.dart';
import 'package:FermentPro/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class DefaultScreen extends StatefulWidget{
  final ThemeNotifier themeNotifier;

  const DefaultScreen({super.key,  required this.themeNotifier});


  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DataPage(),
  ];

  // void _navigateBottomBar(int index) {
  //   setState(() {
  //     _previousIndex = _selectedIndex;
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Slide direction based on destination page
    final slideFrom = _selectedIndex == 0
        ? const Offset(-1, 0)  // HomePage slides in from left
        : const Offset(1, 0);  // DataPage slides in from right

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation, secondaryAnimation) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          final fade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation);

          final slide = Tween<Offset>(
            begin: slideFrom,
            end: Offset.zero,
          ).animate(curvedAnimation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).iconTheme.color,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        onTap: (index) {
          setState(() {
            _previousIndex = _selectedIndex;
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_object),
            label: 'Database',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.themeNotifier.toggleTheme,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          widget.themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }

}

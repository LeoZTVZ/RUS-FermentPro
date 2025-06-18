import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:FermentPro/pages/data_page.dart';
import 'package:FermentPro/pages/home_page.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/fermentRecord.dart';
import '../providers/data_providers.dart';

class DefaultScreen extends ConsumerStatefulWidget { // <-- CHANGE TO ConsumerStatefulWidget
  final ThemeNotifier themeNotifier;

  const DefaultScreen({super.key, required this.themeNotifier});

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends ConsumerState<DefaultScreen> { // <--- ConsumerState
  int _selectedIndex = 0;
  int _previousIndex = 0;


  @override
  Widget build(BuildContext context) {
    final fermentRecords = ref.watch(fermentRecordProvider);
    debugPrint(fermentRecords.toString());

    // Slide direction based on destination page
    final slideFrom = _selectedIndex == 0
        ? const Offset(-1, 0)  // HomePage slides in from left
        : const Offset(1, 0);  // DataPage slides in from right

    return Scaffold(
      body: fermentRecords.when(
        data: (records) {
          final dateFormat = DateFormat("HH:mm:ss d.M.yyyy.");

          final List<FermentRecordModel> sortedRecords = List.from(records);



// Sort by parsed DateTime in descending order
          sortedRecords.sort((a, b) {
            final dateA = dateFormat.parse(a.dateTime);
            final dateB = dateFormat.parse(b.dateTime);
            return dateB.compareTo(dateA); // descending
          });

          final FermentRecordModel? latestRecord = sortedRecords.isNotEmpty ? sortedRecords.first : null;
          final pages = [
            HomePage(latestRecord: latestRecord),
            DataPage(records: records),
          ];

          return PageTransitionSwitcher(
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
            child: pages[_selectedIndex],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FermentPro/screens/default_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme(); // Ensure theme is loaded before app starts
  runApp(MyApp(themeNotifier: themeNotifier));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const MyApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainPage(themeNotifier: themeNotifier),
        );
      },
    );
  }
}

// Theme Notifier to handle switching
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true, // Enable Material 3 for a modern base

  primaryColor: const Color(0xFFEB9100), // Golden Amber
  scaffoldBackgroundColor: const Color(0xFFF4E8C1), // Light luxury parchment tone
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFE3C87C), // Lighter deep honey for modern gloss
    elevation: 4,
  ),
  cardColor: const Color(0xFFEB9100), // Light glass-like off-white
  iconTheme: const IconThemeData(color: Color(0xFF5C3B00)), // Deep bronze
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFF2B1A00),
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF2B1A00),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB16A00), // Warm Clay
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFFEB9100),
    secondary: Color(0xFFFFD262),
    surface: Color(0xFFF9F3DF),
    background: Color(0xFFF4E8C1),
    onPrimary: Color(0xFFF4E8C1),
    onSecondary: Color(0x802B1A00),
    onSurface: Color(0x592B1A00),
    onBackground: Color(0xFF2B1A00),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,

  primaryColor: const Color(0xFFEB9100), // Soft Wheat
  scaffoldBackgroundColor: const Color(0xFF1A1200), // Rich coffee bean dark
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF2E1F00), // Deep chocolate
    elevation: 6,
  ),
  cardColor: const Color(0xFFFFFFFF), // Dark surface for glassy contrast
  iconTheme: const IconThemeData(color: Color(0xFFE0D8B8)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFE0D8B8),
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    titleLarge: TextStyle(
      color: Color(0xFFFFD262),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD1791B),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFD2C084),
    secondary: Color(0xFFFFD262),
    surface: Color(0xFF4C3515),
    background: Color(0xFF1A1200),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Color(0x80E0D8B8),
    onBackground: Color(0xFFE0D8B8),
  ),
);



// Main screen widget
class MainPage extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const MainPage({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultScreen(themeNotifier: themeNotifier),
    );
  }
}

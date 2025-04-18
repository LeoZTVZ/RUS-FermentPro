import 'package:FermentPro/components/circle_frosted_glass.dart';
import 'package:FermentPro/components/frosted_glass.dart';
import 'package:FermentPro/components/sunicon_widget.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:FermentPro/components/thermometer_widget.dart'; // Importing the separated thermometer widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final double currentTemperature = 70; // You can change this value!

  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: currentTemperature).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalMargin = 16.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'FermentPro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              FrostedGlass(
                theWidth: screenWidth - (horizontalMargin * 2),
                theHeight: 650, // Increased height to fit both thermometers
                enableAnimatedBorder: false,
                gradientColors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.surface,
                ],
                innerPadding: const EdgeInsets.fromLTRB(20,20,20,20),
                theChild: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // First thermometer
                    CircleFrostedGlass(
                      diameter: 260,
                      enableAnimatedBorder: false,
                      innerPadding: const EdgeInsets.all(36),
                      gradientColors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.background,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.inversePrimary,
                      ],
                      theChild: AnimatedBuilder(
                        animation: _fillAnimation,
                        builder: (context, child) {
                          return ThermometerIconFill(
                            temperature: _fillAnimation.value,
                            minTemp: 0,
                            maxTemp: 100,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Divider
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 32),

                    // Second thermometer
                    CircleFrostedGlass(
                      diameter: 260,
                      enableAnimatedBorder: false,
                      innerPadding: const EdgeInsets.all(36),
                      gradientColors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.background,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.inversePrimary,
                      ],
                      theChild: AnimatedBuilder(
                        animation: _fillAnimation,
                        builder: (context, child) {
                          return SunIcon(
                            co2Value: _fillAnimation.value, // Pass your animated CO₂ value here
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


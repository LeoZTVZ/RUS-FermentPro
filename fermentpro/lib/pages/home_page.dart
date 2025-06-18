import 'package:FermentPro/components/circle_frosted_glass.dart';
import 'package:FermentPro/components/frosted_glass.dart';
import 'package:FermentPro/components/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:FermentPro/components/bubbles_widget.dart';

import '../models/fermentRecord.dart'; // Importing the separated thermometer widget

class HomePage extends StatefulWidget {
  final FermentRecordModel? latestRecord;

  const HomePage({super.key, required this.latestRecord});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fillAnimation;
  late FermentRecordModel? latestRecord;

  @override
  void initState() {
    super.initState();
    latestRecord = widget.latestRecord;


    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: latestRecord!.photoSensor.toDouble()).animate(
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
                  Theme.of(context).colorScheme.surface,
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
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.inversePrimary,
                      ],
                      theChild: AnimatedBuilder(
                        animation: _fillAnimation,
                        builder: (context, child) {
                          return BubblesIconFill(
                            co2value: _fillAnimation.value,
                            minValue: 0,
                            maxValue: 10,
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
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.inversePrimary,
                      ],
                      theChild: AnimatedBuilder(
                        animation: _fillAnimation,
                        builder: (context, child) {
                          return TimeIcon(
                            latestTime: latestRecord!.dateTime, // Pass your animated CO₂ value here
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


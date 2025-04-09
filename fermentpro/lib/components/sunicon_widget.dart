import 'package:flutter/material.dart';

class SunIcon extends StatefulWidget {
  final double co2Value;

  const SunIcon({
    super.key,
    required this.co2Value,
  });

  @override
  State<SunIcon> createState() => _SunIconState();
}

class _SunIconState extends State<SunIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(); // Keeps the sun spinning
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = constraints.maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: Icon(
                Icons.wb_sunny_rounded,
                size: size * 0.7,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.co2Value.toStringAsFixed(1)} CO₂/min',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}

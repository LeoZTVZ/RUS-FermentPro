import 'package:flutter/material.dart';



class TimeIcon extends StatefulWidget {
  final String latestTime;

  const TimeIcon({
    super.key,
    required this.latestTime,
  });

  @override
  State<TimeIcon> createState() => _TimeIconState();
}

class _TimeIconState extends State<TimeIcon> with SingleTickerProviderStateMixin {
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
                Icons.hourglass_empty_rounded,
                size: size * 0.7,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
        widget.latestTime, // Formatted time
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

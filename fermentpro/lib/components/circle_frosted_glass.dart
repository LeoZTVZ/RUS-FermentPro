import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CircleFrostedGlass extends StatefulWidget {
  const CircleFrostedGlass({
    super.key,
    required this.diameter,
    required this.theChild,
    this.elevation = 16.0,
    this.innerPadding = const EdgeInsets.all(16.0),
    this.enableAnimatedBorder = false,
    this.gradientColors = const [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
    ],
  });

  final double diameter;
  final Widget theChild;
  final double elevation;
  final EdgeInsets innerPadding;
  final bool enableAnimatedBorder;
  final List<Color> gradientColors;

  @override
  State<CircleFrostedGlass> createState() => _CircleFrostedGlass();
}

class _CircleFrostedGlass extends State<CircleFrostedGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimatedBorder) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 12),
      )..repeat();
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimatedBorder) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel( // UPDATED: adds elevation and shadow
      color: Colors.transparent,
      elevation: widget.elevation,
      shape: BoxShape.circle,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      child: ClipOval( // UPDATED: clip into perfect circle
        child: Container(
          width: widget.diameter,
          height: widget.diameter,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Frosted background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(color: Colors.transparent),
              ),
              // Inner glass gradient + static border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // UPDATED
                  border: Border.all(
                    color: Theme.of(context).cardColor.withAlpha(15),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface.withAlpha(100),
                      Theme.of(context).colorScheme.surface.withAlpha(50),
                    ],
                  ),
                ),
              ),
              // Optional animated glowing border
              if (widget.enableAnimatedBorder)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return CustomPaint(
                      size: Size(widget.diameter, widget.diameter),
                      painter: _GlowBorderPainter(
                        animationValue: _controller.value,
                        colors: widget.gradientColors,
                      ),
                    );
                  },
                ),
              // Child content
              Padding(
                padding: widget.innerPadding,
                child: widget.theChild,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBorderPainter extends CustomPainter {
  _GlowBorderPainter({
    required this.animationValue,
    required this.colors,
  });

  final double animationValue;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;

    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0.0,
        endAngle: 2 * pi,
        transform: GradientRotation(2 * pi * animationValue),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(center, radius - 2, paint); // UPDATED: ensure glowing circle border
  }

  @override
  bool shouldRepaint(covariant _GlowBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
          oldDelegate.colors != colors;
}

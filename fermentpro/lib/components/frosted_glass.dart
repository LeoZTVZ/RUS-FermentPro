import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class FrostedGlass extends StatefulWidget {
  const FrostedGlass({
    super.key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
    this.innerPadding = const EdgeInsets.all(16.0),
    this.enableAnimatedBorder = false,
    this.gradientColors = const [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
    ],
  });

  final double theWidth;
  final double theHeight;
  final Widget theChild;
  final EdgeInsets innerPadding;
  final bool enableAnimatedBorder;
  final List<Color> gradientColors;

  @override
  State<FrostedGlass> createState() => _FrostedGlassState();
}

class _FrostedGlassState extends State<FrostedGlass>
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: widget.theWidth,
        height: widget.theHeight,
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
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).cardColor.withAlpha(33),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).cardColor.withAlpha(40),
                    Theme.of(context).cardColor.withAlpha(13),
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
                    size: Size(widget.theWidth, widget.theHeight),
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
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0.0,
        endAngle: 2 * pi,
        transform: GradientRotation(2 * pi * animationValue),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final RRect borderRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(30),
    );

    canvas.drawRRect(borderRect, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
          oldDelegate.colors != colors;
}

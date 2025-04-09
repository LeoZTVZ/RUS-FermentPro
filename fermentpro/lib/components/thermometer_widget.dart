import 'package:flutter/material.dart';

class ThermometerIconFill extends StatelessWidget {
  final double temperature;
  final double minTemp;
  final double maxTemp;

  const ThermometerIconFill({
    super.key,
    required this.temperature,
    this.minTemp = 0,
    this.maxTemp = 100,
  });

  @override
  Widget build(BuildContext context) {
    final double fillPercent =
    ((temperature - minTemp) / (maxTemp - minTemp)).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalHeight = constraints.maxHeight;
        final double iconHeight = totalHeight * 0.8;
        final double textHeight = totalHeight * 0.2;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: iconHeight,
              width: iconHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.device_thermostat_rounded,
                    size: iconHeight,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  ClipPath(
                    clipper: _ThermometerFillClipper(fillPercent),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.red, Colors.yellow],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Icon(
                        Icons.thermostat,
                        size: iconHeight,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: textHeight * 0.2), // Small spacing between icon and text
            SizedBox(
              height: textHeight * 0.8,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThermometerFillClipper extends CustomClipper<Path> {
  final double fillPercent;

  _ThermometerFillClipper(this.fillPercent);

  @override
  Path getClip(Size size) {
    final double fillHeight = size.height * fillPercent;
    return Path()
      ..addRect(Rect.fromLTRB(0, size.height - fillHeight, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant _ThermometerFillClipper oldClipper) {
    return oldClipper.fillPercent != fillPercent;
  }
}

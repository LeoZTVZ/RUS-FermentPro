import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/fermentRecord.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key, required this.records});

  final List<FermentRecordModel> records;

  @override
  Widget build(BuildContext context) {
    final sortedRecords = records
        .where((r) => r.dateTime != null)
        .toList()
      ..sort((a, b) =>
          parseDateTime(a.dateTime!).compareTo(parseDateTime(b.dateTime!)));

    if (sortedRecords.isEmpty) {
      return const Center(child: Text('No data'));
    }

    List<FlSpot> temperatureSpots = [];
    List<FlSpot> photoSensorSpots = [];
    Map<double, DateTime> xValueToTime = {}; // Map x value to datetime for labels

    for (int i = 0; i < sortedRecords.length; i++) {
      final record = sortedRecords[i];
      final time = parseDateTime(record.dateTime!);
      final x = i.toDouble(); // Assign simple index-based x-axis

      if (record.temperature != null) {
        temperatureSpots.add(FlSpot(x, record.temperature));
        xValueToTime[x] = time;
      }

      if (record.photoSensor != null) {
        photoSensorSpots.add(FlSpot(x, record.photoSensor!.toDouble()));
        xValueToTime[x] = time;
      }
    }

    final allSpots = [...temperatureSpots, ...photoSensorSpots];
    final maxX = allSpots.map((e) => e.x).fold<double>(0, (a, b) => a > b ? a : b);
    final maxY = allSpots.map((e) => e.y).fold<double>(0, (a, b) => a > b ? a : b);

    return InteractiveViewer(
      constrained: false,
      scaleEnabled: true, // Allow pinch zoom
      panEnabled: true,   // Allow panning
      minScale: 1,
      maxScale: 5,
      child: SizedBox(
        width: (maxX + 3) * 50, // 50px per record roughly
        height: 300,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.transparent,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (xValueToTime.containsKey(value)) {
                      final time = xValueToTime[value]!;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  reservedSize: 32,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 5,
                  getTitlesWidget: (value, meta) => Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
                  ),
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide top titles
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true, // Use built-in touches
              touchTooltipData: LineTouchTooltipData(
                //tooltipBgColor: Colors.black.withOpacity(0.7), // Background for tooltip
                fitInsideHorizontally: true, // Important: don't overflow outside left/right
                fitInsideVertically: true,   // Important: don't overflow outside top/bottom
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final isTemperature = spot.bar.color == Colors.orange;
                    return LineTooltipItem(
                      '${isTemperature ? 'Temp' : 'Light'}\n${spot.y.toStringAsFixed(1)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.orange,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.orange,
                    strokeColor: Colors.white,
                  ),
                ),
                spots: temperatureSpots,
              ),
              LineChartBarData(
                isCurved: true,
                color: Colors.greenAccent,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.greenAccent,
                    strokeColor: Colors.white,
                  ),
                ),
                spots: photoSensorSpots,
              ),
            ],
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY + 10,
          ),
        ),
      ),
    );
  }

  DateTime parseDateTime(String input) {
    final parts = input.split(' ');
    final timePart = parts[0].split(':');
    final datePart = parts[1].split('.');
    return DateTime(
      int.parse(datePart[2]),
      int.parse(datePart[1]),
      int.parse(datePart[0]),
      int.parse(timePart[0]),
      int.parse(timePart[1]),
      int.parse(timePart[2]),
    );
  }
}

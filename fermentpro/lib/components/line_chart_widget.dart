import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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

    final baseTime = parseDateTime(sortedRecords.first.dateTime!);

    List<FlSpot> temperatureSpots = [];
    List<FlSpot> photoSensorSpots = [];

    for (var record in sortedRecords) {
      final time = parseDateTime(record.dateTime!);
      final secondsSinceStart = time.difference(baseTime).inSeconds.toDouble();

      if (record.temperature != null) {
        temperatureSpots.add(FlSpot(secondsSinceStart, record.temperature.toDouble()));
      }

      if (record.photoSensor != null) {
        photoSensorSpots.add(FlSpot(secondsSinceStart, record.photoSensor.toDouble()));
      }
    }

    // Determine maxX to stretch chart width
    final maxX = [
      ...temperatureSpots.map((e) => e.x),
      ...photoSensorSpots.map((e) => e.x)
    ].fold<double>(0, (a, b) => a > b ? a : b);

    // Chart width in pixels (e.g., 100 pixels per minute)
    final chartWidth = maxX + 60 * 10; // extend for smooth scroll

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: 300,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.transparent,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 60,
                  getTitlesWidget: (value, meta) {
                    final time = baseTime.add(Duration(seconds: value.toInt()));
                    return Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 5,
                  getTitlesWidget: (value, meta) => Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.orange,
                dotData: FlDotData(show: false),
                spots: temperatureSpots,
              ),
              LineChartBarData(
                isCurved: true,
                color: Colors.greenAccent,
                dotData: FlDotData(show: false),
                spots: photoSensorSpots,
              ),
            ],
            minX: 0,
            maxX: maxX + 10,
            minY: 0,
            maxY: [
              ...temperatureSpots.map((e) => e.y),
              ...photoSensorSpots.map((e) => e.y)
            ].fold<double>(0, (prev, curr) => curr > prev ? curr : prev) + 10,
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

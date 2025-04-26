import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../components/frosted_glass.dart';
import '../components/line_chart_widget.dart';
import '../models/fermentRecord.dart';

class DataPage extends StatelessWidget {
  final List<FermentRecordModel> records;

  const DataPage({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalMargin = 16.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Fermentation Summary"),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
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
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: FrostedGlass(
                theWidth: screenWidth - (horizontalMargin * 2),
                theHeight: 400,
                theChild: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChartWidget(records: records),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final record = records[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 10),
                  child: FrostedGlass(
                    theWidth: screenWidth - (horizontalMargin * 2),
                    theHeight: 200,
                    theChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID: ${record.id}",
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Temperature: ${record.temperature} °C",
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Bubble Count: ${record.photoSensor}",
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: records.length,
            ),
          ),
        ],
      ),
    );
  }
}

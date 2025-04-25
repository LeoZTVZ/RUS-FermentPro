import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../components/frosted_glass.dart';
import '../components/line_chart_widget.dart';
import '../models/fermentRecord.dart';
import '../services/firebase_service.dart';
import '../models/bubble_count.dart';
import '../models/temperature.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  // Fetch ferment records and map them to a list of key-value pairs.
  Future<List<FermentRecordModel>> _loadRecords() async {
    final firebaseService = FirebaseService();
    final records = await firebaseService.fetchFermentRecords();

    // Convert List<Map<String, dynamic>> to List<FermentRecordModel>
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FermentRecordModel>>(
        future: _loadRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final dataPairs = snapshot.data!;
          final screenWidth = MediaQuery.of(context).size.width;
          const horizontalMargin = 16.0;

          return CustomScrollView(
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

              // Frosted Glass Widget for LineChartWidget
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: FrostedGlass(
                    theWidth: screenWidth - (horizontalMargin * 2),
                    theHeight: 400, // Height to fit chart
                    theChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChartWidget(
                        records: dataPairs, // Pass the records here
                      ),
                    ),
                  ),
                ),
              ),

              // Original data list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final record = dataPairs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 10,
                      ),
                      child: FrostedGlass(
                        theWidth: screenWidth - (horizontalMargin * 2),
                        theHeight: 200,
                        theChild: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ID: ${record.id}", style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),),
                              Text("Temperature: ${record.temperature} °C",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text("Bubble Count: ${record.photoSensor}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: dataPairs.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../components/frosted_glass.dart';
import '../components/line_chart_widget.dart';
import '../services/firebase_service.dart';
import '../models/bubble_count.dart';
import '../models/temperature.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  Future<List<Map<String, dynamic>>> _loadPairedData() async {
    final firebaseService = FirebaseService();
    final bubbleCounts = await firebaseService.fetchBubbleCounts();
    final temperatures = await firebaseService.fetchTemperatures();

    final List<Map<String, dynamic>> pairedData = [];

    for (var temp in temperatures) {
      BubbleCount? match;
      try {
        match = bubbleCounts.firstWhere((b) => b.id == temp.id);
      } catch (_) {
        match = null;
      }

      if (match != null) {
        pairedData.add({'temperature': temp, 'bubbleCount': match});
      }
    }

    return pairedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadPairedData(),
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

              // NEW FrostedGlass Widget above the list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: FrostedGlass(
                    theWidth: screenWidth - (horizontalMargin * 2),
                    theHeight: 400, // Increased height to fit both thermometers
                    theChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChartWidget(),
                    ),
                  ),
                ),
              ),

              // Original data list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final pair = dataPairs[index];
                    final temp = pair['temperature'] as Temperature;
                    final bubble = pair['bubbleCount'] as BubbleCount;

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
                              Text("ID: ${temp.id}",  style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),),
                              Text("Temperature: ${temp.value} °C",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text("Bubble Count: ${bubble.count}",
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

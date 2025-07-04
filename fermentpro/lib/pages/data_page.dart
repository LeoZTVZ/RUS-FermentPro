import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/filter_dialog.dart';
import '../components/frosted_glass.dart';
import '../components/line_chart_widget.dart';
import '../models/fermentRecord.dart';

class DataPage extends StatefulWidget {
  final List<FermentRecordModel> records;

  const DataPage({super.key, required this.records});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<FermentRecordModel> filteredRecords = [];

  String? sortBy; // 'date', 'deviceId', 'type'
  bool ascending = true;

  DateTime? selectedDate;
  String? selectedDeviceId;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    filteredRecords = List.from(widget.records);
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterDialog(
        selectedDate: selectedDate,
        selectedDeviceId: selectedDeviceId,
        selectedType: selectedType,
        sortBy: sortBy,
        ascending: ascending,
        allRecords: widget.records,
        onApply: ({
          DateTime? date,
          String? deviceId,
          String? type,
          String? sortBy,
          bool ascending = true,
          bool clear = false,
          List<FermentRecordModel>? filteredRecords,
        }) {
          setState(() {
            if (clear) {
              selectedDate = null;
              selectedDeviceId = null;
              selectedType = null;
              this.sortBy = null;
              this.ascending = true;
              this.filteredRecords = List.from(widget.records);
            } else {
              selectedDate = date;
              selectedDeviceId = deviceId;
              selectedType = type;
              this.sortBy = sortBy;
              this.ascending = ascending;
              this.filteredRecords = filteredRecords ?? List.from(widget.records);
            }
          });
        },
      ),
    );
  }



  void _applySortAndFilter() {
    final dateFormat = DateFormat("HH:mm:ss d.M.yyyy.");

    setState(() {
      filteredRecords = widget.records.where((record) {
        final matchesDate = selectedDate == null
            || dateFormat.parse(record.dateTime).year == selectedDate!.year
                && dateFormat.parse(record.dateTime).month == selectedDate!.month
                && dateFormat.parse(record.dateTime).day == selectedDate!.day;

        final matchesDeviceId = selectedDeviceId == null || selectedDeviceId == '' || record.deviceId == selectedDeviceId;
        final matchesType = selectedType == null || selectedType == '' || record.type == selectedType;

        return matchesDate && matchesDeviceId && matchesType;
      }).toList();

      // Sorting
      filteredRecords.sort((a, b) {
        dynamic valA, valB;

        switch (sortBy) {
          case 'date':
            valA = dateFormat.parse(a.dateTime);
            valB = dateFormat.parse(b.dateTime);
            break;
          case 'deviceId':
            valA = a.deviceId;
            valB = b.deviceId;
            break;
          case 'type':
            valA = a.type;
            valB = b.type;
            break;
          default:
            return 0;
        }

        if (valA is Comparable && valB is Comparable) {
          return ascending ? valA.compareTo(valB) : valB.compareTo(valA);
        }

        return 0;
      });
    });
  }

  Widget _sortOption(String title, String value, void Function(void Function()) setModalState) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: sortBy,
      onChanged: (val) {
        setModalState(() => sortBy = val);
      },
    );
  }


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

          // Chart card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: FrostedGlass(
                theWidth: screenWidth - (horizontalMargin * 2),
                theHeight: 400,
                theChild: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChartWidget(records: filteredRecords),
                ),
              ),
            ),
          ),

          // Filter/Sort Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Records", style: Theme.of(context).textTheme.titleLarge),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.sort),
                    label: const Text("Filter & Sort"),
                    onPressed: _openFilterDialog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Records List
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final record = filteredRecords[index];
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
                          Text("ID: ${record.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Device ID: ${record.deviceId}"),
                          Text("Type: ${record.type}"),
                          Text("Temperature: ${record.bottleVolume} °C"),
                          Text("Bubble Count: ${record.photoSensor}"),
                          Text("Date: ${record.dateTime}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredRecords.length,
            ),
          ),
        ],
      ),
    );
  }
}

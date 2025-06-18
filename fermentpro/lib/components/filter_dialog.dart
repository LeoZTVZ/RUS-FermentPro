import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/fermentRecord.dart';

class FilterDialog extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedDeviceId;
  final String? selectedType;
  final String? sortBy;
  final bool ascending;
  final List<FermentRecordModel> allRecords;

  final void Function({
  DateTime? date,
  String? deviceId,
  String? type,
  String? sortBy,
  bool ascending,
  bool clear,
  List<FermentRecordModel>? filteredRecords,
  }) onApply;

  const FilterDialog({
    super.key,
    required this.selectedDate,
    required this.selectedDeviceId,
    required this.selectedType,
    required this.sortBy,
    required this.ascending,
    required this.allRecords,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  Set<DateTime> selectedDates = {};
  late String? deviceId;
  late String? type;
  late String? sortBy;
  late bool ascending;

  @override
  void initState() {
    super.initState();
    deviceId = widget.selectedDeviceId;
    type = widget.selectedType;
    sortBy = widget.sortBy;
    ascending = widget.ascending;
    if (widget.selectedDate != null) {
      selectedDates.add(DateTime(
        widget.selectedDate!.year,
        widget.selectedDate!.month,
        widget.selectedDate!.day,
      ));
    }
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime? _tryParseDate(String date, DateFormat format) {
    try {
      return format.parse(date);
    } catch (_) {
      return null;
    }
  }

  List<FermentRecordModel> _filterRecords() {
    final dateTimeFormat = DateFormat("HH:mm:ss d.M.yyyy.");
    return widget.allRecords.where((record) {
      final recordDate = _tryParseDate(record.dateTime, dateTimeFormat);

      final dateMatch = selectedDates.isEmpty ||
          (recordDate != null &&
              selectedDates.any((d) => _isSameDay(d, recordDate)));

      final deviceMatch = deviceId == null || deviceId!.isEmpty || record.deviceId == deviceId;
      final typeMatch = type == null || type!.isEmpty || record.type == type;

      return dateMatch && deviceMatch && typeMatch;
    }).toList()
      ..sort((a, b) {
        int compare;
        final ad = _tryParseDate(a.dateTime, dateTimeFormat);
        final bd = _tryParseDate(b.dateTime, dateTimeFormat);

        switch (sortBy) {
          case "date":
            compare = (ad ?? DateTime(0)).compareTo(bd ?? DateTime(0));
            break;
          case "deviceId":
            compare = a.deviceId.compareTo(b.deviceId);
            break;
          case "type":
            compare = a.type.compareTo(b.type);
            break;
          default:
            compare = 0;
        }
        return ascending ? compare : -compare;
      });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> deviceIds =
    widget.allRecords.map((e) => e.deviceId).toSet().toList();
    final List<String> types =
    widget.allRecords.map((e) => e.type).toSet().toList();
    final dateFormat = DateFormat("d.M.yyyy.");

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                selectedDates.isNotEmpty
                    ? "Selected dates:\n${(selectedDates.toList()..sort()).map(dateFormat.format).join(', ')}"
                    : "Pick dates",
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final dateTimeFormat = DateFormat("HH:mm:ss d.M.yyyy.");

                final validDates = widget.allRecords
                    .map((e) => _tryParseDate(e.dateTime, dateTimeFormat))
                    .whereType<DateTime>()
                    .map((d) => DateTime(d.year, d.month, d.day))
                    .toSet();

                if (validDates.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No available dates.")),
                  );
                  return;
                }

                DateTime focusedDay =
                selectedDates.isNotEmpty ? selectedDates.first : validDates.first;

                await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return AlertDialog(
                          title: const Text("Select Dates"),
                          content: SizedBox(
                            height: 400,
                            width: double.maxFinite,
                            child: TableCalendar(
                              firstDay: DateTime(2020),
                              lastDay: DateTime.now().add(const Duration(days: 365)),
                              focusedDay: focusedDay,
                              calendarFormat: calendarFormat,
                              selectedDayPredicate: (day) {
                                final normalized = DateTime(day.year, day.month, day.day);
                                return selectedDates.any(
                                      (selected) => _isSameDay(selected, normalized),
                                );
                              },
                              onFormatChanged: (format) {
                                if (format != calendarFormat) {
                                  setState(() {
                                    calendarFormat = format;
                                  });
                                  setStateDialog(() {});
                                }
                              },
                              availableGestures: AvailableGestures.all,
                              enabledDayPredicate: (day) {
                                final normalized = DateTime(day.year, day.month, day.day);
                                return validDates.contains(normalized);
                              },
                              onDaySelected: (pickedDay, _) {
                                final normalized = DateTime(pickedDay.year, pickedDay.month, pickedDay.day);
                                if (validDates.contains(normalized)) {
                                  setStateDialog(() {
                                    if (selectedDates.any((d) => _isSameDay(d, normalized))) {
                                      selectedDates.removeWhere((d) => _isSameDay(d, normalized));
                                    } else {
                                      selectedDates.add(normalized);
                                    }
                                  });
                                }
                              },
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, _) {
                                  final normalized = DateTime(day.year, day.month, day.day);
                                  if (validDates.contains(normalized)) {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                                selectedBuilder: (context, day, _) {
                                  final normalized = DateTime(day.year, day.month, day.day);
                                  if (selectedDates.any((d) => _isSameDay(d, normalized))) {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.red.shade900, width: 2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                                todayBuilder: (context, day, _) {
                                  final normalized = DateTime(day.year, day.month, day.day);
                                  if (_isSameDay(DateTime.now(), normalized) &&
                                      validDates.contains(normalized)) {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.green.shade900, width: 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Done"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),

            // Device ID Autocomplete
            Autocomplete<String>(
              initialValue: TextEditingValue(text: deviceId ?? ''),
              optionsBuilder: (TextEditingValue value) {
                return deviceIds.where((id) =>
                    id.toLowerCase().contains(value.text.toLowerCase()));
              },
              onSelected: (value) {
                setState(() {
                  deviceId = value;
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Device ID"),
                );
              },
            ),

            // Type Autocomplete
            Autocomplete<String>(
              initialValue: TextEditingValue(text: type ?? ''),
              optionsBuilder: (TextEditingValue value) {
                return types.where((t) =>
                    t.toLowerCase().contains(value.text.toLowerCase()));
              },
              onSelected: (value) {
                setState(() {
                  type = value;
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: "Type"),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text("Sort By"),

            DropdownButton<String?>(
              value: sortBy,
              items: const [
                DropdownMenuItem(value: null, child: Text("None")),
                DropdownMenuItem(value: "date", child: Text("Date")),
                DropdownMenuItem(value: "deviceId", child: Text("Device ID")),
                DropdownMenuItem(value: "type", child: Text("Type")),
              ],
              onChanged: (value) {
                setState(() {
                  sortBy = value;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ascending"),
                Switch(
                  value: ascending,
                  onChanged: (value) {
                    setState(() {
                      ascending = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.clear_all),
              label: const Text("Clear All Filters"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                widget.onApply(
                  date: null,
                  deviceId: null,
                  type: null,
                  sortBy: null,
                  ascending: true,
                  clear: true,
                  filteredRecords: widget.allRecords,
                );
                Navigator.of(context).pop();
              },
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Apply"),
              onPressed: () {
                final filtered = _filterRecords();
                widget.onApply(
                  date: selectedDates.isNotEmpty ? selectedDates.first : null,
                  deviceId: deviceId,
                  type: type,
                  sortBy: sortBy,
                  ascending: ascending,
                  clear: false,
                  filteredRecords: filtered,
                );
                Navigator.of(context).pop();
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:FermentPro/models/bubble_count.dart';
import 'package:http/http.dart' as http;

import '../models/fermentRecord.dart';
import '../models/temperature.dart';

class FirebaseService {
  final String baseUrl = "https://smartferment-default-rtdb.europe-west1.firebasedatabase.app/";



  Future<List<FermentRecordModel>> fetchFermentRecords() async {
    final response = await http.get(Uri.parse('$baseUrl/fermentRecord.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.entries.map((entry) {
        return FermentRecordModel.fromJson(entry.key, entry.value);
      }).toList();
    } else {
      throw Exception('Failed to load ferment records');
    }
  }

}

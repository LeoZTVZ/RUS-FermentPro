import 'dart:convert';
import 'package:FermentPro/models/bubble_count.dart';
import 'package:http/http.dart' as http;

import '../models/temperature.dart';

class FirebaseService {
  final String baseUrl = "https://smartferment-default-rtdb.europe-west1.firebasedatabase.app/";

  Future<List<BubbleCount>> fetchBubbleCounts() async {
    final response = await http.get(Uri.parse('$baseUrl/bubbleCount.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.values.map((e) => BubbleCount.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load bubble counts');
    }
  }

  Future<List<Temperature>> fetchTemperatures() async {
    final response = await http.get(Uri.parse('$baseUrl/temperatura.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.values.map((e) => Temperature.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load temperatures');
    }
  }
}

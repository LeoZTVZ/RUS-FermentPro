import 'package:riverpod/riverpod.dart';
import '../services/firebase_service.dart';
import '../models/bubble_count.dart';
import '../models/temperature.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final bubbleCountProvider = FutureProvider<List<BubbleCount>>((ref) async {
  final service = ref.read(firebaseServiceProvider);
  return service.fetchBubbleCounts();
});

final temperatureProvider = FutureProvider<List<Temperature>>((ref) async {
  final service = ref.read(firebaseServiceProvider);
  return service.fetchTemperatures();
});

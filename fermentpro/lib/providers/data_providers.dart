import 'package:riverpod/riverpod.dart';
import '../models/fermentRecord.dart';
import '../services/firebase_service.dart';


final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final fermentRecordProvider = FutureProvider<List<FermentRecordModel>>((ref) async {
  final service = ref.read(firebaseServiceProvider);
  return service.fetchFermentRecords();
});

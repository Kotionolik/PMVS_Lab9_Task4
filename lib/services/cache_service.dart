import 'package:hive_flutter/hive_flutter.dart';
import '../models/parking_lot.dart';

class CacheService {
  static const _boxName = 'parking_cache';
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }
  Future<void> saveParkingLots(List<ParkingLot> lots) async {
    final box = Hive.box(_boxName);
    await box.put('lots', lots.map((e) => e.toMap()).toList());
  }
  List<ParkingLot> getCachedLots() {
  try {
    final box = Hive.box(_boxName);
    final data = box.get('lots', defaultValue: []) as List;
    return data.map((e) => ParkingLot.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  } catch (e, s) {
    print('CacheService.getCachedLots: $e\n$s');
    return [];
  }
  }
  Future<void> clear() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
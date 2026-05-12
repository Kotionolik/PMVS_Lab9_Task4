import 'package:flutter/material.dart';
import 'services/database_helper.dart';
import 'services/cache_service.dart';
import 'services/notification_service.dart';
import 'app.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseHelper.initDatabase();
    await CacheService.init();
    await NotificationService.init();
  } catch (e, s) {
    print('Initialization error: $e\n$s');
  }
  runApp(const CityParkingApp());
}
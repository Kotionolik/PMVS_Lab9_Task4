import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/parking_lot.dart';
import '../models/booking.dart';
import '../models/payment.dart';

class DatabaseHelper {
  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }
  static Future<void> initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    await database;
  }
  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'parking.db'), version: 1, onCreate: _onCreate);
  }
  static Future<void> _onCreate(Database db, int v) async {
    await db.execute('''
    CREATE TABLE parking_lots(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL, latitude REAL, longitude REAL,
      total_spots INTEGER, free_spots INTEGER,
      price_per_hour REAL, is_favorite INTEGER DEFAULT 0
    )''');
    await db.execute('''
    CREATE TABLE bookings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      parking_lot_id INTEGER, start_time TEXT, end_time TEXT,
      status TEXT DEFAULT 'active', payment_id INTEGER
    )''');
    await db.execute('''
    CREATE TABLE payments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      booking_id INTEGER, amount REAL,
      timestamp TEXT, success INTEGER DEFAULT 0
    )''');
    await db.insert('parking_lots', {'name': 'Central Parking',
      'latitude': 53.893009, 'longitude': 27.567444,
      'total_spots': 100, 'free_spots': 34, 'price_per_hour': 2.5});
    await db.insert('parking_lots', {'name': 'Station Parking',
      'latitude': 53.890670, 'longitude': 27.552835,
      'total_spots': 80, 'free_spots': 12, 'price_per_hour': 1.8});
    await db.insert('parking_lots', {'name': 'Mall Parking',
      'latitude': 53.906185, 'longitude': 27.556816,
      'total_spots': 200, 'free_spots': 150, 'price_per_hour': 1.0});
  }
  Future<List<ParkingLot>> getParkingLots() async {
    try {
      final db = await database;
      final m = await db.query('parking_lots');
      return m.map((e) => ParkingLot.fromMap(e)).toList();
    } catch (e, s) { print('getParkingLots: $e\n$s'); rethrow; }
  }
  Future<int> insertBooking(Booking b) async {
    final db = await database;
    final id = await db.insert('bookings', b.toMap());
    await db.rawUpdate(
      'UPDATE parking_lots SET free_spots = free_spots - 1 WHERE id = ? AND free_spots > 0',
      [b.parkingLotId]);
    return id;
  }
  Future<List<Booking>> getBookings() async {
    final db = await database;
    final m = await db.query('bookings', orderBy: 'id DESC');
    return m.map((e) => Booking.fromMap(e)).toList();
  }
  Future<void> cancelBooking(int id) async {
    final db = await database;
    await db.update('bookings', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> insertPayment(Payment p) async {
    final db = await database;
    return db.insert('payments', p.toMap());
  }
  Future<void> toggleFavorite(int id, bool v) async {
    final db = await database;
    await db.update('parking_lots', {'is_favorite': v ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
}
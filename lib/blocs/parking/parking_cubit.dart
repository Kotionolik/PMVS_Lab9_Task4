import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/parking_lot.dart';
import '../../models/booking.dart';
import '../../services/database_helper.dart';
import '../../services/payment_api.dart';
import '../../services/cache_service.dart';
part 'parking_state.dart';
class ParkingCubit extends Cubit<ParkingState> {
  final DatabaseHelper dbHelper;
  final PaymentApi paymentApi;
  final CacheService cache;
  ParkingCubit(this.dbHelper, this.paymentApi, this.cache) : super(const ParkingState());
  Future<void> loadParkingLots({bool offline = false}) async {
    emit(state.copyWith(status: ParkingStatus.loading));
    try {
      if (offline) {
        emit(state.copyWith(status: ParkingStatus.loaded,
          parkingLots: cache.getCachedLots(), isOffline: true));
        return;
      }
      final lots = await dbHelper.getParkingLots();
      await cache.saveParkingLots(lots);
      emit(state.copyWith(status: ParkingStatus.loaded,
        parkingLots: lots, isOffline: false));
    } catch (e, s) {
      print('loadParkingLots: $e\n$s');
      emit(state.copyWith(status: ParkingStatus.loaded,
      parkingLots: cache.getCachedLots(), isOffline: true,
        errorMessage: 'Offline mode'));
    }
  }
  void selectParkingLot(ParkingLot lot) => emit(state.copyWith(selectedParking: lot));
  Future<void> toggleFavorite(ParkingLot lot) async {
    final u = lot.copyWith(isFavorite: !lot.isFavorite);
    await dbHelper.toggleFavorite(lot.id!, u.isFavorite);
    emit(state.copyWith(parkingLots: state.parkingLots
      .map((l) => l.id == lot.id ? u : l).toList()));
  }
  Future<void> bookParkingLot({required ParkingLot lot, required String startTime, required String endTime}) async {
    try {
      if (lot.freeSpots <= 0) throw Exception('No free spots');
      final b = Booking(parkingLotId: lot.id!,
        startTime: startTime, endTime: endTime);
      final id = await dbHelper.insertBooking(b);
      final upd = state.parkingLots.map((l) =>
        l.id == lot.id ? l.copyWith(freeSpots: l.freeSpots - 1) : l).toList();
      emit(state.copyWith(status: ParkingStatus.bookingSuccess,
        parkingLots: upd, bookings: [Booking(id: id, parkingLotId: lot.id!,
        startTime: startTime, endTime: endTime), ...state.bookings]));
    } catch (e, s) {
      print('bookParkingLot: $e\n$s');
      emit(state.copyWith(status: ParkingStatus.error,
        errorMessage: e.toString()));
    }
  }
  Future<void> loadBookings() async {
    try {
      emit(state.copyWith(bookings: await dbHelper.getBookings()));
    } catch (e, s) { print('loadBookings: $e\n$s'); }
  }
  Future<void> cancelBooking(int id) async {
    await dbHelper.cancelBooking(id);
    await loadBookings();
  }
}
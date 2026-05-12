part of 'parking_cubit.dart';
enum ParkingStatus { initial, loading, loaded, error, bookingSuccess, paymentSuccess }
class ParkingState {
  final ParkingStatus status;
  final List<ParkingLot> parkingLots;
  final ParkingLot? selectedParking;
  final List<Booking> bookings;
  final String? errorMessage;
  final bool isOffline;
  const ParkingState({this.status = ParkingStatus.initial,
    this.parkingLots = const [], this.selectedParking,
    this.bookings = const [], this.errorMessage,
    this.isOffline = false});
  ParkingState copyWith({ParkingStatus? status,
    List<ParkingLot>? parkingLots, ParkingLot? selectedParking,
    List<Booking>? bookings, String? errorMessage, bool? isOffline}) =>
    ParkingState(
      status: status ?? this.status,
      parkingLots: parkingLots ?? this.parkingLots,
      selectedParking: selectedParking ?? this.selectedParking,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
    );
}
class Booking {
  final int? id;
  final int parkingLotId;
  final String startTime;
  final String endTime;
  final String status;
  final int? paymentId;
  Booking({this.id, required this.parkingLotId,
    required this.startTime, required this.endTime,
    this.status = 'active', this.paymentId});
  factory Booking.fromMap(Map<String, dynamic> m) => Booking(
    id: m['id'] as int?, parkingLotId: m['parking_lot_id'] as int,
    startTime: m['start_time'] as String, endTime: m['end_time'] as String,
    status: m['status'] as String? ?? 'active',
    paymentId: m['payment_id'] as int?,
  );
  Map<String, dynamic> toMap() => {
    'id': id, 'parking_lot_id': parkingLotId,
    'start_time': startTime, 'end_time': endTime,
    'status': status, 'payment_id': paymentId,
  };
}
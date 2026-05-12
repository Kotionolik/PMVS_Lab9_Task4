class Payment {
  final int? id;
  final int bookingId;
  final double amount;
  final String timestamp;
  final bool success;
  Payment({this.id, required this.bookingId,
    required this.amount, required this.timestamp,
    this.success = false});
  factory Payment.fromMap(Map<String, dynamic> m) => Payment(
    id: m['id'] as int?, bookingId: m['booking_id'] as int,
    amount: (m['amount'] as num).toDouble(),
    timestamp: m['timestamp'] as String,
    success: (m['success'] as int) == 1,
  );
  Map<String, dynamic> toMap() => {
    'id': id, 'booking_id': bookingId, 'amount': amount,
    'timestamp': timestamp, 'success': success ? 1 : 0,
  };
}
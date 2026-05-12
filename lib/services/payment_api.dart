import 'package:dio/dio.dart';

class PaymentApi {
  final Dio _dio;
  PaymentApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  Future<bool> processPayment({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required double amount,
  }) async {
    try {
      final r = await _dio.post('/posts', data: {
        'card': cardNumber, 'expiry': expiry,
        'cvv': cvv, 'amount': amount,
      });
      return r.statusCode == 201;
    } on DioException catch (e, s) {
      print('PaymentApi DioException: ${e.message}\n$s');
      return false;
    } catch (e, s) {
      print('PaymentApi error: $e\n$s');
      return false;
    }
  }
}
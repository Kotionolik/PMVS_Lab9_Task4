import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions/context_extensions.dart';
import '../services/payment_api.dart';
import '../services/notification_service.dart';
class PaymentScreenRoute extends StatefulWidget {
  const PaymentScreenRoute({super.key});
  @override
  State<PaymentScreenRoute> createState() => _PaymentScreenRouteState();
}
class _PaymentScreenRouteState extends State<PaymentScreenRoute> {
  final _card = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.payment)),
      body: Form(key: _formKey, child: Padding(padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextFormField(controller: _card, maxLength: 16,
            decoration: InputDecoration(labelText: l10n.cardNumber),
            validator: (v) => v!.length != 16 ? l10n.invalidCard : null
          ),
          TextFormField(controller: _exp, maxLength: 5,
            decoration: InputDecoration(labelText: l10n.expiryDate),
            validator: (v) => v!.length != 5 ? l10n.invalidCard : null
          ),
          TextFormField(controller: _cvv, maxLength: 3, obscureText: true,
            decoration: InputDecoration(labelText: l10n.cvv),
            validator: (v) => v!.length != 3 ? l10n.invalidCard :null
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final ok = await PaymentApi().processPayment(
                cardNumber: _card.text, expiry: _exp.text, cvv: _cvv.text, amount: 10.0
              );
              if (!context.mounted) return;
              await NotificationService.show(
                title: l10n.payment,
                body: ok ? l10n.paymentSuccessful : l10n.error, context: context
              );
              context.go('/home');
            },
            icon: const Icon(Icons.payment),
            label: Text(l10n.pay),
          ),
        ]),
      )),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/parking/parking_cubit.dart';
import '../core/extensions/context_extensions.dart';
import '../services/notification_service.dart';
class BookingScreenRoute extends StatefulWidget {
  final int lotId;
  const BookingScreenRoute({super.key, required this.lotId});
  @override
  State<BookingScreenRoute> createState() => _BookingScreenRouteState();
}
class _BookingScreenRouteState extends State<BookingScreenRoute> {
  DateTime? _date;
  TimeOfDay? _time;
  int _hours = 1;
  Future<void> _pick() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: now,
    firstDate: now, lastDate: now.add(const Duration(days: 30)));
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    if (t == null) return;
    setState(() { _date = d; _time = t; });
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ParkingCubit>().state;
    final lot = state.parkingLots.firstWhere((l) => l.id ==
    widget.lotId);
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.bookNow} — ${lot.name}')),
      body: Padding(padding: const EdgeInsets.all(16), child:
      Column(children: [
        ListTile(title: Text(l10n.selectDateTime),
          subtitle: Text(_date == null ? '—' : '${_date} ${_time}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: _pick
        ),
        TextFormField(initialValue: '1',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.durationHours),
          onChanged: (v) => _hours = int.tryParse(v) ?? 1
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            if (_date == null || _time == null) return;
            final s = DateTime(_date!.year, _date!.month, _date!.day,
              _time!.hour, _time!.minute);
            final e = s.add(Duration(hours: _hours));
            await context.read<ParkingCubit>().bookParkingLot(
              lot: lot, startTime: s.toIso8601String(), endTime:e.toIso8601String()
            );
            await NotificationService.show(
              title: l10n.appTitle, body: l10n.bookingSuccessful, context: context
            );
            if (context.mounted) context.go('/payment');
          },
          child: Text(l10n.confirmBooking),
        ),
      ])),
    );
  }
}
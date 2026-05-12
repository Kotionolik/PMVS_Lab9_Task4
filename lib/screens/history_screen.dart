import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/parking/parking_cubit.dart';
import '../widgets/adaptive_navigation.dart';
import '../core/extensions/context_extensions.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingCubit>().loadBookings();
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveNavigation(
      title: l10n.history, currentIndex: 2,
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (ctx, state) {
          if (state.bookings.isEmpty) {
            return Center(child: Text(l10n.noBookings));
          }
          return ListView.builder(
            itemCount: state.bookings.length,
            itemBuilder: (_, i) {
              final b = state.bookings[i];
              return Dismissible(
                key: ValueKey(b.id),
                onDismissed: (_) => ctx.read<ParkingCubit>().cancelBooking(b.id!),
                child: ListTile(
                  title: Text('${l10n.parkingLot}#${b.parkingLotId}'),
                  subtitle: Text('${l10n.startTime}:${b.startTime}'),
                  trailing: Text(b.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
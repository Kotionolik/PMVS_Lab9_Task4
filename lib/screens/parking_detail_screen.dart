import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/parking/parking_cubit.dart';
import '../core/extensions/context_extensions.dart';
class ParkingDetailScreen extends StatelessWidget {
  final int id;
  const ParkingDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ParkingCubit>().state;
    final lot = state.parkingLots.firstWhere(
    (l) => l.id == id, orElse: () => state.parkingLots.first);
    return Scaffold(
      appBar: AppBar(title: Text(lot.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(tag: 'parking_${lot.id}',
          child: const Icon(Icons.local_parking, size: 96, color: Colors.blue)),
          const SizedBox(height: 12),
          Text('${l10n.freeSpots}: ${lot.freeSpots}/${lot.totalSpots}'),
          Text('${l10n.pricePerHour}: \$${lot.pricePerHour.toStringAsFixed(2)}'),
          const Spacer(),
          ElevatedButton(
            onPressed: () => context.go('/booking/${lot.id}'),
            child: Text(l10n.bookNow),
          ),
        ]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/parking/parking_cubit.dart';
import '../widgets/adaptive_navigation.dart';
import '../core/extensions/context_extensions.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveNavigation(
      title: l10n.favorites, currentIndex: 1,
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (ctx, st) {
          final favs = st.parkingLots.where((l) => l.isFavorite).toList();
          if (favs.isEmpty) return Center(child: Text(l10n.noBookings));
          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (_, i) {
              final lot = favs[i];
              return Dismissible(
                key: ValueKey(lot.id),
                onDismissed: (_) => ctx.read<ParkingCubit>().toggleFavorite(lot),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(lot.name),
                  subtitle: Text('${l10n.freeSpots}: ${lot.freeSpots}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
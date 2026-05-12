import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/parking/parking_cubit.dart';
import '../widgets/adaptive_navigation.dart';
import '../widgets/parking_card.dart';
import '../core/extensions/context_extensions.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingCubit>().loadParkingLots();
  }
  int _cols(BuildContext c) {
    if (c.width >= 2000) return 5;
    if (c.width >= 1400) return 4;
    if (c.width >= 900) return 3;
    if (c.width >= 600) return 2;
    return 1;
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.f5): const
      ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction(
            onInvoke: (_) => context.read<ParkingCubit>().loadParkingLots(),
          ),
        },
        child: AdaptiveNavigation(
          title: l10n.home, currentIndex: 0,
          body: BlocBuilder<ParkingCubit, ParkingState>(
            builder: (ctx, state) {
              if (state.status == ParkingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(children: [
                if (state.isOffline)
                Container(color: Colors.orange,
                padding: const EdgeInsets.all(8),
                child: Text(l10n.offline)), Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: GridView.builder(
                      key: ValueKey(state.parkingLots.length),
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _cols(ctx),
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 12, mainAxisSpacing: 12,
                      ),
                      itemCount: state.parkingLots.length,
                      itemBuilder: (_, i) {
                        final lot = state.parkingLots[i];
                        return ParkingCard(
                          lot: lot,
                          onTap: () => ctx.go('/parking/${lot.id}'),
                          onFavorite: () => ctx.read<ParkingCubit>().toggleFavorite(lot),
                        );
                      },
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
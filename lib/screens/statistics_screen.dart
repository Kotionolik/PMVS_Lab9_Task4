import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../blocs/parking/parking_cubit.dart';
import '../widgets/adaptive_navigation.dart';
import '../core/extensions/context_extensions.dart';
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveNavigation(
      title: l10n.statistics, currentIndex: 3,
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (ctx, state) {
          int free = 0, total = 0;
          for (final l in state.parkingLots) { free += l.freeSpots; total += l.totalSpots; }
          final occupied = total - free;
          if (total == 0) return const Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(24),
            child: PieChart(PieChartData(sections: [
              PieChartSectionData(value: free.toDouble(),
                color: Colors.green,
                title: '${l10n.freeSpots}\n$free'
              ),
              PieChartSectionData(value: occupied.toDouble(),
                color: Colors.red,
                title: '${l10n.occupied}\n$occupied'
              ),
            ])),
          );
        },
      ),
    );
  }
}
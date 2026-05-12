import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../screens/login_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/history_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/statistics_screen.dart';
import '../../screens/parking_detail_screen.dart';
import '../../screens/booking_screen.dart';
import '../../screens/payment_screen.dart';

class AppRouter {
  static GoRouter create(BuildContext ctx) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, gs) {
        final auth = context.read<AuthCubit>().state;
        final logged = auth.status == AuthStatus.authenticated;
        final goingLogin = gs.matchedLocation == '/login';
        if (!logged && !goingLogin) return '/login';
        if (logged && goingLogin) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/statistics', builder: (_, __) => const StatisticsScreen()),
        GoRoute(path: '/parking/:id',
          builder: (_, g) => ParkingDetailScreen(id:
          int.parse(g.pathParameters['id']!))),
        GoRoute(path: '/booking/:id',
          builder: (_, g) => BookingScreenRoute(lotId:
          int.parse(g.pathParameters['id']!))),
        GoRoute(path: '/payment', builder: (_, __) => const PaymentScreenRoute()),
      ],
    );
  }
}
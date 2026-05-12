import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/parking/parking_cubit.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/theme/theme_cubit.dart';
import 'services/database_helper.dart';
import 'services/payment_api.dart';
import 'services/auth_service.dart';
import 'services/cache_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';
class CityParkingApp extends StatelessWidget {
  const CityParkingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) =>
          AuthCubit(AuthService())..checkSession()),
        BlocProvider(create: (_) => ParkingCubit(
          DatabaseHelper(), PaymentApi(), CacheService())),
      ],
      child: Builder(builder: (context) {
        final router = AppRouter.create(context);
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'City Parking',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              routerConfig: router,
              localizationsDelegates:
                AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        );
      }),
    );
  }
}
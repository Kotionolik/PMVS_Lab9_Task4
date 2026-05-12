import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../services/cache_service.dart';
import '../widgets/adaptive_navigation.dart';
import '../core/extensions/context_extensions.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((i) => setState(() => _version = i.version));
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = context.watch<ThemeCubit>().state;
    return AdaptiveNavigation(
      title: l10n.settings, currentIndex: 4,
      body: ListView(children: [
        ListTile(
          title: Text(l10n.theme), trailing: DropdownButton<ThemeMode>(
            key: const Key('theme_dropdown'),
            value: mode,
            onChanged: (m) => m != null ? context.read<ThemeCubit>().setTheme(m) : null,
            items: [
              DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.systemTheme)),
              DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.lightTheme)),
              DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.darkTheme)),
            ],
          ),
        ),
        ListTile(
          title: Text(l10n.clearCache),
          trailing: const Icon(Icons.delete),
          onTap: () async {
            await CacheService().clear();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.clearCache)));
            }
          },
        ),
        ListTile(title: Text(l10n.version), trailing: Text(_version)),
        ListTile(
          title: Text(l10n.signOut),
          trailing: const Icon(Icons.logout),
          onTap: () => context.read<AuthCubit>().logout(),
        ),
      ]),
    );
  }
}
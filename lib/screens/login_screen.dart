import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_cubit.dart';
import '../core/extensions/context_extensions.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _submit() {
  if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(_email.text.trim(), _password.text);
  }
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, st) {
      if (st.status == AuthStatus.authenticated) ctx.go('/home');
      if (st.status == AuthStatus.error) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(st.error ?? l10n.error)),
        );
      }
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.isMobile ?
            360 : 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.appTitle, style:
                      Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('email_field'),
                      controller: _email,
                      decoration: InputDecoration(labelText: l10n.email),
                      validator: (v) => (v == null ||
                        !v.contains('@')) ? l10n.invalidCard : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('password_field'),
                      controller: _password, obscureText: true,
                      decoration: InputDecoration(labelText: l10n.password),
                      validator: (v) => (v == null || v.length < 4)
                        ? l10n.invalidCard : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      key: const Key('login_button'),
                      onPressed: _submit,
                      child: Text(l10n.signIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
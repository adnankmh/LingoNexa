import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  bool _register = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const LingoNexaLogo(height: 128),
                  const SizedBox(height: 18),
                  Text(
                      _register
                          ? 'Create your LingoNexa account'
                          : 'Welcome back',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(
                      _register
                          ? 'Save progress, XP, levels, exams, and learning streaks.'
                          : 'Your language journey continues here.',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 22),
                  SegmentedButton<bool>(
                    segments: [
                      const ButtonSegment(
                          value: false,
                          label: Text('Sign in'),
                          icon: Icon(Icons.login_rounded)),
                      ButtonSegment(
                          value: true,
                          enabled: state.registrationEnabled,
                          label: const Text('Create account'),
                          icon: const Icon(Icons.person_add_alt_1_rounded))
                    ],
                    selected: {_register},
                    onSelectionChanged: (value) => setState(() {
                      _register = value.first;
                      state.authError = null;
                    }),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AutofillGroup(
                        child: Column(children: [
                          if (_register) ...[
                            TextField(
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                autofillHints: const [AutofillHints.name],
                                decoration: const InputDecoration(
                                    labelText: 'Display name',
                                    prefixIcon: Icon(Icons.badge_outlined))),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _username,
                                autofillHints: const [AutofillHints.username],
                                decoration: const InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon:
                                        Icon(Icons.alternate_email_rounded))),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon:
                                        Icon(Icons.mail_outline_rounded))),
                          ] else
                            TextField(
                                controller: _identifier,
                                autofillHints: const [AutofillHints.username],
                                decoration: const InputDecoration(
                                    labelText: 'Username or email',
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded))),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _password,
                            obscureText: _hidePassword,
                            autofillHints: _register
                                ? const [AutofillHints.newPassword]
                                : const [AutofillHints.password],
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                  onPressed: () => setState(
                                      () => _hidePassword = !_hidePassword),
                                  icon: Icon(_hidePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded)),
                            ),
                          ),
                          if (state.authError != null) ...[
                            const SizedBox(height: 12),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: .09),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Text(state.authError!,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700))),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                                onPressed: state.authBusy ? null : _submit,
                                icon: state.authBusy
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : Icon(_register
                                        ? Icons.person_add_alt_1_rounded
                                        : Icons.login_rounded),
                                label: Text(
                                    _register ? 'Create account' : 'Sign in')),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                        child: Divider(color: Theme.of(context).dividerColor)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or continue with')),
                    Expanded(
                        child: Divider(color: Theme.of(context).dividerColor))
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                        child: OutlinedButton.icon(
                            onPressed: () => _socialInfo('Google'),
                            icon: const Text('G',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 18)),
                            label: const Text('Google'))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: OutlinedButton.icon(
                            onPressed: () => _socialInfo('Facebook'),
                            icon: const Icon(Icons.facebook_rounded),
                            label: const Text('Facebook'))),
                  ]),
                  const SizedBox(height: 10),
                  TextButton.icon(
                      onPressed: state.signInAsGuest,
                      icon: const Icon(Icons.explore_outlined),
                      label: const Text('Continue as guest')),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: .55),
                        borderRadius: BorderRadius.circular(18)),
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Demo accounts',
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          SizedBox(height: 6),
                          SelectableText('demo1 / Demo123\ndemo2 / Demo123',
                              style: TextStyle(height: 1.6)),
                          SizedBox(height: 5),
                          Text(
                              'These accounts are local test accounts. Production authentication must use a secure backend.',
                              style: TextStyle(fontSize: 11.5, height: 1.4)),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final state = AppStateScope.of(context);
    if (_register) {
      await state.register(
          displayName: _name.text,
          username: _username.text,
          email: _email.text,
          password: _password.text);
    } else {
      await state.signIn(_identifier.text, _password.text);
    }
  }

  void _socialInfo(String provider) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$provider sign-in'),
          content: Text(
              'The interface is ready. To activate $provider securely, connect Firebase Authentication or your own OAuth backend and add the provider keys outside the source code.'),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Understood'))
          ],
        ),
      );
}

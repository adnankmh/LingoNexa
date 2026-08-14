import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _register
                        ? 'Save progress, XP, levels, exams, and learning streaks.'
                        : 'Your language journey continues here.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  SegmentedButton<bool>(
                    segments: [
                      const ButtonSegment(
                        value: false,
                        label: Text('Sign in'),
                        icon: Icon(Icons.login_rounded),
                      ),
                      ButtonSegment(
                        value: true,
                        enabled: state.registrationEnabled,
                        label: const Text('Create account'),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
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
                        child: Column(
                          children: [
                            if (_register) ...[
                              TextField(
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                autofillHints: const [AutofillHints.name],
                                decoration: const InputDecoration(
                                  labelText: 'Display name',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _username,
                                autofillHints: const [AutofillHints.username],
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(
                                    Icons.alternate_email_rounded,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline_rounded),
                                ),
                              ),
                            ] else
                              TextField(
                                controller: _identifier,
                                autofillHints: const [AutofillHints.username],
                                decoration: const InputDecoration(
                                  labelText: 'Username or email',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                  ),
                                ),
                              ),
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
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: context.text.get(
                                    _hidePassword
                                        ? 'tip_password_show'
                                        : 'tip_password_hide',
                                  ),
                                  onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                  ),
                                ),
                              ),
                            ),
                            if (state.authError != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: .09),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  state.authError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        _register
                                            ? Icons.person_add_alt_1_rounded
                                            : Icons.login_rounded,
                                      ),
                                label: Text(
                                  _register ? 'Create account' : 'Sign in',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: (state.remoteBackendEnabled
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary)
                          .withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (state.remoteBackendEnabled
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary)
                            .withValues(alpha: .22),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.remoteBackendEnabled
                              ? Icons.cloud_done_rounded
                              : Icons.offline_bolt_rounded,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            state.remoteBackendEnabled
                                ? 'Secure cloud account & progress sync enabled'
                                : 'Offline-first account mode',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _configureServer(state),
                    icon: const Icon(Icons.dns_rounded),
                    label: Text(
                      state.remoteBackendEnabled
                          ? 'Server: ${state.apiBaseUrl}'
                          : 'Connect Laravel server',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextButton.icon(
                    onPressed: state.signInAsGuest,
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text('Continue as guest'),
                  ),
                  if (!state.remoteBackendEnabled) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo accounts',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 6),
                        SelectableText(
                          'demo1 / Demo-Learner!2026\ndemo2 / Demo-Learner!2026',
                          style: TextStyle(height: 1.6),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'These accounts are local test accounts. Production authentication must use a secure backend.',
                          style: TextStyle(fontSize: 11.5, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _configureServer(AppState state) async {
    final controller = TextEditingController(text: state.apiBaseUrl);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('LingoNexa server'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the Laravel base URL. Android emulator example: http://10.0.2.2:8000. For a phone, use the computer LAN address or your HTTPS domain.',
              style: TextStyle(fontSize: 12.5, height: 1.45),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'https://learn.example.com',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          if (state.remoteBackendEnabled)
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, ''),
              child: const Text('Use offline mode'),
            ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    await state.setApiBaseUrl(result);
  }

  Future<void> _submit() async {
    final state = AppStateScope.of(context);
    if (_register) {
      await state.register(
        displayName: _name.text,
        username: _username.text,
        email: _email.text,
        password: _password.text,
      );
    } else {
      await state.signIn(_identifier.text, _password.text);
    }
  }

}

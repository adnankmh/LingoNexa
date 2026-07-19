import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../widgets/ui.dart';

class InterfaceLanguageScreen extends StatelessWidget {
  const InterfaceLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('interface_language'))),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LingoNexaLogo(height: 105),
            const SizedBox(height: 18),
            Text(
              '${AppText.supported.length} interface languages',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'Navigation, learning controls, Nexa Live, and the main experience change instantly. English is the safe fallback for newly added content.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 760 ? 3 : constraints.maxWidth >= 480 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppText.supported.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: columns == 1 ? 3.6 : 2.7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final option = AppText.supported[index];
                    final selected = state.locale.languageCode == option.code;
                    return Card(
                      color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () async {
                          await state.setLocale(option.code);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Text(option.flag, style: const TextStyle(fontSize: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(option.nativeName, style: const TextStyle(fontWeight: FontWeight.w900)),
                                    Text(option.englishName, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11)),
                                  ],
                                ),
                              ),
                              if (selected) Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

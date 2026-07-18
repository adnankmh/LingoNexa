import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';

class LanguagePickerScreen extends StatefulWidget {
  const LanguagePickerScreen({super.key});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final results = LanguageCatalog.all.where((language) {
      final q = _query.trim().toLowerCase();
      return q.isEmpty || language.englishName.toLowerCase().contains(q) || language.nativeName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('choose_language'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: context.text.get('search')),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                mainAxisExtent: 82,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) => _LanguageTile(
                language: results[index],
                selected: state.targetLanguageCode == results[index].code,
                onTap: () async {
                  await state.setTargetLanguage(results[index].code);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.language, required this.selected, required this.onTap});

  final LanguageOption language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: selected ? scheme.primary : Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Text(language.flag, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.nativeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text('${language.englishName} · ${language.script}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11)),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}


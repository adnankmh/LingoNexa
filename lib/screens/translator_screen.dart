import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/global_content_repository.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../services/speech_service.dart';
import '../widgets/speech_control_panel.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final SpeechService _speech = SpeechService();
  String _sourceCode = 'en';
  String _targetCode = 'es';
  String _result = '';
  String _category = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final state = AppStateScope.of(context);
    final interfaceCode =
        LanguageCatalog.all.any(
          (language) => language.code == state.locale.languageCode,
        )
        ? state.locale.languageCode
        : 'en';
    _sourceCode = interfaceCode == state.targetLanguageCode
        ? 'en'
        : interfaceCode;
    _targetCode = state.targetLanguageCode;
    _initialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = LanguageCatalog.byCode(_sourceCode);
    final target = LanguageCatalog.byCode(_targetCode);
    final suggestions = _suggestions();
    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('translator'))),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 940),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.g_translate_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.text.get('instant_translator'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.text.get('translator_subtitle'),
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _languagePicker(source, true)),
                            IconButton.filledTonal(
                              tooltip: context.text.get('tip_swap_languages'),
                              onPressed: _swap,
                              icon: const Icon(Icons.swap_horiz_rounded),
                            ),
                            Expanded(child: _languagePicker(target, false)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _controller,
                          minLines: 4,
                          maxLines: 8,
                          textDirection: source.flow == TextFlow.rightToLeft
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: context.text.get('text_to_translate'),
                            hintText: context.text.get('translator_hint'),
                            prefixIcon: const Icon(Icons.edit_note_rounded),
                            suffixIcon: _controller.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: context.text.get('tip_clear_text'),
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() {
                                        _result = '';
                                        _category = '';
                                      });
                                    },
                                    icon: const Icon(Icons.clear_rounded),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _controller.text.trim().isEmpty
                                ? null
                                : _run,
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: Text(context.text.get('translate_now')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_result.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                target.flag,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  _category,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: context.text.get('tip_copy'),
                                onPressed: () => _copy(context),
                                icon: const Icon(Icons.copy_rounded),
                              ),
                              IconButton.filledTonal(
                                tooltip: context.text.get('tip_speak'),
                                onPressed: () => _speak(context),
                                icon: const Icon(Icons.volume_up_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SelectableText(
                            _result,
                            textDirection: target.flow == TextFlow.rightToLeft
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (_controller.text.trim().isNotEmpty && _result.isEmpty) ...[
                  const SizedBox(height: 14),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.verified_user_outlined),
                      title: Text(
                        context.text.get('verified_translation_only'),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(context.text.get('translator_no_guess')),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  context.text.get('useful_phrases'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 9),
                for (final item in suggestions)
                  Card(
                    child: ListTile(
                      leading: Text(
                        item.visual,
                        style: const TextStyle(fontSize: 25),
                      ),
                      title: Text(item.source),
                      subtitle: Text(item.target),
                      trailing: const Icon(Icons.north_west_rounded),
                      onTap: () {
                        _controller.text = item.source;
                        setState(() {
                          _result = item.target;
                          _category = item.category;
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                SpeechControlPanel(languageCode: _targetCode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _languagePicker(LanguageOption selected, bool source) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selected.code,
        isExpanded: true,
        menuMaxHeight: 430,
        items: [
          for (final language in LanguageCatalog.all)
            DropdownMenuItem(
              value: language.code,
              child: Text(
                '${language.flag} ${language.nativeName}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            if (source) {
              _sourceCode = value;
            } else {
              _targetCode = value;
            }
            _result = '';
            _category = '';
          });
        },
      ),
    );
  }

  void _swap() {
    setState(() {
      final previous = _sourceCode;
      _sourceCode = _targetCode;
      _targetCode = previous;
      if (_result.isNotEmpty) {
        final oldInput = _controller.text;
        _controller.text = _result;
        _result = oldInput;
      }
    });
  }

  void _run() {
    final match = _translateExact(_controller.text.trim());
    setState(() {
      _result = match?.target ?? '';
      _category = match?.category ?? '';
    });
  }

  TranslationResult? _translateExact(String input) {
    final global = GlobalContentRepository.translateExact(
      input,
      sourceLanguageCode: _sourceCode,
      targetLanguageCode: _targetCode,
    );
    if (global != null) return global;
    final sourceItems = CourseRepository.starterLexicon[_sourceCode];
    final targetItems = CourseRepository.starterLexicon[_targetCode];
    if (sourceItems == null || targetItems == null) return null;
    final normalized = _normalize(input);
    for (var index = 0; index < sourceItems.length; index++) {
      if (_normalize(sourceItems[index]) == normalized) {
        return TranslationResult(
          source: sourceItems[index],
          target: targetItems[index],
          category: context.text.get('essentials'),
          visual: index == 1 ? '🙏' : '👋',
        );
      }
    }
    return null;
  }

  List<TranslationResult> _suggestions() {
    final global = GlobalContentRepository.translationSuggestions(
      sourceLanguageCode: _sourceCode,
      targetLanguageCode: _targetCode,
      query: _controller.text,
      limit: 8,
    );
    if (global.isNotEmpty) return global;
    final sourceItems = CourseRepository.starterLexicon[_sourceCode];
    final targetItems = CourseRepository.starterLexicon[_targetCode];
    if (sourceItems == null || targetItems == null) return const [];
    return [
      for (var index = 0; index < sourceItems.length; index++)
        TranslationResult(
          source: sourceItems[index],
          target: targetItems[index],
          category: context.text.get('essentials'),
          visual: index == 1 ? '🙏' : '👋',
        ),
    ];
  }

  Future<void> _speak(BuildContext context) async {
    final state = AppStateScope.of(context);
    final success = await _speech.speak(
      _result,
      _targetCode,
      rate: state.speechRate,
      voiceName: state.preferredVoiceFor(_targetCode),
    );
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('voice_not_installed'))),
      );
    }
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _result));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.text.get('copied'))));
    }
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'''[.,!?،؛:;"'“”‘’…()\[\]{}_-]+'''), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

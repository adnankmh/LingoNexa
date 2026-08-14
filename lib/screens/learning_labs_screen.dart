import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../data/modern_learning_repository.dart';
import '../models/models.dart';

class LearningLabsScreen extends StatelessWidget {
  const LearningLabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    final copy = ModernLearningRepository.copy(locale);
    final methods = ModernLearningRepository.methods(locale);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final phrases = LearningContentRepository.phrasesFor(
      language.code,
      sourceLanguageCode: locale,
    );

    return Scaffold(
      appBar: AppBar(title: Text(copy.hubTitle)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF122B54), Color(0xFF5C4DF0)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final text = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${language.flag} ${language.nativeName}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                copy.hubTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                copy.hubSubtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.55,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _Pill(text: '${methods.length} labs'),
                                  _Pill(text: '${phrases.length} examples'),
                                  _Pill(text: state.currentLevel),
                                ],
                              ),
                            ],
                          );
                          if (constraints.maxWidth < 650) return text;
                          return Row(
                            children: [
                              Expanded(child: text),
                              SizedBox(
                                width: 170,
                                height: 145,
                                child: Lottie.asset(
                                  'assets/lottie/brain_pulse.json',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.psychology_rounded,
                                    color: Colors.white,
                                    size: 86,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 34),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.crossAxisExtent >= 920
                          ? 3
                          : constraints.crossAxisExtent >= 620
                              ? 2
                              : 1;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: columns == 1 ? 2.05 : 1.32,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final method = methods[index];
                            return _MethodCard(
                              method: method,
                              startLabel: copy.start,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => _LearningLabSession(
                                    method: method,
                                    phrases: phrases,
                                    locale: locale,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: methods.length,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 11.5,
          ),
        ),
      );
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.startLabel,
    required this.onTap,
  });

  final LearningMethod method;
  final String startLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: .55),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(method.icon,
                          style: const TextStyle(fontSize: 25)),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: Lottie.asset(
                        method.animation,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.auto_awesome_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  method.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    method.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.45,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      startLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _LearningLabSession extends StatefulWidget {
  const _LearningLabSession({
    required this.method,
    required this.phrases,
    required this.locale,
  });

  final LearningMethod method;
  final List<PhraseEntry> phrases;
  final String locale;

  @override
  State<_LearningLabSession> createState() => _LearningLabSessionState();
}

class _LearningLabSessionState extends State<_LearningLabSession> {
  int _index = 0;
  int _known = 0;
  bool _revealed = false;
  bool _finished = false;

  int get _sessionLength => widget.phrases.length.clamp(1, 10).toInt();

  PhraseEntry get _phrase => widget.phrases.isEmpty
      ? const PhraseEntry(
          source: 'No aligned phrase is available yet.',
          target: '—',
          category: 'system',
        )
      : widget.phrases[_index % widget.phrases.length];

  @override
  Widget build(BuildContext context) {
    final copy = ModernLearningRepository.copy(widget.locale);
    final state = AppStateScope.of(context);
    if (_finished) {
      final score = _sessionLength == 0
          ? 0
          : ((_known / _sessionLength) * 100).round();
      return Scaffold(
        appBar: AppBar(title: Text(widget.method.title)),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Lottie.asset(
                          'assets/lottie/celebration.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        copy.sessionDone,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$score% · $_known/$_sessionLength',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await state.recordSkillPractice('vocabulary', score);
                            if (context.mounted) Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: Text(copy.sessionDone),
                        ),
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

    final phrase = _phrase;
    return Scaffold(
      appBar: AppBar(title: Text(widget.method.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / _sessionLength,
                minHeight: 8,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(widget.method.icon,
                          style: const TextStyle(fontSize: 46)),
                      const SizedBox(height: 12),
                      Text(
                        phrase.target,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          height: 1.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (phrase.pronunciation.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          phrase.pronunciation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Text(
                        copy.sessionHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: _revealed
                            ? Container(
                                key: ValueKey(_index),
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withValues(alpha: .48),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  phrase.source,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.45,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      setState(() => _revealed = true),
                                  icon: const Icon(Icons.visibility_rounded),
                                  label: Text(copy.reveal),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_revealed) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _advance(false),
                        icon: const Icon(Icons.replay_rounded),
                        label: Text(copy.reviewIt),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _advance(true),
                        icon: const Icon(Icons.check_circle_rounded),
                        label: Text(copy.knewIt),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _advance(bool known) {
    if (known) _known++;
    if (_index + 1 >= _sessionLength) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index++;
      _revealed = false;
    });
  }
}

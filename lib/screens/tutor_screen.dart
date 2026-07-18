import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_TutorMessage> _messages = [
    const _TutorMessage(
      text: 'Welcome! Choose a real-world scene, then reply in your target language. I will guide you without interrupting your confidence.',
      fromTutor: true,
    ),
  ];
  String _scenario = 'Coffee shop';

  static const _scenarios = ['Coffee shop', 'Airport', 'Job interview', 'Hotel', 'Meeting a friend'];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [const CircleAvatar(child: Text('✨')), const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Nexa Coach'), Text('${language.flag} ${language.nativeName} · $_scenario', style: Theme.of(context).textTheme.labelSmall)])]),
        actions: [IconButton(onPressed: _showScenarioPicker, icon: const Icon(Icons.tune_rounded))],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(17)),
                  child: const Row(children: [Icon(Icons.lock_outline_rounded, size: 18), SizedBox(width: 8), Expanded(child: Text('Practice mode is private. Connect your own AI endpoint in Admin for generative feedback.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))]),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                  child: Row(
                    children: [
                      IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.mic_rounded)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(hintText: 'Write your reply…', contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(onPressed: _send, icon: const Icon(Icons.arrow_upward_rounded)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final state = AppStateScope.of(context);
    final lexicon = CourseRepository.starterLexicon[state.targetLanguageCode] ?? CourseRepository.starterLexicon['en']!;
    setState(() {
      _messages.add(_TutorMessage(text: text, fromTutor: false));
      _messages.add(_TutorMessage(
        text: _coachReply(text, lexicon),
        fromTutor: true,
        feedback: text.length < 4 ? 'Try a complete phrase to build speaking confidence.' : 'Good attempt. Focus next on a natural greeting and a polite closing.',
      ));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    });
  }

  String _coachReply(String input, List<String> lexicon) {
    if (_scenario == 'Coffee shop') return '${lexicon[0]}! ☕ ${lexicon[2]} — now ask for a drink and mention its size.';
    if (_scenario == 'Airport') return 'Great start. Ask where the departure gate is, then repeat the answer to confirm it.';
    if (_scenario == 'Job interview') return 'Tell me one strength and support it with a short example.';
    if (_scenario == 'Hotel') return 'Ask whether breakfast and Wi-Fi are included.';
    return 'Nice to meet you. Ask me a follow-up question so the conversation keeps moving.';
  }

  Future<void> _showScenarioPicker() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose a scenario', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              for (final item in _scenarios) ListTile(title: Text(item, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: _scenario == item ? const Icon(Icons.check_circle_rounded) : null, onTap: () => Navigator.pop(context, item)),
            ],
          ),
        ),
      ),
    );
    if (selected != null) setState(() => _scenario = selected);
  }
}

class _TutorMessage {
  const _TutorMessage({required this.text, required this.fromTutor, this.feedback});

  final String text;
  final bool fromTutor;
  final String? feedback;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _TutorMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: message.fromTutor ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: message.fromTutor ? Theme.of(context).cardTheme.color : scheme.primary,
          borderRadius: BorderRadiusDirectional.only(topStart: const Radius.circular(20), topEnd: const Radius.circular(20), bottomStart: Radius.circular(message.fromTutor ? 5 : 20), bottomEnd: Radius.circular(message.fromTutor ? 20 : 5)),
          border: message.fromTutor ? Border.all(color: Theme.of(context).dividerColor) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text, style: TextStyle(color: message.fromTutor ? scheme.onSurface : scheme.onPrimary, height: 1.45, fontWeight: FontWeight.w600)),
            if (message.feedback != null) ...[
              const SizedBox(height: 10),
              Divider(color: message.fromTutor ? Theme.of(context).dividerColor : scheme.onPrimary.withValues(alpha: .25)),
              Text('Coach note · ${message.feedback!}', style: TextStyle(color: message.fromTutor ? scheme.onSurfaceVariant : scheme.onPrimary.withValues(alpha: .82), fontSize: 11.5, height: 1.4)),
            ],
          ],
        ),
      ),
    );
  }
}


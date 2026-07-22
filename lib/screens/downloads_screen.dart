import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../services/speech_service.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final SpeechService _speech = SpeechService();
  final Set<String> _busy = {};
  final Map<String, Future<bool>> _voiceChecks = {};

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('downloads'))),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Lottie.asset('assets/lottie/download.json'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.text.get('offline_ready'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${state.downloadedPackCodes.length} ${context.text.get('packs_active')}',
                              style: const TextStyle(fontSize: 11.5),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              context.text.get('offline_voice_note'),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                    itemCount: LanguageCatalog.all.length,
                    itemBuilder: (context, index) {
                      final language = LanguageCatalog.all[index];
                      final active = state.downloadedPackCodes.contains(
                        language.code,
                      );
                      final busy = _busy.contains(language.code);
                      final voiceCheck = _voiceChecks.putIfAbsent(
                        language.code,
                        () => _speech.isVoiceAvailable(language.code),
                      );
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            14,
                            7,
                            10,
                            7,
                          ),
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                language.flag,
                                style: const TextStyle(fontSize: 31),
                              ),
                              if (active)
                                const PositionedDirectional(
                                  end: -5,
                                  bottom: -4,
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            language.nativeName,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          subtitle: FutureBuilder<bool>(
                            future: voiceCheck,
                            builder: (context, snapshot) {
                              final voiceReady = snapshot.data == true;
                              return Text(
                                '${context.text.get('lessons')} + ${context.text.get('stories')} + ${context.text.get('grammar')} · ${voiceReady ? context.text.get('voice_ready') : context.text.get('voice_required')}',
                              );
                            },
                          ),
                          trailing: busy
                              ? const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : active
                              ? IconButton(
                                  tooltip: context.text.get(
                                    'tip_delete_download',
                                  ),
                                  onPressed: () =>
                                      _toggle(state, language.code),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                )
                              : IconButton.filledTonal(
                                  tooltip: context.text.get('tip_download'),
                                  onPressed: () =>
                                      _toggle(state, language.code),
                                  icon: const Icon(Icons.download_rounded),
                                ),
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

  Future<void> _toggle(AppState state, String code) async {
    setState(() => _busy.add(code));
    await Future<void>.delayed(const Duration(milliseconds: 550));
    await state.toggleDownloadedPack(code);
    if (mounted) setState(() => _busy.remove(code));
  }
}

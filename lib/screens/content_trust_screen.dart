import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/global_content_repository.dart';
import '../data/language_catalog.dart';
import '../data/product_copy_repository.dart';
import '../widgets/ui.dart';

class ContentTrustScreen extends StatelessWidget {
  const ContentTrustScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    final target = LanguageCatalog.byCode(state.targetLanguageCode);
    String copy(String key) => ProductCopyRepository.text(locale, key);
    final core =
        GlobalContentRepository.coreLanguageCodes.contains(target.code);

    return Scaffold(
      appBar: AppBar(title: Text(copy('content_trust'))),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 28,
                        child: Text(target.flag,
                            style: const TextStyle(fontSize: 27))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(target.nativeName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 19)),
                          const SizedBox(height: 4),
                          Text(core
                              ? 'Aligned core pack · 84 concepts · 4,032 drills'
                              : copy('foundation_pack')),
                        ],
                      ),
                    ),
                    Chip(
                      avatar: Icon(
                          core
                              ? Icons.verified_outlined
                              : Icons.construction_rounded,
                          size: 17),
                      label: Text(core ? 'CORE' : 'STARTER'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            SectionHeading(
                title: copy('editorial_pipeline'),
                subtitle: copy('content_trust_sub')),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 92,
                height: 92,
                child: Lottie.asset(
                  'assets/lottie/human_review.json',
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fact_check_outlined,
                    size: 58,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _PipelineStep(
                      icon: Icons.edit_note_rounded,
                      title: copy('author'),
                      status: 'Structure complete',
                      complete: true),
                  const Divider(height: 1),
                  _PipelineStep(
                      icon: Icons.translate_rounded,
                      title: copy('linguist'),
                      status: core
                          ? 'Aligned terminology check'
                          : 'Scheduled per course pack',
                      complete: core),
                  const Divider(height: 1),
                  _PipelineStep(
                      icon: Icons.record_voice_over_outlined,
                      title: copy('native_reviewer'),
                      status: copy('native_review_needed'),
                      complete: false),
                  const Divider(height: 1),
                  _PipelineStep(
                      icon: Icons.fact_check_outlined,
                      title: copy('quality_review'),
                      status:
                          'Regression, pedagogy, accessibility, and rights gate',
                      complete: false),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionHeading(title: copy('release_ready')),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Gate(
                        label: 'Translation alignment', value: core ? 1 : .35),
                    _Gate(label: 'Native editorial review', value: 0),
                    _Gate(label: 'Licensed native audio', value: 0),
                    _Gate(label: 'Automated content integrity', value: 1),
                    _Gate(label: copy('rights_record'), value: .25),
                    const SizedBox(height: 10),
                    Text(
                      copy('native_review_needed'),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: .5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'A polished interface cannot replace editorial proof. LingoNexa keeps unfinished packs visibly separated from commercially reviewed packs so generated or placeholder material is never presented as native-expert content.',
                style: TextStyle(fontSize: 12, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  const _PipelineStep(
      {required this.icon,
      required this.title,
      required this.status,
      required this.complete});
  final IconData icon;
  final String title;
  final String status;
  final bool complete;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(status),
        trailing: Icon(
          complete ? Icons.check_circle_rounded : Icons.schedule_rounded,
          color: complete ? const Color(0xFF0E9F79) : Colors.orange,
        ),
      );
}

class _Gate extends StatelessWidget {
  const _Gate({required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(label,
                        style: const TextStyle(fontWeight: FontWeight.w800))),
                Text('${(value * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(value: value, minHeight: 8),
            ),
          ],
        ),
      );
}

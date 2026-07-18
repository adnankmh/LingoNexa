import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../widgets/ui.dart';
import 'tutor_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final scheme = Theme.of(context).colorScheme;
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.text.get('explore'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text('${language.flag} Immerse yourself in ${language.englishName} beyond lessons.', style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          SizedBox(
            height: 205,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _HeroCard(title: 'Interactive story', subtitle: 'The last train', emoji: '🚆', colors: const [Color(0xFF6C63FF), Color(0xFF9B70FF)], onTap: () => _storyDialog(context)),
                _HeroCard(title: 'Role-play', subtitle: 'Order like a local', emoji: '🥐', colors: const [Color(0xFF008F79), Color(0xFF35C5A6)], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorScreen()))),
                _HeroCard(title: 'Audio brief', subtitle: 'Five-minute news', emoji: '🎙️', colors: const [Color(0xFFE76F51), Color(0xFFF4A261)], onTap: () => _openUrl(context, 'https://learningenglish.voanews.com/')),
              ],
            ),
          ),
          const SizedBox(height: 26),
          SectionHeading(title: context.text.get('articles'), subtitle: 'Original learning notes designed for practical use'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 720 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CourseRepository.articles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, childAspectRatio: columns == 1 ? 2.7 : 2.25, mainAxisSpacing: 10, crossAxisSpacing: 10),
                itemBuilder: (context, index) => _ArticleCard(article: CourseRepository.articles[index], onTap: () => _articleDialog(context, CourseRepository.articles[index])),
              );
            },
          ),
          const SizedBox(height: 26),
          const SectionHeading(title: 'Curated open resources', subtitle: 'External learning links open in your browser'),
          const SizedBox(height: 12),
          FeatureTile(icon: Icons.play_circle_outline_rounded, title: 'VOA Learning English', subtitle: 'Slow-paced news and listening practice', color: const Color(0xFF4DABF7), onTap: () => _openUrl(context, 'https://learningenglish.voanews.com/')),
          FeatureTile(icon: Icons.public_rounded, title: 'DW Learn German', subtitle: 'Structured videos, audio, and current topics', color: const Color(0xFFFFA94D), onTap: () => _openUrl(context, 'https://learngerman.dw.com/')),
          FeatureTile(icon: Icons.movie_filter_outlined, title: 'TV5MONDE Learn French', subtitle: 'Video-based French comprehension activities', color: const Color(0xFF20C997), onTap: () => _openUrl(context, 'https://apprendre.tv5monde.com/')),
        ],
      ),
    );
  }

  static Future<void> _openUrl(BuildContext context, String value) async {
    final launched = await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open this resource.')));
  }

  static Future<void> _articleDialog(BuildContext context, CultureArticle article) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(article.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 9),
              Text('${article.category} · ${article.readMinutes} min read', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              Text(article.summary, style: const TextStyle(height: 1.65, fontSize: 16)),
              const SizedBox(height: 12),
              const Text('Try this today: notice one expression in context, say it aloud three times, then use it in a new sentence without looking. Return tomorrow and recall it before checking.', style: TextStyle(height: 1.65)),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _storyDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🚆 The last train'),
          content: const Text('You arrive at the station with two minutes left. Read the signs, ask a traveler which platform you need, and choose the clearest response.\n\nThis story template is ready for localized audio and branching content from the Admin Studio.', style: TextStyle(height: 1.55)),
          actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Start story'))],
        ),
      );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle, required this.emoji, required this.colors, required this.onTap});

  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsetsDirectional.only(end: 12),
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(27)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(27),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(emoji, style: const TextStyle(fontSize: 57)), const Spacer(), Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 8), const Icon(Icons.arrow_forward_rounded, color: Colors.white)]),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final CultureArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [Text(article.emoji, style: const TextStyle(fontSize: 39)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, height: 1.25)), const SizedBox(height: 6), Text('${article.category} · ${article.readMinutes} min', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11.5))])), const Icon(Icons.arrow_forward_ios_rounded, size: 15)]),
        ),
      ),
    );
  }
}


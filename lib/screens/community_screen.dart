import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../models/models.dart';
import '../widgets/ui.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<CommunityPost> _posts = [...CourseRepository.communityPosts];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    if (!state.communityEnabled) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.people_alt_outlined, size: 70),
                const SizedBox(height: 14),
                Text('Community is disabled by the administrator.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge)
              ])));
    }
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(context.text.get('community'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(
                        'Safe language exchange, corrections, and cultural discovery.',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant))
                  ])),
              FilledButton.icon(
                  onPressed: _composePost,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Post')),
            ],
          ),
          const SizedBox(height: 20),
          if (state.voiceRoomsEnabled) _VoiceRoomBanner(onTap: _showRooms),
          const SizedBox(height: 14),
          SizedBox(
            height: 92,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _Partner(
                    avatar: '👩🏽',
                    name: 'Maya',
                    detail: 'AR → ES',
                    online: true),
                _Partner(
                    avatar: '👨🏻',
                    name: 'Kenji',
                    detail: 'JA → EN',
                    online: true),
                _Partner(
                    avatar: '👩🏻',
                    name: 'Amélie',
                    detail: 'FR → AR',
                    online: false),
                _Partner(
                    avatar: '👨🏾',
                    name: 'Daniel',
                    detail: 'EN → SW',
                    online: true),
                _Partner(
                    avatar: '👩🏼',
                    name: 'Lena',
                    detail: 'DE → TR',
                    online: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final post in _posts)
            _PostCard(post: post, onMore: () => _moderationSheet(post)),
        ],
      ),
    );
  }

  Future<void> _composePost() async {
    final controller = TextEditingController();
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 24),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Practice with the community',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              TextField(
                  controller: controller,
                  autofocus: true,
                  minLines: 4,
                  maxLines: 7,
                  maxLength: 500,
                  decoration: const InputDecoration(
                      hintText: 'Write in the language you are learning…')),
              const SizedBox(height: 10),
              FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim().isNotEmpty),
                  child: const Text('Publish'))
            ]),
      ),
    );
    if (submitted == true && controller.text.trim().isNotEmpty) {
      setState(() => _posts.insert(
          0,
          CommunityPost(
              author: 'You',
              nativeLanguage: 'Arabic',
              learningLanguage: 'Practice',
              text: controller.text.trim(),
              avatar: '🙂',
              likes: 0,
              comments: 0)));
    }
    controller.dispose();
  }

  void _showRooms() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Live voice rooms',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const _RoomTile(
                        title: 'English confidence café',
                        people: 18,
                        level: 'A2–B1',
                        color: Color(0xFF6C63FF)),
                    const _RoomTile(
                        title: 'Palestinian Arabic exchange',
                        people: 9,
                        level: 'All levels',
                        color: Color(0xFF20C997)),
                    const _RoomTile(
                        title: 'Spanish travel stories',
                        people: 12,
                        level: 'B1',
                        color: Color(0xFFFFA94D))
                  ]))),
    );
  }

  void _moderationSheet(CommunityPost post) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Report post'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Report received for moderator review.')));
            }),
        ListTile(
            leading: const Icon(Icons.block_rounded),
            title: Text('Block ${post.author}'),
            onTap: () => Navigator.pop(context)),
        ListTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: const Text('Hide this post'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _posts.remove(post));
            })
      ])),
    );
  }
}

class _VoiceRoomBanner extends StatelessWidget {
  const _VoiceRoomBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GradientPanel(
      padding: const EdgeInsets.all(17),
      child: Row(children: [
        Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .17),
                shape: BoxShape.circle),
            child: const Icon(Icons.graphic_eq_rounded, color: Colors.white)),
        const SizedBox(width: 12),
        const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Live voice rooms',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 17)),
          Text('39 learners are speaking now',
              style: TextStyle(color: Colors.white70, fontSize: 12))
        ])),
        FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(78, 42)),
            child: const Text('Join'))
      ]),
    );
  }
}

class _Partner extends StatelessWidget {
  const _Partner(
      {required this.avatar,
      required this.name,
      required this.detail,
      required this.online});
  final String avatar;
  final String name;
  final String detail;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      margin: const EdgeInsetsDirectional.only(end: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(children: [
        Stack(children: [
          Text(avatar, style: const TextStyle(fontSize: 32)),
          if (online)
            PositionedDirectional(
                end: 0,
                bottom: 2,
                child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).cardTheme.color!,
                            width: 2))))
        ]),
        const SizedBox(height: 3),
        Text(name,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        Text(detail,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 9.5))
      ]),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onMore});
  final CommunityPost post;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
                child: Text(post.avatar, style: const TextStyle(fontSize: 23))),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(post.author,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  Text('${post.nativeLanguage} → ${post.learningLanguage}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11))
                ])),
            IconButton(
                onPressed: onMore, icon: const Icon(Icons.more_horiz_rounded))
          ]),
          const SizedBox(height: 12),
          Text(post.text,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, fontWeight: FontWeight.w600)),
          if (post.correctedText != null) ...[
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Native correction',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(post.correctedText!,
                          style: const TextStyle(fontWeight: FontWeight.w700))
                    ]))
          ],
          const SizedBox(height: 12),
          Row(children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border_rounded)),
            Text('${post.likes}'),
            const SizedBox(width: 12),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline_rounded)),
            Text('${post.comments}'),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border_rounded))
          ])
        ]),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile(
      {required this.title,
      required this.people,
      required this.level,
      required this.color});
  final String title;
  final int people;
  final String level;
  final Color color;

  @override
  Widget build(BuildContext context) => ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(Icons.graphic_eq_rounded, color: color)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text('$people speaking · $level'),
      trailing:
          FilledButton.tonal(onPressed: () {}, child: const Text('Join')));
}

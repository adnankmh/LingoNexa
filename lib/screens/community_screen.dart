import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final Set<CommunityPost> _liked = {};
  final Set<CommunityPost> _saved = {};
  final Map<CommunityPost, List<String>> _comments = {};

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    if (!state.communityEnabled) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_alt_outlined, size: 70),
              const SizedBox(height: 14),
              Text(
                'Community is disabled by the administrator.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
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
                    Text(
                      context.text.get('community'),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.text.get('community_subtitle'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: _composePost,
                icon: const Icon(Icons.add_rounded),
                label: Text(context.text.get('post')),
              ),
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
                  online: true,
                ),
                _Partner(
                  avatar: '👨🏻',
                  name: 'Kenji',
                  detail: 'JA → EN',
                  online: true,
                ),
                _Partner(
                  avatar: '👩🏻',
                  name: 'Amélie',
                  detail: 'FR → AR',
                  online: false,
                ),
                _Partner(
                  avatar: '👨🏾',
                  name: 'Daniel',
                  detail: 'EN → SW',
                  online: true,
                ),
                _Partner(
                  avatar: '👩🏼',
                  name: 'Lena',
                  detail: 'DE → TR',
                  online: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final post in _posts)
            _PostCard(
              post: post,
              liked: _liked.contains(post),
              saved: _saved.contains(post),
              commentCount: post.comments + (_comments[post]?.length ?? 0),
              onLike: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (!_liked.add(post)) _liked.remove(post);
                });
              },
              onComment: () => _showComments(post),
              onSave: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (!_saved.add(post)) _saved.remove(post);
                });
              },
              onMore: () => _moderationSheet(post),
            ),
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
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.text.get('practice_with_community'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              minLines: 4,
              maxLines: 7,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: context.text.get('write_learning_language'),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim().isNotEmpty),
              child: Text(context.text.get('publish')),
            ),
          ],
        ),
      ),
    );
    if (submitted == true && controller.text.trim().isNotEmpty) {
      setState(
        () => _posts.insert(
          0,
          CommunityPost(
            author: AppStateScope.of(context).currentUser!.displayName,
            nativeLanguage: AppStateScope.of(context).nativeLanguageCode,
            learningLanguage: AppStateScope.of(context).targetLanguageCode,
            text: controller.text.trim(),
            avatar: '🙂',
            likes: 0,
            comments: 0,
          ),
        ),
      );
    }
    controller.dispose();
  }

  Future<void> _showComments(CommunityPost post) async {
    final controller = TextEditingController();
    final comments = _comments.putIfAbsent(post, () => []);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, refresh) => Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            0,
            18,
            MediaQuery.viewInsetsOf(context).bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.text.get('discussion'),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(post.text, maxLines: 3, overflow: TextOverflow.ellipsis),
              const Divider(height: 24),
              if (comments.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(context.text.get('start_discussion')),
                ),
              for (final comment in comments)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    AppStateScope.of(context).currentUser!.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(comment),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: context.text.get('write_comment'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: context.text.get('tip_send'),
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;
                      comments.add(text);
                      controller.clear();
                      refresh(() {});
                      setState(() {});
                    },
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              Text(
                context.text.get('voice_rooms'),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              _RoomTile(
                title: context.text.get('room_english_confidence'),
                people: 18,
                level: 'A2–B1',
                color: Color(0xFF6C63FF),
                onJoin: () =>
                    _openRoom(context.text.get('room_english_confidence')),
              ),
              _RoomTile(
                title: context.text.get('room_arabic_exchange'),
                people: 9,
                level: context.text.get('all_levels'),
                color: Color(0xFF20C997),
                onJoin: () =>
                    _openRoom(context.text.get('room_arabic_exchange')),
              ),
              _RoomTile(
                title: context.text.get('room_spanish_stories'),
                people: 12,
                level: 'B1',
                color: Color(0xFFFFA94D),
                onJoin: () =>
                    _openRoom(context.text.get('room_spanish_stories')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRoom(String title) {
    var microphoneOn = false;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.graphic_eq_rounded, size: 58),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  context.text.get('room_preview_note'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                IconButton.filled(
                  tooltip: context.text.get('tip_record'),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    refresh(() => microphoneOn = !microphoneOn);
                  },
                  icon: Icon(
                    microphoneOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  microphoneOn
                      ? context.text.get('microphone_on')
                      : context.text.get('microphone_off'),
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.text.get('leave_room')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _moderationSheet(CommunityPost post) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(context.text.get('report_post')),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.text.get('report_received'))),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_rounded),
              title: Text('${context.text.get('block_user')} ${post.author}'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(context.text.get('hide_post')),
              onTap: () {
                Navigator.pop(context);
                setState(() => _posts.remove(post));
              },
            ),
          ],
        ),
      ),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .17),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.text.get('voice_rooms'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '39 ${context.text.get('learners_speaking_now')}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(78, 42),
            ),
            child: Text(context.text.get('join')),
          ),
        ],
      ),
    );
  }
}

class _Partner extends StatelessWidget {
  const _Partner({
    required this.avatar,
    required this.name,
    required this.detail,
    required this.online,
  });
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
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Stack(
            children: [
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
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            name,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
          Text(
            detail,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.liked,
    required this.saved,
    required this.commentCount,
    required this.onLike,
    required this.onComment,
    required this.onSave,
    required this.onMore,
  });
  final CommunityPost post;
  final bool liked;
  final bool saved;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onSave;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    post.avatar,
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${post.nativeLanguage} → ${post.learningLanguage}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: context.text.get('tip_more'),
                  onPressed: onMore,
                  icon: const Icon(Icons.more_horiz_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (post.correctedText != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Native correction',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.correctedText!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  tooltip: context.text.get('tip_like'),
                  onPressed: onLike,
                  icon: Icon(
                    liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: liked ? Colors.red : null,
                  ),
                ),
                Text('${post.likes + (liked ? 1 : 0)}'),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: context.text.get('tip_comment'),
                  onPressed: onComment,
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                Text('$commentCount'),
                const Spacer(),
                IconButton(
                  tooltip: context.text.get('tip_save'),
                  onPressed: onSave,
                  icon: Icon(
                    saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({
    required this.title,
    required this.people,
    required this.level,
    required this.color,
    required this.onJoin,
  });
  final String title;
  final int people;
  final String level;
  final Color color;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: color.withValues(alpha: .15),
      child: Icon(Icons.graphic_eq_rounded, color: color),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text('$people speaking · $level'),
    trailing: FilledButton.tonal(
      onPressed: onJoin,
      child: Text(context.text.get('join')),
    ),
  );
}

import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Course Packs')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [const Icon(Icons.offline_bolt_rounded, size: 33), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Learn without a connection', style: TextStyle(fontWeight: FontWeight.w900)), Text('${state.downloadedPackCodes.length} packs selected · Wi-Fi recommended', style: const TextStyle(fontSize: 11.5))]))]),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                    itemCount: LanguageCatalog.all.length,
                    itemBuilder: (context, index) {
                      final language = LanguageCatalog.all[index];
                      final downloaded = state.downloadedPackCodes.contains(language.code);
                      final size = 42 + (index * 17) % 210;
                      return Card(
                        child: ListTile(
                          leading: Text(language.flag, style: const TextStyle(fontSize: 31)),
                          title: Text(language.nativeName, style: const TextStyle(fontWeight: FontWeight.w900)),
                          subtitle: Text('${language.englishName} · $size MB · lessons + audio'),
                          trailing: downloaded ? IconButton(onPressed: () => state.toggleDownloadedPack(language.code), icon: const Icon(Icons.delete_outline_rounded)) : IconButton.filledTonal(onPressed: () => state.toggleDownloadedPack(language.code), icon: const Icon(Icons.download_rounded)),
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


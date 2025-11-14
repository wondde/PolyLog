import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polylog/providers.dart';
import 'package:polylog/l10n/app_localizations.dart';

/// 최근 학습한 단어 목록 페이지
class VocabularyListPage extends ConsumerWidget {
  /// [VocabularyListPage] 생성자
  const VocabularyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final uid = authState.value?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.newVocabulary)),
        body: const Center(child: Text('로그인이 필요합니다')),
      );
    }

    final recentVocabAsync = ref.watch(recentVocabularyProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newVocabulary),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: '단어장으로 이동',
            onPressed: () {
              context.go('/vocabulary');
            },
          ),
        ],
      ),
      body: recentVocabAsync.when(
        data: (vocab) {
          if (vocab.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '아직 학습한 단어가 없습니다.\n일기를 작성하고 AI 분석을 받아보세요!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: vocab.length,
            itemBuilder: (context, index) {
              final item = vocab[index];
              final meaning =
                  item.meanings.isNotEmpty ? item.meanings.first : '';
              final level = item.level ?? 'A1';

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getLevelColor(level),
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    item.lemma,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        meaning,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.pos.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: '단어장으로 이동',
                    onPressed: () {
                      context.go('/vocabulary');
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'A1':
      case 'A2':
        return Colors.green;
      case 'B1':
      case 'B2':
        return Colors.orange;
      case 'C1':
      case 'C2':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

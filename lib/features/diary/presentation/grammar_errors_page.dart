import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polylog/providers.dart';
import 'package:polylog/l10n/app_localizations.dart';

/// 문법 오류 목록 페이지
class GrammarErrorsPage extends ConsumerWidget {
  /// [GrammarErrorsPage] 생성자
  const GrammarErrorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final uid = authState.value?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.commonGrammarMistakes)),
        body: const Center(child: Text('로그인이 필요합니다')),
      );
    }

    final topErrorsAsync = ref.watch(topGrammarErrorsProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.commonGrammarMistakes),
      ),
      body: topErrorsAsync.when(
        data: (errors) {
          if (errors.isEmpty) {
            return const Center(
              child: Text('아직 문법 데이터가 없습니다.\n일기를 작성하고 AI 분석을 받아보세요!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: errors.length,
            itemBuilder: (context, index) {
              final error = errors[index];
              final note = error['note'] as String;
              final count = error['count'] as int;

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    note,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text('$count회 반복'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.push('/grammar-error-entries', extra: note);
                  },
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
}

/// 특정 문법 오류가 포함된 일기 목록 페이지
class GrammarErrorEntriesPage extends ConsumerStatefulWidget {
  /// 문법 노트
  final String grammarNote;

  /// [GrammarErrorEntriesPage] 생성자
  const GrammarErrorEntriesPage({super.key, required this.grammarNote});

  @override
  ConsumerState<GrammarErrorEntriesPage> createState() =>
      _GrammarErrorEntriesPageState();
}

class _GrammarErrorEntriesPageState
    extends ConsumerState<GrammarErrorEntriesPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final uid = authState.value?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('문법 오류 일기')),
        body: const Center(child: Text('로그인이 필요합니다')),
      );
    }

    final entriesAsync = ref.watch(userEntriesProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('해당 문법이 포함된 일기'),
      ),
      body: entriesAsync.when(
        data: (allEntries) {
          return FutureBuilder<List<String>>(
            future:
                _filterEntriesWithGrammar(allEntries, widget.grammarNote, ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('해당 문법이 포함된 일기가 없습니다'),
                );
              }

              final filteredEntryIds = snapshot.data!;
              final filteredEntries = allEntries
                  .where((e) => filteredEntryIds.contains(e.id))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  final entry = filteredEntries[index];
                  final preview = entry.textRaw.length > 50
                      ? '${entry.textRaw.substring(0, 50)}...'
                      : entry.textRaw;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      title: Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${entry.createdAt.year}-${entry.createdAt.month.toString().padLeft(2, '0')}-${entry.createdAt.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push('/entries/${entry.id}');
                      },
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
    );
  }

  Future<List<String>> _filterEntriesWithGrammar(
    List entries,
    String grammarNote,
    WidgetRef ref,
  ) async {
    final List<String> matchingEntryIds = [];

    for (final entry in entries) {
      try {
        final repository = ref.read(diaryRepositoryProvider);
        final ai = await repository.getAI(entry.id);

        if (ai != null &&
            ai.grammarNotes.any((note) => note.contains(grammarNote))) {
          matchingEntryIds.add(entry.id);
        }
      } catch (e) {
        // Skip entries with errors
        continue;
      }
    }

    return matchingEntryIds;
  }
}

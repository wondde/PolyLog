import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polylog/providers.dart';
import 'package:polylog/core/widgets/diff_text.dart';
import 'package:polylog/core/widgets/ruby_text.dart';
import 'package:polylog/l10n/app_localizations.dart';

/// AI 리뷰 화면
class AIReviewPage extends ConsumerStatefulWidget {
  /// 항목 ID
  final String entryId;

  /// [AIReviewPage] 생성자
  const AIReviewPage({super.key, required this.entryId});

  @override
  ConsumerState<AIReviewPage> createState() => _AIReviewPageState();
}

class _AIReviewPageState extends ConsumerState<AIReviewPage> {
  var _waitSeconds = 0;

  @override
  void initState() {
    super.initState();
    // 타임아웃 타이머 시작
    Future.delayed(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (mounted) {
      setState(() => _waitSeconds++);
      if (_waitSeconds < 60) {
        Future.delayed(const Duration(seconds: 1), _updateTimer);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final diaryRepo = ref.watch(diaryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => GoRouter.of(context).go('/home'),
        ),
        title: Text(l10n.aiReview),
      ),
      body: FutureBuilder(
        future: diaryRepo.getEntry(widget.entryId),
        builder: (context, entrySnapshot) {
          if (!entrySnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entry = entrySnapshot.data!;
          final aiAsync = ref.watch(entryAIProvider(widget.entryId));

          return aiAsync.when(
            data: (ai) {
              if (ai == null) {
                // 60초 이상 대기 시 타임아웃 메시지 표시
                if (_waitSeconds >= 60) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          Text(
                            l10n.aiAnalysisTakingLong,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.checkFirebaseLogs,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Entry ID: ${widget.entryId}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() => _waitSeconds = 0);
                              ref.invalidate(entryAIProvider(widget.entryId));
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.refresh),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        l10n.aiAnalysisInProgress(_waitSeconds),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Entry ID: ${widget.entryId}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: l10n.corrections),
                        Tab(text: l10n.natural),
                        Tab(text: l10n.vocab),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _CorrectionsTab(entry: entry, ai: ai),
                          _NaturalTab(ai: ai),
                          _VocabTab(ai: ai, entryId: widget.entryId),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.loadingData),
                ],
              ),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      l10n.errorOccurred,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$err',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _waitSeconds = 0);
                        ref.invalidate(entryAIProvider(widget.entryId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CorrectionsTab extends StatelessWidget {
  final dynamic entry;
  final dynamic ai;

  const _CorrectionsTab({required this.entry, required this.ai});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original vs Corrected
          Text(
            l10n.originalVsCorrected,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DiffText(
                before: entry.textRaw,
                after: ai.corrected,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Scores
          Text(
            l10n.scores,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  title: l10n.fluency,
                  score: ai.score.fluency,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreCard(
                  title: l10n.accuracy,
                  score: ai.score.accuracy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Grammar Notes
          if (ai.grammarNotes.isNotEmpty) ...[
            Text(
              l10n.grammarNotes,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...ai.grammarNotes.map((note) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(note),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _NaturalTab extends StatelessWidget {
  final dynamic ai;

  const _NaturalTab({required this.ai});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showRuby = ai.rendering?.jaFurigana ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.casualExpression,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: showRuby
                  ? RubyText(ai.natural.casual)
                  : Text(ai.natural.casual),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.formalExpression,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: showRuby
                  ? RubyText(ai.natural.formal)
                  : Text(ai.natural.formal),
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabTab extends ConsumerWidget {
  final dynamic ai;
  final String entryId;

  const _VocabTab({required this.ai, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (ai.vocab.isEmpty) {
      return Center(
        child: Text(l10n.noVocabularyFound),
      );
    }

    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text(l10n.loginRequired));
        }

        return Column(
          children: [
            // 모든 단어 추가 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton.icon(
                onPressed: () async {
                  try {
                    // 일기의 언어 가져오기
                    final entryAsync = ref.read(userEntriesProvider(user.uid));
                    String lang = 'en';
                    entryAsync.when(
                      data: (entries) {
                        final entry = entries.firstWhere(
                          (e) => e.id == entryId,
                          orElse: () => entries.first,
                        );
                        lang = entry.lang;
                      },
                      loading: () {},
                      error: (_, __) {},
                    );

                    int addedCount = 0;
                    int skippedCount = 0;

                    for (final vocab in ai.vocab) {
                      try {
                        await ref.read(vocabularyControllerProvider.notifier).addCard(
                              uid: user.uid,
                              lemma: vocab.lemma,
                              pos: vocab.pos,
                              meanings: vocab.meanings,
                              level: vocab.level ?? 'unknown',
                              example: vocab.example,
                              lang: lang,
                              sourceEntryId: entryId,
                            );
                        addedCount++;
                      } catch (e) {
                        if (e.toString().contains('이미 단어장에 존재')) {
                          skippedCount++;
                        }
                      }
                    }

                    if (context.mounted) {
                      final l10n = AppLocalizations.of(context)!;
                      String message = '';
                      if (addedCount > 0 && skippedCount > 0) {
                        message = l10n.wordsAddedAndSkipped(addedCount, skippedCount);
                      } else if (addedCount > 0) {
                        message = l10n.wordsAddedCount(addedCount);
                      } else if (skippedCount > 0) {
                        message = l10n.allWordsAlreadyExist;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.errorWithMessage(e.toString()))),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.add_box),
                label: Text(l10n.addAllWords(ai.vocab.length)),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: ai.vocab.length,
                itemBuilder: (context, index) {
                  final vocab = ai.vocab[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vocab.lemma,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(vocab.pos),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        if (vocab.level != null) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(vocab.level!),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: AppLocalizations.of(context)!.addToVocabulary,
                          onPressed: () async {
                            try {
                              // 일기의 언어 가져오기
                              final entryAsync = ref.read(userEntriesProvider(user.uid));
                              String lang = 'en';
                              entryAsync.when(
                                data: (entries) {
                                  final entry = entries.firstWhere(
                                    (e) => e.id == entryId,
                                    orElse: () => entries.first,
                                  );
                                  lang = entry.lang;
                                },
                                loading: () {},
                                error: (_, __) {},
                              );

                              await ref.read(vocabularyControllerProvider.notifier).addCard(
                                    uid: user.uid,
                                    lemma: vocab.lemma,
                                    pos: vocab.pos,
                                    meanings: vocab.meanings,
                                    level: vocab.level ?? 'unknown',
                                    example: vocab.example,
                                    lang: lang,
                                    sourceEntryId: entryId,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.wordAdded(vocab.lemma))),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                final l10n = AppLocalizations.of(context)!;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString().contains('이미 단어장에 존재')
                                        ? l10n.wordAlreadyExists
                                        : l10n.errorWithMessage(e.toString())),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...vocab.meanings.map((meaning) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(meaning)),
                            ],
                          ),
                        )),
                    if (vocab.example.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          vocab.example,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(AppLocalizations.of(context)!.errorOccurred)),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final int score;

  const _ScoreCard({required this.title, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(score),
                  ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(_getScoreColor(score)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

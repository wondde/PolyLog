import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polylog/core/utils/language_support.dart';
import 'package:polylog/features/vocabulary/domain/models.dart';
import 'package:polylog/l10n/app_localizations.dart';
import 'package:polylog/providers.dart';

/// 단어장 메인 화면 - 퀴즈 중심
class VocabularyPage extends ConsumerWidget {
  /// [VocabularyPage] 생성자
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(child: Text(l10n.loginRequired)),
          );
        }

        final dueCardsAsync = ref.watch(dueCardsProvider(user.uid));
        final todayCountAsync = ref.watch(todayReviewCountProvider(user.uid));
        final totalCountAsync = ref.watch(totalCardCountProvider(user.uid));
        final newCardsAsync = ref.watch(newCardsProvider(user.uid));
        final learningCardsAsync = ref.watch(learningCardsProvider(user.uid));

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.vocabulary),
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: l10n.viewAllWords,
                onPressed: () =>
                    _showCardListBottomSheet(context, ref, user.uid),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 퀴즈 카드 섹션
                  _buildQuizSectionWithData(
                    context,
                    ref,
                    user.uid,
                    dueCardsAsync,
                    newCardsAsync,
                    learningCardsAsync,
                  ),
                  const SizedBox(height: 24),

                  // 통계 섹션
                  _buildStatsSection(
                    context,
                    dueCardsAsync,
                    todayCountAsync,
                    totalCountAsync,
                    newCardsAsync,
                    learningCardsAsync,
                  ),
                  const SizedBox(height: 24),

                  // 단어 목록 버튼
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showCardListBottomSheet(context, ref, user.uid),
                    icon: const Icon(Icons.view_list),
                    label: Text(l10n.viewAllWords),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 디버그 버튼
                  OutlinedButton.icon(
                    onPressed: () => _showDebugInfo(context, ref, user.uid,
                        dueCardsAsync, newCardsAsync, learningCardsAsync),
                    icon: const Icon(Icons.bug_report),
                    label: Text(l10n.viewDebugInfo),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddCardDialog(context, ref, user.uid),
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('오류: $err')),
      ),
    );
  }

  Widget _buildQuizSectionWithData(
    BuildContext context,
    WidgetRef ref,
    String uid,
    AsyncValue<List<VocabularyCard>> dueCardsAsync,
    AsyncValue<List<VocabularyCard>> newCardsAsync,
    AsyncValue<List<VocabularyCard>> learningCardsAsync,
  ) {
    final totalCountAsync = ref.watch(totalCardCountProvider(uid));

    return dueCardsAsync.when(
      data: (dueCards) {
        return newCardsAsync.when(
          data: (newCards) {
            return learningCardsAsync.when(
              data: (learningCards) {
                // 복습 가능한 모든 카드 합치기: due + new + learning
                final allReviewableCards = [
                  ...dueCards,
                  ...newCards,
                  ...learningCards,
                ];

                if (allReviewableCards.isEmpty) {
                  // 총 카드 수를 확인하여 정말 단어가 없는지, 학습 완료인지 구분
                  return totalCountAsync.when(
                    data: (totalCount) => totalCount > 0
                        ? _buildCompletedState(context)
                        : _buildEmptyState(context),
                    loading: () => _buildEmptyState(context),
                    error: (_, __) => _buildEmptyState(context),
                  );
                }

                return _buildQuizSection(context, allReviewableCards);
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                  child: Text(AppLocalizations.of(context)!
                      .errorWithMessage(err.toString()))),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => Center(
              child: Text(AppLocalizations.of(context)!
                  .errorWithMessage(err.toString()))),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Center(
          child: Text(
              AppLocalizations.of(context)!.errorWithMessage(err.toString()))),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noEntriesYet,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.writeYourFirstDiary,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.allReviewsComplete,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.goBack,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(
      BuildContext context, List<VocabularyCard> allCards) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final firstCard = allCards.first;

    return Column(
      children: [
        // 카드 프리뷰
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.today,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.entriesCount(allCards.length),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                firstCard.lemma,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  firstCard.pos.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Icon(
                Icons.help_outline,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.howWellRemember,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 복습 시작 버튼
        FilledButton.icon(
          onPressed: () => context.push('/vocabulary/review'),
          icon: const Icon(Icons.play_arrow, size: 28),
          label: Text(
            l10n.reviewStart,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    AsyncValue<List<VocabularyCard>> dueCardsAsync,
    AsyncValue<int> todayCountAsync,
    AsyncValue<int> totalCountAsync,
    AsyncValue<List<VocabularyCard>> newCardsAsync,
    AsyncValue<List<VocabularyCard>> learningCardsAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.learningProgress,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.event_available,
                label: l10n.dueForReview,
                value: dueCardsAsync.when(
                  data: (cards) => '${cards.length}',
                  loading: () => '-',
                  error: (_, __) => '0',
                ),
                color: const Color(0xFF8D6E63), // 차분한 갈색
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.check_circle,
                label: AppLocalizations.of(context)!.todayCompleted,
                value: todayCountAsync.when(
                  data: (count) => '$count',
                  loading: () => '-',
                  error: (_, __) => '0',
                ),
                color: const Color(0xFF81C784), // 부드러운 녹색
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.fiber_new,
                label: AppLocalizations.of(context)!.newCards,
                value: newCardsAsync.when(
                  data: (cards) => '${cards.length}',
                  loading: () => '-',
                  error: (_, __) => '0',
                ),
                color: const Color(0xFF64B5F6), // 부드러운 파란색
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.school,
                label: AppLocalizations.of(context)!.learning,
                value: learningCardsAsync.when(
                  data: (cards) => '${cards.length}',
                  loading: () => '-',
                  error: (_, __) => '0',
                ),
                color: const Color(0xFFFFB74D), // 부드러운 주황색
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          context,
          icon: Icons.library_books,
          label: AppLocalizations.of(context)!.totalWords,
          value: totalCountAsync.when(
            data: (count) => '$count',
            loading: () => '-',
            error: (_, __) => '0',
          ),
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCardListBottomSheet(
      BuildContext context, WidgetRef ref, String uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _CardListView(
          uid: uid,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showDebugInfo(
    BuildContext context,
    WidgetRef ref,
    String uid,
    AsyncValue<List<VocabularyCard>> dueCardsAsync,
    AsyncValue<List<VocabularyCard>> newCardsAsync,
    AsyncValue<List<VocabularyCard>> learningCardsAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final dueCount = dueCardsAsync.when(
        data: (cards) => cards.length, loading: () => -1, error: (_, __) => -1);
    final newCount = newCardsAsync.when(
        data: (cards) => cards.length, loading: () => -1, error: (_, __) => -1);
    final learningCount = learningCardsAsync.when(
        data: (cards) => cards.length, loading: () => -1, error: (_, __) => -1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.debugInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UID: $uid'),
            const Divider(),
            Text('Due cards: $dueCount'),
            Text('New cards: $newCount'),
            Text('Learning cards: $learningCount'),
            Text('Total: ${dueCount + newCount + learningCount}'),
            const Divider(),
            Text('${l10n.status}:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Due async: ${dueCardsAsync.runtimeType}'),
            Text('New async: ${newCardsAsync.runtimeType}'),
            Text('Learning async: ${learningCardsAsync.runtimeType}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog(BuildContext context, WidgetRef ref, String uid) {
    final l10n = AppLocalizations.of(context)!;
    final lemmaController = TextEditingController();
    final meaningsController = TextEditingController();
    String selectedLang = 'en';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addWord),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lemmaController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.word,
                  hintText: 'apple',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: meaningsController,
                decoration: InputDecoration(
                  labelText: l10n.meaning,
                  hintText: '사과',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedLang,
                decoration: InputDecoration(
                  labelText: l10n.language,
                  border: const OutlineInputBorder(),
                ),
                items: languagePickerOrder
                    .map(
                      (code) => DropdownMenuItem(
                        value: code,
                        child: Text(
                            '${languageFlag(code)} ${localizedLanguageLabel(code, l10n)}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLang = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (lemmaController.text.isEmpty ||
                    meaningsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.enterWordAndMeaning)),
                  );
                  return;
                }

                try {
                  final word = lemmaController.text.trim();
                  await ref.read(vocabularyControllerProvider.notifier).addCard(
                        uid: uid,
                        lemma: word,
                        pos: 'word',
                        meanings: [meaningsController.text.trim()],
                        level: 'A1',
                        example: '',
                        lang: selectedLang,
                      );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.wordAdded(word))),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(l10n.errorWithMessage(e.toString()))),
                    );
                  }
                }
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}

/// 카드 목록 뷰 (바텀시트용)
class _CardListView extends ConsumerStatefulWidget {
  final String uid;
  final ScrollController scrollController;

  const _CardListView({
    required this.uid,
    required this.scrollController,
  });

  @override
  ConsumerState<_CardListView> createState() => _CardListViewState();
}

class _CardListViewState extends ConsumerState<_CardListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allCardsAsync = ref.watch(userVocabularyCardsProvider(widget.uid));
    final newCardsAsync = ref.watch(newCardsProvider(widget.uid));
    final learningCardsAsync = ref.watch(learningCardsProvider(widget.uid));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  l10n.viewAllWords,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.all),
              Tab(text: l10n.newCards),
              Tab(text: l10n.learning),
              Tab(text: l10n.reviewing),
            ],
          ),
          const Divider(height: 1),
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCardList(allCardsAsync, l10n.all),
                _buildCardList(newCardsAsync, l10n.newCards),
                _buildCardList(learningCardsAsync, l10n.learning),
                _buildReviewCards(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList(
    AsyncValue<List<VocabularyCard>> cardsAsync,
    String emptyMessage,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return cardsAsync.when(
      data: (cards) {
        if (cards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noCardsInCategory(emptyMessage),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _buildCardItem(card);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text(l10n.errorWithMessage(err.toString()))),
    );
  }

  Widget _buildReviewCards() {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(userVocabularyCardsProvider(widget.uid));
    return cardsAsync.when(
      data: (cards) {
        final reviewCards =
            cards.where((c) => c.state == CardState.review).toList();
        if (reviewCards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noCardsInCategory(l10n.reviewing),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: reviewCards.length,
          itemBuilder: (context, index) {
            final card = reviewCards[index];
            return _buildCardItem(card);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text(l10n.errorWithMessage(err.toString()))),
    );
  }

  Widget _buildCardItem(VocabularyCard card) {
    final l10n = AppLocalizations.of(context)!;
    Color stateColor;
    String stateText;

    switch (card.state) {
      case CardState.newCard:
        stateColor = const Color(0xFF64B5F6); // 부드러운 파란색
        stateText = l10n.newCard;
      case CardState.learning:
        stateColor = const Color(0xFFFFB74D); // 부드러운 주황색
        stateText = l10n.learning;
      case CardState.review:
        stateColor = const Color(0xFF81C784); // 부드러운 녹색
        stateText = l10n.reviewing;
      case CardState.leech:
        stateColor = const Color(0xFFE57373); // 부드러운 빨간색
        stateText = l10n.problemCard;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                card.lemma,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stateColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: stateColor),
              ),
              child: Text(
                stateText,
                style: TextStyle(
                  color: stateColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              card.meanings.join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  card.pos.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  card.level,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (card.due != null && !card.isNew)
                  Text(
                    '${AppLocalizations.of(context)!.next}: ${_formatDueDate(card.due!)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime due) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = due.difference(now);

    if (diff.isNegative) {
      return l10n.now;
    } else if (diff.inDays > 0) {
      return l10n.daysLater(diff.inDays);
    } else if (diff.inHours > 0) {
      return l10n.hoursLater(diff.inHours);
    } else if (diff.inMinutes > 0) {
      return l10n.minutesLater(diff.inMinutes);
    } else {
      return l10n.soon;
    }
  }
}

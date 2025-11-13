import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/models.dart';

/// 대시보드 화면
///
/// 사용자의 학습 통계를 표시합니다:
/// - 연속 학습 일수
/// - 주간 학습량
/// - 자주 하는 문법 실수
/// - 최근 학습한 단어
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userDoc = ref.watch(currentUserDocProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns based on screen width
    final crossAxisCount = (screenWidth / 350).floor().clamp(1, 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
      ),
      body: userDoc.when(
        data: (userData) {
          if (userData == null) {
            return Center(child: Text(l10n.loadingUserData));
          }

          final cards = _buildCardData(context, ref, userData, l10n);

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8, // Adjust aspect ratio as needed
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }
}

List<Widget> _buildCardData(BuildContext context, WidgetRef ref,
    UserModel userData, AppLocalizations l10n) {
  return [
    // Streak Card
    Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/streak'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.orange, size: 40),
              const SizedBox(height: 8),
              Text(
                '${userData.streak}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                l10n.dayStreakLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    ),
    // Weekly Goal Card
    _buildWeeklyStatsCard(
        context, ref, userData.uid, userData.weeklyGoal, l10n),
    // Top Grammar Errors Card
    _buildTopGrammarErrorsCard(context, ref, userData.uid, l10n),
    // Recent Vocabulary Card
    _buildRecentVocabularyCard(context, ref, userData.uid, l10n),
  ];
}

Widget _buildWeeklyStatsCard(BuildContext context, WidgetRef ref, String uid,
    int weeklyGoal, AppLocalizations l10n) {
  final weeklyStatsAsync = ref.watch(weeklyStatsProvider(uid));
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: weeklyStatsAsync.when(
        data: (stats) {
          final weeklyTotal =
              stats.values.fold<int>(0, (sum, count) => sum + count);
          final isGoalAchieved = weeklyTotal >= weeklyGoal;
          final progress = (weeklyGoal == 0)
              ? 0.0
              : (weeklyTotal / weeklyGoal).clamp(0.0, 1.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.weeklyGoal,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.goal,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '$weeklyTotal/$weeklyGoal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isGoalAchieved
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isGoalAchieved
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      ),
    ),
  );
}

Widget _buildTopGrammarErrorsCard(
    BuildContext context, WidgetRef ref, String uid, AppLocalizations l10n) {
  final topErrorsAsync = ref.watch(topGrammarErrorsProvider(uid));
  return Card(
    elevation: 2,
    child: InkWell(
      onTap: () => context.push('/grammar-errors'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: topErrorsAsync.when(
          data: (errors) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.commonGrammarMistakes,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              if (errors.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No grammar data yet.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: errors.length,
                    itemBuilder: (context, index) {
                      final error = errors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                '${error['note']} (${error['count']}회)',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
        ),
      ),
    ),
  );
}

Widget _buildRecentVocabularyCard(
    BuildContext context, WidgetRef ref, String uid, AppLocalizations l10n) {
  final recentVocabAsync = ref.watch(recentVocabularyProvider(uid));
  return Card(
    elevation: 2,
    child: InkWell(
      onTap: () => context.push('/vocabulary-list'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: recentVocabAsync.when(
          data: (vocab) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.newVocabulary,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              if (vocab.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No new vocabulary yet.'),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: vocab
                          .map((v) => Chip(
                                label: Text(
                                  v.lemma,
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers.dart';
import '../../../l10n/app_localizations.dart';

/// 활동 연속 기록 페이지
///
/// 히트맵 캘린더로 일기 작성 기록을 표시합니다.
class StreakPage extends ConsumerWidget {
  /// [StreakPage] 생성자
  const StreakPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final uid = authState.value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activityStreak),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: uid == null
          ? Center(child: Text(l10n.notLoggedIn))
          : ref.watch(userEntriesProvider(uid)).when(
                data: (entries) {
                  // Process data for the heatmap
                  final Map<DateTime, int> datasets = {};
                  for (var entry in entries) {
                    final date = DateTime(
                      entry.createdAt.year,
                      entry.createdAt.month,
                      entry.createdAt.day,
                    );
                    datasets[date] = (datasets[date] ?? 0) + 1;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        HeatMap(
                          datasets: datasets,
                          colorMode: ColorMode.opacity,
                          showText: false,
                          scrollable: true,
                          colorsets: const {
                            1: Colors.green,
                          },
                          onClick: (value) {
                            final count = datasets[value] ?? 0;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${value.month}/${value.day}: ${l10n.entriesCount(count)}',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.local_fire_department, color: Colors.orange),
                          title: Text(l10n.howItWorks),
                          subtitle: Text(l10n.streakDescription),
                        )
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
              ),
    );
  }
}

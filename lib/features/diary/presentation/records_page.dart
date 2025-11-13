import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers.dart';
import '../domain/models.dart';

// #region Top-level Helper Functions
// These are placed at the top level to be accessible by all widgets in this file.

bool _isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool _isYesterday(DateTime date) {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day;
}

IconData _getMoodIcon(String? mood) {
  switch (mood) {
    case 'happy':
      return Icons.sentiment_very_satisfied;
    case 'sad':
      return Icons.sentiment_dissatisfied;
    case 'angry':
      return Icons.sentiment_very_dissatisfied;
    case 'calm':
      return Icons.sentiment_satisfied;
    default:
      return Icons.article;
  }
}

Color _getMoodColor(String? mood) {
  switch (mood) {
    case 'happy':
      return Colors.green;
    case 'sad':
      return Colors.blue;
    case 'angry':
      return Colors.red;
    case 'calm':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

Color _getLanguageColor(String lang) {
  switch (lang) {
    case 'ja':
      return Colors.pink.shade400;
    case 'ko':
      return Colors.blue.shade400;
    case 'en':
      return Colors.amber.shade600;
    case 'de':
      return Colors.blueGrey.shade400;
    case 'es':
      return Colors.orange.shade400;
    case 'ar':
      return Colors.teal.shade400;
    case 'zh':
      return Colors.red.shade300;
    case 'fr':
      return Colors.blue.shade300;
    case 'ru':
      return Colors.deepPurple.shade300;
    case 'pt':
      return Colors.green.shade400;
    case 'it':
      return Colors.lightGreen.shade400;
    case 'vi':
      return Colors.pink.shade300;
    case 'th':
      return Colors.purple.shade200;
    default:
      return Colors.grey.shade400;
  }
}

Widget _getStatusWidget(String status, AppLocalizations l10n) {
  switch (status) {
    case 'done':
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
        const SizedBox(width: 4),
        Text(l10n.aiAnalysisComplete,
            style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ]);
    case 'error':
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.error, color: Colors.red.shade600, size: 16),
        const SizedBox(width: 4),
        Text(l10n.error,
            style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ]);
    default:
      return Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.orange.shade600))),
        const SizedBox(width: 6),
        Text(l10n.aiAnalyzing,
            style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ]);
  }
}

// #endregion

class RecordsPage extends ConsumerWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final uid = authState.value?.uid;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.records),
      ),
      body: uid == null
          ? Center(child: Text(l10n.notLoggedIn))
          : _EntriesList(
              uid: uid,
              onEntrySelected: (id) => context.push('/review/$id'),
            ),
    );
  }
}

class _EntriesList extends ConsumerWidget {
  final String uid;
  final Function(String) onEntrySelected;

  const _EntriesList({
    required this.uid,
    required this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(userEntriesProvider(uid));
    final l10n = AppLocalizations.of(context)!;

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(l10n.noEntriesYet),
                const SizedBox(height: 8),
                Text(l10n.writeYourFirstDiary),
              ],
            ),
          );
        }

        final groupedEntries = _groupEntriesByDate(entries);

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: groupedEntries.length,
          itemBuilder: (context, index) {
            final dateGroup = groupedEntries[index];
            return _DateSection(
              date: dateGroup['date'] as DateTime,
              entries: dateGroup['entries'] as List<EntryModel>,
              onEntrySelected: onEntrySelected,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
    );
  }

  List<Map<String, dynamic>> _groupEntriesByDate(List<EntryModel> entries) {
    final Map<String, List<EntryModel>> grouped = {};
    for (final entry in entries) {
      final dateKey = DateFormat('yyyy-MM-dd').format(entry.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(entry);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedKeys.map((key) {
      return {
        'date': DateTime.parse(key),
        'entries': grouped[key]!,
      };
    }).toList();
  }
}

class _DateSection extends StatelessWidget {
  final DateTime date;
  final List<EntryModel> entries;
  final Function(String) onEntrySelected;

  const _DateSection({
    required this.date,
    required this.entries,
    required this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String dateLabel;
    if (_isToday(date)) {
      dateLabel = l10n.today;
    } else if (_isYesterday(date)) {
      dateLabel = l10n.yesterday;
    } else {
      dateLabel = DateFormat.yMMMd(l10n.localeName).format(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(dateLabel,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.entriesCount(entries.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
        ...entries.map((entry) => _EntryCard(
              entry: entry,
              onTap: () => onEntrySelected(entry.id),
              isSelected: false,
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _EntryCard extends ConsumerWidget {
  final EntryModel entry;
  final VoidCallback onTap;
  final bool isSelected;

  const _EntryCard(
      {required this.entry, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 실제 AI 데이터가 있는지 확인
    final aiDataAsync = ref.watch(entryAIProvider(entry.id));
    final actualStatus = aiDataAsync.when(
      data: (aiData) => aiData != null ? 'done' : entry.aiStatus,
      loading: () => entry.aiStatus,
      error: (_, __) => entry.aiStatus,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: isSelected ? 4 : 2,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getMoodIcon(entry.mood),
                      size: 20, color: _getMoodColor(entry.mood)),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm').format(entry.createdAt),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getLanguageColor(entry.lang),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.lang.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  _getStatusWidget(actualStatus, l10n),
                ],
              ),
              const SizedBox(height: 12),
              Text(entry.textRaw,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

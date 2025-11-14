import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/core/utils/language_support.dart';
import 'package:polylog/l10n/app_localizations.dart';
import 'package:polylog/providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, l10n.appearance),
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: ref.watch(themeProvider) == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeProvider.notifier).toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(),
          _buildSectionHeader(context, l10n.language),
          ListTile(
            leading: const Icon(Icons.smartphone_outlined),
            title: Text(l10n.uiLanguage),
            subtitle: Text(
              localizedLanguageLabel(
                ref.watch(localeProvider).languageCode,
                l10n,
              ),
            ),
            onTap: () {
              _showUILanguageDialog(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l10n.learningLanguages),
            subtitle: Text(
              _getLearnLangsText(
                ref.watch(currentUserDocProvider).value?.learnLangs ?? [],
                l10n,
              ),
            ),
            onTap: () {
              _showLearningLanguagesDialog(context, ref);
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'AI'),
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            title: Text(l10n.aiExplanationLanguage),
            subtitle: Text(
              localizedLanguageLabel(
                ref.watch(currentUserDocProvider).value?.prefs.aiLang ?? 'en',
                l10n,
              ),
            ),
            onTap: () {
              _showAILanguageDialog(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(l10n.weeklyGoal),
            subtitle: Text(l10n.entriesPerWeek(
                ref.watch(currentUserDocProvider).value?.weeklyGoal ?? 7)),
            onTap: () {
              _showWeeklyGoalDialog(context, ref);
            },
          ),
          const Divider(),
          _buildSectionHeader(context, l10n.account),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l10n.logOut,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              // Ensure context is still valid before navigating
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getLearnLangsText(List<String> learnLangs, AppLocalizations l10n) {
    if (learnLangs.isEmpty) return l10n.notSetAllAvailable;
    return learnLangs
        .map((code) => localizedLanguageLabel(code, l10n))
        .join(', ');
  }

  void _showUILanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        final currentLang = ref.read(localeProvider).languageCode;

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectUILanguage,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: ListView.separated(
                    itemCount: languagePickerOrder.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final code = languagePickerOrder[index];
                      final isActive = currentLang == code;
                      final label = localizedLanguageLabel(code, l10n);

                      return InkWell(
                        onTap: () {
                          ref.read(localeProvider.notifier).changeLocale(code);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                languageFlag(code),
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  label,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isActive
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ),
                              if (isActive)
                                Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLearningLanguagesDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentLearnLangs =
        ref.read(currentUserDocProvider).value?.learnLangs ?? [];
    final selectedLangs = Set<String>.from(currentLearnLangs);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectLearningLanguages,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      width: double.maxFinite,
                      child: ListView.separated(
                        itemCount: languagePickerOrder.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final code = languagePickerOrder[index];
                          final isSelected = selectedLangs.contains(code);
                          final label = localizedLanguageLabel(code, l10n);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedLangs.remove(code);
                                } else {
                                  selectedLangs.add(code);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primaryContainer
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    languageFlag(code),
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      label,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: theme.colorScheme.primary,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            try {
                              // 다이얼로그 닫기
                              Navigator.pop(context);

                              // 학습 언어 업데이트
                              await ref
                                  .read(authRepositoryProvider)
                                  .updateLearningLanguages(
                                      selectedLangs.toList());

                              // Provider 갱신
                              ref.invalidate(currentUserDocProvider);

                              // 성공 메시지
                              if (context.mounted) {
                                final langNames = selectedLangs
                                    .map((code) =>
                                        localizedLanguageLabel(code, l10n))
                                    .join(', ');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${l10n.learningLanguages}: $langNames'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              // 에러 메시지
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${l10n.error}: $e'),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(l10n.save),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showWeeklyGoalDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentGoal = ref.read(currentUserDocProvider).value?.weeklyGoal ?? 7;

    showDialog<int>(
      context: context,
      builder: (context) {
        int selectedGoal = currentGoal;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(l10n.setWeeklyGoal),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.entriesPerWeek(selectedGoal),
                    style:
                        Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                              color: Theme.of(dialogContext).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 24),
                  SliderTheme(
                    data: SliderTheme.of(dialogContext).copyWith(
                      trackHeight: 4.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 24.0),
                    ),
                    child: Slider(
                      value: selectedGoal.toDouble(),
                      min: 1,
                      max: 14,
                      divisions: 13,
                      label: selectedGoal.toString(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedGoal = value.round();
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1',
                          style: Theme.of(dialogContext).textTheme.bodySmall),
                      Text('14',
                          style: Theme.of(dialogContext).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    try {
                      // 다이얼로그 닫기
                      Navigator.pop(dialogContext);

                      // 주간 목표 업데이트
                      await ref
                          .read(authRepositoryProvider)
                          .updateWeeklyGoal(selectedGoal);

                      // Provider 갱신
                      ref.invalidate(currentUserDocProvider);

                      // 성공 메시지
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.entriesPerWeek(selectedGoal)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      // 에러 메시지
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${l10n.error}: $e'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAILanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentPrefs = ref.read(currentUserDocProvider).value?.prefs;
    if (currentPrefs == null) return;

    showDialog(
      context: context,
      builder: (context) {
        final currentAILang = currentPrefs.aiLang;

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectAILanguage,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: ListView.separated(
                    itemCount: languagePickerOrder.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final code = languagePickerOrder[index];
                      final isActive = currentAILang == code;
                      final label = localizedLanguageLabel(code, l10n);

                      return InkWell(
                        onTap: () async {
                          try {
                            // 다이얼로그 닫기
                            Navigator.pop(context);

                            // AI 언어 업데이트
                            final newPrefs = currentPrefs.toMap()
                              ..['aiLang'] = code;
                            await ref
                                .read(authRepositoryProvider)
                                .updateUserPreferences(newPrefs);

                            // Provider 갱신
                            ref.invalidate(currentUserDocProvider);

                            // 성공 메시지
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${l10n.aiExplanationLanguage}: ${localizedLanguageLabel(code, l10n)}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            // 에러 메시지
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l10n.error}: $e'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                languageFlag(code),
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  label,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isActive
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ),
                              if (isActive)
                                Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

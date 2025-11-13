import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/core/utils/language_support.dart';
import 'package:polylog/features/diary/domain/models.dart';
import 'package:polylog/l10n/app_localizations.dart';
import 'package:polylog/providers.dart';

/// 온보딩 설정 화면 (언어 및 레벨 선택)
class OnboardingSetupPage extends ConsumerStatefulWidget {
  /// [OnboardingSetupPage] 생성자
  const OnboardingSetupPage({super.key});

  @override
  ConsumerState<OnboardingSetupPage> createState() =>
      _OnboardingSetupPageState();
}

class _OnboardingSetupPageState extends ConsumerState<OnboardingSetupPage> {
  String _nativeLang = 'ko';
  final Set<String> _learnLangs = {};
  final Map<String, String> _levels = {};
  bool _isLoading = false;
  final Set<String> _expandedAdvancedLangs = {};
  int _weeklyGoal = 7;

  static const List<String> _presetLevelCodes = ['A1', 'B1', 'C1'];
  static const List<String> _cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  Future<void> _completeSetup() async {
    final l10n = AppLocalizations.of(context)!;

    if (_learnLangs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingSelectAtLeastOne)),
      );
      return;
    }

    for (final lang in _learnLangs) {
      if (!_levels.containsKey(lang)) {
        final languageLabel = _languageLabel(lang, l10n);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.onboardingSelectLevelFor(languageLabel))),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = authRepo.currentUser;

      if (user == null) {
        throw Exception(l10n.onboardingUserNotFound);
      }

      await authRepo.completeOnboarding(
        uid: user.uid,
        nativeLang: _nativeLang,
        learnLangs: _learnLangs.toList(),
        level: _levels,
        prefs: const UserPreferences(),
        weeklyGoal: _weeklyGoal,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.onboardingSaveFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);

    // 인증 상태 변경 감지 - 로그아웃 시 루트로 이동
    ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (prev, next) {
        next.whenData((user) {
          if (user == null && context.mounted) {
            context.go('/');
          }
        });
      },
    );

    if (authState.isLoading || authState.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authState.hasError) {
      return Scaffold(
        body: Center(
          child: Text(l10n.onboardingSaveFailed(authState.error.toString())),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingSetupTitle),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onboardingNativeLanguageTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...languagePickerOrder.map((code) {
                      final label = _languageLabel(code, l10n);
                      return RadioListTile<String>(
                        title: Text(label),
                        value: code,
                        groupValue: _nativeLang,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _nativeLang = value;
                              _learnLangs.remove(value);
                              _levels.remove(value);
                              _expandedAdvancedLangs.remove(value);
                            });
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                    Text(
                      l10n.onboardingLearningLanguageTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...languagePickerOrder
                        .where((code) => code != _nativeLang)
                        .map((code) {
                      final label = _languageLabel(code, l10n);
                      final isSelected = _learnLangs.contains(code);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            title: Text(label),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _learnLangs.add(code);
                                } else {
                                  _learnLangs.remove(code);
                                  _levels.remove(code);
                                  _expandedAdvancedLangs.remove(code);
                                }
                              });
                            },
                          ),
                          if (isSelected) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.onboardingLevelQuestion,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: _presetLevelCodes.map((level) {
                                      final isPresetSelected =
                                          _levels[code] == level;
                                      final labelText =
                                          _presetLabel(level, l10n);
                                      final subtitleText =
                                          _presetSubtitle(level, l10n);
                                      return ChoiceChip(
                                        label: Text(
                                          '$labelText\n$subtitleText',
                                          textAlign: TextAlign.center,
                                        ),
                                        selected: isPresetSelected,
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() {
                                              _levels[code] = level;
                                            });
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_expandedAdvancedLangs
                                              .contains(code)) {
                                            _expandedAdvancedLangs.remove(code);
                                          } else {
                                            _expandedAdvancedLangs.add(code);
                                          }
                                        });
                                      },
                                      child: Text(
                                        _expandedAdvancedLangs.contains(code)
                                            ? l10n.onboardingHideDetailedLevels
                                            : l10n.onboardingShowDetailedLevels,
                                      ),
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: _expandedAdvancedLangs.contains(code)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                l10n.onboardingDetailedLevelHeader,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children:
                                                    _cefrLevels.map((level) {
                                                  final isLevelSelected =
                                                      _levels[code] == level;
                                                  return ChoiceChip(
                                                    label: Text(
                                                      _levelLabel(
                                                        level,
                                                        l10n,
                                                      ),
                                                    ),
                                                    selected: isLevelSelected,
                                                    onSelected: (selected) {
                                                      if (selected) {
                                                        setState(() {
                                                          _levels[code] = level;
                                                        });
                                                      }
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  const SizedBox(height: 8),
                                  Builder(
                                    builder: (context) {
                                      final currentLevel = _levels[code];
                                      if (currentLevel == null) {
                                        return const SizedBox.shrink();
                                      }
                                      if (_presetLevelCodes
                                          .contains(currentLevel)) {
                                        final labelText =
                                            _presetLabel(currentLevel, l10n);
                                        return Text(
                                          l10n.onboardingPresetSelected(
                                            labelText,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        );
                                      }
                                      return Text(
                                        l10n.onboardingCurrentSelection(
                                          _levelLabel(currentLevel, l10n),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                    const SizedBox(height: 32),
                    Text(
                      l10n.weeklyGoal,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              l10n.entriesPerWeek(_weeklyGoal),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Slider(
                              value: _weeklyGoal.toDouble(),
                              min: 1,
                              max: 14,
                              divisions: 13,
                              label: _weeklyGoal.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _weeklyGoal = value.round();
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text('14',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _completeSetup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l10n.onboardingStartButton),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.onboardingChangeLaterNote,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _languageLabel(String code, AppLocalizations l10n) =>
      localizedLanguageLabel(code, l10n);

  String _presetLabel(String level, AppLocalizations l10n) {
    switch (level) {
      case 'A1':
        return l10n.onboardingPresetBeginnerLabel;
      case 'B1':
        return l10n.onboardingPresetIntermediateLabel;
      case 'C1':
        return l10n.onboardingPresetAdvancedLabel;
      default:
        return level;
    }
  }

  String _presetSubtitle(String level, AppLocalizations l10n) {
    switch (level) {
      case 'A1':
        return l10n.onboardingPresetBeginnerSubtitle;
      case 'B1':
        return l10n.onboardingPresetIntermediateSubtitle;
      case 'C1':
        return l10n.onboardingPresetAdvancedSubtitle;
      default:
        return '';
    }
  }

  String _levelLabel(String level, AppLocalizations l10n) {
    switch (level) {
      case 'A1':
        return l10n.onboardingLevelA1;
      case 'A2':
        return l10n.onboardingLevelA2;
      case 'B1':
        return l10n.onboardingLevelB1;
      case 'B2':
        return l10n.onboardingLevelB2;
      case 'C1':
        return l10n.onboardingLevelC1;
      case 'C2':
        return l10n.onboardingLevelC2;
      default:
        return level;
    }
  }
}

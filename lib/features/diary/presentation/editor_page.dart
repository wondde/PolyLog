import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/language_support.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers.dart';

/// 일기 에디터 화면
class EditorPage extends ConsumerStatefulWidget {
  final String? initialText;
  final String? suggestionTopic;

  /// [EditorPage] 생성자
  const EditorPage({super.key, this.initialText, this.suggestionTopic});

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  late final TextEditingController _textController;
  String _selectedLang = 'en';
  String? _selectedMood;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText ?? '');
    _textController.addListener(() {
      setState(() {}); // To update character count
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSomething)),
      );
      return;
    }

    if (text.length > 600) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.textTooLong)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      if (user == null) throw Exception(l10n.notLoggedIn);

      final locale = ref.read(localeProvider);
      final diaryRepo = ref.read(diaryRepositoryProvider);
      final entryId = await diaryRepo.createEntry(
        uid: user.uid,
        lang: _selectedLang,
        text: text,
        nativeLang: locale.languageCode,
        mood: _selectedMood,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.entrySaved)),
        );
        context.go('/review/$entryId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
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
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // GoRouter를 사용할 때는 pop 대신 go를 사용
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(l10n.editor),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // 화면 탭하면 키보드 내리기
          FocusScope.of(context).unfocus();
        },
        onHorizontalDragUpdate: (details) {
          // 오른쪽으로 드래그 감지
          if (details.primaryDelta != null && details.primaryDelta! > 10) {
            // 드래그가 충분히 움직였을 때만 처리
          }
        },
        onHorizontalDragEnd: (details) {
          // 오른쪽으로 스와이프 (뒤로가기)
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 300) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dictionary Search
                      _buildDictionarySearch(l10n, theme),
                      const SizedBox(height: 12),
                      // Language & Mood Selection Card
                      _buildMetadataCard(l10n, theme),
                      const SizedBox(height: 12),
                      // Text Editor Card
                      _buildTextEditorCard(theme, l10n),
                      if (user != null) const SizedBox(height: 12),
                      // Keyword Suggestions
                      if (user != null)
                        _buildKeywordSuggestionsCard(l10n, theme, user.uid),
                    ],
                  ),
                ),
              ),
              // Save Button
              _buildSaveButton(l10n, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDictionarySearch(AppLocalizations l10n, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.searchUnknownWords,
          hintStyle: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(fontSize: 14),
        onSubmitted: (query) async {
          if (query.trim().isEmpty) return;

          final locale = ref.read(localeProvider);
          final nativeLang = locale.languageCode;

          // Firebase ML Kit으로 번역 (무료, 오프라인)
          try {
            final translationRepo = ref.read(translationRepositoryProvider);

            // 로딩 표시
            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final result = await translationRepo.translate(
              text: query,
              sourceLang: nativeLang,
              targetLang: _selectedLang,
            );

            // 로딩 닫기
            if (context.mounted) {
              Navigator.of(context).pop();
            }

            // 번역 결과를 바텀시트로 표시
            if (context.mounted) {
              _showTranslationBottomSheet(
                  context, query, result.translatedText);
            }
          } catch (e) {
            // 로딩 닫기
            if (context.mounted) {
              Navigator.of(context).pop();
            }

            // ML Kit 실패 시 (모델 미다운로드 등) 구글 번역 웹페이지로 fallback
            if (context.mounted) {
              final urlString =
                  'https://translate.google.com/?sl=$nativeLang&tl=$_selectedLang&text=${Uri.encodeComponent(query)}';
              final url = Uri.parse(urlString);

              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('번역 실패: $e')),
                  );
                }
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildMetadataCard(AppLocalizations l10n, ThemeData theme) {
    final user = ref.watch(currentUserDocProvider).value;
    final learnLangs = user?.learnLangs ?? [];

    // Ensure the selected language is valid
    if (learnLangs.isNotEmpty && !learnLangs.contains(_selectedLang)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedLang = learnLangs.first;
          });
        }
      });
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.language,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (learnLangs.isEmpty)
                  Text(
                    l10n.notSetAllAvailable,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: learnLangs.map((lang) {
                      final isSelected = _selectedLang == lang;
                      return FilterChip(
                        selected: isSelected,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              languageFlag(lang),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              localizedLanguageLabel(lang, l10n),
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        onSelected: _isLoading
                            ? null
                            : (selected) {
                                if (selected) {
                                  setState(() => _selectedLang = lang);
                                }
                              },
                        selectedColor: theme.colorScheme.primaryContainer,
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          width: isSelected ? 1.5 : 1,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Mood Selection
            Row(
              children: [
                Icon(
                  Icons.sentiment_satisfied_alt,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.mood,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MoodButton(
                  icon: Icons.sentiment_very_satisfied,
                  label: 'Happy',
                  value: 'happy',
                  color: Colors.green,
                  selected: _selectedMood == 'happy',
                  onTap: () => setState(() => _selectedMood =
                      _selectedMood == 'happy' ? null : 'happy'),
                ),
                _MoodButton(
                  icon: Icons.sentiment_dissatisfied,
                  label: 'Sad',
                  value: 'sad',
                  color: Colors.blue,
                  selected: _selectedMood == 'sad',
                  onTap: () => setState(() =>
                      _selectedMood = _selectedMood == 'sad' ? null : 'sad'),
                ),
                _MoodButton(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'Angry',
                  value: 'angry',
                  color: Colors.red,
                  selected: _selectedMood == 'angry',
                  onTap: () => setState(() => _selectedMood =
                      _selectedMood == 'angry' ? null : 'angry'),
                ),
                _MoodButton(
                  icon: Icons.sentiment_satisfied,
                  label: 'Calm',
                  value: 'calm',
                  color: Colors.amber,
                  selected: _selectedMood == 'calm',
                  onTap: () => setState(() =>
                      _selectedMood = _selectedMood == 'calm' ? null : 'calm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordSuggestionsCard(
      AppLocalizations l10n, ThemeData theme, String uid) {
    final keywords = _getRandomKeywords(_selectedLang, 4); // 6개 → 4개로 줄임

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.topicKeywords,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, size: 14),
                tooltip: '다른 키워드',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    // 새로고침
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: keywords.map((keyword) {
              return ActionChip(
                label: Text(
                  keyword,
                  style: const TextStyle(fontSize: 11),
                ),
                avatar: Icon(
                  Icons.add,
                  size: 12,
                  color: theme.colorScheme.primary,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                visualDensity: VisualDensity.compact,
                backgroundColor:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 0.5,
                ),
                onPressed: () {
                  final currentText = _textController.text;
                  final newText =
                      currentText.isEmpty ? keyword : '$currentText $keyword';
                  _textController.text = newText;
                  _textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textController.text.length),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextEditorCard(ThemeData theme, AppLocalizations l10n) {
    final charCount = _textController.text.length;
    final isNearLimit = charCount > 500;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 300),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_note,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.writeHere,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$charCount / 600',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isNearLimit
                        ? Colors.orange
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        isNearLimit ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: null,
              minLines: 8,
              maxLength: 600,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.suggestionTopic ?? l10n.writeHere,
                hintStyle: TextStyle(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
              enabled: !_isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: _isLoading ? null : _saveEntry,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline),
          label: Text(
            _isLoading ? 'Saving...' : l10n.save,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showTranslationBottomSheet(
      BuildContext context, String original, String translated) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.read(localeProvider);
    final nativeLang = locale.languageCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 핸들
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 제목
            Row(
              children: [
                Icon(Icons.translate, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '번역 결과',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 원문 (모국어)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        languageFlag(nativeLang),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        localizedLanguageLabel(nativeLang, l10n),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    original,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 번역문 (학습 언어)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        languageFlag(_selectedLang),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        localizedLanguageLabel(_selectedLang, l10n),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translated,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 단어장 추가 버튼
            FilledButton.icon(
              onPressed: () {
                // TODO: 단어장에 추가 기능
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('단어장 추가 기능은 곧 구현될 예정입니다')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('단어장에 추가'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  List<String> _getAllKeywords(String lang) {
    switch (lang) {
      case 'en':
        return [
          // Daily life
          'morning', 'breakfast', 'lunch', 'dinner', 'food', 'cooking',
          'weather', 'rain', 'sunny', 'sleep', 'dream', 'coffee', 'tea',
          // People & Relationships
          'family', 'friends', 'love', 'meeting', 'conversation', 'parents',
          'children', 'colleague', 'pet',
          // Activities
          'travel', 'shopping', 'walking', 'exercise', 'sports', 'running',
          'yoga', 'swimming', 'hiking',
          // Work & Study
          'work', 'study', 'reading', 'writing', 'project', 'goal',
          'achievement',
          // Hobbies & Entertainment
          'hobby', 'music', 'movie', 'game', 'book', 'art', 'photography',
          'painting', 'concert',
          // Emotions & Thoughts
          'happy', 'grateful', 'excited', 'peaceful', 'worried', 'tired',
          'motivated', 'reflective', 'nostalgic',
          // Health & Wellness
          'health', 'meditation', 'relaxation', 'stress', 'energy',
          // Special occasions
          'birthday', 'celebration', 'holiday', 'weekend', 'vacation',
          'memory', 'surprise', 'adventure', 'challenge', 'change'
        ];
      case 'ko':
        return [
          // 일상
          '아침', '아침식사', '점심', '저녁', '음식', '요리',
          '날씨', '비', '맑음', '수면', '꿈', '커피', '차',
          // 사람 & 관계
          '가족', '친구', '사랑', '만남', '대화', '부모님',
          '자녀', '동료', '반려동물',
          // 활동
          '여행', '쇼핑', '산책', '운동', '스포츠', '달리기',
          '요가', '수영', '등산',
          // 일 & 공부
          '일', '공부', '독서', '글쓰기', '프로젝트', '목표', '성취',
          // 취미 & 엔터테인먼트
          '취미', '음악', '영화', '게임', '책', '미술', '사진',
          '그림', '콘서트',
          // 감정 & 생각
          '행복', '감사', '설렘', '평화', '걱정', '피곤',
          '동기부여', '성찰', '그리움',
          // 건강 & 웰빙
          '건강', '명상', '휴식', '스트레스', '에너지',
          // 특별한 날
          '생일', '축하', '휴일', '주말', '휴가',
          '추억', '놀라움', '모험', '도전', '변화'
        ];
      case 'ja':
        return [
          // 日常
          '朝', '朝食', '昼食', '夕食', '食べ物', '料理',
          '天気', '雨', '晴れ', '睡眠', '夢', 'コーヒー', 'お茶',
          // 人間関係
          '家族', '友達', '愛', '出会い', '会話', '両親',
          '子供', '同僚', 'ペット',
          // 活動
          '旅行', '買い物', '散歩', '運動', 'スポーツ', 'ランニング',
          'ヨガ', '水泳', '登山',
          // 仕事・勉強
          '仕事', '勉強', '読書', '執筆', 'プロジェクト', '目標', '達成',
          // 趣味・娯楽
          '趣味', '音楽', '映画', 'ゲーム', '本', 'アート', '写真',
          '絵画', 'コンサート',
          // 感情・思考
          '幸せ', '感謝', 'ワクワク', '平和', '心配', '疲れ',
          'やる気', '反省', '懐かしい',
          // 健康・ウェルネス
          '健康', '瞑想', 'リラックス', 'ストレス', 'エネルギー',
          // 特別な日
          '誕生日', 'お祝い', '休日', '週末', '休暇',
          '思い出', 'サプライズ', '冒険', 'チャレンジ', '変化'
        ];
      default:
        return [
          'travel',
          'food',
          'weather',
          'family',
          'work',
          'hobby',
          'health',
          'friends'
        ];
    }
  }

  List<String> _getRandomKeywords(String lang, int count) {
    final allKeywords = _getAllKeywords(lang);
    final shuffled = List<String>.from(allKeywords)..shuffle();
    return shuffled.take(count).toList();
  }
}

class _MoodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? color
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              icon,
              color: selected ? color : theme.colorScheme.onSurfaceVariant,
            ),
            iconSize: 28,
            tooltip: value,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected ? color : theme.colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

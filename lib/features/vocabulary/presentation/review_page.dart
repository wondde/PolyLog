import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polylog/providers.dart';
import 'package:polylog/features/vocabulary/domain/models.dart';
import 'package:polylog/features/vocabulary/controllers/vocabulary_controller.dart';

/// 복습 페이지 - SRS 퀴즈
class ReviewPage extends ConsumerStatefulWidget {
  /// [ReviewPage] 생성자
  const ReviewPage({super.key});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  List<VocabularyCard>? _fixedCards; // 복습 시작 시 고정된 카드 목록

  void _nextCard() {
    setState(() {
      _currentIndex++;
      _showAnswer = false;
    });
  }

  Future<void> _handleRating(VocabularyCard card, Rating rating) async {
    try {
      await ref
          .read(vocabularyControllerProvider.notifier)
          .reviewCard(card, rating);
      _nextCard();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('로그인이 필요합니다.')),
          );
        }

        final dueCardsAsync = ref.watch(dueCardsProvider(user.uid));
        final newCardsAsync = ref.watch(newCardsProvider(user.uid));
        final learningCardsAsync = ref.watch(learningCardsProvider(user.uid));

        // 세 개의 AsyncValue를 모두 확인
        if (dueCardsAsync is AsyncLoading ||
            newCardsAsync is AsyncLoading ||
            learningCardsAsync is AsyncLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (dueCardsAsync is AsyncError) {
          return Scaffold(
            body: Center(child: Text('오류 (Due): ${dueCardsAsync.error}')),
          );
        }

        if (newCardsAsync is AsyncError) {
          return Scaffold(
            body: Center(child: Text('오류 (New): ${newCardsAsync.error}')),
          );
        }

        if (learningCardsAsync is AsyncError) {
          return Scaffold(
            body: Center(
                child: Text('오류 (Learning): ${learningCardsAsync.error}')),
          );
        }

        final dueCards = dueCardsAsync.value ?? [];
        final newCards = newCardsAsync.value ?? [];
        final learningCards = learningCardsAsync.value ?? [];

        // 복습 시작 시 카드 목록을 한 번만 고정 (Firestore 실시간 업데이트로 인한 카드 변경 방지)
        _fixedCards ??= [...dueCards, ...newCards, ...learningCards];

        final allCards = _fixedCards!;

        // 복습할 카드가 없는 경우
        if (allCards.isEmpty || _currentIndex >= allCards.length) {
          return Scaffold(
            appBar: AppBar(title: const Text('복습 완료')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.celebration,
                        size: 100, color: Colors.green),
                    const SizedBox(height: 24),
                    const Text(
                      '모든 복습을 완료했습니다!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('돌아가기'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // 현재 카드 표시
        final card = allCards[_currentIndex];
        final progress = (_currentIndex + 1) / allCards.length;

        return Scaffold(
          appBar: AppBar(
            title: Text('복습 (${_currentIndex + 1}/${allCards.length})'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(value: progress),
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // 카드 영역
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showAnswer = !_showAnswer;
                                  });
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 단어
                                        Text(
                                          card.lemma,
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        // 품사
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            card.pos.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        // 답변 표시
                                        if (_showAnswer) ...[
                                          const Divider(),
                                          const SizedBox(height: 16),
                                          // 의미
                                          ...card.meanings
                                              .map((meaning) => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Text(
                                                      '• $meaning',
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  )),
                                          if (card.example.isNotEmpty) ...[
                                            const SizedBox(height: 16),
                                            Text(
                                              card.example,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey.shade700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ] else ...[
                                          const Icon(
                                            Icons.touch_app,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '탭하여 답 보기',
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // 평가 버튼 (답을 본 후에만 표시)
                          if (_showAnswer)
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '이 단어를 얼마나 잘 기억하셨나요?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildRatingButton(
                                          context,
                                          card,
                                          Rating.again,
                                          '다시',
                                          Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildRatingButton(
                                          context,
                                          card,
                                          Rating.hard,
                                          '어려움',
                                          Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildRatingButton(
                                          context,
                                          card,
                                          Rating.good,
                                          '좋음',
                                          Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildRatingButton(
                                          context,
                                          card,
                                          Rating.easy,
                                          '쉬움',
                                          Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('오류 (Auth): $err')),
      ),
    );
  }

  Widget _buildRatingButton(
    BuildContext context,
    VocabularyCard card,
    Rating rating,
    String label,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () => _handleRating(card, rating),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

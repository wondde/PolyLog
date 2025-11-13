import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/features/vocabulary/domain/models.dart';
import 'package:polylog/features/vocabulary/data/vocabulary_repository.dart';

/// 평가 등급
enum Rating {
  /// 다시 (0) - 실패, 학습 단계로 강등
  again(0),

  /// 어려움 (1) - 간격 1.2배
  hard(1),

  /// 좋음 (2) - 간격 ease배
  good(2),

  /// 쉬움 (3) - 간격 ease * 1.3배
  easy(3);

  const Rating(this.value);

  /// 평가 값
  final int value;
}

/// SRS 알고리즘을 적용한 단어장 컨트롤러
class VocabularyController extends AsyncNotifier<List<VocabularyCard>> {
  final _repository = VocabularyRepository();

  @override
  Future<List<VocabularyCard>> build() async {
    return [];
  }

  /// 카드 복습 처리 (SRS 알고리즘)
  Future<void> reviewCard(VocabularyCard card, Rating rating) async {
    final now = DateTime.now();
    VocabularyCard updatedCard = card;

    // 새 카드 또는 학습 중 카드
    if (card.isNew || card.isLearning) {
      if (rating == Rating.again) {
        // 실패: 10분 후 재출제
        updatedCard = card.copyWith(
          state: CardState.learning,
          due: now.add(const Duration(minutes: 10)),
          reps: card.reps + 1,
          lastReviewed: now,
        );
      } else {
        // 성공: 복습 단계로 승격
        int intervalDays;
        if (card.reps == 0) {
          intervalDays = 1; // I1 = 1일
        } else if (card.reps == 1) {
          intervalDays = 6; // I2 = 6일
        } else {
          intervalDays = (card.intervalDays * card.ease).round();
        }

        updatedCard = card.copyWith(
          state: CardState.review,
          intervalDays: intervalDays,
          due: now.add(Duration(days: intervalDays)),
          reps: card.reps + 1,
          lastReviewed: now,
        );
      }
    }
    // 복습 단계 카드
    else if (card.isReview) {
      if (rating == Rating.again) {
        // 실패: lapse 증가, ease 감소, 학습 단계로 강등
        final newEase = max(1.3, card.ease - 0.2);
        final newLapses = card.lapses + 1;

        updatedCard = card.copyWith(
          state: newLapses >= 8 ? CardState.leech : CardState.learning,
          ease: newEase,
          intervalDays: 1,
          lapses: newLapses,
          due: now.add(const Duration(minutes: 10)),
          reps: card.reps + 1,
          lastReviewed: now,
        );
      } else {
        // 성공: ease 조정 후 간격 계산
        final delta = {
          Rating.hard: -0.15,
          Rating.good: 0.0,
          Rating.easy: 0.15,
        }[rating]!;

        final newEase = (card.ease + delta).clamp(1.3, 2.8);

        // 간격 후보
        final hardI = max(1, (card.intervalDays * 1.2).round());
        final goodI = max(1, (card.intervalDays * newEase).round());
        final easyI = max(goodI + 1, (goodI * 1.3).round());

        final intervalDays = {
          Rating.hard: hardI,
          Rating.good: goodI,
          Rating.easy: easyI,
        }[rating]!;

        updatedCard = card.copyWith(
          ease: newEase,
          intervalDays: intervalDays,
          due: now.add(Duration(days: intervalDays)),
          reps: card.reps + 1,
          lastReviewed: now,
        );
      }
    }

    // Firestore 업데이트
    await _repository.updateCard(card.id, updatedCard.toFirestore());
  }

  /// 새 카드 추가
  Future<void> addCard({
    required String uid,
    required String lemma,
    required String pos,
    required List<String> meanings,
    required String level,
    required String example,
    required String lang,
    String? sourceEntryId,
  }) async {
    // 중복 체크
    final exists = await _repository.hasCard(uid, lemma, lang);
    if (exists) {
      throw Exception('이미 단어장에 존재하는 단어입니다.');
    }

    await _repository.addCard(
      uid: uid,
      lemma: lemma,
      pos: pos,
      meanings: meanings,
      level: level,
      example: example,
      lang: lang,
      sourceEntryId: sourceEntryId,
    );
  }

  /// 카드 삭제
  Future<void> deleteCard(String cardId) async {
    await _repository.deleteCard(cardId);
  }

  /// 카드 수정 (의미, 예문 등)
  Future<void> updateCardContent({
    required String cardId,
    List<String>? meanings,
    String? example,
  }) async {
    final updates = <String, dynamic>{};
    if (meanings != null) updates['meanings'] = meanings;
    if (example != null) updates['example'] = example;

    if (updates.isNotEmpty) {
      await _repository.updateCard(cardId, updates);
    }
  }

  /// Leech 카드를 다시 학습 단계로 복원
  Future<void> resetLeechCard(String cardId) async {
    await _repository.updateCard(cardId, {
      'state': CardState.learning.value,
      'lapses': 0,
      'ease': 2.5,
      'intervalDays': 1,
      'due': null,
    });
  }
}

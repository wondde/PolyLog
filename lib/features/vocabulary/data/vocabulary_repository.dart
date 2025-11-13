import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polylog/features/vocabulary/domain/models.dart';

/// 단어장 데이터 저장소
class VocabularyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 새 카드 추가
  Future<String> addCard({
    required String uid,
    required String lemma,
    required String pos,
    required List<String> meanings,
    required String level,
    required String example,
    required String lang,
    String? sourceEntryId,
  }) async {
    final now = DateTime.now();
    final docRef = await _db.collection('vocabulary').add({
      'uid': uid,
      'lemma': lemma,
      'pos': pos,
      'meanings': meanings,
      'level': level,
      'example': example,
      'lang': lang,
      'state': CardState.newCard.value,
      'ease': 2.5,
      'intervalDays': 1,
      'reps': 0,
      'lapses': 0,
      'due': Timestamp.fromDate(now), // 새 카드는 즉시 복습 가능
      'lastReviewed': null,
      'createdAt': FieldValue.serverTimestamp(),
      'sourceEntryId': sourceEntryId,
    });
    return docRef.id;
  }

  /// 카드 업데이트
  Future<void> updateCard(String cardId, Map<String, dynamic> data) async {
    await _db.collection('vocabulary').doc(cardId).update(data);
  }

  /// 카드 삭제
  Future<void> deleteCard(String cardId) async {
    await _db.collection('vocabulary').doc(cardId).delete();
  }

  /// 특정 카드 가져오기
  Future<VocabularyCard?> getCard(String cardId) async {
    final doc = await _db.collection('vocabulary').doc(cardId).get();
    if (!doc.exists) return null;
    return VocabularyCard.fromFirestore(doc);
  }

  /// 사용자의 모든 카드 스트림
  Stream<List<VocabularyCard>> watchUserCards(String uid) {
    return _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VocabularyCard.fromFirestore(doc))
            .toList());
  }

  /// 사용자의 복습 예정 카드 스트림 (due가 현재 시간 이전)
  Stream<List<VocabularyCard>> watchDueCards(String uid) {
    final now = DateTime.now();
    return _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('state', isEqualTo: CardState.review.value)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VocabularyCard.fromFirestore(doc))
            .where((card) =>
                card.due != null &&
                (card.due!.isBefore(now) || card.due!.isAtSameMomentAs(now)))
            .toList()
          ..sort((a, b) => a.due!.compareTo(b.due!)));
  }

  /// 사용자의 새 카드 스트림 (state == 'new')
  Stream<List<VocabularyCard>> watchNewCards(String uid) {
    return _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('state', isEqualTo: CardState.newCard.value)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      final cards = snapshot.docs
          .map((doc) => VocabularyCard.fromFirestore(doc))
          .toList();
      print('📚 watchNewCards: uid=$uid, found ${cards.length} cards');
      return cards;
    });
  }

  /// 사용자의 학습 중 카드 스트림 (state == 'learning')
  Stream<List<VocabularyCard>> watchLearningCards(String uid) {
    final now = DateTime.now();
    return _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('state', isEqualTo: CardState.learning.value)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VocabularyCard.fromFirestore(doc))
            .where((card) =>
                card.due != null &&
                (card.due!.isBefore(now) || card.due!.isAtSameMomentAs(now)))
            .toList()
          ..sort((a, b) => a.due!.compareTo(b.due!)));
  }

  /// 특정 언어의 카드 스트림
  Stream<List<VocabularyCard>> watchCardsByLang(String uid, String lang) {
    return _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('lang', isEqualTo: lang)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VocabularyCard.fromFirestore(doc))
            .toList());
  }

  /// 중복 체크 (동일 단어 존재 여부)
  Future<bool> hasCard(String uid, String lemma, String lang) async {
    final snapshot = await _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('lemma', isEqualTo: lemma)
        .where('lang', isEqualTo: lang)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// 통계: 총 카드 수
  Future<int> getTotalCardCount(String uid) async {
    final snapshot = await _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// 통계: 상태별 카드 수
  Future<Map<String, int>> getCardCountByState(String uid) async {
    final snapshot =
        await _db.collection('vocabulary').where('uid', isEqualTo: uid).get();
    final counts = <String, int>{};
    for (final state in CardState.values) {
      counts[state.value] = 0;
    }
    for (final doc in snapshot.docs) {
      final state = doc.data()['state'] as String? ?? 'new';
      counts[state] = (counts[state] ?? 0) + 1;
    }
    return counts;
  }

  /// 통계: 오늘 복습한 카드 수
  Future<int> getTodayReviewCount(String uid) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final snapshot = await _db
        .collection('vocabulary')
        .where('uid', isEqualTo: uid)
        .where('lastReviewed',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}

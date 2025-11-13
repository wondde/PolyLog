import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';
import '../domain/models.dart';

/// 일기 Repository
class DiaryRepository {
  final _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  /// 일기 항목 생성
  Future<String> createEntry({
    required String uid,
    required String lang,
    required String text,
    required String nativeLang,
    String? mood,
    String visibility = 'private',
  }) async {
    final entry = EntryModel(
      id: _uuid.v4(),
      uid: uid,
      lang: lang,
      textRaw: text,
      nativeLang: nativeLang,
      mood: mood,
      visibility: visibility,
      createdAt: DateTime.now(),
      aiStatus: 'pending',
    );

    final doc = await _db.collection('entries').add(entry.toFirestore());
    return doc.id;
  }

  /// 일기 항목 조회
  Future<EntryModel?> getEntry(String id) async {
    final doc = await _db.collection('entries').doc(id).get();
    if (!doc.exists) return null;
    return EntryModel.fromFirestore(doc);
  }

  /// 사용자의 일기 목록 조회
  Stream<List<EntryModel>> getUserEntries(String uid) {
    return _db
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EntryModel.fromFirestore(doc)).toList());
  }

  /// 일기 항목 업데이트
  Future<void> updateEntry(String id, Map<String, dynamic> data) async {
    await _db.collection('entries').doc(id).update(data);
  }

  /// 일기 항목 삭제
  Future<void> deleteEntry(String id) async {
    await _db.collection('entries').doc(id).delete();
  }

  /// AI 분석 결과 조회 (스트림)
  Stream<EntryAIModel?> watchAI(String id) {
    return _db.collection('entry_ai').doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EntryAIModel.fromFirestore(doc);
    });
  }

  /// AI 분석 결과 조회 (단일)
  Future<EntryAIModel?> getAI(String id) async {
    final doc = await _db.collection('entry_ai').doc(id).get();
    if (!doc.exists) return null;
    return EntryAIModel.fromFirestore(doc);
  }

  /// 제안 조회
  Future<SuggestionModel?> getSuggestion(String uid, String lang) async {
    final query = await _db
        .collection('suggestions')
        .where('uid', isEqualTo: uid)
        .where('lang', isEqualTo: lang)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return SuggestionModel.fromFirestore(query.docs.first);
  }

  /// 공개 피드 조회
  Stream<List<Map<String, dynamic>>> getPublicFeed() {
    return _db
        .collection('public_feed')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'lang': data['lang'] ?? 'en',
                'text': data['text'] ?? '',
                'mood': data['mood'],
                'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
              };
            }).toList());
  }

  /// 통계 조회 (최근 7일간의 일기 개수)
  Future<Map<DateTime, int>> getWeeklyStats(String uid) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    // uid로만 필터링하고 날짜 필터링은 클라이언트에서 수행 (인덱스 불필요)
    final query = await _db
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();

    final Map<DateTime, int> stats = {};
    for (final doc in query.docs) {
      final entry = EntryModel.fromFirestore(doc);

      // 최근 7일 이내 항목만 카운트
      if (entry.createdAt.isBefore(weekAgo)) continue;

      final date = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      stats[date] = (stats[date] ?? 0) + 1;
    }

    return stats;
  }

  /// Top 문법 오류 조회
  Future<List<Map<String, dynamic>>> getTopGrammarErrors(String uid) async {
    final entries = await _db
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    final Map<String, int> grammarCount = {};

    for (final doc in entries.docs) {
      final ai = await getAI(doc.id);
      if (ai != null) {
        for (final note in ai.grammarNotes) {
          grammarCount[note] = (grammarCount[note] ?? 0) + 1;
        }
      }
    }

    final sorted = grammarCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(3)
        .map((e) => {'note': e.key, 'count': e.value})
        .toList();
  }

  /// 최근 학습한 새로운 단어 조회
  Future<List<VocabItem>> getRecentVocabulary(String uid,
      {int limit = 10}) async {
    final entries = await _db
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    final List<VocabItem> allVocab = [];
    final Set<String> seenLemmas = {};

    for (final doc in entries.docs) {
      final ai = await getAI(doc.id);
      if (ai != null) {
        for (final vocab in ai.vocab) {
          // 중복 제거
          if (!seenLemmas.contains(vocab.lemma)) {
            allVocab.add(vocab);
            seenLemmas.add(vocab.lemma);
            if (allVocab.length >= limit) break;
          }
        }
        if (allVocab.length >= limit) break;
      }
    }

    return allVocab;
  }

  /// 특정 언어로 최근 학습한 새로운 단어 조회
  Future<List<VocabItem>> getRecentVocabularyByLang(
    String uid,
    String lang, {
    int limit = 10,
  }) async {
    final entries = await _db
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .where('lang', isEqualTo: lang)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    final List<VocabItem> allVocab = [];
    final Set<String> seenLemmas = {};

    for (final doc in entries.docs) {
      final ai = await getAI(doc.id);
      if (ai != null) {
        for (final vocab in ai.vocab) {
          // 중복 제거
          if (!seenLemmas.contains(vocab.lemma)) {
            allVocab.add(vocab);
            seenLemmas.add(vocab.lemma);
            if (allVocab.length >= limit) break;
          }
        }
        if (allVocab.length >= limit) break;
      }
    }

    return allVocab;
  }

  /// Cloud Function을 호출하여 새로운 제안 생성
  Future<String> generateSuggestions(String lang) async {
    final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
    final callable = functions.httpsCallable('createSuggestions');

    final result = await callable.call({'lang': lang});
    return result.data['docId'] as String;
  }

  /// 사용자의 최신 제안 가져오기 (특정 언어)
  Future<SuggestionModel?> getLatestSuggestion(String uid, String lang) async {
    final snapshot = await _db
        .collection('suggestions')
        .where('uid', isEqualTo: uid)
        .where('lang', isEqualTo: lang)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return SuggestionModel.fromFirestore(snapshot.docs.first);
  }

  /// 제안 스트림 (실시간 업데이트)
  Stream<SuggestionModel?> watchLatestSuggestion(String uid, String lang) {
    return _db
        .collection('suggestions')
        .where('uid', isEqualTo: uid)
        .where('lang', isEqualTo: lang)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return SuggestionModel.fromFirestore(snapshot.docs.first);
    });
  }
}

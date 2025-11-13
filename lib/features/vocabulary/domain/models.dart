import 'package:cloud_firestore/cloud_firestore.dart';

/// SRS 카드 상태
enum CardState {
  /// 새 카드
  newCard('new'),

  /// 학습 중
  learning('learning'),

  /// 복습 중
  review('review'),

  /// 문제 카드 (8회 이상 실패)
  leech('leech');

  const CardState(this.value);

  /// 상태 값
  final String value;

  /// 문자열에서 CardState로 변환
  static CardState fromString(String value) {
    return CardState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CardState.newCard,
    );
  }
}

/// 단어장 카드 모델 (SRS 알고리즘 적용)
class VocabularyCard {
  /// [VocabularyCard] 생성자
  const VocabularyCard({
    required this.id,
    required this.uid,
    required this.lemma,
    required this.pos,
    required this.meanings,
    required this.level,
    required this.example,
    this.lang = 'en',
    this.state = CardState.newCard,
    this.ease = 2.5,
    this.intervalDays = 1,
    this.reps = 0,
    this.lapses = 0,
    this.due,
    this.lastReviewed,
    required this.createdAt,
    this.sourceEntryId,
  });

  /// 카드 ID
  final String id;

  /// 사용자 ID
  final String uid;

  /// 단어 원형
  final String lemma;

  /// 품사 (noun, verb, adjective 등)
  final String pos;

  /// 의미 리스트 (한국어 번역)
  final List<String> meanings;

  /// 난이도 레벨 (A1, A2, B1, B2, C1, C2 등)
  final String level;

  /// 예문
  final String example;

  /// 학습 언어 (ja, en, ko)
  final String lang;

  /// 카드 상태 (new, learning, review, leech)
  final CardState state;

  /// Ease Factor (기본값: 2.5, 범위: 1.3~2.8)
  final double ease;

  /// 복습 간격 (일 단위)
  final int intervalDays;

  /// 복습 횟수
  final int reps;

  /// 실패 횟수
  final int lapses;

  /// 다음 복습 예정 시간
  final DateTime? due;

  /// 마지막 복습 시간
  final DateTime? lastReviewed;

  /// 카드 생성 시간
  final DateTime createdAt;

  /// 출처 일기 ID (AI에서 추출된 경우)
  final String? sourceEntryId;

  /// Firestore 문서에서 VocabularyCard 생성
  factory VocabularyCard.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VocabularyCard(
      id: doc.id,
      uid: data['uid'] as String,
      lemma: data['lemma'] as String,
      pos: data['pos'] as String,
      meanings:
          (data['meanings'] as List<dynamic>).map((e) => e as String).toList(),
      level: data['level'] as String,
      example: data['example'] as String,
      lang: data['lang'] as String? ?? 'en',
      state: CardState.fromString(data['state'] as String? ?? 'new'),
      ease: (data['ease'] as num?)?.toDouble() ?? 2.5,
      intervalDays: data['intervalDays'] as int? ?? 1,
      reps: data['reps'] as int? ?? 0,
      lapses: data['lapses'] as int? ?? 0,
      due: (data['due'] as Timestamp?)?.toDate(),
      lastReviewed: (data['lastReviewed'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      sourceEntryId: data['sourceEntryId'] as String?,
    );
  }

  /// VocabularyCard를 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'lemma': lemma,
      'pos': pos,
      'meanings': meanings,
      'level': level,
      'example': example,
      'lang': lang,
      'state': state.value,
      'ease': ease,
      'intervalDays': intervalDays,
      'reps': reps,
      'lapses': lapses,
      'due': due != null ? Timestamp.fromDate(due!) : null,
      'lastReviewed':
          lastReviewed != null ? Timestamp.fromDate(lastReviewed!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'sourceEntryId': sourceEntryId,
    };
  }

  /// 카드 복사 (일부 필드 업데이트)
  VocabularyCard copyWith({
    String? id,
    String? uid,
    String? lemma,
    String? pos,
    List<String>? meanings,
    String? level,
    String? example,
    String? lang,
    CardState? state,
    double? ease,
    int? intervalDays,
    int? reps,
    int? lapses,
    DateTime? due,
    DateTime? lastReviewed,
    DateTime? createdAt,
    String? sourceEntryId,
  }) {
    return VocabularyCard(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      lemma: lemma ?? this.lemma,
      pos: pos ?? this.pos,
      meanings: meanings ?? this.meanings,
      level: level ?? this.level,
      example: example ?? this.example,
      lang: lang ?? this.lang,
      state: state ?? this.state,
      ease: ease ?? this.ease,
      intervalDays: intervalDays ?? this.intervalDays,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      due: due ?? this.due,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      createdAt: createdAt ?? this.createdAt,
      sourceEntryId: sourceEntryId ?? this.sourceEntryId,
    );
  }

  /// 복습이 필요한 카드인지 확인
  bool get isDue {
    if (due == null) return true;
    return DateTime.now().isAfter(due!);
  }

  /// 새 카드인지 확인
  bool get isNew => state == CardState.newCard;

  /// 학습 중인지 확인
  bool get isLearning => state == CardState.learning;

  /// 복습 중인지 확인
  bool get isReview => state == CardState.review;

  /// 문제 카드인지 확인
  bool get isLeech => state == CardState.leech;
}

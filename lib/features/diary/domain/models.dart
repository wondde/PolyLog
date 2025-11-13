import 'package:cloud_firestore/cloud_firestore.dart';

/// 사용자 문서 모델
class UserModel {
  /// 사용자 UID
  final String uid;

  /// 표시 이름
  final String displayName;

  /// 지역 (kr/jp/en)
  final String region;

  /// 모국어 (ko/ja/en)
  final String nativeLang;

  /// 학습 언어 목록
  final List<String> learnLangs;

  /// 언어별 레벨
  final Map<String, String> level;

  /// 사용자 설정
  final UserPreferences prefs;

  /// 생성 시각
  final DateTime createdAt;

  /// 연속 기록 일수
  final int streak;

  /// 주간 목표 학습량 (일기 개수, 1-14개)
  final int weeklyGoal;

  /// [UserModel] 생성자
  const UserModel({
    required this.uid,
    required this.displayName,
    required this.region,
    required this.nativeLang,
    required this.learnLangs,
    required this.level,
    required this.prefs,
    required this.createdAt,
    this.streak = 0,
    this.weeklyGoal = 7,
  });

  /// Firestore 문서에서 모델 생성
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      region: data['region'] ?? 'kr',
      nativeLang: data['nativeLang'] ?? 'ko',
      learnLangs: List<String>.from(data['learnLangs'] ?? []),
      level: Map<String, String>.from(data['level'] ?? {}),
      prefs: UserPreferences.fromMap(data['prefs'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      streak: data['streak'] ?? 0,
      weeklyGoal: data['weeklyGoal'] ?? data['dailyGoal'] ?? 7,
    );
  }

  /// Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'region': region,
      'nativeLang': nativeLang,
      'learnLangs': learnLangs,
      'level': level,
      'prefs': prefs.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'streak': streak,
      'weeklyGoal': weeklyGoal,
    };
  }
}

/// 사용자 설정
class UserPreferences {
  /// 쉬운 단어 사용
  final bool easyWords;

  /// 후리가나 표시 (일본어)
  final bool showFurigana;

  /// 혼합 UI (모국어 글로스 표시)
  final bool mixedUI;

  /// AI 설명 언어
  final String aiLang;

  /// [UserPreferences] 생성자
  const UserPreferences({
    this.easyWords = false,
    this.showFurigana = true,
    this.mixedUI = false,
    this.aiLang = 'en',
  });

  /// Map에서 생성
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      easyWords: map['easyWords'] ?? false,
      showFurigana: map['showFurigana'] ?? true,
      mixedUI: map['mixedUI'] ?? false,
      aiLang: map['aiLang'] ?? 'en',
    );
  }

  /// Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'easyWords': easyWords,
      'showFurigana': showFurigana,
      'mixedUI': mixedUI,
      'aiLang': aiLang,
    };
  }
}

/// 일기 항목 모델
class EntryModel {
  /// 항목 ID
  final String id;

  /// 사용자 UID
  final String uid;

  /// 언어 (ja/en/ko)
  final String lang;

  /// 원본 텍스트
  final String textRaw;

  /// 사용자 모국어
  final String nativeLang;

  /// 기분 (happy/sad/angry/calm)
  final String? mood;

  /// 공개 설정 (private/anon)
  final String visibility;

  /// 생성 시각
  final DateTime createdAt;

  /// AI 처리 상태 (pending/done/error)
  final String aiStatus;

  /// [EntryModel] 생성자
  const EntryModel({
    required this.id,
    required this.uid,
    required this.lang,
    required this.textRaw,
    required this.nativeLang,
    this.mood,
    this.visibility = 'private',
    required this.createdAt,
    this.aiStatus = 'pending',
  });

  /// Firestore 문서에서 모델 생성
  factory EntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EntryModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      lang: data['lang'] ?? 'en',
      textRaw: data['textRaw'] ?? '',
      nativeLang: data['native_lang'] ?? 'en',
      mood: data['mood'],
      visibility: data['visibility'] ?? 'private',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      aiStatus: data['aiStatus'] ?? 'pending',
    );
  }

  /// Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'lang': lang,
      'textRaw': textRaw,
      'native_lang': nativeLang,
      'mood': mood,
      'visibility': visibility,
      'createdAt': Timestamp.fromDate(createdAt),
      'aiStatus': aiStatus,
    };
  }
}

/// AI 분석 결과 모델
class EntryAIModel {
  /// 교정된 텍스트
  final String corrected;

  /// 자연스러운 표현
  final NaturalExpression natural;

  /// 차이점 목록
  final List<DiffItem> diffs;

  /// 강조 표시할 구문
  final List<String> highlights;

  /// 어휘 목록
  final List<VocabItem> vocab;

  /// 문법 노트
  final List<String> grammarNotes;

  /// 점수
  final Score score;

  /// 렌더링 옵션
  final RenderingOptions? rendering;

  /// [EntryAIModel] 생성자
  const EntryAIModel({
    required this.corrected,
    required this.natural,
    required this.diffs,
    required this.highlights,
    required this.vocab,
    required this.grammarNotes,
    required this.score,
    this.rendering,
  });

  /// Firestore 문서에서 모델 생성
  factory EntryAIModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EntryAIModel(
      corrected: data['corrected'] ?? '',
      natural: NaturalExpression.fromMap(data['natural'] ?? {}),
      diffs: (data['diffs'] as List<dynamic>?)
              ?.map((e) => DiffItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      highlights: List<String>.from(data['highlights'] ?? []),
      vocab: (data['vocab'] as List<dynamic>?)
              ?.map((e) => VocabItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      grammarNotes: List<String>.from(data['grammarNotes'] ?? []),
      score: Score.fromMap(data['score'] ?? {}),
      rendering: data['rendering'] != null
          ? RenderingOptions.fromMap(data['rendering'])
          : null,
    );
  }
}

/// 자연스러운 표현
class NaturalExpression {
  /// 캐주얼 표현
  final String casual;

  /// 격식 있는 표현
  final String formal;

  /// [NaturalExpression] 생성자
  const NaturalExpression({
    required this.casual,
    required this.formal,
  });

  /// Map에서 생성
  factory NaturalExpression.fromMap(Map<String, dynamic> map) {
    return NaturalExpression(
      casual: map['casual'] ?? '',
      formal: map['formal'] ?? '',
    );
  }
}

/// 차이점 항목
class DiffItem {
  /// 연산 (replace/add/del)
  final String op;

  /// 원본
  final String? from;

  /// 변경
  final String? to;

  /// [DiffItem] 생성자
  const DiffItem({
    required this.op,
    this.from,
    this.to,
  });

  /// Map에서 생성
  factory DiffItem.fromMap(Map<String, dynamic> map) {
    return DiffItem(
      op: map['op'] ?? 'replace',
      from: map['from'],
      to: map['to'],
    );
  }
}

/// 어휘 항목
class VocabItem {
  /// 기본형
  final String lemma;

  /// 품사
  final String pos;

  /// 의미 목록
  final List<String> meanings;

  /// 레벨
  final String? level;

  /// 예문
  final String example;

  /// [VocabItem] 생성자
  const VocabItem({
    required this.lemma,
    required this.pos,
    required this.meanings,
    this.level,
    required this.example,
  });

  /// Map에서 생성
  factory VocabItem.fromMap(Map<String, dynamic> map) {
    return VocabItem(
      lemma: map['lemma'] ?? '',
      pos: map['pos'] ?? '',
      meanings: List<String>.from(map['meanings'] ?? []),
      level: map['level'],
      example: map['example'] ?? '',
    );
  }
}

/// 점수
class Score {
  /// 유창성
  final int fluency;

  /// 정확성
  final int accuracy;

  /// [Score] 생성자
  const Score({
    required this.fluency,
    required this.accuracy,
  });

  /// Map에서 생성
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      fluency: map['fluency'] ?? 0,
      accuracy: map['accuracy'] ?? 0,
    );
  }
}

/// 렌더링 옵션
class RenderingOptions {
  /// 일본어 후리가나 표시
  final bool? jaFurigana;

  /// [RenderingOptions] 생성자
  const RenderingOptions({
    this.jaFurigana,
  });

  /// Map에서 생성
  factory RenderingOptions.fromMap(Map<String, dynamic> map) {
    return RenderingOptions(
      jaFurigana: map['jaFurigana'],
    );
  }
}

/// 제안 모델
class SuggestionModel {
  /// 문서 ID
  final String id;

  /// 사용자 UID
  final String uid;

  /// 언어
  final String lang;

  /// 레벨 태그
  final String levelTag;

  /// 주제 목록
  final List<String> topics;

  /// 문장 시작
  final List<String> starters;

  /// 성찰 질문
  final List<String> questions;

  /// [SuggestionModel] 생성자
  const SuggestionModel({
    required this.id,
    required this.uid,
    required this.lang,
    required this.levelTag,
    required this.topics,
    required this.starters,
    required this.questions,
  });

  /// Firestore 문서에서 모델 생성
  factory SuggestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SuggestionModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      lang: data['lang'] ?? 'en',
      levelTag: data['levelTag'] ?? 'A2',
      topics: List<String>.from(data['topics'] ?? []),
      starters: List<String>.from(data['starters'] ?? []),
      questions: List<String>.from(data['questions'] ?? []),
    );
  }
}

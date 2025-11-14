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

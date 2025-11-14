import 'package:cloud_firestore/cloud_firestore.dart';

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

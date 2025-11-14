import 'package:cloud_firestore/cloud_firestore.dart';

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

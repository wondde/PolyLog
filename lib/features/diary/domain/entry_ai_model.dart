import 'package:cloud_firestore/cloud_firestore.dart';

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

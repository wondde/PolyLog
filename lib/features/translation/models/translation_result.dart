/// 번역 결과 모델
class TranslationResult {
  /// 원문 텍스트
  final String sourceText;

  /// 번역된 텍스트
  final String translatedText;

  /// 원본 언어 코드
  final String sourceLang;

  /// 목표 언어 코드
  final String targetLang;

  /// [TranslationResult] 생성자
  const TranslationResult({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
  });
}

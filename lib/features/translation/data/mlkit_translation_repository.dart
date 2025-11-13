import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:polylog/features/translation/models/translation_result.dart';

/// Firebase ML Kit 번역 Repository
class MLKitTranslationRepository {
  final _translatorCache = <String, OnDeviceTranslator>{};

  /// 언어 코드를 TranslateLanguage로 변환
  TranslateLanguage _getLanguage(String code) {
    switch (code) {
      case 'ko':
        return TranslateLanguage.korean;
      case 'ja':
        return TranslateLanguage.japanese;
      case 'en':
        return TranslateLanguage.english;
      case 'de':
        return TranslateLanguage.german;
      case 'es':
        return TranslateLanguage.spanish;
      case 'ar':
        return TranslateLanguage.arabic;
      case 'zh':
        return TranslateLanguage.chinese;
      case 'fr':
        return TranslateLanguage.french;
      case 'ru':
        return TranslateLanguage.russian;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'it':
        return TranslateLanguage.italian;
      case 'vi':
        return TranslateLanguage.vietnamese;
      case 'th':
        return TranslateLanguage.thai;
      default:
        return TranslateLanguage.english;
    }
  }

  /// Translator 인스턴스 가져오기 (캐싱)
  OnDeviceTranslator _getTranslator(String sourceLang, String targetLang) {
    final key = '$sourceLang-$targetLang';

    if (!_translatorCache.containsKey(key)) {
      _translatorCache[key] = OnDeviceTranslator(
        sourceLanguage: _getLanguage(sourceLang),
        targetLanguage: _getLanguage(targetLang),
      );
    }

    return _translatorCache[key]!;
  }

  /// 번역 모델이 다운로드되어 있는지 확인
  Future<bool> isModelDownloaded(String sourceLang, String targetLang) async {
    final modelManager = OnDeviceTranslatorModelManager();

    final sourceDownloaded =
        await modelManager.isModelDownloaded(_getLanguage(sourceLang).bcpCode);
    final targetDownloaded =
        await modelManager.isModelDownloaded(_getLanguage(targetLang).bcpCode);

    return sourceDownloaded && targetDownloaded;
  }

  /// 번역 모델 다운로드
  Future<void> downloadModel(String sourceLang, String targetLang) async {
    final translator = _getTranslator(sourceLang, targetLang);

    // Translator를 사용하면 자동으로 모델 다운로드가 시작됨
    // 단, 실제 번역을 시도해야 다운로드가 트리거됨
    try {
      await translator.translateText('test');
    } catch (e) {
      // 다운로드 중 에러는 무시 (자동으로 재시도됨)
    }
  }

  /// 텍스트 번역
  ///
  /// [text]: 번역할 텍스트
  /// [sourceLang]: 원본 언어 (ko, en, ja, de, es, ar, zh, fr, ru, pt, it, vi, th)
  /// [targetLang]: 목표 언어 (ko, en, ja, de, es, ar, zh, fr, ru, pt, it, vi, th)
  Future<TranslationResult> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final translator = _getTranslator(sourceLang, targetLang);

    try {
      final translatedText = await translator.translateText(text);

      return TranslationResult(
        sourceText: text,
        translatedText: translatedText,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
    } catch (e) {
      throw Exception('번역 실패: $e\n모델이 다운로드되지 않았을 수 있습니다.');
    }
  }

  /// 리소스 정리
  Future<void> dispose() async {
    for (final translator in _translatorCache.values) {
      await translator.close();
    }
    _translatorCache.clear();
  }
}

import 'package:polylog/l10n/app_localizations.dart';

/// 앱에서 지원하는 언어 코드 목록
const List<String> supportedLanguageCodes = [
  'ko',
  'ja',
  'en',
];

/// 언어 선택기 우선순위
const List<String> languagePickerOrder = [
  'ko',
  'ja',
  'en',
];

/// 지역화된 언어 라벨 반환
String localizedLanguageLabel(String code, AppLocalizations l10n) {
  switch (code) {
    case 'ko':
      return l10n.onboardingLanguageKoLabel;
    case 'ja':
      return l10n.onboardingLanguageJaLabel;
    case 'en':
      return l10n.onboardingLanguageEnLabel;
    default:
      return code;
  }
}

/// 영어 언어명 반환
String englishLanguageName(String code) {
  switch (code) {
    case 'ko':
      return 'Korean';
    case 'ja':
      return 'Japanese';
    case 'en':
      return 'English';
    default:
      return code;
  }
}

/// 언어 국기 이모지 반환
String languageFlag(String code) {
  switch (code) {
    case 'ko':
      return '🇰🇷';
    case 'ja':
      return '🇯🇵';
    case 'en':
      return '🇺🇸';
    default:
      return '🌐';
  }
}

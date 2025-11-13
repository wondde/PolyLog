// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'PolyLog';

  @override
  String get signInWithGoogle => 'Google로 로그인';

  @override
  String get writeDiary => '일기 쓰기';

  @override
  String get suggestions => '제안';

  @override
  String get corrections => '교정';

  @override
  String get natural => '자연스러운 표현';

  @override
  String get vocab => '단어장';

  @override
  String get home => '홈';

  @override
  String get feed => '피드';

  @override
  String get dashboard => '대시보드';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get signOut => '로그아웃';

  @override
  String get streak => '연속 일수';

  @override
  String get topicIdeas => '주제 아이디어';

  @override
  String get sentenceStarters => '문장 시작하기';

  @override
  String get reflectiveQuestions => '성찰 질문';

  @override
  String get saveEntry => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '수정';

  @override
  String get share => '공유';

  @override
  String get mood => '기분';

  @override
  String get happy => '행복';

  @override
  String get sad => '슬픔';

  @override
  String get angry => '화남';

  @override
  String get calm => '평온';

  @override
  String get visibility => '공개 설정';

  @override
  String get private => '비공개';

  @override
  String get anonymous => '익명';

  @override
  String get casual => '편한 말투';

  @override
  String get formal => '격식 있는 말투';

  @override
  String get grammarNotes => '문법 노트';

  @override
  String get score => '점수';

  @override
  String get fluency => '유창성';

  @override
  String get accuracy => '정확성';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get appearance => '화면 설정';

  @override
  String get darkMode => '다크 모드';

  @override
  String get language => '언어';

  @override
  String get uiLanguage => '앱 언어';

  @override
  String get learningLanguages => '학습 언어';

  @override
  String get aiExplanationLanguage => 'AI 설명 언어';

  @override
  String get account => '계정';

  @override
  String get logOut => '로그아웃';

  @override
  String get selectUILanguage => '앱 언어 선택';

  @override
  String get selectLearningLanguages => '학습 언어 선택';

  @override
  String get selectAILanguage => 'AI 설명 언어 선택';

  @override
  String get notSetAllAvailable => '미설정 (모든 언어 사용 가능)';

  @override
  String get save => '저장';

  @override
  String welcome(String name) {
    return '환영합니다, $name님!';
  }

  @override
  String dayStreak(int count) {
    return '$count일 연속';
  }

  @override
  String get writeTodayDiary => '오늘의 일기 작성하기';

  @override
  String get todaySentence => '오늘의 문장';

  @override
  String get topicSuggestions => '일기 거리 제안';

  @override
  String get sentenceSuggestions => '문장 시작하기';

  @override
  String get reflectiveSuggestions => '성찰 질문';

  @override
  String get loadingUserData => '사용자 데이터 로딩 중...';

  @override
  String get writeDiaryEntry => '일기 작성';

  @override
  String get pleaseSomething => '내용을 입력해주세요';

  @override
  String get textTooLong => '텍스트가 너무 깁니다 (최대 600자)';

  @override
  String get entrySaved => '일기가 저장되었습니다! 문장 수정하는 중...';

  @override
  String get notLoggedIn => '로그인되지 않음';

  @override
  String get writeHere => '여기에 일기를 작성하세요...';

  @override
  String get editor => '작성';

  @override
  String get records => '기록';

  @override
  String get weeklyStudy => '주간 학습량';

  @override
  String get commonGrammarMistakes => '자주 틀리는 문법';

  @override
  String get newVocabulary => '새로운 단어';

  @override
  String get graphWillBeDisplayedHere => '그래프가 여기에 표시됩니다.';

  @override
  String get grammarPointsWillBeDisplayedHere => '문법 포인트 목록이 여기에 표시됩니다.';

  @override
  String get vocabularyListWillBeDisplayedHere => '단어 목록이 여기에 표시됩니다.';

  @override
  String get dayStreakLabel => '연속 일수';

  @override
  String get weeklyGoal => '주간 목표';

  @override
  String get setWeeklyGoal => '주간 목표 설정';

  @override
  String entriesPerWeek(int count) {
    return '일기 $count개/주';
  }

  @override
  String get goal => '목표';

  @override
  String get activityStreak => '활동 연속 기록';

  @override
  String get howItWorks => '사용 방법';

  @override
  String get streakDescription =>
      '각 초록색 사각형은 일기를 작성한 날을 나타냅니다. 색이 진할수록 그날 더 많이 작성한 것입니다.';

  @override
  String entriesCount(int count) {
    return '$count개의 일기';
  }

  @override
  String characterCount(int count) {
    return '$count/600자';
  }

  @override
  String get writingPrompts => '작성 도움말';

  @override
  String get topicKeywords => '주제 키워드';

  @override
  String suggestionFrom(String topic) {
    return '제안: $topic';
  }

  @override
  String get tapToUse => '탭하여 사용하기';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get noEntriesYet => '아직 작성한 일기가 없습니다.';

  @override
  String get writeYourFirstDiary => '첫 일기를 작성해보세요!';

  @override
  String get aiAnalysisComplete => '문장 분석 완료';

  @override
  String get aiAnalyzing => '문장 분석 중...';

  @override
  String get onboardingSetupTitle => '학습 설정';

  @override
  String get onboardingNativeLanguageTitle => '모국어를 선택하세요';

  @override
  String get onboardingLearningLanguageTitle => '학습할 언어를 선택하세요';

  @override
  String get onboardingSelectAtLeastOne => '학습할 언어를 하나 이상 선택해주세요';

  @override
  String onboardingSelectLevelFor(String language) {
    return '$language의 레벨을 선택해주세요';
  }

  @override
  String get onboardingUserNotFound => '사용자 정보를 찾을 수 없습니다.';

  @override
  String onboardingSaveFailed(String error) {
    return '설정을 저장하지 못했어요: $error';
  }

  @override
  String get onboardingLevelQuestion => '얼마나 학습해 보셨나요?';

  @override
  String get onboardingPresetBeginnerLabel => '초급';

  @override
  String get onboardingPresetBeginnerSubtitle => '기초 표현 중심';

  @override
  String get onboardingPresetIntermediateLabel => '중급';

  @override
  String get onboardingPresetIntermediateSubtitle => '일상 대화 가능';

  @override
  String get onboardingPresetAdvancedLabel => '고급';

  @override
  String get onboardingPresetAdvancedSubtitle => '복잡한 주제도 가능';

  @override
  String get onboardingShowDetailedLevels => '세부 레벨 선택 보기';

  @override
  String get onboardingHideDetailedLevels => '간단 선택으로 돌아가기';

  @override
  String get onboardingDetailedLevelHeader => '세부 CEFR 레벨 선택';

  @override
  String onboardingPresetSelected(String label) {
    return '$label 수준으로 설정되었습니다.';
  }

  @override
  String onboardingCurrentSelection(String level) {
    return '현재 선택: $level';
  }

  @override
  String get onboardingStartButton => '시작하기';

  @override
  String get onboardingChangeLaterNote => '나중에 설정에서 언제든 다시 바꿀 수 있어요.';

  @override
  String get onboardingLanguageKoLabel => '한국어 (Korean)';

  @override
  String get onboardingLanguageJaLabel => '일본어 (Japanese)';

  @override
  String get onboardingLanguageEnLabel => '영어 (English)';

  @override
  String get onboardingLanguageDeLabel => '독일어 (Deutsch)';

  @override
  String get onboardingLanguageEsLabel => '스페인어 (Español)';

  @override
  String get onboardingLanguageArLabel => '아랍어 (العربية)';

  @override
  String get onboardingLanguageZhLabel => '중국어 (中文)';

  @override
  String get onboardingLanguageFrLabel => '프랑스어 (Français)';

  @override
  String get onboardingLanguageRuLabel => '러시아어 (Русский)';

  @override
  String get onboardingLanguagePtLabel => '포르투갈어 (Português)';

  @override
  String get onboardingLanguageItLabel => '이탈리아어 (Italiano)';

  @override
  String get onboardingLanguageViLabel => '베트남어 (Tiếng Việt)';

  @override
  String get onboardingLanguageThLabel => '태국어 (ไทย)';

  @override
  String get onboardingLevelA1 => 'A1 · 초급';

  @override
  String get onboardingLevelA2 => 'A2 · 기초';

  @override
  String get onboardingLevelB1 => 'B1 · 중급';

  @override
  String get onboardingLevelB2 => 'B2 · 중상급';

  @override
  String get onboardingLevelC1 => 'C1 · 고급';

  @override
  String get onboardingLevelC2 => 'C2 · 원어민에 가까움';

  @override
  String get onboardingSubtitle => '일기를 쓰며 언어를 배워요';

  @override
  String get onboardingFeature1Title => '어떤 언어로든 작성';

  @override
  String get onboardingFeature1Desc => '일본어, 한국어, 영어로 자유롭게 표현하세요';

  @override
  String get onboardingFeature2Title => 'AI 기반 피드백';

  @override
  String get onboardingFeature2Desc => '즉각적인 교정과 함께 실수에서 배우세요';

  @override
  String get onboardingFeature3Title => '매일 습관 만들기';

  @override
  String get onboardingFeature3Desc => '연속 기록을 추적하고 목표를 달성하세요';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String errorWithMessage(String message) {
    return '오류: $message';
  }

  @override
  String get modelDownloadComplete => '모델 다운로드 완료';

  @override
  String downloadFailed(String error) {
    return '다운로드 실패: $error';
  }

  @override
  String get deleteModel => '모델 삭제';

  @override
  String get deleteModelConfirm => '다운로드한 모델을 삭제하시겠습니까?\n(1.1GB 확보)';

  @override
  String get modelDeleted => '모델 삭제 완료';

  @override
  String get aiModel => 'AI 모델';

  @override
  String get vocabulary => '단어장';

  @override
  String get debugInfo => '디버그 정보';

  @override
  String get initializationStatus => '초기화 상태';

  @override
  String get cacheSize => '캐시 크기';

  @override
  String get cacheHitRate => '캐시 적중률';

  @override
  String get systemInfo => '시스템 정보';

  @override
  String get clearCache => '캐시 클리어';

  @override
  String get cacheCleared => '캐시 클리어 완료';

  @override
  String addAllWords(int count) {
    return '모든 단어 추가 ($count개)';
  }

  @override
  String get refresh => '새로고침';

  @override
  String get loadingData => '데이터 로딩 중...';

  @override
  String wordAdded(String word) {
    return '$word이(가) 단어장에 추가되었습니다';
  }

  @override
  String get noGrammarData => '아직 문법 데이터가 없습니다.\n일기를 작성하고 AI 분석을 받아보세요!';

  @override
  String repeatCount(int count) {
    return '$count회 반복';
  }

  @override
  String get grammarErrorEntries => '문법 오류 일기';

  @override
  String get entriesWithGrammar => '해당 문법이 포함된 일기';

  @override
  String get noEntriesWithGrammar => '해당 문법이 포함된 일기가 없습니다';

  @override
  String get generatingNewSuggestion => '새로운 제안을 생성하고 있습니다...';

  @override
  String get viewAllWords => '모든 단어 보기';

  @override
  String get viewDebugInfo => '🐛 디버그 정보 보기';

  @override
  String get status => '상태';

  @override
  String get onDeviceAI => '온디바이스 AI';

  @override
  String modelDownloaded(String size) {
    return '다운로드 완료 ($size MB)';
  }

  @override
  String get modelNotDownloaded => '다운로드 필요 (~1.1 GB)';

  @override
  String get modelDownloadDescription =>
      '모델을 다운로드하면 오프라인에서도 단어 추천을 사용할 수 있습니다.';

  @override
  String get reviewStart => '복습 시작';

  @override
  String get reviewComplete => '복습 완료';

  @override
  String get allReviewsComplete => '모든 복습을 완료했습니다!';

  @override
  String get goBack => '돌아가기';

  @override
  String reviewProgress(int current, int total) {
    return '복습 ($current/$total)';
  }

  @override
  String get tapToShowAnswer => '탭하여 답 보기';

  @override
  String get howWellRemember => '이 단어를 얼마나 잘 기억하셨나요?';

  @override
  String get ratingAgain => '다시';

  @override
  String get ratingHard => '어려움';

  @override
  String get ratingGood => '좋음';

  @override
  String get ratingEasy => '쉬움';

  @override
  String get korean => '한국어';

  @override
  String get learningProgress => '학습 현황';

  @override
  String get dueForReview => '복습 예정';

  @override
  String get todayCompleted => '오늘 완료';

  @override
  String get newCards => '새 카드';

  @override
  String get learning => '학습 중';

  @override
  String get totalWords => '총 단어';

  @override
  String get close => '닫기';

  @override
  String get addWord => '단어 추가';

  @override
  String get word => '단어';

  @override
  String get meaning => '의미';

  @override
  String get enterWordAndMeaning => '단어와 의미를 입력해주세요';

  @override
  String get add => '추가';

  @override
  String get all => '전체';

  @override
  String get reviewing => '복습 중';

  @override
  String noCardsInCategory(String category) {
    return '$category 카드가 없습니다';
  }

  @override
  String get newCard => '새 카드';

  @override
  String get problemCard => '문제 카드';

  @override
  String get next => '다음';

  @override
  String get now => '지금';

  @override
  String daysLater(int days) {
    return '$days일 후';
  }

  @override
  String hoursLater(int hours) {
    return '$hours시간 후';
  }

  @override
  String minutesLater(int minutes) {
    return '$minutes분 후';
  }

  @override
  String get soon => '곧';

  @override
  String get aiReview => 'AI 리뷰';

  @override
  String get aiAnalysisTakingLong => 'AI 분석이 예상보다 오래 걸리고 있습니다';

  @override
  String get checkFirebaseLogs =>
      'Firebase Functions 로그를 확인하거나\n잠시 후 다시 시도해주세요';

  @override
  String aiAnalysisInProgress(int seconds) {
    return 'AI 분석 진행 중... ($seconds초)';
  }

  @override
  String get noVocabularyFound => '추출된 단어가 없습니다';

  @override
  String wordsAddedAndSkipped(int added, int skipped) {
    return '$added개 추가, $skipped개 이미 존재';
  }

  @override
  String wordsAddedCount(int count) {
    return '$count개의 단어가 추가되었습니다';
  }

  @override
  String get allWordsAlreadyExist => '모든 단어가 이미 단어장에 있습니다';

  @override
  String get addToVocabulary => '단어장에 추가';

  @override
  String get wordAlreadyExists => '이미 단어장에 있는 단어입니다';

  @override
  String get generatingSuggestions => '새로운 제안을 생성하고 있습니다...';

  @override
  String get originalVsCorrected => '원문 vs 교정본';

  @override
  String get scores => '점수';

  @override
  String get casualExpression => '편한 말투';

  @override
  String get formalExpression => '격식 있는 말투';

  @override
  String get searchUnknownWords => '모르는 단어를 검색하세요...';
}

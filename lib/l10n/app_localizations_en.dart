// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PolyLog';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get writeDiary => 'Write a diary';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get corrections => 'Corrections';

  @override
  String get natural => 'Natural';

  @override
  String get vocab => 'Vocab';

  @override
  String get home => 'Home';

  @override
  String get feed => 'Feed';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get streak => 'Day Streak';

  @override
  String get topicIdeas => 'Topic Ideas';

  @override
  String get sentenceStarters => 'Sentence Starters';

  @override
  String get reflectiveQuestions => 'Reflective Questions';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get mood => 'Mood';

  @override
  String get happy => 'Happy';

  @override
  String get sad => 'Sad';

  @override
  String get angry => 'Angry';

  @override
  String get calm => 'Calm';

  @override
  String get visibility => 'Visibility';

  @override
  String get private => 'Private';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get casual => 'Casual';

  @override
  String get formal => 'Formal';

  @override
  String get grammarNotes => 'Grammar Notes';

  @override
  String get score => 'Score';

  @override
  String get fluency => 'Fluency';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get uiLanguage => 'UI Language';

  @override
  String get learningLanguages => 'Learning Languages';

  @override
  String get aiExplanationLanguage => 'AI Explanation Language';

  @override
  String get account => 'Account';

  @override
  String get logOut => 'Log Out';

  @override
  String get selectUILanguage => 'Select UI Language';

  @override
  String get selectLearningLanguages => 'Select Learning Languages';

  @override
  String get selectAILanguage => 'Select AI Language';

  @override
  String get notSetAllAvailable => 'Not set (all available)';

  @override
  String get save => 'Save';

  @override
  String welcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String dayStreak(int count) {
    return '$count day streak';
  }

  @override
  String get writeTodayDiary => 'Write Today\'s Diary';

  @override
  String get todaySentence => 'Today\'s Sentence';

  @override
  String get topicSuggestions => 'Topic Suggestions';

  @override
  String get sentenceSuggestions => 'Sentence Starters';

  @override
  String get reflectiveSuggestions => 'Reflective Questions';

  @override
  String get loadingUserData => 'Loading user data...';

  @override
  String get writeDiaryEntry => 'Write Diary';

  @override
  String get pleaseSomething => 'Please write something';

  @override
  String get textTooLong => 'Text is too long (max 600 characters)';

  @override
  String get entrySaved => 'Entry saved! AI analysis in progress...';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get writeHere => 'Write your diary entry here...';

  @override
  String get editor => 'Editor';

  @override
  String get records => 'Records';

  @override
  String get weeklyStudy => 'Weekly Study';

  @override
  String get commonGrammarMistakes => 'Common Grammar Mistakes';

  @override
  String get newVocabulary => 'New Vocabulary';

  @override
  String get graphWillBeDisplayedHere => 'Graph will be displayed here.';

  @override
  String get grammarPointsWillBeDisplayedHere =>
      'Grammar points list will be displayed here.';

  @override
  String get vocabularyListWillBeDisplayedHere =>
      'Vocabulary list will be displayed here.';

  @override
  String get dayStreakLabel => 'Day Streak';

  @override
  String get weeklyGoal => 'Weekly Goal';

  @override
  String get setWeeklyGoal => 'Set Weekly Goal';

  @override
  String entriesPerWeek(int count) {
    return '$count entries/week';
  }

  @override
  String get goal => 'Goal';

  @override
  String get activityStreak => 'Activity Streak';

  @override
  String get howItWorks => 'How it works';

  @override
  String get streakDescription =>
      'Each green square represents a day you wrote in your diary. The darker the square, the more you wrote on that day.';

  @override
  String entriesCount(int count) {
    return '$count entries';
  }

  @override
  String characterCount(int count) {
    return '$count/600 characters';
  }

  @override
  String get writingPrompts => 'Writing Prompts';

  @override
  String get topicKeywords => 'Topic Keywords';

  @override
  String suggestionFrom(String topic) {
    return 'Suggestion: $topic';
  }

  @override
  String get tapToUse => 'Tap to use';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noEntriesYet => 'No entries yet.';

  @override
  String get writeYourFirstDiary => 'Write your first diary!';

  @override
  String get aiAnalysisComplete => 'AI Analysis Complete';

  @override
  String get aiAnalyzing => 'AI Analyzing...';

  @override
  String get onboardingSetupTitle => 'Learning setup';

  @override
  String get onboardingNativeLanguageTitle => 'Select your native language';

  @override
  String get onboardingLearningLanguageTitle =>
      'Choose the languages you want to learn';

  @override
  String get onboardingSelectAtLeastOne =>
      'Please select at least one learning language';

  @override
  String onboardingSelectLevelFor(String language) {
    return 'Please select a level for $language';
  }

  @override
  String get onboardingUserNotFound => 'Unable to find user information.';

  @override
  String onboardingSaveFailed(String error) {
    return 'Failed to save settings: $error';
  }

  @override
  String get onboardingLevelQuestion => 'How long have you been learning?';

  @override
  String get onboardingPresetBeginnerLabel => 'Beginner';

  @override
  String get onboardingPresetBeginnerSubtitle => 'Basic phrases';

  @override
  String get onboardingPresetIntermediateLabel => 'Intermediate';

  @override
  String get onboardingPresetIntermediateSubtitle =>
      'Comfortable in daily conversations';

  @override
  String get onboardingPresetAdvancedLabel => 'Advanced';

  @override
  String get onboardingPresetAdvancedSubtitle => 'Handle complex topics';

  @override
  String get onboardingShowDetailedLevels => 'See detailed CEFR levels';

  @override
  String get onboardingHideDetailedLevels => 'Back to simple options';

  @override
  String get onboardingDetailedLevelHeader => 'Detailed CEFR level';

  @override
  String onboardingPresetSelected(String label) {
    return 'Set to $label level.';
  }

  @override
  String onboardingCurrentSelection(String level) {
    return 'Current selection: $level';
  }

  @override
  String get onboardingStartButton => 'Get started';

  @override
  String get onboardingChangeLaterNote =>
      'You can change these anytime in settings.';

  @override
  String get onboardingLanguageKoLabel => 'Korean (한국어)';

  @override
  String get onboardingLanguageJaLabel => 'Japanese (日本語)';

  @override
  String get onboardingLanguageEnLabel => 'English';

  @override
  String get onboardingLanguageDeLabel => 'German (Deutsch)';

  @override
  String get onboardingLanguageEsLabel => 'Spanish (Español)';

  @override
  String get onboardingLanguageArLabel => 'Arabic (العربية)';

  @override
  String get onboardingLanguageZhLabel => 'Chinese (中文)';

  @override
  String get onboardingLanguageFrLabel => 'French (Français)';

  @override
  String get onboardingLanguageRuLabel => 'Russian (Русский)';

  @override
  String get onboardingLanguagePtLabel => 'Portuguese (Português)';

  @override
  String get onboardingLanguageItLabel => 'Italian (Italiano)';

  @override
  String get onboardingLanguageViLabel => 'Vietnamese (Tiếng Việt)';

  @override
  String get onboardingLanguageThLabel => 'Thai (ไทย)';

  @override
  String get onboardingLevelA1 => 'A1 · Beginner';

  @override
  String get onboardingLevelA2 => 'A2 · Elementary';

  @override
  String get onboardingLevelB1 => 'B1 · Intermediate';

  @override
  String get onboardingLevelB2 => 'B2 · Upper Intermediate';

  @override
  String get onboardingLevelC1 => 'C1 · Advanced';

  @override
  String get onboardingLevelC2 => 'C2 · Proficient';

  @override
  String get onboardingSubtitle => 'Learn languages through journaling';

  @override
  String get onboardingFeature1Title => 'Write in Any Language';

  @override
  String get onboardingFeature1Desc =>
      'Express yourself freely in Japanese, Korean, or English';

  @override
  String get onboardingFeature2Title => 'AI-Powered Feedback';

  @override
  String get onboardingFeature2Desc =>
      'Get instant corrections and learn from your mistakes';

  @override
  String get onboardingFeature3Title => 'Build Daily Habits';

  @override
  String get onboardingFeature3Desc =>
      'Track streaks and stay motivated with your goals';

  @override
  String get loginRequired => 'Login required';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get modelDownloadComplete => 'Model download complete';

  @override
  String downloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get deleteModel => 'Delete Model';

  @override
  String get deleteModelConfirm =>
      'Do you want to delete the downloaded model?\n(Free up 1.1GB)';

  @override
  String get modelDeleted => 'Model deleted';

  @override
  String get aiModel => 'AI Model';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get debugInfo => 'Debug Info';

  @override
  String get initializationStatus => 'Initialization Status';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get cacheHitRate => 'Cache Hit Rate';

  @override
  String get systemInfo => 'System Info';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String addAllWords(int count) {
    return 'Add All Words ($count)';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get loadingData => 'Loading data...';

  @override
  String wordAdded(String word) {
    return '$word has been added to vocabulary';
  }

  @override
  String get noGrammarData =>
      'No grammar data yet.\nWrite diary entries and get AI analysis!';

  @override
  String repeatCount(int count) {
    return '$count times';
  }

  @override
  String get grammarErrorEntries => 'Grammar Error Entries';

  @override
  String get entriesWithGrammar => 'Entries with this grammar';

  @override
  String get noEntriesWithGrammar => 'No entries with this grammar';

  @override
  String get generatingNewSuggestion => 'Generating new suggestion...';

  @override
  String get viewAllWords => 'View All Words';

  @override
  String get viewDebugInfo => '🐛 View Debug Info';

  @override
  String get status => 'Status';

  @override
  String get onDeviceAI => 'On-Device AI';

  @override
  String modelDownloaded(String size) {
    return 'Downloaded ($size MB)';
  }

  @override
  String get modelNotDownloaded => 'Download required (~1.1 GB)';

  @override
  String get modelDownloadDescription =>
      'Download the model to use word suggestions offline.';

  @override
  String get reviewStart => 'Start Review';

  @override
  String get reviewComplete => 'Review Complete';

  @override
  String get allReviewsComplete => 'All reviews complete!';

  @override
  String get goBack => 'Go Back';

  @override
  String reviewProgress(int current, int total) {
    return 'Review ($current/$total)';
  }

  @override
  String get tapToShowAnswer => 'Tap to show answer';

  @override
  String get howWellRemember => 'How well did you remember this word?';

  @override
  String get ratingAgain => 'Again';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get korean => 'Korean';

  @override
  String get learningProgress => 'Learning Progress';

  @override
  String get dueForReview => 'Due for Review';

  @override
  String get todayCompleted => 'Today Completed';

  @override
  String get newCards => 'New Cards';

  @override
  String get learning => 'Learning';

  @override
  String get totalWords => 'Total Words';

  @override
  String get close => 'Close';

  @override
  String get addWord => 'Add Word';

  @override
  String get word => 'Word';

  @override
  String get meaning => 'Meaning';

  @override
  String get enterWordAndMeaning => 'Please enter word and meaning';

  @override
  String get add => 'Add';

  @override
  String get all => 'All';

  @override
  String get reviewing => 'Reviewing';

  @override
  String noCardsInCategory(String category) {
    return 'No $category cards';
  }

  @override
  String get newCard => 'New Card';

  @override
  String get problemCard => 'Problem Card';

  @override
  String get next => 'Next';

  @override
  String get now => 'Now';

  @override
  String daysLater(int days) {
    return '$days days later';
  }

  @override
  String hoursLater(int hours) {
    return '$hours hours later';
  }

  @override
  String minutesLater(int minutes) {
    return '$minutes minutes later';
  }

  @override
  String get soon => 'Soon';

  @override
  String get aiReview => 'AI Review';

  @override
  String get aiAnalysisTakingLong =>
      'AI analysis is taking longer than expected';

  @override
  String get checkFirebaseLogs =>
      'Please check Firebase Functions logs\nor try again later';

  @override
  String aiAnalysisInProgress(int seconds) {
    return 'AI analysis in progress... (${seconds}s)';
  }

  @override
  String get noVocabularyFound => 'No vocabulary items found';

  @override
  String wordsAddedAndSkipped(int added, int skipped) {
    return '$added added, $skipped already exist';
  }

  @override
  String wordsAddedCount(int count) {
    return '$count words have been added';
  }

  @override
  String get allWordsAlreadyExist => 'All words already exist in vocabulary';

  @override
  String get addToVocabulary => 'Add to vocabulary';

  @override
  String get wordAlreadyExists => 'Word already exists in vocabulary';

  @override
  String get generatingSuggestions => 'Generating new suggestions...';

  @override
  String get originalVsCorrected => 'Original vs Corrected';

  @override
  String get scores => 'Scores';

  @override
  String get casualExpression => 'Casual Expression';

  @override
  String get formalExpression => 'Formal Expression';

  @override
  String get searchUnknownWords => 'Search unknown words...';
}

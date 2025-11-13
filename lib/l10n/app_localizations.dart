import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PolyLog'**
  String get appTitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @writeDiary.
  ///
  /// In en, this message translates to:
  /// **'Write a diary'**
  String get writeDiary;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @corrections.
  ///
  /// In en, this message translates to:
  /// **'Corrections'**
  String get corrections;

  /// No description provided for @natural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get natural;

  /// No description provided for @vocab.
  ///
  /// In en, this message translates to:
  /// **'Vocab'**
  String get vocab;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get streak;

  /// No description provided for @topicIdeas.
  ///
  /// In en, this message translates to:
  /// **'Topic Ideas'**
  String get topicIdeas;

  /// No description provided for @sentenceStarters.
  ///
  /// In en, this message translates to:
  /// **'Sentence Starters'**
  String get sentenceStarters;

  /// No description provided for @reflectiveQuestions.
  ///
  /// In en, this message translates to:
  /// **'Reflective Questions'**
  String get reflectiveQuestions;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Entry'**
  String get saveEntry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @formal.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get formal;

  /// No description provided for @grammarNotes.
  ///
  /// In en, this message translates to:
  /// **'Grammar Notes'**
  String get grammarNotes;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @fluency.
  ///
  /// In en, this message translates to:
  /// **'Fluency'**
  String get fluency;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @uiLanguage.
  ///
  /// In en, this message translates to:
  /// **'UI Language'**
  String get uiLanguage;

  /// No description provided for @learningLanguages.
  ///
  /// In en, this message translates to:
  /// **'Learning Languages'**
  String get learningLanguages;

  /// No description provided for @aiExplanationLanguage.
  ///
  /// In en, this message translates to:
  /// **'AI Explanation Language'**
  String get aiExplanationLanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectUILanguage.
  ///
  /// In en, this message translates to:
  /// **'Select UI Language'**
  String get selectUILanguage;

  /// No description provided for @selectLearningLanguages.
  ///
  /// In en, this message translates to:
  /// **'Select Learning Languages'**
  String get selectLearningLanguages;

  /// No description provided for @selectAILanguage.
  ///
  /// In en, this message translates to:
  /// **'Select AI Language'**
  String get selectAILanguage;

  /// No description provided for @notSetAllAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not set (all available)'**
  String get notSetAllAvailable;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcome(String name);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String dayStreak(int count);

  /// No description provided for @writeTodayDiary.
  ///
  /// In en, this message translates to:
  /// **'Write Today\'s Diary'**
  String get writeTodayDiary;

  /// No description provided for @todaySentence.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sentence'**
  String get todaySentence;

  /// No description provided for @topicSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Topic Suggestions'**
  String get topicSuggestions;

  /// No description provided for @sentenceSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Sentence Starters'**
  String get sentenceSuggestions;

  /// No description provided for @reflectiveSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Reflective Questions'**
  String get reflectiveSuggestions;

  /// No description provided for @loadingUserData.
  ///
  /// In en, this message translates to:
  /// **'Loading user data...'**
  String get loadingUserData;

  /// No description provided for @writeDiaryEntry.
  ///
  /// In en, this message translates to:
  /// **'Write Diary'**
  String get writeDiaryEntry;

  /// No description provided for @pleaseSomething.
  ///
  /// In en, this message translates to:
  /// **'Please write something'**
  String get pleaseSomething;

  /// No description provided for @textTooLong.
  ///
  /// In en, this message translates to:
  /// **'Text is too long (max 600 characters)'**
  String get textTooLong;

  /// No description provided for @entrySaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved! AI analysis in progress...'**
  String get entrySaved;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write your diary entry here...'**
  String get writeHere;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @weeklyStudy.
  ///
  /// In en, this message translates to:
  /// **'Weekly Study'**
  String get weeklyStudy;

  /// No description provided for @commonGrammarMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Grammar Mistakes'**
  String get commonGrammarMistakes;

  /// No description provided for @newVocabulary.
  ///
  /// In en, this message translates to:
  /// **'New Vocabulary'**
  String get newVocabulary;

  /// No description provided for @graphWillBeDisplayedHere.
  ///
  /// In en, this message translates to:
  /// **'Graph will be displayed here.'**
  String get graphWillBeDisplayedHere;

  /// No description provided for @grammarPointsWillBeDisplayedHere.
  ///
  /// In en, this message translates to:
  /// **'Grammar points list will be displayed here.'**
  String get grammarPointsWillBeDisplayedHere;

  /// No description provided for @vocabularyListWillBeDisplayedHere.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary list will be displayed here.'**
  String get vocabularyListWillBeDisplayedHere;

  /// No description provided for @dayStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreakLabel;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get weeklyGoal;

  /// No description provided for @setWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Weekly Goal'**
  String get setWeeklyGoal;

  /// No description provided for @entriesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} entries/week'**
  String entriesPerWeek(int count);

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @activityStreak.
  ///
  /// In en, this message translates to:
  /// **'Activity Streak'**
  String get activityStreak;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @streakDescription.
  ///
  /// In en, this message translates to:
  /// **'Each green square represents a day you wrote in your diary. The darker the square, the more you wrote on that day.'**
  String get streakDescription;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(int count);

  /// No description provided for @characterCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/600 characters'**
  String characterCount(int count);

  /// No description provided for @writingPrompts.
  ///
  /// In en, this message translates to:
  /// **'Writing Prompts'**
  String get writingPrompts;

  /// No description provided for @topicKeywords.
  ///
  /// In en, this message translates to:
  /// **'Topic Keywords'**
  String get topicKeywords;

  /// No description provided for @suggestionFrom.
  ///
  /// In en, this message translates to:
  /// **'Suggestion: {topic}'**
  String suggestionFrom(String topic);

  /// No description provided for @tapToUse.
  ///
  /// In en, this message translates to:
  /// **'Tap to use'**
  String get tapToUse;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get noEntriesYet;

  /// No description provided for @writeYourFirstDiary.
  ///
  /// In en, this message translates to:
  /// **'Write your first diary!'**
  String get writeYourFirstDiary;

  /// No description provided for @aiAnalysisComplete.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis Complete'**
  String get aiAnalysisComplete;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI Analyzing...'**
  String get aiAnalyzing;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning setup'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingNativeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your native language'**
  String get onboardingNativeLanguageTitle;

  /// No description provided for @onboardingLearningLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the languages you want to learn'**
  String get onboardingLearningLanguageTitle;

  /// No description provided for @onboardingSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one learning language'**
  String get onboardingSelectAtLeastOne;

  /// No description provided for @onboardingSelectLevelFor.
  ///
  /// In en, this message translates to:
  /// **'Please select a level for {language}'**
  String onboardingSelectLevelFor(String language);

  /// No description provided for @onboardingUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'Unable to find user information.'**
  String get onboardingUserNotFound;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings: {error}'**
  String onboardingSaveFailed(String error);

  /// No description provided for @onboardingLevelQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long have you been learning?'**
  String get onboardingLevelQuestion;

  /// No description provided for @onboardingPresetBeginnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onboardingPresetBeginnerLabel;

  /// No description provided for @onboardingPresetBeginnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic phrases'**
  String get onboardingPresetBeginnerSubtitle;

  /// No description provided for @onboardingPresetIntermediateLabel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onboardingPresetIntermediateLabel;

  /// No description provided for @onboardingPresetIntermediateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comfortable in daily conversations'**
  String get onboardingPresetIntermediateSubtitle;

  /// No description provided for @onboardingPresetAdvancedLabel.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onboardingPresetAdvancedLabel;

  /// No description provided for @onboardingPresetAdvancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Handle complex topics'**
  String get onboardingPresetAdvancedSubtitle;

  /// No description provided for @onboardingShowDetailedLevels.
  ///
  /// In en, this message translates to:
  /// **'See detailed CEFR levels'**
  String get onboardingShowDetailedLevels;

  /// No description provided for @onboardingHideDetailedLevels.
  ///
  /// In en, this message translates to:
  /// **'Back to simple options'**
  String get onboardingHideDetailedLevels;

  /// No description provided for @onboardingDetailedLevelHeader.
  ///
  /// In en, this message translates to:
  /// **'Detailed CEFR level'**
  String get onboardingDetailedLevelHeader;

  /// No description provided for @onboardingPresetSelected.
  ///
  /// In en, this message translates to:
  /// **'Set to {label} level.'**
  String onboardingPresetSelected(String label);

  /// No description provided for @onboardingCurrentSelection.
  ///
  /// In en, this message translates to:
  /// **'Current selection: {level}'**
  String onboardingCurrentSelection(String level);

  /// No description provided for @onboardingStartButton.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStartButton;

  /// No description provided for @onboardingChangeLaterNote.
  ///
  /// In en, this message translates to:
  /// **'You can change these anytime in settings.'**
  String get onboardingChangeLaterNote;

  /// No description provided for @onboardingLanguageKoLabel.
  ///
  /// In en, this message translates to:
  /// **'Korean (한국어)'**
  String get onboardingLanguageKoLabel;

  /// No description provided for @onboardingLanguageJaLabel.
  ///
  /// In en, this message translates to:
  /// **'Japanese (日本語)'**
  String get onboardingLanguageJaLabel;

  /// No description provided for @onboardingLanguageEnLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get onboardingLanguageEnLabel;

  /// No description provided for @onboardingLanguageDeLabel.
  ///
  /// In en, this message translates to:
  /// **'German (Deutsch)'**
  String get onboardingLanguageDeLabel;

  /// No description provided for @onboardingLanguageEsLabel.
  ///
  /// In en, this message translates to:
  /// **'Spanish (Español)'**
  String get onboardingLanguageEsLabel;

  /// No description provided for @onboardingLanguageArLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic (العربية)'**
  String get onboardingLanguageArLabel;

  /// No description provided for @onboardingLanguageZhLabel.
  ///
  /// In en, this message translates to:
  /// **'Chinese (中文)'**
  String get onboardingLanguageZhLabel;

  /// No description provided for @onboardingLanguageFrLabel.
  ///
  /// In en, this message translates to:
  /// **'French (Français)'**
  String get onboardingLanguageFrLabel;

  /// No description provided for @onboardingLanguageRuLabel.
  ///
  /// In en, this message translates to:
  /// **'Russian (Русский)'**
  String get onboardingLanguageRuLabel;

  /// No description provided for @onboardingLanguagePtLabel.
  ///
  /// In en, this message translates to:
  /// **'Portuguese (Português)'**
  String get onboardingLanguagePtLabel;

  /// No description provided for @onboardingLanguageItLabel.
  ///
  /// In en, this message translates to:
  /// **'Italian (Italiano)'**
  String get onboardingLanguageItLabel;

  /// No description provided for @onboardingLanguageViLabel.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese (Tiếng Việt)'**
  String get onboardingLanguageViLabel;

  /// No description provided for @onboardingLanguageThLabel.
  ///
  /// In en, this message translates to:
  /// **'Thai (ไทย)'**
  String get onboardingLanguageThLabel;

  /// No description provided for @onboardingLevelA1.
  ///
  /// In en, this message translates to:
  /// **'A1 · Beginner'**
  String get onboardingLevelA1;

  /// No description provided for @onboardingLevelA2.
  ///
  /// In en, this message translates to:
  /// **'A2 · Elementary'**
  String get onboardingLevelA2;

  /// No description provided for @onboardingLevelB1.
  ///
  /// In en, this message translates to:
  /// **'B1 · Intermediate'**
  String get onboardingLevelB1;

  /// No description provided for @onboardingLevelB2.
  ///
  /// In en, this message translates to:
  /// **'B2 · Upper Intermediate'**
  String get onboardingLevelB2;

  /// No description provided for @onboardingLevelC1.
  ///
  /// In en, this message translates to:
  /// **'C1 · Advanced'**
  String get onboardingLevelC1;

  /// No description provided for @onboardingLevelC2.
  ///
  /// In en, this message translates to:
  /// **'C2 · Proficient'**
  String get onboardingLevelC2;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn languages through journaling'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Write in Any Language'**
  String get onboardingFeature1Title;

  /// No description provided for @onboardingFeature1Desc.
  ///
  /// In en, this message translates to:
  /// **'Express yourself freely in Japanese, Korean, or English'**
  String get onboardingFeature1Desc;

  /// No description provided for @onboardingFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Feedback'**
  String get onboardingFeature2Title;

  /// No description provided for @onboardingFeature2Desc.
  ///
  /// In en, this message translates to:
  /// **'Get instant corrections and learn from your mistakes'**
  String get onboardingFeature2Desc;

  /// No description provided for @onboardingFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Build Daily Habits'**
  String get onboardingFeature3Title;

  /// No description provided for @onboardingFeature3Desc.
  ///
  /// In en, this message translates to:
  /// **'Track streaks and stay motivated with your goals'**
  String get onboardingFeature3Desc;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @modelDownloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Model download complete'**
  String get modelDownloadComplete;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String downloadFailed(String error);

  /// No description provided for @deleteModel.
  ///
  /// In en, this message translates to:
  /// **'Delete Model'**
  String get deleteModel;

  /// No description provided for @deleteModelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the downloaded model?\n(Free up 1.1GB)'**
  String get deleteModelConfirm;

  /// No description provided for @modelDeleted.
  ///
  /// In en, this message translates to:
  /// **'Model deleted'**
  String get modelDeleted;

  /// No description provided for @aiModel.
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get aiModel;

  /// No description provided for @vocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabulary;

  /// No description provided for @debugInfo.
  ///
  /// In en, this message translates to:
  /// **'Debug Info'**
  String get debugInfo;

  /// No description provided for @initializationStatus.
  ///
  /// In en, this message translates to:
  /// **'Initialization Status'**
  String get initializationStatus;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @cacheHitRate.
  ///
  /// In en, this message translates to:
  /// **'Cache Hit Rate'**
  String get cacheHitRate;

  /// No description provided for @systemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Info'**
  String get systemInfo;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// No description provided for @addAllWords.
  ///
  /// In en, this message translates to:
  /// **'Add All Words ({count})'**
  String addAllWords(int count);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// No description provided for @wordAdded.
  ///
  /// In en, this message translates to:
  /// **'{word} has been added to vocabulary'**
  String wordAdded(String word);

  /// No description provided for @noGrammarData.
  ///
  /// In en, this message translates to:
  /// **'No grammar data yet.\nWrite diary entries and get AI analysis!'**
  String get noGrammarData;

  /// No description provided for @repeatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String repeatCount(int count);

  /// No description provided for @grammarErrorEntries.
  ///
  /// In en, this message translates to:
  /// **'Grammar Error Entries'**
  String get grammarErrorEntries;

  /// No description provided for @entriesWithGrammar.
  ///
  /// In en, this message translates to:
  /// **'Entries with this grammar'**
  String get entriesWithGrammar;

  /// No description provided for @noEntriesWithGrammar.
  ///
  /// In en, this message translates to:
  /// **'No entries with this grammar'**
  String get noEntriesWithGrammar;

  /// No description provided for @generatingNewSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Generating new suggestion...'**
  String get generatingNewSuggestion;

  /// No description provided for @viewAllWords.
  ///
  /// In en, this message translates to:
  /// **'View All Words'**
  String get viewAllWords;

  /// No description provided for @viewDebugInfo.
  ///
  /// In en, this message translates to:
  /// **'🐛 View Debug Info'**
  String get viewDebugInfo;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @onDeviceAI.
  ///
  /// In en, this message translates to:
  /// **'On-Device AI'**
  String get onDeviceAI;

  /// No description provided for @modelDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded ({size} MB)'**
  String modelDownloaded(String size);

  /// No description provided for @modelNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Download required (~1.1 GB)'**
  String get modelNotDownloaded;

  /// No description provided for @modelDownloadDescription.
  ///
  /// In en, this message translates to:
  /// **'Download the model to use word suggestions offline.'**
  String get modelDownloadDescription;

  /// No description provided for @reviewStart.
  ///
  /// In en, this message translates to:
  /// **'Start Review'**
  String get reviewStart;

  /// No description provided for @reviewComplete.
  ///
  /// In en, this message translates to:
  /// **'Review Complete'**
  String get reviewComplete;

  /// No description provided for @allReviewsComplete.
  ///
  /// In en, this message translates to:
  /// **'All reviews complete!'**
  String get allReviewsComplete;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @reviewProgress.
  ///
  /// In en, this message translates to:
  /// **'Review ({current}/{total})'**
  String reviewProgress(int current, int total);

  /// No description provided for @tapToShowAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap to show answer'**
  String get tapToShowAnswer;

  /// No description provided for @howWellRemember.
  ///
  /// In en, this message translates to:
  /// **'How well did you remember this word?'**
  String get howWellRemember;

  /// No description provided for @ratingAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get ratingAgain;

  /// No description provided for @ratingHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get ratingHard;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get ratingEasy;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @learningProgress.
  ///
  /// In en, this message translates to:
  /// **'Learning Progress'**
  String get learningProgress;

  /// No description provided for @dueForReview.
  ///
  /// In en, this message translates to:
  /// **'Due for Review'**
  String get dueForReview;

  /// No description provided for @todayCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today Completed'**
  String get todayCompleted;

  /// No description provided for @newCards.
  ///
  /// In en, this message translates to:
  /// **'New Cards'**
  String get newCards;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @totalWords.
  ///
  /// In en, this message translates to:
  /// **'Total Words'**
  String get totalWords;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addWord.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWord;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// No description provided for @enterWordAndMeaning.
  ///
  /// In en, this message translates to:
  /// **'Please enter word and meaning'**
  String get enterWordAndMeaning;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @reviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get reviewing;

  /// No description provided for @noCardsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No {category} cards'**
  String noCardsInCategory(String category);

  /// No description provided for @newCard.
  ///
  /// In en, this message translates to:
  /// **'New Card'**
  String get newCard;

  /// No description provided for @problemCard.
  ///
  /// In en, this message translates to:
  /// **'Problem Card'**
  String get problemCard;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @daysLater.
  ///
  /// In en, this message translates to:
  /// **'{days} days later'**
  String daysLater(int days);

  /// No description provided for @hoursLater.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours later'**
  String hoursLater(int hours);

  /// No description provided for @minutesLater.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes later'**
  String minutesLater(int minutes);

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @aiReview.
  ///
  /// In en, this message translates to:
  /// **'AI Review'**
  String get aiReview;

  /// No description provided for @aiAnalysisTakingLong.
  ///
  /// In en, this message translates to:
  /// **'AI analysis is taking longer than expected'**
  String get aiAnalysisTakingLong;

  /// No description provided for @checkFirebaseLogs.
  ///
  /// In en, this message translates to:
  /// **'Please check Firebase Functions logs\nor try again later'**
  String get checkFirebaseLogs;

  /// No description provided for @aiAnalysisInProgress.
  ///
  /// In en, this message translates to:
  /// **'AI analysis in progress... ({seconds}s)'**
  String aiAnalysisInProgress(int seconds);

  /// No description provided for @noVocabularyFound.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary items found'**
  String get noVocabularyFound;

  /// No description provided for @wordsAddedAndSkipped.
  ///
  /// In en, this message translates to:
  /// **'{added} added, {skipped} already exist'**
  String wordsAddedAndSkipped(int added, int skipped);

  /// No description provided for @wordsAddedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words have been added'**
  String wordsAddedCount(int count);

  /// No description provided for @allWordsAlreadyExist.
  ///
  /// In en, this message translates to:
  /// **'All words already exist in vocabulary'**
  String get allWordsAlreadyExist;

  /// No description provided for @addToVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Add to vocabulary'**
  String get addToVocabulary;

  /// No description provided for @wordAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Word already exists in vocabulary'**
  String get wordAlreadyExists;

  /// No description provided for @generatingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Generating new suggestions...'**
  String get generatingSuggestions;

  /// No description provided for @originalVsCorrected.
  ///
  /// In en, this message translates to:
  /// **'Original vs Corrected'**
  String get originalVsCorrected;

  /// No description provided for @scores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get scores;

  /// No description provided for @casualExpression.
  ///
  /// In en, this message translates to:
  /// **'Casual Expression'**
  String get casualExpression;

  /// No description provided for @formalExpression.
  ///
  /// In en, this message translates to:
  /// **'Formal Expression'**
  String get formalExpression;

  /// No description provided for @searchUnknownWords.
  ///
  /// In en, this message translates to:
  /// **'Search unknown words...'**
  String get searchUnknownWords;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

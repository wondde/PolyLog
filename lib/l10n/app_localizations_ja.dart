// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'PolyLog';

  @override
  String get signInWithGoogle => 'Googleでログイン';

  @override
  String get writeDiary => '日記を書く';

  @override
  String get suggestions => '提案';

  @override
  String get corrections => '添削';

  @override
  String get natural => '自然な表現';

  @override
  String get vocab => '単語帳';

  @override
  String get home => 'ホーム';

  @override
  String get feed => 'フィード';

  @override
  String get dashboard => '統計';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get signOut => 'ログアウト';

  @override
  String get streak => '連続日数';

  @override
  String get topicIdeas => 'トピックのアイデア';

  @override
  String get sentenceStarters => '文の始め方';

  @override
  String get reflectiveQuestions => '振り返りの質問';

  @override
  String get saveEntry => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get share => '共有';

  @override
  String get mood => '気分';

  @override
  String get happy => '嬉しい';

  @override
  String get sad => '悲しい';

  @override
  String get angry => '怒っている';

  @override
  String get calm => '落ち着いている';

  @override
  String get visibility => '公開設定';

  @override
  String get private => '非公開';

  @override
  String get anonymous => '匿名';

  @override
  String get casual => 'カジュアル';

  @override
  String get formal => 'フォーマル';

  @override
  String get grammarNotes => '文法メモ';

  @override
  String get score => 'スコア';

  @override
  String get fluency => '流暢さ';

  @override
  String get accuracy => '正確さ';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get retry => '再試行';

  @override
  String get appearance => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get uiLanguage => 'UI言語';

  @override
  String get learningLanguages => '学習言語';

  @override
  String get aiExplanationLanguage => 'AI説明言語';

  @override
  String get account => 'アカウント';

  @override
  String get logOut => 'ログアウト';

  @override
  String get selectUILanguage => 'UI言語を選択';

  @override
  String get selectLearningLanguages => '学習言語を選択';

  @override
  String get selectAILanguage => 'AI説明言語を選択';

  @override
  String get notSetAllAvailable => '未設定（すべて利用可能）';

  @override
  String get save => '保存';

  @override
  String welcome(String name) {
    return 'ようこそ、$nameさん！';
  }

  @override
  String dayStreak(int count) {
    return '$count日連続';
  }

  @override
  String get writeTodayDiary => '今日の日記を書く';

  @override
  String get todaySentence => '今日の文章';

  @override
  String get topicSuggestions => 'トピックの提案';

  @override
  String get sentenceSuggestions => '文の始め方';

  @override
  String get reflectiveSuggestions => '振り返りの質問';

  @override
  String get loadingUserData => 'ユーザーデータを読み込み中...';

  @override
  String get writeDiaryEntry => '日記を書く';

  @override
  String get pleaseSomething => '何か書いてください';

  @override
  String get textTooLong => 'テキストが長すぎます（最大600文字）';

  @override
  String get entrySaved => '日記が保存されました！AI分析中...';

  @override
  String get notLoggedIn => 'ログインしていません';

  @override
  String get writeHere => '日記を書く...';

  @override
  String get editor => '編集';

  @override
  String get records => '記録';

  @override
  String get weeklyStudy => '週間学習量';

  @override
  String get commonGrammarMistakes => 'よくある文法ミス';

  @override
  String get newVocabulary => '新しい単語';

  @override
  String get graphWillBeDisplayedHere => 'グラフがここに表示されます。';

  @override
  String get grammarPointsWillBeDisplayedHere => '文法ポイントのリストがここに表示されます。';

  @override
  String get vocabularyListWillBeDisplayedHere => '単語リストがここに表示されます。';

  @override
  String get dayStreakLabel => '連続日数';

  @override
  String get weeklyGoal => '週間目標';

  @override
  String get setWeeklyGoal => '週間目標を設定';

  @override
  String entriesPerWeek(int count) {
    return '日記$count個/週';
  }

  @override
  String get goal => '目標';

  @override
  String get activityStreak => 'アクティビティ連続記録';

  @override
  String get howItWorks => '使い方';

  @override
  String get streakDescription =>
      '各緑色の四角形は日記を書いた日を表します。色が濃いほど、その日により多く書いたことを示します。';

  @override
  String entriesCount(int count) {
    return '$count個の日記';
  }

  @override
  String characterCount(int count) {
    return '$count/600文字';
  }

  @override
  String get writingPrompts => '作成ヒント';

  @override
  String get topicKeywords => 'トピックキーワード';

  @override
  String suggestionFrom(String topic) {
    return '提案: $topic';
  }

  @override
  String get tapToUse => 'タップして使用';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get noEntriesYet => 'まだ日記がありません。';

  @override
  String get writeYourFirstDiary => '最初の日記を書いてみましょう！';

  @override
  String get aiAnalysisComplete => 'AI分析完了';

  @override
  String get aiAnalyzing => 'AI分析中...';

  @override
  String get onboardingSetupTitle => '学習設定';

  @override
  String get onboardingNativeLanguageTitle => '母語を選択してください';

  @override
  String get onboardingLearningLanguageTitle => '学習したい言語を選択してください';

  @override
  String get onboardingSelectAtLeastOne => '学習する言語を1つ以上選択してください';

  @override
  String onboardingSelectLevelFor(String language) {
    return '$languageのレベルを選択してください';
  }

  @override
  String get onboardingUserNotFound => 'ユーザー情報を取得できませんでした。';

  @override
  String onboardingSaveFailed(String error) {
    return '設定の保存に失敗しました: $error';
  }

  @override
  String get onboardingLevelQuestion => 'どのくらい学習しましたか？';

  @override
  String get onboardingPresetBeginnerLabel => '初級';

  @override
  String get onboardingPresetBeginnerSubtitle => '基礎フレーズ中心';

  @override
  String get onboardingPresetIntermediateLabel => '中級';

  @override
  String get onboardingPresetIntermediateSubtitle => '日常会話ができる';

  @override
  String get onboardingPresetAdvancedLabel => '上級';

  @override
  String get onboardingPresetAdvancedSubtitle => '複雑な話題も対応';

  @override
  String get onboardingShowDetailedLevels => '詳細なレベルを選択する';

  @override
  String get onboardingHideDetailedLevels => '簡単な選択に戻る';

  @override
  String get onboardingDetailedLevelHeader => 'CEFR 詳細レベル';

  @override
  String onboardingPresetSelected(String label) {
    return '$labelレベルで設定しました。';
  }

  @override
  String onboardingCurrentSelection(String level) {
    return '現在の選択: $level';
  }

  @override
  String get onboardingStartButton => '始める';

  @override
  String get onboardingChangeLaterNote => '設定は後からいつでも変更できます。';

  @override
  String get onboardingLanguageKoLabel => '韓国語 (한국어)';

  @override
  String get onboardingLanguageJaLabel => '日本語';

  @override
  String get onboardingLanguageEnLabel => '英語 (English)';

  @override
  String get onboardingLanguageDeLabel => 'ドイツ語 (Deutsch)';

  @override
  String get onboardingLanguageEsLabel => 'スペイン語 (Español)';

  @override
  String get onboardingLanguageArLabel => 'アラビア語 (العربية)';

  @override
  String get onboardingLanguageZhLabel => '中国語 (中文)';

  @override
  String get onboardingLanguageFrLabel => 'フランス語 (Français)';

  @override
  String get onboardingLanguageRuLabel => 'ロシア語 (Русский)';

  @override
  String get onboardingLanguagePtLabel => 'ポルトガル語 (Português)';

  @override
  String get onboardingLanguageItLabel => 'イタリア語 (Italiano)';

  @override
  String get onboardingLanguageViLabel => 'ベトナム語 (Tiếng Việt)';

  @override
  String get onboardingLanguageThLabel => 'タイ語 (ไทย)';

  @override
  String get onboardingLevelA1 => 'A1 · 初級';

  @override
  String get onboardingLevelA2 => 'A2 · 基礎';

  @override
  String get onboardingLevelB1 => 'B1 · 中級';

  @override
  String get onboardingLevelB2 => 'B2 · 中上級';

  @override
  String get onboardingLevelC1 => 'C1 · 上級';

  @override
  String get onboardingLevelC2 => 'C2 · 熟達';

  @override
  String get onboardingSubtitle => '日記を通じて言語を学ぶ';

  @override
  String get onboardingFeature1Title => 'どんな言語でも書ける';

  @override
  String get onboardingFeature1Desc => '日本語、韓国語、英語で自由に表現しましょう';

  @override
  String get onboardingFeature2Title => 'AI搭載フィードバック';

  @override
  String get onboardingFeature2Desc => '即座に添削を受けて、ミスから学びましょう';

  @override
  String get onboardingFeature3Title => '毎日の習慣を作る';

  @override
  String get onboardingFeature3Desc => '連続記録を追跡し、目標を維持しましょう';

  @override
  String get loginRequired => 'ログインが必要です';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String errorWithMessage(String message) {
    return 'エラー: $message';
  }

  @override
  String get modelDownloadComplete => 'モデルのダウンロード完了';

  @override
  String downloadFailed(String error) {
    return 'ダウンロード失敗: $error';
  }

  @override
  String get deleteModel => 'モデルを削除';

  @override
  String get deleteModelConfirm => 'ダウンロードしたモデルを削除しますか？\n(1.1GB解放)';

  @override
  String get modelDeleted => 'モデル削除完了';

  @override
  String get aiModel => 'AIモデル';

  @override
  String get vocabulary => '単語帳';

  @override
  String get debugInfo => 'デバッグ情報';

  @override
  String get initializationStatus => '初期化状態';

  @override
  String get cacheSize => 'キャッシュサイズ';

  @override
  String get cacheHitRate => 'キャッシュヒット率';

  @override
  String get systemInfo => 'システム情報';

  @override
  String get clearCache => 'キャッシュをクリア';

  @override
  String get cacheCleared => 'キャッシュをクリアしました';

  @override
  String addAllWords(int count) {
    return 'すべての単語を追加 ($count個)';
  }

  @override
  String get refresh => '更新';

  @override
  String get loadingData => 'データ読み込み中...';

  @override
  String wordAdded(String word) {
    return '$wordを単語帳に追加しました';
  }

  @override
  String get noGrammarData => 'まだ文法データがありません。\n日記を書いてAI分析を受けてみましょう！';

  @override
  String repeatCount(int count) {
    return '$count回繰り返し';
  }

  @override
  String get grammarErrorEntries => '文法エラー日記';

  @override
  String get entriesWithGrammar => 'この文法を含む日記';

  @override
  String get noEntriesWithGrammar => 'この文法を含む日記がありません';

  @override
  String get generatingNewSuggestion => '新しい提案を生成中...';

  @override
  String get viewAllWords => 'すべての単語を見る';

  @override
  String get viewDebugInfo => '🐛 デバッグ情報を見る';

  @override
  String get status => 'ステータス';

  @override
  String get onDeviceAI => 'オンデバイスAI';

  @override
  String modelDownloaded(String size) {
    return 'ダウンロード完了 ($size MB)';
  }

  @override
  String get modelNotDownloaded => 'ダウンロード必要 (~1.1 GB)';

  @override
  String get modelDownloadDescription => 'モデルをダウンロードすると、オフラインでも単語提案を使用できます。';

  @override
  String get reviewStart => '復習開始';

  @override
  String get reviewComplete => '復習完了';

  @override
  String get allReviewsComplete => 'すべての復習が完了しました！';

  @override
  String get goBack => '戻る';

  @override
  String reviewProgress(int current, int total) {
    return '復習 ($current/$total)';
  }

  @override
  String get tapToShowAnswer => 'タップして答えを表示';

  @override
  String get howWellRemember => 'この単語をどれくらい覚えていましたか？';

  @override
  String get ratingAgain => 'もう一度';

  @override
  String get ratingHard => '難しい';

  @override
  String get ratingGood => '良い';

  @override
  String get ratingEasy => '簡単';

  @override
  String get korean => '韓国語';

  @override
  String get learningProgress => '学習状況';

  @override
  String get dueForReview => '復習予定';

  @override
  String get todayCompleted => '今日完了';

  @override
  String get newCards => '新しいカード';

  @override
  String get learning => '学習中';

  @override
  String get totalWords => '総単語数';

  @override
  String get close => '閉じる';

  @override
  String get addWord => '単語を追加';

  @override
  String get word => '単語';

  @override
  String get meaning => '意味';

  @override
  String get enterWordAndMeaning => '単語と意味を入力してください';

  @override
  String get add => '追加';

  @override
  String get all => 'すべて';

  @override
  String get reviewing => '復習中';

  @override
  String noCardsInCategory(String category) {
    return '$categoryカードがありません';
  }

  @override
  String get newCard => '新しいカード';

  @override
  String get problemCard => '問題カード';

  @override
  String get next => '次';

  @override
  String get now => '今';

  @override
  String daysLater(int days) {
    return '$days日後';
  }

  @override
  String hoursLater(int hours) {
    return '$hours時間後';
  }

  @override
  String minutesLater(int minutes) {
    return '$minutes分後';
  }

  @override
  String get soon => 'もうすぐ';

  @override
  String get aiReview => 'AIレビュー';

  @override
  String get aiAnalysisTakingLong => 'AI分析が予想より長くかかっています';

  @override
  String get checkFirebaseLogs => 'Firebase Functionsログを確認するか\n後でもう一度お試しください';

  @override
  String aiAnalysisInProgress(int seconds) {
    return 'AI分析中... ($seconds秒)';
  }

  @override
  String get noVocabularyFound => '抽出された単語がありません';

  @override
  String wordsAddedAndSkipped(int added, int skipped) {
    return '$added個追加、$skipped個すでに存在';
  }

  @override
  String wordsAddedCount(int count) {
    return '$count個の単語が追加されました';
  }

  @override
  String get allWordsAlreadyExist => 'すべての単語がすでに単語帳にあります';

  @override
  String get addToVocabulary => '単語帳に追加';

  @override
  String get wordAlreadyExists => 'すでに単語帳にある単語です';

  @override
  String get generatingSuggestions => '新しい提案を生成しています...';

  @override
  String get originalVsCorrected => '原文 vs 訂正文';

  @override
  String get scores => 'スコア';

  @override
  String get casualExpression => 'カジュアルな表現';

  @override
  String get formalExpression => 'フォーマルな表現';

  @override
  String get searchUnknownWords => 'わからない単語を検索...';
}

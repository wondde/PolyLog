import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polylog/features/auth/data/auth_repository.dart';
import 'package:polylog/features/diary/data/diary_repository.dart';
import 'package:polylog/features/diary/domain/models.dart';
import 'package:polylog/features/vocabulary/data/vocabulary_repository.dart';
import 'package:polylog/features/vocabulary/domain/models.dart';
import 'package:polylog/features/vocabulary/controllers/vocabulary_controller.dart';
import 'package:polylog/features/translation/data/mlkit_translation_repository.dart';

// Core
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // This will be overridden in main.dart
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier([String? initialLangCode])
      : super(Locale(initialLangCode ?? 'en'));

  void changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    state = Locale(languageCode);
  }
}

// Firebase
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Diary Repository Provider
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});

/// 현재 사용자 Provider (Firebase Auth)
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// 현재 사용자 문서 Provider (Firestore)
final currentUserDocProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return authRepository.userDocumentStream(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// 사용자 일기 목록 Provider
final userEntriesProvider =
    StreamProvider.family<List<EntryModel>, String>((ref, uid) {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return diaryRepository.getUserEntries(uid);
});

/// AI 분석 결과 Provider
final entryAIProvider =
    StreamProvider.family<EntryAIModel?, String>((ref, entryId) {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return diaryRepository.watchAI(entryId);
});

/// 주간 학습량 통계 Provider
final FutureProviderFamily<Map<DateTime, int>, String> weeklyStatsProvider =
    FutureProvider.family<Map<DateTime, int>, String>((ref, uid) async {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return await diaryRepository.getWeeklyStats(uid);
});

/// 자주 등장하는 문법 오류 Provider
final FutureProviderFamily<List<Map<String, dynamic>>, String>
    topGrammarErrorsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, uid) async {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return await diaryRepository.getTopGrammarErrors(uid);
});

/// 최근 학습한 단어 Provider
final FutureProviderFamily<List<VocabItem>, String> recentVocabularyProvider =
    FutureProvider.family<List<VocabItem>, String>((ref, uid) async {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return await diaryRepository.getRecentVocabulary(uid, limit: 10);
});

/// 특정 언어로 최근 학습한 단어 Provider
final FutureProviderFamily<List<VocabItem>, ({String uid, String lang})>
    recentVocabularyByLangProvider =
    FutureProvider.family<List<VocabItem>, ({String uid, String lang})>(
        (ref, params) async {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return await diaryRepository
      .getRecentVocabularyByLang(params.uid, params.lang, limit: 8);
});

// Vocabulary

/// Vocabulary Repository Provider
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository();
});

/// Vocabulary Controller Provider
final vocabularyControllerProvider =
    AsyncNotifierProvider<VocabularyController, List<VocabularyCard>>(
  VocabularyController.new,
);

/// 사용자의 모든 단어 카드 Provider
final userVocabularyCardsProvider =
    StreamProvider.family<List<VocabularyCard>, String>((ref, uid) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return repository.watchUserCards(uid);
});

/// 복습 예정 카드 Provider
final dueCardsProvider =
    StreamProvider.family<List<VocabularyCard>, String>((ref, uid) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return repository.watchDueCards(uid);
});

/// 새 카드 Provider
final newCardsProvider =
    StreamProvider.family<List<VocabularyCard>, String>((ref, uid) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return repository.watchNewCards(uid);
});

/// 학습 중 카드 Provider
final learningCardsProvider =
    StreamProvider.family<List<VocabularyCard>, String>((ref, uid) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return repository.watchLearningCards(uid);
});

/// 특정 언어의 카드 Provider
final StreamProviderFamily<List<VocabularyCard>, ({String uid, String lang})>
    cardsByLangProvider =
    StreamProvider.family<List<VocabularyCard>, ({String uid, String lang})>(
        (ref, params) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return repository.watchCardsByLang(params.uid, params.lang);
});

/// 오늘 복습한 카드 수 Provider
final FutureProviderFamily<int, String> todayReviewCountProvider =
    FutureProvider.family<int, String>((ref, uid) async {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return await repository.getTodayReviewCount(uid);
});

/// 총 카드 수 Provider
final FutureProviderFamily<int, String> totalCardCountProvider =
    FutureProvider.family<int, String>((ref, uid) async {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return await repository.getTotalCardCount(uid);
});

/// 상태별 카드 수 Provider
final FutureProviderFamily<Map<String, int>, String> cardCountByStateProvider =
    FutureProvider.family<Map<String, int>, String>((ref, uid) async {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return await repository.getCardCountByState(uid);
});

// Suggestions

/// Firebase ML Kit 번역 Repository Provider
final translationRepositoryProvider =
    Provider<MLKitTranslationRepository>((ref) {
  return MLKitTranslationRepository();
});

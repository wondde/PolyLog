import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/presentation/onboarding_page.dart';
import 'features/auth/presentation/onboarding_setup_page.dart';
import 'features/diary/presentation/home_page.dart';
import 'features/diary/presentation/editor_page.dart';
import 'features/diary/presentation/ai_review_page.dart';
import 'features/diary/presentation/records_page.dart';
import 'features/diary/presentation/dashboard_page.dart';
import 'features/diary/presentation/settings_page.dart';
import 'features/diary/presentation/streak_page.dart';
import 'features/diary/presentation/main_scaffold.dart';
import 'features/vocabulary/presentation/vocabulary_page.dart';
import 'features/vocabulary/presentation/review_page.dart';
import 'features/diary/presentation/grammar_errors_page.dart';
import 'features/diary/presentation/vocabulary_list_page.dart';

/// 앱 라우터 설정
const Set<String> _onboardingPaths = {
  '/',
  '/setup',
};

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isOnboarding = _onboardingPaths.contains(state.matchedLocation);

    // 로그인된 사용자가 온보딩 페이지에 접근하면 홈으로 리다이렉트
    if (user != null && isOnboarding) {
      return '/home';
    }

    return null; // 리다이렉트 없음
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) => const OnboardingSetupPage(),
    ),
    GoRoute(
      path: '/review/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AIReviewPage(entryId: id);
      },
    ),
    GoRoute(
      path: '/streak',
      builder: (context, state) => const StreakPage(),
    ),
    GoRoute(
      path: '/vocabulary/review',
      builder: (context, state) => const ReviewPage(),
    ),
    GoRoute(
      path: '/grammar-errors',
      builder: (context, state) => const GrammarErrorsPage(),
    ),
    GoRoute(
      path: '/grammar-error-entries',
      builder: (context, state) {
        final grammarNote = state.extra as String;
        return GrammarErrorEntriesPage(grammarNote: grammarNote);
      },
    ),
    GoRoute(
      path: '/vocabulary-list',
      builder: (context, state) => const VocabularyListPage(),
    ),
    GoRoute(
      path: '/editor',
      pageBuilder: (context, state) {
        String? initialText;
        String? suggestionTopic;
        if (state.extra is Map<String, String>) {
          final extra = state.extra as Map<String, String>;
          initialText = extra['text'];
          suggestionTopic = extra['topic'];
        } else if (state.extra is String) {
          initialText = state.extra as String;
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditorPage(
            initialText: initialText,
            suggestionTopic: suggestionTopic,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // 에디터 진입: 우 -> 좌, 뒤로가기: 좌 -> 우로 자연스럽게 이동
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
    // Main application shell with platform-specific navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/home', builder: (context, state) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/vocabulary',
                builder: (context, state) => const VocabularyPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/records',
                builder: (context, state) => const RecordsPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage()),
          ],
        ),
      ],
    ),
  ],
);

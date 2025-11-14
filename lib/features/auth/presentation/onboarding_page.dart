import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers.dart';
import '../../../core/utils/language_support.dart';
import 'unlogged_content.dart';
import 'logged_in_view.dart';

/// Onboarding 화면
class OnboardingPage extends ConsumerWidget {
  /// [OnboardingPage] 생성자
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: const _OnboardingContent(),
          ),
        ),
      ),
    );
  }
}

/// Onboarding 화면 컨텐츠
class _OnboardingContent extends ConsumerWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // 로그인된 사용자는 바로 리다이렉트
          return const Center(child: LoggedInView());
        }
        // 비로그인 사용자만 온보딩 UI 표시
        return const UnloggedContent();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

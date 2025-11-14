import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/providers.dart';

/// 로그인된 사용자 뷰
class LoggedInView extends ConsumerWidget {
  const LoggedInView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);
    final authState = ref.watch(authStateProvider);

    authState.whenData((user) {
      if (user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final userDoc = await authRepo.getUserDocument(user.uid);
          if (context.mounted) {
            // 학습 언어가 설정되지 않았으면 설정 페이지로
            if (userDoc?.learnLangs.isEmpty ?? true) {
              context.go('/setup');
            } else {
              context.go('/home');
            }
          }
        });
      }
    });

    return const CircularProgressIndicator();
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/core/utils/language_support.dart';
import 'package:polylog/l10n/app_localizations.dart';
import 'package:polylog/providers.dart';

/// 비로그인 사용자용 온보딩 컨텐츠
class UnloggedContent extends ConsumerWidget {
  /// [UnloggedContent] 생성자
  const UnloggedContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        // Logo & Title
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'PolyLog',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.onboardingSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 56),

        // Feature highlights
        _FeatureCard(
          icon: Icons.translate_rounded,
          title: l10n.onboardingFeature1Title,
          description: l10n.onboardingFeature1Desc,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.auto_fix_high_rounded,
          title: l10n.onboardingFeature2Title,
          description: l10n.onboardingFeature2Desc,
          color: const Color(0xFFEC4899),
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.emoji_events_rounded,
          title: l10n.onboardingFeature3Title,
          description: l10n.onboardingFeature3Desc,
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 48),

        // Language selection
        Text(
          l10n.selectUILanguage,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentLocale.languageCode,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              borderRadius: BorderRadius.circular(16),
              dropdownColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              items: languagePickerOrder.map((code) {
                final label = localizedLanguageLabel(code, l10n);
                final flag = languageFlag(code);
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    children: [
                      Text(
                        flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(localeProvider.notifier).changeLocale(newValue);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Google 로그인 버튼
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () async {
              final authRepo = ref.read(authRepositoryProvider);
              try {
                final user = await authRepo.signInWithGoogle();
                if (user != null && context.mounted) {
                  // 로그인 성공 후 사용자 문서 확인
                  final userDoc = await authRepo.getUserDocument(user.uid);
                  if (context.mounted) {
                    // 학습 언어가 설정되지 않았으면 설정 페이지로
                    if (userDoc?.learnLangs.isEmpty ?? true) {
                      context.go('/setup');
                    } else {
                      context.go('/home');
                    }
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.login_rounded, size: 22),
            label: Text(
              l10n.signInWithGoogle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}

/// 기능 소개 카드
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

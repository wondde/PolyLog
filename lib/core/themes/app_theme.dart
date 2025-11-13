import 'package:flutter/material.dart';

/// 앱 테마 정의
class AppTheme {
  AppTheme._();

  /// 라이트 테마
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5B8DEF), // 부드러운 블루 (채도 낮춤)
          primaryContainer: Color(0xFFE3F0FF), // 연한 블루 컨테이너
          surface: Color(0xFFFFFFFF),
          surfaceContainerHighest: Color(0xFFF8FAFC), // neutral50
          error: Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSurface: Color(0xFF0F172A), // neutral900
          onSurfaceVariant: Color(0xFF64748B), // 더 부드러운 회색
          outline: Color(0xFFE5E7EB), // border
        ),
        dividerColor: const Color(0xFFE5E7EB),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),

        // Typography - 미니멀 프로 스케일
        textTheme: const TextTheme(
          // H1 24/32 semibold
          headlineMedium: TextStyle(
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          // H2 18/28 semibold
          titleLarge: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          // Title 20/28 semibold (섹션)
          titleMedium: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          // Body 14/22 regular
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 22 / 14,
            color: Color(0xFF64748B), // 더 부드러운 회색
          ),
          // Body Large 16/24 regular
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 24 / 16,
            color: Color(0xFF64748B),
          ),
          // Caption 12/18 medium
          bodySmall: TextStyle(
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),

        // AppBar - flat, minimal
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF0F172A),
          scrolledUnderElevation: 1,
        ),

        // Cards - radius 12, border
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          color: Colors.white,
        ),

        // Chips - outline style
        chipTheme: ChipThemeData(
          backgroundColor: Colors.transparent,
          selectedColor: const Color(0xFFDCEAFE), // primary-50
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // Input - minimal
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFF5B8DEF), width: 2), // 부드러운 블루
          ),
          filled: true,
          fillColor: Colors.white,
        ),

        // Floating Action Button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 55, 111, 224), // 부드러운 블루
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      );

  /// 다크 테마
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6B9EF5), // 부드러운 블루 (채도 낮춤)
          primaryContainer: Color(0xFF1E3A5F), // 어두운 블루 컨테이너
          surface: Color(0xFF1F2937),
          surfaceContainerHighest: Color(0xFF374151),
          error: Color(0xFFF87171),
          onPrimary: Color(0xFF0F172A), // 더 어두운 텍스트
          onSurface: Color(0xFFE5E7EB), // 덜 밝은 텍스트
          onSurfaceVariant: Color(0xFFB3B8C2), // 더 부드러운 회색
          outline: Color(0xFF4B5563),
        ),
        dividerColor: const Color(0xFF4B5563),
        scaffoldBackgroundColor: const Color(0xFF0F172A),

        // Typography
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE5E7EB), // 더 부드러운 텍스트
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE5E7EB),
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE5E7EB),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 22 / 14,
            color: Color(0xFFB3B8C2), // 더 부드러운 회색
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 24 / 16,
            color: Color(0xFFB3B8C2),
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
          ),
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Color(0xFFE5E7EB), // 더 부드러운 텍스트
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF4B5563),
              width: 1,
            ),
          ),
          color: const Color(0xFF1F2937),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: Colors.transparent,
          selectedColor: const Color(0xFF1E40AF),
          side: const BorderSide(color: Color(0xFF4B5563)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4B5563)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4B5563)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFF6B9EF5), width: 2), // 부드러운 블루
          ),
          filled: true,
          fillColor: const Color(0xFF1F2937),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 55, 111, 224), // 부드러운 블루
          foregroundColor: Color(0xFF0F172A),
          elevation: 2,
        ),
      );
}

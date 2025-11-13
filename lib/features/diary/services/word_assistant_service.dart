import 'dart:convert';
import 'package:http/http.dart' as http;

/// Word Assistant API 서비스
class WordAssistantService {
  // TODO: 실제 배포 시 환경변수나 설정 파일로 관리
  final String baseUrl;

  WordAssistantService({
    this.baseUrl = 'http://localhost:3000', // 개발 환경
  });

  /// 단어 추천 요청
  ///
  /// [context]: 현재까지 작성된 텍스트 (마지막 문장 또는 일부)
  /// [language]: 언어 코드 (en, ko, ja)
  Future<List<String>> getSuggestions({
    required String context,
    String? language,
  }) async {
    try {
      // 입력 검증
      if (context.trim().isEmpty) {
        return [];
      }

      // 너무 짧은 경우 요청하지 않음 (비용 절감)
      if (context.trim().length < 3) {
        return [];
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/suggest'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'context': context,
              if (language != null) 'language': language,
            }),
          )
          .timeout(const Duration(seconds: 3)); // 타임아웃 3초

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestions = (data['suggestions'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        return suggestions;
      } else {
        print('Word Assistant API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // 에러 발생 시 빈 배열 반환 (사용자에게 표시하지 않음)
      print('Word Assistant error: $e');
      return [];
    }
  }

  /// 마지막 문장 또는 일부 추출
  ///
  /// 전체 텍스트에서 마지막 50자만 추출하여 API에 전송
  /// (비용 절감 및 성능 최적화)
  String extractContext(String fullText, {int maxLength = 50}) {
    if (fullText.length <= maxLength) {
      return fullText;
    }

    // 마지막 maxLength 문자 추출
    final lastPart = fullText.substring(fullText.length - maxLength);

    // 가능하면 완전한 단어로 시작하도록 조정
    final firstSpace = lastPart.indexOf(' ');
    if (firstSpace > 0 && firstSpace < 10) {
      return lastPart.substring(firstSpace + 1);
    }

    return lastPart;
  }
}

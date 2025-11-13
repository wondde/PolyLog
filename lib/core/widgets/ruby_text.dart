import 'package:flutter/widgets.dart';

/// 일본어 루비 텍스트를 표시하는 위젯
///
/// 입력 규약: "今日は{図書館|としょかん}に行きました"
/// {한자|히라가나} 형식으로 루비를 지정
class RubyText extends StatelessWidget {
  /// 루비 텍스트를 포함한 문자열
  final String text;

  /// 텍스트 스타일
  final TextStyle? style;

  /// [RubyText] 생성자
  const RubyText(
    this.text, {
    super.key,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\{([^|}]+)\|([^}]+)\}');
    int last = 0;

    for (final match in regex.allMatches(text)) {
      // 루비 앞의 일반 텍스트
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }

      final base = match.group(1)!;
      final ruby = match.group(2)!;

      // 루비 텍스트를 위아래로 배치 (개선된 버전)
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          baseline: TextBaseline.alphabetic,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 메인 텍스트 (한자)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    base,
                    style: style ?? const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
                // 루비 텍스트 (히라가나) - 한자 위에 배치
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      ruby,
                      style: TextStyle(
                        fontSize: (style?.fontSize ?? 16) * 0.5, // 메인 텍스트의 50% 크기
                        color: const Color(0xFF64748B),
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      last = match.end;
    }

    // 마지막 일반 텍스트
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return RichText(
      text: TextSpan(
        style: style ?? const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 16,
          height: 1.8, // 루비를 위한 여유 공간
        ),
        children: spans,
      ),
    );
  }
}

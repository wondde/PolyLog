import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';

/// 두 텍스트의 차이를 시각적으로 표시하는 위젯
class DiffText extends StatelessWidget {
  /// 원본 텍스트
  final String before;

  /// 수정된 텍스트
  final String after;

  /// [DiffText] 생성자
  const DiffText({
    super.key,
    required this.before,
    required this.after,
  });

  @override
  Widget build(BuildContext context) {
    final dmp = DiffMatchPatch();
    final diffs = dmp.diff(before, after);
    final spans = <TextSpan>[];

    for (final diff in diffs) {
      switch (diff.operation) {
        case DIFF_DELETE:
          spans.add(
            TextSpan(
              text: diff.text,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.red,
                backgroundColor: Color(0xFFFFEBEE),
              ),
            ),
          );
          break;
        case DIFF_INSERT:
          spans.add(
            TextSpan(
              text: diff.text,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.green,
                backgroundColor: Color(0xFFE8F5E9),
              ),
            ),
          );
          break;
        default:
          spans.add(TextSpan(text: diff.text));
      }
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}

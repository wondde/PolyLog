import 'dart:collection';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// LRU 캐시 (Least Recently Used)
///
/// 단어 추천 결과를 메모리에 캐싱하여 빠른 응답 제공
class WordCache {
  final int maxSize;
  final LinkedHashMap<String, CacheEntry> _cache = LinkedHashMap();

  /// 생성자
  ///
  /// [maxSize]: 최대 캐시 크기 (기본: 100)
  WordCache({this.maxSize = 100});

  /// 캐시 키 생성 (context + language 해시)
  String _generateKey(String context, String language) {
    final normalized = '${context.trim().toLowerCase()}_$language';
    return md5.convert(utf8.encode(normalized)).toString();
  }

  /// 캐시에서 조회
  ///
  /// [context]: 입력 문맥
  /// [language]: 언어 코드
  /// 반환: 캐시된 추천 단어 목록 (없으면 null)
  List<String>? get(String context, String language) {
    final key = _generateKey(context, language);
    final entry = _cache.remove(key);

    if (entry == null) {
      return null;
    }

    // TTL 확인 (30분)
    final now = DateTime.now();
    if (now.difference(entry.timestamp).inMinutes > 30) {
      return null;
    }

    // LRU: 다시 마지막에 추가 (최근 사용)
    _cache[key] = entry;

    return entry.suggestions;
  }

  /// 캐시에 저장
  ///
  /// [context]: 입력 문맥
  /// [language]: 언어 코드
  /// [suggestions]: 추천 단어 목록
  void put(String context, String language, List<String> suggestions) {
    final key = _generateKey(context, language);

    // 크기 제한 확인
    if (_cache.length >= maxSize) {
      // 가장 오래된 항목 제거 (첫 번째)
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = CacheEntry(
      suggestions: suggestions,
      timestamp: DateTime.now(),
    );
  }

  /// 캐시 클리어
  void clear() {
    _cache.clear();
  }

  /// 캐시 크기 조회
  int get size => _cache.length;

  /// 캐시 적중률 계산 (디버깅용)
  double get hitRate {
    if (_totalRequests == 0) return 0.0;
    return _cacheHits / _totalRequests;
  }

  int _cacheHits = 0;
  int _totalRequests = 0;
}

/// 캐시 항목
class CacheEntry {
  /// 추천 단어 목록
  final List<String> suggestions;

  /// 캐시된 시간
  final DateTime timestamp;

  /// 생성자
  CacheEntry({
    required this.suggestions,
    required this.timestamp,
  });
}

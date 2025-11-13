#!/bin/bash

# Android SHA-1 인증서 지문 확인 스크립트
# 사용법: ./scripts/get_android_sha1.sh

echo "=========================================="
echo "Android SHA-1 인증서 지문 확인"
echo "=========================================="
echo ""

# Debug keystore 위치
DEBUG_KEYSTORE="$HOME/.android/debug.keystore"

if [ ! -f "$DEBUG_KEYSTORE" ]; then
    echo "❌ Debug keystore를 찾을 수 없습니다: $DEBUG_KEYSTORE"
    echo ""
    echo "해결 방법:"
    echo "1. Android Studio 또는 Android SDK가 설치되어 있는지 확인하세요"
    echo "2. Flutter 프로젝트를 한 번 실행하면 자동으로 생성됩니다:"
    echo "   flutter run"
    exit 1
fi

echo "✅ Debug keystore 발견: $DEBUG_KEYSTORE"
echo ""
echo "SHA-1 인증서 지문:"
echo "=========================================="

# SHA-1 추출
keytool -list -v -keystore "$DEBUG_KEYSTORE" -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep "SHA1:" || {
    echo "❌ SHA-1 추출 실패"
    echo "keytool이 설치되어 있는지 확인하세요 (Java JDK 필요)"
    exit 1
}

echo "=========================================="
echo ""
echo "📋 다음 단계:"
echo "1. 위의 SHA1 값을 복사하세요"
echo "2. Firebase Console (https://console.firebase.google.com) 접속"
echo "3. 프로젝트 설정 > Android 앱 선택"
echo "4. 'SHA 인증서 지문' 섹션에서 '인증서 지문 추가' 클릭"
echo "5. SHA-1 값 붙여넣고 저장"
echo "6. google-services.json 다시 다운로드"
echo ""

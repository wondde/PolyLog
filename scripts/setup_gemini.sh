#!/bin/bash

# Gemini API 키 설정 스크립트
# 사용법: ./scripts/setup_gemini.sh

set -e  # 에러 발생 시 스크립트 중단

echo "=========================================="
echo "Gemini API 키 설정 스크립트"
echo "=========================================="
echo ""

# Firebase CLI 확인
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI가 설치되어 있지 않습니다."
    echo ""
    echo "설치 방법:"
    echo "  npm install -g firebase-tools"
    echo ""
    exit 1
fi

echo "✅ Firebase CLI 발견"
echo ""

# Firebase 로그인 확인
echo "Firebase 로그인 상태 확인 중..."
if ! firebase projects:list &> /dev/null; then
    echo "❌ Firebase에 로그인되어 있지 않습니다."
    echo ""
    echo "Firebase 로그인을 진행합니다..."
    firebase login
fi

echo "✅ Firebase 로그인 완료"
echo ""

# API 키 입력 받기
echo "Gemini API 키를 입력하세요:"
echo "(Google AI Studio에서 발급받은 키: https://makersuite.google.com/app/apikey)"
echo ""
read -r -p "API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo "❌ API 키가 입력되지 않았습니다."
    exit 1
fi

echo ""
echo "API 키 검증 중..."

# 간단한 키 포맷 검증 (AIza로 시작하는지)
if [[ ! "$API_KEY" =~ ^AIza ]]; then
    echo "⚠️  경고: API 키가 올바른 형식이 아닐 수 있습니다."
    echo "일반적으로 Gemini API 키는 'AIza'로 시작합니다."
    echo ""
    read -r -p "계속 진행하시겠습니까? (y/N): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        echo "취소되었습니다."
        exit 0
    fi
fi

echo ""
echo "Firebase Functions에 API 키 설정 중..."

# Firebase Functions에 API 키 설정
firebase functions:config:set gemini.api_key="$API_KEY"

echo "✅ API 키 설정 완료"
echo ""

# 설정 확인
echo "설정된 API 키 확인:"
firebase functions:config:get gemini

echo ""
echo "=========================================="
echo "다음 단계"
echo "=========================================="
echo ""
echo "1. Functions 의존성 설치 및 빌드:"
echo "   cd functions"
echo "   npm install"
echo "   npm run build"
echo "   cd .."
echo ""
echo "2. Firebase Functions 배포:"
echo "   firebase deploy --only functions"
echo ""
echo "3. Flutter 앱에서 테스트:"
echo "   fvm flutter run"
echo "   일기를 작성하고 AI 분석이 작동하는지 확인"
echo ""
echo "=========================================="
echo ""

read -r -p "지금 Functions를 배포하시겠습니까? (y/N): " DEPLOY_NOW

if [[ "$DEPLOY_NOW" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Functions 의존성 설치 중..."
    cd functions

    if [ ! -d "node_modules" ]; then
        npm install
    fi

    echo ""
    echo "TypeScript 빌드 중..."
    npm run build

    cd ..

    echo ""
    echo "Firebase Functions 배포 중..."
    firebase deploy --only functions

    echo ""
    echo "✅ 배포 완료!"
else
    echo ""
    echo "나중에 배포하려면 다음 명령어를 실행하세요:"
    echo "  cd functions && npm install && npm run build && cd .."
    echo "  firebase deploy --only functions"
fi

echo ""
echo "✨ 설정이 완료되었습니다!"

# PolyLog - 설정 가이드

## 목차
1. [iOS 설정](#ios-설정)
2. [Android 설정](#android-설정)
3. [Firebase 설정](#firebase-설정)
4. [Google Sign-In 설정](#google-sign-in-설정)
5. [문제 해결](#문제-해결)

---

## iOS 설정

### 1. CocoaPods 설치 및 업데이트

```bash
cd ios
pod install
cd ..
```

### 2. Info.plist 확인

`ios/Runner/Info.plist` 파일이 다음 내용을 포함하는지 확인:
- ✅ CFBundleDisplayName: "PolyLog"
- ✅ CFBundleName: "PolyLog"

### 3. iOS 빌드 및 실행

```bash
# 시뮬레이터에서 실행
fvm flutter run -d "iPhone 16"

# 또는 특정 시뮬레이터 선택
fvm flutter devices
fvm flutter run -d <device-id>
```

### 일반적인 iOS 빌드 오류 해결

#### 오류: "Could not build the application for the simulator"

**해결 방법:**
```bash
# 1. Clean 실행
fvm flutter clean

# 2. Pods 재설치
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# 3. 패키지 재설치
fvm flutter pub get

# 4. 빌드 폴더 삭제
rm -rf build/
rm -rf ios/build/

# 5. 다시 실행
fvm flutter run
```

---

## Android 설정

### 1. Google Sign-In을 위한 SHA-1 설정

Android에서 Google 로그인이 작동하려면 **SHA-1 인증서 지문**을 Firebase Console에 등록해야 합니다.

#### SHA-1 키 확인 방법

**개발용 (Debug) SHA-1:**
```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

출력에서 `SHA1:` 로 시작하는 줄을 찾으세요:
```
Certificate fingerprints:
         SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
         SHA256: ...
```

#### Firebase Console에 SHA-1 등록

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택 (`exam-4516e`)
3. **프로젝트 설정** (톱니바퀴 아이콘) 클릭
4. **내 앱** 섹션에서 Android 앱 선택
5. **SHA 인증서 지문** 섹션에서 **인증서 지문 추가** 클릭
6. 위에서 확인한 SHA-1 값 붙여넣기
7. **저장** 클릭

#### google-services.json 다시 다운로드

SHA-1을 등록한 후:
1. Firebase Console에서 `google-services.json` 다시 다운로드
2. `android/app/google-services.json` 파일 교체
3. 앱 재실행

### 2. AndroidManifest.xml 확인

`android/app/src/main/AndroidManifest.xml` 파일에 인터넷 권한이 있는지 확인:

```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET"/>
    ...
</manifest>
```

### 3. Android 빌드 및 실행

```bash
# USB 연결된 기기 또는 에뮬레이터에서 실행
fvm flutter run

# 특정 기기 선택
fvm flutter devices
fvm flutter run -d <device-id>
```

---

## Firebase 설정

### 1. Firebase 프로젝트 확인

현재 프로젝트는 `exam-4516e` Firebase 프로젝트에 연결되어 있습니다.

### 2. Firebase Console에서 Google Sign-In 활성화

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. **Authentication** > **Sign-in method** 클릭
4. **Google** 제공업체 활성화
5. **프로젝트 지원 이메일** 설정
6. **저장** 클릭

### 3. Firebase Functions 배포 (선택사항)

AI 분석 기능을 사용하려면 Functions를 배포해야 합니다:

```bash
# Firebase CLI 설치 (한 번만)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# Functions 의존성 설치
cd functions
npm install

# TypeScript 빌드
npm run build

# Functions 배포
cd ..
firebase deploy --only functions
```

### 4. Gemini API 키 설정

Functions에서 Gemini AI를 사용하려면:

```bash
# Gemini API 키 설정
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"

# 설정 확인
firebase functions:config:get
```

**Gemini API 키 발급:**
1. [Google AI Studio](https://makersuite.google.com/app/apikey) 접속
2. **API 키 만들기** 클릭
3. 키 복사 후 위 명령어로 설정

---

## Google Sign-In 설정

### iOS Google Sign-In 설정

Google Sign-In iOS SDK는 자동으로 설정됩니다. 추가 설정 불필요.

### Android Google Sign-In 설정

**중요:** Android에서 Google 로그인이 작동하려면 **SHA-1 인증서 지문**을 반드시 등록해야 합니다.

위의 [Android 설정 > SHA-1 설정](#1-google-sign-in을-위한-sha-1-설정) 섹션을 참고하세요.

### Web OAuth Client ID (선택사항)

웹 플랫폼을 지원하려면:

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. **API 및 서비스** > **사용자 인증 정보**
3. **OAuth 2.0 클라이언트 ID** 생성 (웹 애플리케이션)
4. 승인된 리디렉션 URI 추가:
   - `http://localhost:XXXX` (개발용)
   - `https://exam-4516e.firebaseapp.com/__/auth/handler` (배포용)

---

## 문제 해결

### 문제 1: iOS - "Could not build the application for the simulator"

**원인:** Pods 캐시 문제 또는 빌드 캐시 충돌

**해결:**
```bash
fvm flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
fvm flutter pub get
fvm flutter run
```

### 문제 2: Android - Google 로그인 후 "Sign in failed" 또는 앱이 멈춤

**원인:** SHA-1 인증서 지문이 Firebase Console에 등록되지 않음

**해결:**
1. SHA-1 키 확인:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. Firebase Console에서 SHA-1 등록
3. `google-services.json` 다시 다운로드
4. 앱 재실행

### 문제 3: "PlatformException(sign_in_failed)"

**원인:**
- SHA-1 미등록
- 또는 Firebase Console에서 Google Sign-In 비활성화 상태

**해결:**
1. Firebase Console > Authentication > Sign-in method
2. Google 제공업체 **활성화** 확인
3. SHA-1 등록 확인
4. 앱 재실행

### 문제 4: iOS - Google Sign-In 팝업이 표시되지 않음

**원인:** iOS 시뮬레이터에서 Google 계정이 로그인되어 있지 않음

**해결:**
- iOS 시뮬레이터 **설정** > **Safari** > **개발자** 메뉴에서 쿠키 허용
- 또는 실제 iOS 기기에서 테스트

### 문제 5: Firebase 초기화 오류

**원인:** `firebase_options.dart` 파일 누락 또는 잘못된 설정

**해결:**
```bash
# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase 프로젝트 재설정
flutterfire configure
```

### 문제 6: Functions 배포 실패

**원인:** Node.js 버전 또는 TypeScript 빌드 오류

**해결:**
```bash
# Node.js 20 확인
node --version  # v20.x.x 이어야 함

# Functions 디렉토리에서
cd functions
rm -rf node_modules package-lock.json
npm install
npm run build
cd ..

# 재배포
firebase deploy --only functions
```

---

## 개발 체크리스트

### iOS 실행 전 체크리스트
- [ ] `fvm flutter pub get` 실행
- [ ] `cd ios && pod install` 실행
- [ ] Info.plist 확인
- [ ] Xcode에서 시뮬레이터 선택 확인

### Android 실행 전 체크리스트
- [ ] SHA-1 키 Firebase Console에 등록
- [ ] `google-services.json` 최신 버전 확인
- [ ] Firebase Authentication에서 Google Sign-In 활성화
- [ ] Android 에뮬레이터 또는 실제 기기 준비

### Firebase Functions 배포 전 체크리스트
- [ ] `functions/` 디렉토리에서 `npm install` 실행
- [ ] `npm run build` 성공 확인
- [ ] Gemini API 키 설정 확인
- [ ] Firebase 프로젝트 결제 활성화 (Blaze 플랜)

---

## 유용한 명령어

```bash
# Flutter 버전 확인
fvm flutter --version

# Firebase 프로젝트 확인
firebase projects:list

# 연결된 기기 확인
fvm flutter devices

# 로그 확인 (Android)
fvm flutter logs

# iOS 시뮬레이터 목록
xcrun simctl list devices

# Android 에뮬레이터 목록
emulator -list-avds

# Firebase Functions 로그 확인
firebase functions:log
```

---

## 참고 자료

- [Firebase 문서](https://firebase.google.com/docs)
- [Flutter Firebase 플러그인](https://firebase.flutter.dev/)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Gemini AI Studio](https://ai.google.dev/)

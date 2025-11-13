# 문제 해결 가이드

이 문서는 PolyLog 앱 개발 중 자주 발생하는 문제와 해결 방법을 정리합니다.

## 목차
- [iOS 문제](#ios-문제)
- [Android 문제](#android-문제)
- [Firebase 문제](#firebase-문제)
- [Google Sign-In 문제](#google-sign-in-문제)

---

## iOS 문제

### 1. "Could not build the application for the simulator"

**증상:**
```
Error: Could not build the application for the simulator.
Error launching application on iPhone 16.
```

**원인:**
- Pods 캐시 문제
- 빌드 폴더 충돌
- CocoaPods 버전 불일치

**해결 방법:**

```bash
# 1단계: Flutter 클린
fvm flutter clean

# 2단계: iOS Pods 완전 삭제 및 재설치
cd ios
rm -rf Pods Podfile.lock .symlinks
pod deintegrate
pod install --repo-update
cd ..

# 3단계: 빌드 폴더 삭제
rm -rf build/
rm -rf ios/build/
rm -rf ios/.symlinks/

# 4단계: Flutter 패키지 재설치
fvm flutter pub get

# 5단계: 실행
fvm flutter run
```

**추가 해결 방법 (위 방법이 실패한 경우):**

```bash
# Xcode에서 Derived Data 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Xcode 캐시 삭제
rm -rf ~/Library/Caches/com.apple.dt.Xcode

# CocoaPods 캐시 삭제
pod cache clean --all

# 다시 시도
cd ios
pod install
cd ..
fvm flutter run
```

### 2. "Module 'firebase_core' not found"

**원인:** CocoaPods 통합 문제

**해결:**
```bash
cd ios
pod install --repo-update
cd ..
fvm flutter clean
fvm flutter run
```

### 3. iOS 시뮬레이터 목록이 안 보임

**해결:**
```bash
# 시뮬레이터 목록 확인
xcrun simctl list devices

# 시뮬레이터 리셋
xcrun simctl erase all

# Xcode 재시작
killall Xcode
open -a Xcode
```

---

## Android 문제

### 1. Google 로그인 후 앱이 멈추거나 "Sign in failed" 에러

**증상:**
- Google 로그인 버튼 클릭 시 계정 선택은 되지만 이후 앱으로 돌아오지 않음
- `PlatformException(sign_in_failed)` 에러 발생

**원인:** SHA-1 인증서 지문이 Firebase Console에 등록되지 않음

**해결 방법:**

#### 1단계: SHA-1 키 확인

**macOS/Linux:**
```bash
# 스크립트 사용 (권장)
./scripts/get_android_sha1.sh

# 또는 직접 실행
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
```

**Windows:**
```cmd
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android | findstr SHA1
```

출력 예시:
```
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
```

#### 2단계: Firebase Console에 SHA-1 등록

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택 (`exam-4516e`)
3. **설정** (톱니바퀴) > **프로젝트 설정** 클릭
4. **내 앱** 섹션에서 Android 앱 선택
5. 아래로 스크롤하여 **SHA 인증서 지문** 찾기
6. **인증서 지문 추가** 클릭
7. 위에서 확인한 SHA-1 값 붙여넣기
8. **저장** 클릭

#### 3단계: google-services.json 업데이트

1. Firebase Console에서 `google-services.json` 다시 다운로드
2. `android/app/google-services.json` 파일 교체
3. 앱 완전히 종료 후 재실행

```bash
# 앱 완전히 종료
fvm flutter clean

# 재설치 및 실행
fvm flutter pub get
fvm flutter run
```

### 2. "google-services.json is missing"

**해결:**
```bash
# Firebase Console에서 google-services.json 다운로드
# android/app/ 폴더에 배치

# 파일 위치 확인
ls -la android/app/google-services.json
```

### 3. Gradle 빌드 실패

**해결:**
```bash
# Gradle 캐시 삭제
cd android
./gradlew clean
cd ..

# 빌드 폴더 삭제
rm -rf build/
rm -rf android/build/
rm -rf android/app/build/

# 다시 실행
fvm flutter run
```

### 4. "Minimum SDK version" 에러

**해결:**

`android/app/build.gradle.kts` 파일 확인:
```kotlin
defaultConfig {
    minSdk = 23  // 최소 23 이상이어야 함
}
```

---

## Firebase 문제

### 1. "Firebase has not been initialized"

**원인:** `firebase_options.dart` 문제 또는 Firebase 초기화 코드 누락

**해결:**

1. `lib/firebase_options.dart` 파일 존재 확인
2. `main.dart`에서 Firebase 초기화 확인:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

3. FlutterFire CLI로 재설정:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 2. Firebase Authentication 에러

**증상:** "The API key is invalid" 또는 "Project not found"

**해결:**

1. Firebase Console에서 프로젝트 ID 확인
2. `firebase_options.dart`의 `projectId` 값이 일치하는지 확인
3. API Key가 제한되어 있다면 제한 해제 또는 앱 추가

---

## Google Sign-In 문제

### 1. iOS에서 Google 로그인 팝업이 나타나지 않음

**원인:**
- iOS 시뮬레이터에서 Safari 쿠키 차단
- 또는 네트워크 문제

**해결:**

**시뮬레이터 설정:**
1. iOS 시뮬레이터 **설정** 앱 열기
2. **Safari** > **개인정보 보호 및 보안**
3. "사이트 간 추적 방지" **끄기**
4. "모든 쿠키 차단" **끄기**

**또는 실제 기기에서 테스트:**
```bash
# 연결된 iOS 기기 확인
fvm flutter devices

# 기기에서 실행
fvm flutter run -d <device-id>
```

### 2. "The operation couldn't be completed" 에러 (iOS)

**해결:**
```bash
# Pods 재설치
cd ios
pod deintegrate
pod install
cd ..

# 앱 재실행
fvm flutter run
```

### 3. Android - "PlatformException(sign_in_failed)"

**원인:**
- SHA-1 미등록
- Firebase Authentication에서 Google Sign-In 비활성화

**해결:**

1. **SHA-1 확인 및 등록** (위의 Android 문제 섹션 참고)

2. **Firebase Console에서 Google Sign-In 활성화:**
   - Firebase Console > Authentication
   - Sign-in method 탭
   - Google 제공업체 **사용 설정**
   - 프로젝트 지원 이메일 입력
   - 저장

---

## 일반적인 문제

### 1. "Waiting for another flutter command to release the startup lock"

**해결:**
```bash
# Flutter 프로세스 강제 종료
killall -9 dart

# 또는 lock 파일 삭제
rm -rf /Users/$USER/.pub-cache/bin/cache/lockfile
```

### 2. 패키지 버전 충돌

**해결:**
```bash
# pubspec.yaml 확인 후
fvm flutter pub get

# 버전 충돌 시
fvm flutter pub upgrade --major-versions
```

### 3. Hot Reload가 작동하지 않음

**해결:**
- 앱 완전히 재시작 (Stop 후 다시 Run)
- Flutter 버전 확인: `fvm flutter --version`
- IDE 재시작

---

## 도움 받기

위의 방법으로 해결되지 않는 경우:

1. **로그 확인:**
   ```bash
   fvm flutter logs
   ```

2. **상세 로그:**
   ```bash
   fvm flutter run -v
   ```

3. **이슈 리포트:**
   - [GitHub Issues](https://github.com/yourusername/multilingual-diary/issues)
   - 에러 메시지 전체
   - OS 및 Flutter 버전
   - 재현 방법

---

## 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Firebase Flutter 플러그인](https://firebase.flutter.dev/)
- [Google Sign-In 문제 해결](https://pub.dev/packages/google_sign_in#troubleshooting)

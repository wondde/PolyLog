# PolyLog 🌍📝

일기를 통해 언어 실력을 자연스럽게 키우는 AI 기반 학습 앱

---

## 소개

**PolyLog**는 일기 작성을 통해 외국어 학습을 돕는 AI 기반 언어 학습 도우미입니다. 매일 일기를 작성하면서 실시간 AI 피드백을 받고, 문법 오류를 개선하며, 개인 맞춤 단어장을 구축할 수 있습니다.

### 주요 특징

- **AI 피드백**: Google Gemini API 기반 실시간 문법 및 표현 분석
- **개인 단어장**: 일기에서 모르는 단어를 자동 저장하고 복습
- **학습 대시보드**: 히트맵으로 학습 진행도 시각화
- **멀티 플랫폼**: iOS, Android, Web 지원
- **오프라인 번역**: Google ML Kit을 활용한 오프라인 단어 번역
- **연속 작성 추적**: 매일 작성 습관을 형성하도록 동기부여

---

## 기술 스택

### Frontend

- **Flutter 3.3+**: 크로스 플랫폼 UI 프레임워크
- **Hooks Riverpod 2.6**: 상태 관리
- **GoRouter 14.2**: 선언형 라우팅
- **Material 3**: 최신 디자인 시스템

### Backend & Services

- **Firebase Authentication**: Google Sign-In 기반 인증
- **Cloud Firestore**: 실시간 NoSQL 데이터베이스
- **Cloud Functions**: 서버리스 백엔드 (TypeScript)
- **Firebase Crashlytics**: 오류 추적 및 모니터링

### AI & ML

- **Google Gemini API**: AI 기반 문법 및 표현 피드백
- **Google ML Kit Translation**: 오프라인 단어 번역

---

## 프로젝트 구조

```
lib/
├── app_router.dart                    # GoRouter 라우팅 설정
├── core/
│   ├── themes/                        # 앱 테마 및 디자인 시스템
│   └── utils/                         # 공용 유틸리티
├── features/
│   ├── auth/                          # 인증 및 온보딩
│   │   ├── data/                      # AuthRepository
│   │   └── presentation/              # 온보딩 화면
│   ├── diary/                         # 일기 작성 및 관리
│   │   ├── data/                      # DiaryRepository
│   │   ├── domain/                    # 도메인 모델
│   │   ├── presentation/              # 화면 및 위젯
│   │   └── services/                  # 단어 도우미 서비스
│   ├── vocabulary/                    # 단어장 기능
│   │   ├── controllers/               # VocabularyController
│   │   ├── data/                      # VocabularyRepository
│   │   ├── domain/                    # 단어 모델
│   │   └── presentation/              # 단어장 화면
│   └── translation/                   # 번역 기능
│       ├── data/                      # ML Kit Repository
│       └── models/                    # 번역 결과 모델
├── l10n/                              # 국제화 리소스 (arb)
└── providers.dart                     # 전역 Riverpod Provider

functions/                             # Firebase Cloud Functions
├── src/
│   ├── analyzeDiary.ts                # AI 일기 분석
│   ├── analyzeEntry.ts                # 문법 분석
│   └── callGemini.ts                  # Gemini API 호출
└── index.ts

assets/
├── translations/                      # easy_localization 번역 파일
└── polylog1.jpg                       # 앱 아이콘 및 스플래시
```

---

## 시작하기

### 사전 요구사항

| 항목                  | 버전 / 내용                             |
| --------------------- | --------------------------------------- |
| Flutter SDK           | 3.3.0 이상                              |
| Dart SDK              | 3.3.0 이상                              |
| Firebase 프로젝트     | Firebase Console에서 생성               |
| Google Cloud 프로젝트 | Gemini API 활성화 필요                  |
| 개발 환경             | iOS: Xcode 14+, Android: Android Studio |

### 설치 및 설정

#### 1. 저장소 클론

```bash
git clone https://github.com/your-username/polylog.git
cd polylog
```

#### 2. Flutter 의존성 설치

```bash
flutter pub get
```

#### 3. Firebase 설정

**3.1 Firebase 프로젝트 생성**

- [Firebase Console](https://console.firebase.google.com)에서 새 프로젝트 생성
- Authentication, Firestore, Functions 활성화

**3.2 플랫폼별 설정 파일 다운로드**

- **Android**: `google-services.json` → `android/app/`
- **iOS**: `GoogleService-Info.plist` → `ios/Runner/`
- **Web**: Firebase 설정을 `web/index.html`에 추가

**3.3 Google Sign-In 설정**

각 플랫폼에 OAuth 클라이언트 ID 생성:

- Android: SHA-1 인증서 지문 등록
- iOS: Bundle ID 등록
- Web: OAuth 2.0 클라이언트 ID 생성

#### 4. 환경 변수 설정

**모바일 (Android/iOS)**

`env.yaml` 파일 생성 (root 디렉토리):

```yaml
GOOGLE_WEB_CLIENT_ID: your-client-id.apps.googleusercontent.com
```

**웹**

실행 시 `--dart-define` 사용:

```bash
flutter run -d chrome --dart-define=GOOGLE_WEB_CLIENT_ID=your-web-client-id
```

#### 5. Firebase Functions 배포

```bash
cd functions
npm install
npm run build

# Gemini API 키 설정
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"

# 배포
firebase deploy --only functions
```

---

## 실행

### 개발 모드

```bash
# iOS 시뮬레이터
flutter run -d "iPhone 16"

# Android 에뮬레이터
flutter run -d emulator-5554

# Chrome 웹
flutter run -d chrome --dart-define=GOOGLE_WEB_CLIENT_ID=your-client-id

# macOS 데스크톱
flutter run -d macos
```

### 릴리즈 빌드

```bash
# Android APK
flutter build apk --split-per-abi

# iOS IPA
flutter build ipa

# Web
flutter build web --release --dart-define=GOOGLE_WEB_CLIENT_ID=your-client-id
```

---

## 주요 기능

### 1. 일기 작성 및 AI 분석

- 실시간 AI 피드백으로 문법 및 표현 개선
- 문장별 수정 제안 및 설명
- 일기 저장 및 히스토리 관리

### 2. 개인 단어장

- 일기 작성 중 모르는 단어 저장
- 오프라인 번역 지원 (ML Kit)
- 단어 복습 및 학습 진행도 추적

### 3. 학습 대시보드

- 히트맵으로 학습 진행도 시각화
- 연속 작성 일수 추적
- 자주 틀리는 문법 포인트 분석
- 주간/월간 통계

### 4. 문법 오류 추적

- 반복되는 문법 오류 패턴 분석
- 오류별 일기 항목 연결
- 개선 제안 및 학습 자료 제공

---

## 테스트

```bash
# 모든 테스트 실행
flutter test

# 커버리지 포함
flutter test --coverage

# 특정 테스트 파일
flutter test test/features/diary/diary_repository_test.dart

# Lint 검사
flutter analyze
```

---

## 배포

### Firebase Hosting (웹)

```bash
# 웹 빌드
flutter build web --release --dart-define=GOOGLE_WEB_CLIENT_ID=$GOOGLE_WEB_CLIENT_ID

# Firebase 배포
firebase deploy --only hosting
```

### App Store (iOS)

1. Xcode에서 프로젝트 열기
2. Bundle Identifier 확인 (`com.example.polylog`)
3. Archive 생성
4. App Store Connect에 업로드

### Google Play Store (Android)

1. 키 스토어 생성 및 서명 설정
2. SHA-1/SHA-256 지문을 Firebase Console에 등록
3. AAB 또는 APK 빌드
4. Play Console에 업로드

---

## 아이콘 및 스플래시 스크린

### 아이콘 재생성

```bash
flutter pub run flutter_launcher_icons
```

설정: `pubspec.yaml`의 `flutter_launcher_icons` 섹션

### 스플래시 스크린 재생성

```bash
flutter pub run flutter_native_splash:create
```

설정: `pubspec.yaml`의 `flutter_native_splash` 섹션

---

## 다국어화

현재 지원 언어:

- 한국어 (ko)
- 영어 (en)
- 일본어 (ja)

번역 파일: `lib/l10n/app_{locale}.arb`

새 언어 추가:

1. `lib/l10n/app_새언어코드.arb` 생성
2. 번역 키 추가
3. `flutter gen-l10n` 실행

---

## 개발 명령어 요약

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 테스트
flutter test
flutter analyze

# 빌드
flutter build apk
flutter build ios
flutter build web

# Functions 로컬 테스트
cd functions && firebase emulators:start

# L10n 생성
flutter gen-l10n

# 아이콘 생성
flutter pub run flutter_launcher_icons
```

---

## 로드맵

- [ ] 음성 입력 기능
- [ ] AI 챗봇 대화 연습
- [ ] 커��니티 피드백 기능
- [ ] 주간 학습 리포트 이메일 발송
- [ ] 오프라인 모드 지원
- [ ] 다크 모드 개선
- [ ] 태블릿 최적화

---

## 트러블슈팅

### Google Sign-In 실패

- Firebase Console에서 SHA-1/SHA-256 지문 확인
- `google-services.json` 및 `GoogleService-Info.plist` 최신 버전 확인
- OAuth 클라이언트 ID가 올바른지 확인

### Functions 배포 실패

```bash
# Functions 로그 확인
firebase functions:log

# 로컬 에뮬레이터로 테스트
firebase emulators:start --only functions
```

### 빌드 오류

```bash
# 캐시 정리
flutter clean
flutter pub get

# iOS Pod 재설치
cd ios && pod install --repo-update
```

---

## 기여

이 프로젝트는 개인 학습 프로젝트이지만, 버그 리포트나 기능 제안은 언제나 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일 참조

---

## 문의

프로젝트 관련 문의: [이슈 트래커](https://github.com/your-username/polylog/issues)

---

**PolyLog**로 즐겁게 언어를 배워보세요! 🚀

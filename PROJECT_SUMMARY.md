# PolyLog MVP - 프로젝트 요약

## 개요

AI 기반 언어 학습을 위한 다국어 일기장 앱입니다. 사용자가 일기를 작성하면 AI가 문법 교정, 자연스러운 표현 제안, 어휘 학습을 제공합니다.

## 기술 스택

### Frontend (Flutter)
- **Flutter**: 3.35.6 (FVM 관리)
- **State Management**: Riverpod 3.0 (hooks_riverpod)
- **Routing**: GoRouter
- **Firebase**:
  - Firebase Core
  - Firebase Auth (Google Sign-in)
  - Cloud Firestore
  - Firebase App Check

### Backend (Firebase Functions)
- **Runtime**: Node.js 20
- **Language**: TypeScript (ES2022)
- **LLM Provider**: Gemini AI Studio
- **Functions**:
  - Entry 생성 시 AI 분석 트리거
  - 제안 생성
  - 공개 피드 게시
  - 사용량 제한 체크

### Database (Firestore)
- **Collections**:
  - `users/` - 사용자 프로필 및 설정
  - `entries/` - 일기 항목
  - `entry_ai/` - AI 분석 결과
  - `suggestions/` - 학습 제안
  - `public_feed/` - 공개 피드

## 주요 기능

### 1. 인증 (Authentication)
- Google 로그인/로그아웃
- 자동 사용자 문서 생성
- 사용자 프로필 관리

### 2. 일기 작성 (Diary Entry)
- 다국어 지원 (영어, 일본어, 한국어)
- 기분 선택 (Happy, Sad, Angry, Calm)
- 최대 600자 제한
- 공개/비공개 설정

### 3. AI 분석 (AI Review)
**교정 탭 (Corrections)**:
- 원본 vs 교정된 텍스트 diff 표시
- 유창성/정확성 점수
- 문법 노트

**자연스러운 표현 탭 (Natural)**:
- 캐주얼/격식 표현 제공
- 일본어는 후리가나 지원 (옵션)

**어휘 탭 (Vocab)**:
- 기본형, 품사, 의미
- 레벨 표시 (N5/N4/N3/N2/N1, A1/A2/B1/B2/C1/C2)
- 예문

### 4. 대시보드
- 연속 기록 일수 (Streak)
- 최근 일기 목록
- AI 처리 상태 표시

## 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점
├── app_router.dart                    # 라우팅 설정
├── providers.dart                     # Riverpod Providers
├── core/
│   ├── themes/
│   │   └── app_theme.dart            # Material 3 테마
│   ├── widgets/
│   │   ├── ruby_text.dart            # 일본어 루비 표시
│   │   └── diff_text.dart            # 텍스트 차이 표시
│   └── result.dart                    # Result 타입
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart   # 인증 Repository
│   │   └── presentation/
│   │       └── onboarding_page.dart   # 온보딩 화면
│   └── diary/
│       ├── data/
│       │   └── diary_repository.dart  # 일기 Repository
│       ├── domain/
│       │   └── models.dart            # 데이터 모델
│       └── presentation/
│           ├── home_page.dart         # 홈 화면
│           ├── editor_page.dart       # 에디터 화면
│           └── ai_review_page.dart    # AI 리뷰 화면
└── l10n/
    ├── app_en.arb                     # 영어 번역
    ├── app_ja.arb                     # 일본어 번역
    └── app_ko.arb                     # 한국어 번역

functions/
├── package.json
├── tsconfig.json
└── src/
    ├── index.ts                       # Functions 진입점
    ├── llm.ts                         # Gemini AI 통합
    └── prompts/
        ├── correct.ts                 # 교정 프롬프트
        ├── natural.ts                 # 자연화 프롬프트
        ├── vocab.ts                   # 어휘 프롬프트
        └── suggestions.ts             # 제안 프롬프트
```

## Firestore 데이터 모델

### users/{uid}
```typescript
{
  displayName: string
  region: 'kr' | 'jp' | 'en'
  nativeLang: 'ko' | 'ja' | 'en'
  learnLangs: ('ja' | 'en' | 'ko')[]
  level: { ja?: string, en?: string, ko?: string }
  prefs: {
    easyWords: boolean
    showFurigana: boolean
    mixedUI: boolean
  }
  createdAt: Timestamp
  streak: number
}
```

### entries/{entryId}
```typescript
{
  uid: string
  lang: 'ja' | 'en' | 'ko'
  textRaw: string
  mood?: 'happy' | 'sad' | 'angry' | 'calm'
  visibility: 'private' | 'anon'
  createdAt: Timestamp
  aiStatus: 'pending' | 'done' | 'error'
}
```

### entry_ai/{entryId}
```typescript
{
  corrected: string
  natural: { casual: string, formal: string }
  diffs: Array<{op: string, from?: string, to?: string}>
  highlights: string[]
  vocab: Array<{
    lemma: string
    pos: string
    meanings: string[]
    level?: string
    example: string
  }>
  grammarNotes: string[]
  score: { fluency: number, accuracy: number }
  rendering?: { jaFurigana?: boolean }
}
```

## 보안 규칙 (Security Rules)

- 사용자는 자신의 `users/{uid}` 문서만 읽기/쓰기 가능
- 일기는 작성자만 읽기/수정/삭제 가능
- AI 분석 결과는 읽기만 가능 (서버에서만 쓰기)
- 공개 피드는 모두 읽기 가능, 로그인 사용자만 생성 가능

## 제약 사항

- **일일 제한**: 사용자당 하루 20회 일기 작성
- **텍스트 길이**: 최대 600자
- **공개 피드**: 익명 공유만 가능
- **LLM 비용**: Gemini Flash 모델 사용 (비용 절감)

## 다음 단계

### MVP 완료 체크리스트
- [x] Google Auth 로그인/로그아웃
- [x] 일기 작성 및 저장
- [x] Firebase Functions AI 분석
- [x] AI 리뷰 3개 탭 (교정/자연화/어휘)
- [x] 홈 화면 및 대시보드
- [ ] Onboarding 설문 (언어 선택, 레벨 설정)
- [ ] Dashboard 통계 화면
- [ ] Public Feed 화면
- [ ] Suggestion Panel 구현

### 배포 전 작업
1. **Firebase 프로젝트 설정**:
   ```bash
   # Firebase CLI 설치
   npm install -g firebase-tools

   # Firebase 로그인
   firebase login

   # 프로젝트 초기화
   firebase init

   # Functions 의존성 설치
   cd functions
   npm install

   # 환경 변수 설정
   firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"
   ```

2. **Functions 배포**:
   ```bash
   cd functions
   npm run build
   firebase deploy --only functions,firestore:rules,firestore:indexes
   ```

3. **Flutter 앱 빌드**:
   ```bash
   # Android
   fvm flutter build apk --release

   # iOS
   fvm flutter build ios --release

   # Web
   fvm flutter build web --release
   ```

4. **환경 설정 파일**:
   - `.env` 파일 생성 (`.env.example` 참고)
   - Firebase 프로젝트 ID 설정
   - Gemini API 키 설정

## 개발 명령어

```bash
# 패키지 설치
fvm flutter pub get

# 앱 실행
fvm flutter run

# 분석
fvm flutter analyze

# 테스트
fvm flutter test

# Functions 로컬 테스트
cd functions
npm run serve

# Firebase Emulator 실행
firebase emulators:start
```

## 참고 사항

- **일본어 루비**: `{漢字|かな}` 형식 사용
- **Material 3**: `useMaterial3: true` 적용
- **Riverpod**: AsyncNotifierProvider 사용 (Riverpod 3.0)
- **상태 관리**: 동기는 NotifierProvider, 비동기는 AsyncNotifierProvider

## 라이선스

MIT License

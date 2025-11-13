# Gemini API 키 설정 가이드

Gemini API를 사용하여 AI 일기 분석 기능을 활성화하는 방법입니다.

## 1. Gemini API 키 받기 (완료 ✅)

이미 API 키를 받으셨다면 다음 단계로 진행하세요.

아직 받지 않으셨다면:
1. [Google AI Studio](https://makersuite.google.com/app/apikey) 접속
2. **API 키 만들기** 클릭
3. 생성된 키 복사

---

## 2. Firebase Functions에 API 키 등록

### 방법 A: Firebase CLI 사용 (권장)

터미널에서 다음 명령어를 실행하세요:

```bash
# Firebase 로그인 (처음 한 번만)
firebase login

# Gemini API 키 설정
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY_HERE"
```

**예시:**
```bash
firebase functions:config:set gemini.api_key="AIzaSyABC123..."
```

**설정 확인:**
```bash
firebase functions:config:get
```

출력 예시:
```json
{
  "gemini": {
    "api_key": "AIzaSyABC123..."
  }
}
```

### 방법 B: Firebase Console에서 설정

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택 (`exam-4516e`)
3. **Functions** 메뉴 클릭
4. **환경 변수** 탭
5. **변수 추가** 클릭
6. 키: `GEMINI_API_KEY`, 값: 복사한 API 키
7. **저장**

---

## 3. Functions 코드에서 API 키 사용 확인

[functions/src/llm.ts](functions/src/llm.ts) 파일이 이미 환경 변수를 읽도록 설정되어 있습니다:

```typescript
const apiKey = process.env.GEMINI_API_KEY;
```

**로컬 테스트를 위한 설정:**

로컬에서 Functions를 테스트하려면 `.env` 파일을 생성하세요:

```bash
# functions/.env 파일 생성
cd functions
cat > .env << 'EOF'
GEMINI_API_KEY=YOUR_ACTUAL_API_KEY_HERE
EOF
cd ..
```

**⚠️ 주의:** `.env` 파일은 `.gitignore`에 포함되어 있으므로 Git에 커밋되지 않습니다.

---

## 4. Functions 배포

API 키를 설정한 후 Functions를 배포해야 적용됩니다.

```bash
# Functions 디렉토리로 이동
cd functions

# 의존성 설치 (처음 한 번만)
npm install

# TypeScript 빌드
npm run build

# Firebase에 배포
cd ..
firebase deploy --only functions
```

**배포 성공 메시지:**
```
✔  Deploy complete!

Functions deployed:
  - onEntryCreate
  - createSuggestions
  - publishToFeed
  - checkRateLimit
```

---

## 5. API 키 작동 확인

### 5-1. Functions 로그 확인

```bash
# 실시간 로그 모니터링
firebase functions:log --only onEntryCreate
```

### 5-2. 앱에서 테스트

1. Flutter 앱 실행
2. 일기 작성 및 저장
3. AI 분석 상태 확인 (pending → done)
4. AI Review 화면에서 결과 확인

### 5-3. Firebase Console에서 확인

1. Firebase Console > **Firestore Database**
2. `entries` 컬렉션에서 방금 작성한 일기 확인
3. `entry_ai` 컬렉션에 AI 분석 결과가 생성되었는지 확인

---

## 로컬 테스트 (선택사항)

Firebase Emulator를 사용하여 로컬에서 Functions를 테스트할 수 있습니다.

### 1. Emulator 설치

```bash
firebase init emulators
```

체크박스에서 선택:
- [x] Functions
- [x] Firestore

### 2. .env 파일 생성

```bash
cd functions
echo "GEMINI_API_KEY=YOUR_API_KEY" > .env
cd ..
```

### 3. Emulator 실행

```bash
firebase emulators:start
```

출력:
```
┌─────────────────────────────────────────────────────────────┐
│ ✔  All emulators ready!                                     │
│                                                              │
│ View Emulator UI at http://127.0.0.1:4000                  │
└─────────────────────────────────────────────────────────────┘

┌───────────┬────────────────┬─────────────────────────────────┐
│ Emulator  │ Host:Port      │ View in Emulator UI             │
├───────────┼────────────────┼─────────────────────────────────┤
│ Functions │ localhost:5001 │ http://127.0.0.1:4000/functions │
│ Firestore │ localhost:8080 │ http://127.0.0.1:4000/firestore │
└───────────┴────────────────┴─────────────────────────────────┘
```

### 4. Flutter 앱을 Emulator에 연결

`lib/main.dart`에 다음 코드 추가 (개발 중에만):

```dart
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 로컬 Emulator 연결 (개발 중에만 활성화)
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  runApp(const ProviderScope(child: App()));
}
```

---

## 문제 해결

### 문제 1: "GEMINI_API_KEY is not set" 에러

**원인:** Functions에 API 키가 설정되지 않음

**해결:**
```bash
firebase functions:config:set gemini.api_key="YOUR_KEY"
firebase deploy --only functions
```

### 문제 2: "Invalid API key" 에러

**원인:** API 키가 잘못되었거나 만료됨

**해결:**
1. [Google AI Studio](https://makersuite.google.com/app/apikey)에서 API 키 재확인
2. 새 API 키 생성
3. `firebase functions:config:set gemini.api_key="NEW_KEY"`
4. 재배포

### 문제 3: Functions 배포 실패

**원인:** Firebase 프로젝트 결제 미활성화

**해결:**
1. Firebase Console > **Spark 플랜에서 Blaze 플랜으로 업그레이드**
2. Cloud Functions는 무료 할당량이 있지만 Blaze 플랜 필요
3. 무료 할당량:
   - 호출: 2,000,000회/월
   - 컴퓨팅: 400,000 GB-초/월
   - 네트워크: 5GB/월

### 문제 4: 로컬 Emulator에서 API 키를 찾을 수 없음

**해결:**
```bash
# functions/.env 파일이 있는지 확인
cat functions/.env

# 없으면 생성
cd functions
echo "GEMINI_API_KEY=YOUR_API_KEY" > .env
cd ..

# Emulator 재시작
firebase emulators:start
```

---

## 빠른 설정 스크립트

전체 과정을 한 번에 실행하는 스크립트:

```bash
#!/bin/bash

# 1. Firebase 로그인
firebase login

# 2. API 키 입력 받기
echo "Gemini API 키를 입력하세요:"
read -r API_KEY

# 3. Firebase Functions에 설정
firebase functions:config:set gemini.api_key="$API_KEY"

# 4. Functions 빌드 및 배포
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions

echo "✅ Gemini API 키 설정 완료!"
echo "✅ Functions 배포 완료!"
echo ""
echo "다음 단계:"
echo "1. Flutter 앱에서 일기를 작성하세요"
echo "2. AI 분석이 자동으로 시작됩니다"
echo "3. AI Review 화면에서 결과를 확인하세요"
```

이 스크립트를 `setup_gemini.sh`로 저장하고 실행:
```bash
chmod +x setup_gemini.sh
./setup_gemini.sh
```

---

## 요약

### 필수 단계 (순서대로)

1. ✅ Gemini API 키 받기
2. 🔧 Firebase Functions에 API 키 등록
   ```bash
   firebase functions:config:set gemini.api_key="YOUR_KEY"
   ```
3. 🚀 Functions 배포
   ```bash
   cd functions && npm install && npm run build && cd ..
   firebase deploy --only functions
   ```
4. ✨ 앱에서 테스트

### 확인 사항

- [ ] Firebase CLI 로그인됨
- [ ] API 키 설정됨 (`firebase functions:config:get`)
- [ ] Functions 배포 성공
- [ ] Firebase 프로젝트 Blaze 플랜 활성화
- [ ] 앱에서 일기 작성 시 AI 분석 작동

---

문제가 발생하면 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)를 참고하세요!

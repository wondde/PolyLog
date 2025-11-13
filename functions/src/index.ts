import 'dotenv/config';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { runCorrection } from './llm.js';

try {
  admin.initializeApp();
} catch (_) {}

setGlobalOptions({ region: 'asia-northeast3' });

const db = admin.firestore();

// Gemini API 키 확인
console.log('GEMINI_API_KEY loaded:', process.env.GEMINI_API_KEY ? 'Yes' : 'No');

// 언어 코드를 전체 언어 이름으로 변환
function langCodeToFullName(code: string): string {
  const mapping: { [key: string]: string } = {
    ko: 'Korean',
    en: 'English',
    ja: 'Japanese',
  };
  return mapping[code] || 'English';
}

// Entry 생성 시 AI 분석 트리거
export const onEntryCreate = onDocumentCreated('entries/{entryId}', async (event) => {
  console.log('onEntryCreate triggered for entryId:', event.params.entryId);
  const snap = event.data;
  if (!snap) {
    console.log('No data snapshot found. Exiting.');
    return;
  }

  const entry = snap.data();
  if (!entry) {
    console.log('No entry data found. Exiting.');
    return;
  }
  console.log('Entry data:', JSON.stringify(entry));

  const uid = entry.uid;
  if (!uid) {
    console.log('No UID in entry. Exiting.');
    return;
  }

  const userRef = db.doc(`users/${uid}`);
  const userSnap = await userRef.get();
  const user = userSnap.data() || {};
  console.log('User data:', JSON.stringify(user));

  try {
    const aiLangCode = user.prefs?.aiLang || user.nativeLang || 'en';
    const nativeLangForAI = langCodeToFullName(aiLangCode);
    console.log(`Determined native language for AI: ${aiLangCode} -> ${nativeLangForAI}`);

    const result = await runCorrection({
      lang: entry.lang,
      text: entry.textRaw,
      userCtx: {
        level: user.level?.[entry.lang],
        prefs: user.prefs,
        native: nativeLangForAI,
      },
    });

    await db.doc(`entry_ai/${snap.id}`).set(result);
    await snap.ref.update({ aiStatus: 'done' });

    // Streak update logic - 연속 일수 계산
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    // 오늘 작성한 일기 개수 확인 (현재 일기 포함)
    const todayEntries = await db
      .collection('entries')
      .where('uid', '==', uid)
      .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(today))
      .get();

    // 오늘 첫 일기인 경우만 streak 업데이트
    if (todayEntries.size === 1) {
      // 어제 일기가 있는지 확인
      const yesterdayEntries = await db
        .collection('entries')
        .where('uid', '==', uid)
        .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(yesterday))
        .where('createdAt', '<', admin.firestore.Timestamp.fromDate(today))
        .limit(1)
        .get();

      if (yesterdayEntries.size > 0) {
        // 어제도 일기 작성 → streak 증가
        await userRef.update({
          streak: admin.firestore.FieldValue.increment(1),
        });
      } else {
        // 어제 일기 없음 → streak을 1로 리셋
        await userRef.update({
          streak: 1,
        });
      }
    }
  } catch (error) {
    console.error('Error processing entry:', error);
    await snap.ref.update({ aiStatus: 'error' });
  }
});

// v2: A new function with a new name to ensure deployment in the correct region
export const analyzeEntry = onDocumentCreated({ document: 'entries/{entryId}', region: 'asia-northeast3' }, async (event) => {
  console.log(`analyzeEntry triggered for entryId: ${event.params.entryId}`);
  const snap = event.data;
  if (!snap) {
    console.log('No data snapshot found. Exiting.');
    return;
  }

  const entry = snap.data();
  if (!entry) {
    console.log('No entry data found. Exiting.');
    return;
  }
  console.log('Entry data:', JSON.stringify(entry));

  const uid = entry.uid;
  if (!uid) {
    console.log('No UID in entry. Exiting.');
    return;
  }

  const userRef = db.doc(`users/${uid}`);
  const userSnap = await userRef.get();
  const user = userSnap.data() || {};
  console.log('User data:', JSON.stringify(user));

  try {
    const aiLangCode = user.prefs?.aiLang || user.nativeLang || 'en';
    const nativeLangForAI = langCodeToFullName(aiLangCode);
    console.log(`Determined native language for AI: ${aiLangCode} -> ${nativeLangForAI}`);

    const result = await runCorrection({
      lang: entry.lang,
      text: entry.textRaw,
      userCtx: {
        level: user.level?.[entry.lang],
        prefs: user.prefs,
        native: nativeLangForAI,
      },
    });

    await db.doc(`entry_ai/${snap.id}`).set(result);
    await snap.ref.update({ aiStatus: 'done' });

    // Streak update logic - 연속 일수 계산
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    // 오늘 작성한 일기 개수 확인 (현재 일기 포함)
    const todayEntries = await db
      .collection('entries')
      .where('uid', '==', uid)
      .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(today))
      .get();

    // 오늘 첫 일기인 경우만 streak 업데이트
    if (todayEntries.size === 1) {
      // 어제 일기가 있는지 확인
      const yesterdayEntries = await db
        .collection('entries')
        .where('uid', '==', uid)
        .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(yesterday))
        .where('createdAt', '<', admin.firestore.Timestamp.fromDate(today))
        .limit(1)
        .get();

      if (yesterdayEntries.size > 0) {
        // 어제도 일기 작성 → streak 증가
        await userRef.update({
          streak: admin.firestore.FieldValue.increment(1),
        });
      } else {
        // 어제 일기 없음 → streak을 1로 리셋
        await userRef.update({
          streak: 1,
        });
      }
    }
  } catch (error) {
    console.error('Error processing entry:', error);
    await snap.ref.update({ aiStatus: 'error' });
  }
});

// 공개 피드에 게시
export const publishToFeed = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { entryId } = (request.data ?? {}) as { entryId?: string };
  if (!entryId) {
    throw new HttpsError('invalid-argument', 'entryId parameter is required');
  }

  const entryRef = db.doc(`entries/${entryId}`);
  const entrySnap = await entryRef.get();

  if (!entrySnap.exists) {
    throw new HttpsError('not-found', 'Entry not found');
  }

  const entry = entrySnap.data();
  if (!entry) {
    throw new HttpsError('not-found', 'Entry data not found');
  }

  if (entry.uid !== uid) {
    throw new HttpsError('permission-denied', 'Not authorized');
  }

  if (entry.visibility !== 'anon') {
    throw new HttpsError('invalid-argument', 'Entry must be set to anonymous');
  }

  // 익명으로 피드에 게시
  await db.collection('public_feed').add({
    lang: entry.lang,
    text: entry.textRaw?.substring(0, 100) ?? '',
    mood: entry.mood,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { ok: true };
});

// 일일 사용 횟수 제한 체크
export const checkRateLimit = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const entriesQuery = await db
    .collection('entries')
    .where('uid', '==', uid)
    .where('createdAt', '>=', today)
    .get();

  const count = entriesQuery.size;
  const limit = 20;

  if (count >= limit) {
    throw new HttpsError(
      'resource-exhausted',
      `Daily limit of ${limit} entries reached`
    );
  }

  return { ok: true, count, remaining: limit - count };
});

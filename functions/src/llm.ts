import { GoogleGenerativeAI } from '@google/generative-ai';
import { CORRECTION_PROMPT } from './prompts/correct.js';

interface UserContext {
  level?: string;
  prefs?: {
    easyWords?: boolean;
    showFurigana?: boolean;
    mixedUI?: boolean;
  };
  native?: string;
}

interface CorrectionInput {
  lang: string;
  text: string;
  userCtx: UserContext;
}

interface CorrectionResult {
  corrected: string;
  natural: {
    casual: string;
    formal: string;
  };
  diffs: Array<{
    op: 'replace' | 'add' | 'del';
    from?: string;
    to?: string;
  }>;
  highlights: string[];
  vocab: Array<{
    lemma: string;
    pos: string;
    meanings: string[];
    level?: string;
    example: string;
  }>;
  grammarNotes: string[];
  score: {
    fluency: number;
    accuracy: number;
  };
  rendering?: {
    jaFurigana?: boolean;
  };
}

function makeSystemPrompt(userCtx: UserContext): string {
  const nativeLang = userCtx.native || 'English';
  let prompt = CORRECTION_PROMPT.replace(/\{\{nativeLang\}\}/g, nativeLang);

  if (userCtx.prefs?.showFurigana && userCtx.prefs.showFurigana) {
    prompt += '\n\nIMPORTANT: For Japanese text, use {漢字|かな} format for ALL kanji characters with furigana. Apply this to corrected text, casual version, and formal version. Example: "今日は{図書館|としょかん}に{行|い}きました" (not "今日は図書館に行きました").';
  }

  if (userCtx.prefs?.easyWords && userCtx.prefs.easyWords) {
    prompt += '\n\nReplace rare or difficult words with simpler synonyms appropriate for the user level.';
  }

  if (userCtx.prefs?.mixedUI && userCtx.prefs.mixedUI && userCtx.native) {
    prompt += `\n\nAdd brief glosses in ${userCtx.native} for key terms.`;
  }

  console.log('---- FINAL SYSTEM PROMPT SENT TO LLM ----');
  console.log(prompt);
  console.log('------------------------------------------');

  return prompt;
}

function makeUserPrompt(lang: string, text: string, userCtx: UserContext): string {
  const nativeLang = userCtx.native || 'English';
  return JSON.stringify({
    Task: 'Correct diary entry and provide learning feedback',
    Language: lang,
    Text: text,
    UserLevel: userCtx.level || 'intermediate',
    Preferences: userCtx.prefs || {},
  }) + `\n\nREMINDER: Write ALL grammarNotes and ALL vocab meanings ONLY in ${nativeLang}. DO NOT use ${lang} or any other language for explanations.`;
}

export async function runCorrection(input: CorrectionInput): Promise<CorrectionResult> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new Error('GEMINI_API_KEY environment variable is not set');
  }

  const genAI = new GoogleGenerativeAI(apiKey);
  const systemPrompt = makeSystemPrompt(input.userCtx);

  const model = genAI.getGenerativeModel({
    model: 'gemini-2.5-flash-lite',  // Lite model for cost efficiency
    generationConfig: {
      temperature: 0.2,  // Even lower for strict instruction following
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 2048,
      responseMimeType: 'application/json',
    },
    systemInstruction: systemPrompt,  // Use systemInstruction instead of mixing in content
  });

  const userPrompt = makeUserPrompt(input.lang, input.text, input.userCtx);

  const result = await model.generateContent([
    { text: userPrompt },
  ]);

  const response = result.response;
  const text = response.text();

  try {
    return JSON.parse(text) as CorrectionResult;
  } catch (error) {
    console.error('Failed to parse LLM response:', text);
    throw new Error('Invalid JSON response from LLM');
  }
}

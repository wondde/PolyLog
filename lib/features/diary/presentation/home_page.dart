import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/language_support.dart';
import '../../../providers.dart';
import '../../../l10n/app_localizations.dart';

/// 홈 화면
class HomePage extends ConsumerStatefulWidget {
  /// [HomePage] 생성자
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _selectedLang; // 사용자가 선택한 학습 언어
  int _refreshCounter = 0; // 새로고침 카운터

  List<String> _getAllTopicSuggestions(String lang) {
    switch (lang) {
      case 'ja':
        return [
          '今日、あなたを笑顔にしたことは何ですか？',
          '乗り越えた困難について書いてみましょう！',
          '感謝していることは何ですか？',
          '最近学んだことを教えてください',
          '今週の一番好きな瞬間は？',
          '今日の朝、最初に思ったことは何でしたか？',
          '今日出会った人の中で印象的だった人は？',
          '最近読んだ本や記事で心に残ったことは？',
          '子供の頃の好きだった遊びを思い出してみましょう',
          '今週挑戦してみたいことは何ですか？',
          '最近の小さな幸せについて書いてみましょう',
          'もし明日が休日だったら何をしますか？',
          '今の季節で一番好きなことは？',
          '最近笑った出来事を思い出してみましょう',
          '10年前の自分に何を伝えたいですか？',
          '今日の天気はあなたの気分にどう影響しましたか？',
          '最近あなたを驚かせたニュースや出来事は？',
          'あなたの理想的な一日を描いてみましょう',
          '最近誰かに言われて嬉しかった言葉は？',
          '今月達成したい小さな目標は何ですか？',
        ];
      case 'ko':
        return [
          '오늘 당신을 미소 짓게 한 것은 무엇인가요?',
          '극복한 어려움에 대해 써보세요!',
          '감사하게 생각하는 것은 무엇인가요?',
          '최근에 배운 교훈을 알려주세요!',
          '이번 주 가장 좋았던 순간은?',
          '오늘 아침에 가장 먼저 든 생각은?',
          '오늘 만난 사람 중 인상 깊었던 사람은?',
          '최근 읽은 책이나 기사에서 기억에 남는 것은?',
          '어렸을 때 좋아했던 놀이를 떠올려보세요',
          '이번 주에 도전해보고 싶은 것은?',
          '최근의 작은 행복에 대해 써보세요',
          '내일이 휴일이라면 무엇을 하고 싶나요?',
          '지금 계절에서 가장 좋아하는 것은?',
          '최근에 웃었던 일을 떠올려보세요',
          '10년 전의 나에게 무엇을 전하고 싶나요?',
          '오늘 날씨가 기분에 어떤 영향을 주었나요?',
          '최근 당신을 놀라게 한 뉴스나 사건은?',
          '이상적인 하루를 그려보세요',
          '최근 누군가에게 들어서 기뻤던 말은?',
          '이번 달에 달성하고 싶은 작은 목표는?',
        ];
      case 'de':
        return [
          'Was hat dich heute zum Lächeln gebracht?',
          'Beschreibe eine Herausforderung, die du gemeistert hast!',
          'Wofür bist du dankbar?',
          'Eine Lektion, die du kürzlich gelernt hast!',
          'Dein Lieblingsmoment diese Woche!',
          'Was war dein erster Gedanke heute Morgen?',
          'Wer hat heute Eindruck auf dich gemacht?',
          'Etwas Denkwürdiges aus einem Buch oder Artikel, den du kürzlich gelesen hast?',
          'Erinnere dich an ein Lieblingsspiel aus deiner Kindheit',
          'Was möchtest du diese Woche ausprobieren?',
          'Schreibe über ein kleines Glück, das du kürzlich erlebt hast',
          'Was würdest du tun, wenn morgen ein freier Tag wäre?',
          'Was magst du am meisten an der aktuellen Jahreszeit?',
          'Erinnere dich an einen kürzlichen Moment, der dich zum Lachen gebracht hat',
          'Was würdest du deinem Ich vor 10 Jahren sagen?',
          'Wie hat das heutige Wetter deine Stimmung beeinflusst?',
          'Ein kürzliches Ereignis, das dich überrascht hat?',
          'Beschreibe deinen idealen Tag',
          'Ein freundliches Wort, das dir kürzlich jemand gesagt hat?',
          'Ein kleines Ziel, das du diesen Monat erreichen möchtest?',
        ];
      case 'es':
        return [
          '¿Qué te hizo sonreír hoy?',
          '¡Describe un desafío que superaste!',
          '¿Por qué estás agradecido?',
          '¡Una lección que aprendiste recientemente!',
          '¡Tu momento favorito de esta semana!',
          '¿Cuál fue tu primer pensamiento esta mañana?',
          '¿Quién te impresionó hoy?',
          '¿Algo memorable de un libro o artículo que leíste recientemente?',
          'Recuerda un juego o actividad favorita de la infancia',
          '¿Qué te gustaría probar esta semana?',
          'Escribe sobre una pequeña felicidad que experimentaste recientemente',
          'Si mañana fuera un día libre, ¿qué harías?',
          '¿Qué es lo que más te gusta de la temporada actual?',
          'Recuerda un momento reciente que te hizo reír',
          '¿Qué le dirías a tu yo de hace 10 años?',
          '¿Cómo afectó el clima de hoy a tu estado de ánimo?',
          '¿Un evento reciente que te sorprendió?',
          'Describe tu día ideal',
          '¿Una palabra amable que alguien te dijo recientemente?',
          '¿Una pequeña meta que quieras lograr este mes?',
        ];
      case 'fr':
        return [
          'Qu\'est-ce qui t\'a fait sourire aujourd\'hui?',
          'Décris un défi que tu as surmonté!',
          'Pour quoi es-tu reconnaissant?',
          'Une leçon que tu as apprise récemment!',
          'Ton moment préféré de cette semaine!',
          'Quelle a été ta première pensée ce matin?',
          'Qui t\'a impressionné aujourd\'hui?',
          'Quelque chose de mémorable d\'un livre ou d\'un article que tu as lu récemment?',
          'Rappelle-toi un jeu ou une activité préférée de ton enfance',
          'Qu\'aimerais-tu essayer cette semaine?',
          'Écris sur un petit bonheur que tu as vécu récemment',
          'Si demain était un jour de congé, que ferais-tu?',
          'Qu\'est-ce que tu préfères dans la saison actuelle?',
          'Rappelle-toi un moment récent qui t\'a fait rire',
          'Que dirais-tu à ton moi d\'il y a 10 ans?',
          'Comment le temps d\'aujourd\'hui a-t-il affecté ton humeur?',
          'Un événement récent qui t\'a surpris?',
          'Décris ta journée idéale',
          'Un mot gentil que quelqu\'un t\'a dit récemment?',
          'Un petit objectif que tu veux atteindre ce mois-ci?',
        ];
      case 'pt':
        return [
          'O que te fez sorrir hoje?',
          'Descreva um desafio que você superou!',
          'Pelo que você é grato?',
          'Uma lição que você aprendeu recentemente!',
          'Seu momento favorito desta semana!',
          'Qual foi seu primeiro pensamento esta manhã?',
          'Quem te impressionou hoje?',
          'Algo memorável de um livro ou artigo que você leu recentemente?',
          'Lembre-se de um jogo ou atividade favorita da infância',
          'O que você gostaria de experimentar esta semana?',
          'Escreva sobre uma pequena felicidade que você experimentou recentemente',
          'Se amanhã fosse um dia de folga, o que você faria?',
          'O que você mais gosta na estação atual?',
          'Lembre-se de um momento recente que te fez rir',
          'O que você diria ao seu eu de 10 anos atrás?',
          'Como o clima de hoje afetou seu humor?',
          'Um evento recente que te surpreendeu?',
          'Descreva seu dia ideal',
          'Uma palavra gentil que alguém te disse recentemente?',
          'Uma pequena meta que você quer alcançar este mês?',
        ];
      case 'it':
        return [
          'Cosa ti ha fatto sorridere oggi?',
          'Descrivi una sfida che hai superato!',
          'Per cosa sei grato?',
          'Una lezione che hai imparato di recente!',
          'Il tuo momento preferito di questa settimana!',
          'Qual è stato il tuo primo pensiero stamattina?',
          'Chi ti ha colpito oggi?',
          'Qualcosa di memorabile da un libro o articolo che hai letto di recente?',
          'Ricorda un gioco o attività preferita dell\'infanzia',
          'Cosa vorresti provare questa settimana?',
          'Scrivi di una piccola felicità che hai vissuto di recente',
          'Se domani fosse un giorno libero, cosa faresti?',
          'Cosa ti piace di più della stagione attuale?',
          'Ricorda un momento recente che ti ha fatto ridere',
          'Cosa diresti al tuo io di 10 anni fa?',
          'Come ha influenzato il tempo di oggi il tuo umore?',
          'Un evento recente che ti ha sorpreso?',
          'Descrivi la tua giornata ideale',
          'Una parola gentile che qualcuno ti ha detto di recente?',
          'Un piccolo obiettivo che vuoi raggiungere questo mese?',
        ];
      case 'ru':
        return [
          'Что заставило тебя улыбнуться сегодня?',
          'Опиши проблему, которую ты преодолел!',
          'За что ты благодарен?',
          'Урок, который ты недавно усвоил!',
          'Твой любимый момент на этой неделе!',
          'Какая была твоя первая мысль этим утром?',
          'Кто произвел на тебя впечатление сегодня?',
          'Что-то запоминающееся из книги или статьи, которую ты недавно прочитал?',
          'Вспомни любимую детскую игру или занятие',
          'Что бы ты хотел попробовать на этой неделе?',
          'Напиши о маленьком счастье, которое ты недавно испытал',
          'Если завтра будет выходной, что ты будешь делать?',
          'Что тебе больше всего нравится в текущем сезоне?',
          'Вспомни недавний момент, который заставил тебя смеяться',
          'Что бы ты сказал себе 10 лет назад?',
          'Как сегодняшняя погода повлияла на твое настроение?',
          'Недавнее событие, которое тебя удивило?',
          'Опиши свой идеальный день',
          'Доброе слово, которое кто-то недавно тебе сказал?',
          'Маленькая цель, которую ты хочешь достичь в этом месяце?',
        ];
      case 'zh':
        return [
          '今天是什么让你微笑的？',
          '描述一个你克服的挑战！',
          '你感激什么？',
          '你最近学到的教训！',
          '本周你最喜欢的时刻！',
          '今天早上你第一个想到的是什么？',
          '今天谁给你留下了深刻印象？',
          '最近读过的书或文章中有什么令人难忘的？',
          '回忆一个童年最喜欢的游戏或活动',
          '本周你想尝试什么？',
          '写写你最近经历的小幸福',
          '如果明天是休息日，你会做什么？',
          '你最喜欢当前季节的什么？',
          '回忆最近让你发笑的时刻',
          '你会对10年前的自己说什么？',
          '今天的天气如何影响你的心情？',
          '最近让你惊讶的事件？',
          '描述你理想的一天',
          '最近有人对你说的温暖的话？',
          '本月你想实现的小目标？',
        ];
      case 'ar':
        return [
          'ما الذي جعلك تبتسم اليوم؟',
          'صف تحديًا تغلبت عليه!',
          'ما الذي أنت ممتن له؟',
          'درس تعلمته مؤخرًا!',
          'لحظتك المفضلة هذا الأسبوع!',
          'ما كان أول فكرة لك هذا الصباح؟',
          'من أثار إعجابك اليوم؟',
          'شيء لا يُنسى من كتاب أو مقال قرأته مؤخرًا؟',
          'تذكر لعبة أو نشاطًا مفضلاً من الطفولة',
          'ما الذي تود تجربته هذا الأسبوع؟',
          'اكتب عن سعادة صغيرة عشتها مؤخرًا',
          'إذا كان الغد يوم عطلة، ماذا ستفعل؟',
          'ما أكثر ما تحب في الموسم الحالي؟',
          'تذكر لحظة حديثة جعلتك تضحك',
          'ماذا ستقول لنفسك قبل 10 سنوات؟',
          'كيف أثر طقس اليوم على مزاجك؟',
          'حدث حديث فاجأك؟',
          'صف يومك المثالي',
          'كلمة لطيفة قالها لك شخص ما مؤخرًا؟',
          'هدف صغير تريد تحقيقه هذا الشهر؟',
        ];
      case 'vi':
        return [
          'Điều gì đã khiến bạn mỉm cười hôm nay?',
          'Mô tả một thử thách bạn đã vượt qua!',
          'Bạn biết ơn điều gì?',
          'Một bài học bạn học được gần đây!',
          'Khoảnh khắc yêu thích của bạn tuần này!',
          'Suy nghĩ đầu tiên của bạn sáng nay là gì?',
          'Ai đã gây ấn tượng với bạn hôm nay?',
          'Điều gì đáng nhớ từ một cuốn sách hoặc bài báo bạn đọc gần đây?',
          'Nhớ lại một trò chơi hoặc hoạt động yêu thích thời thơ ấu',
          'Bạn muốn thử điều gì tuần này?',
          'Viết về một niềm hạnh phúc nhỏ bạn trải nghiệm gần đây',
          'Nếu ngày mai là ngày nghỉ, bạn sẽ làm gì?',
          'Bạn thích gì nhất về mùa hiện tại?',
          'Nhớ lại một khoảnh khắc gần đây khiến bạn cười',
          'Bạn sẽ nói gì với bản thân 10 năm trước?',
          'Thời tiết hôm nay ảnh hưởng đến tâm trạng của bạn như thế nào?',
          'Một sự kiện gần đây khiến bạn ngạc nhiên?',
          'Mô tả một ngày lý tưởng của bạn',
          'Một lời nói tốt đẹp ai đó nói với bạn gần đây?',
          'Một mục tiêu nhỏ bạn muốn đạt được tháng này?',
        ];
      case 'th':
        return [
          'อะไรทำให้คุณยิ้มวันนี้?',
          'บรรยายถึงความท้าทายที่คุณเอาชนะได้!',
          'คุณขอบคุณอะไร?',
          'บทเรียนที่คุณเรียนรู้เมื่อเร็วๆ นี้!',
          'ช่วงเวลาที่คุณชอบที่สุดในสัปดาห์นี้!',
          'สิ่งแรกที่คุณคิดเมื่อเช้านี้คืออะไร?',
          'ใครที่ทำให้คุณประทับใจวันนี้?',
          'สิ่งที่น่าจดจำจากหนังสือหรือบทความที่คุณอ่านเมื่อเร็วๆ นี้?',
          'นึกถึงเกมหรือกิจกรรมที่ชอบในวัยเด็ก',
          'คุณอยากลองอะไรในสัปดาห์นี้?',
          'เขียนเกี่ยวกับความสุขเล็กๆ ที่คุณประสบเมื่อเร็วๆ นี้',
          'ถ้าพรุ่งนี้เป็นวันหยุด คุณจะทำอะไร?',
          'คุณชอบอะไรมากที่สุดเกี่ยวกับฤดูกาลปัจจุบัน?',
          'นึกถึงช่วงเวลาเมื่อเร็วๆ นี้ที่ทำให้คุณหัวเราะ',
          'คุณจะบอกอะไรกับตัวเองเมื่อ 10 ปีก่อน?',
          'สภาพอากาศวันนี้ส่งผลต่ออารมณ์ของคุณอย่างไร?',
          'เหตุการณ์เมื่อเร็วๆ นี้ที่ทำให้คุณประหลาดใจ?',
          'บรรยายถึงวันในอุดมคติของคุณ',
          'คำดีๆ ที่มีคนพูดกับคุณเมื่อเร็วๆ นี้?',
          'เป้าหมายเล็กๆ ที่คุณต้องการบรรลุในเดือนนี้?',
        ];
      default: // 'en'
        return [
          'What made you smile today?',
          'Describe a challenge you overcame!',
          'What are you grateful for?',
          'A lesson you learned recently!',
          'Your favorite moment this week!',
          'What was the first thing you thought this morning?',
          'Who made an impression on you today?',
          'Something memorable from a book or article you read recently?',
          'Recall a favorite childhood game or activity',
          'What would you like to try this week?',
          'Write about a small happiness you experienced recently',
          'If tomorrow was a day off, what would you do?',
          "What's your favorite thing about the current season?",
          'Recall a recent moment that made you laugh',
          'What would you tell your 10-years-ago self?',
          'How did today\'s weather affect your mood?',
          'A recent news or event that surprised you?',
          'Describe your ideal day',
          'A kind word someone said to you recently?',
          'A small goal you want to achieve this month?',
        ];
    }
  }

  List<String> _getAllSentenceStarters(String lang) {
    switch (lang) {
      case 'ja':
        return [
          '今日、私は…と感じた',
          '…の時、驚きました',
          '今日の一番良かったことは…',
          '私は…したいです',
          '振り返ってみると、…と気づきました',
          '最近、私は…に夢中です',
          '…することで、心が落ち着きます',
          '今日学んだことは…',
          'もし…だったら、私は…',
          '昨日とは違って、今日は…',
          '私にとって大切なのは…',
          '…を見た時、心が温かくなりました',
          '今朝、目が覚めた時…',
          '最も印象的だったのは…',
          '…について考えるたびに…',
          '今日の私は、…を決心しました',
          '…によって、視点が変わりました',
          '将来の夢は…',
          '最近気づいたことは…',
          '今、一番大切にしたいのは…',
        ];
      case 'ko':
        return [
          '오늘 나는…라고 느꼈다',
          '…했을 때 놀랐다',
          '오늘 가장 좋았던 순간은…',
          '나는…하고 싶다',
          '돌이켜보니, …를 깨달았다',
          '최근 나는…에 빠져있다',
          '…할 때 마음이 편안해진다',
          '오늘 배운 것은…',
          '만약…라면, 나는…',
          '어제와 달리, 오늘은…',
          '나에게 소중한 것은…',
          '…를 봤을 때, 마음이 따뜻해졌다',
          '오늘 아침 눈을 떴을 때…',
          '가장 인상 깊었던 것은…',
          '…에 대해 생각할 때마다…',
          '오늘 나는…를 결심했다',
          '…로 인해, 생각이 바뀌었다',
          '미래의 꿈은…',
          '최근 깨달은 것은…',
          '지금 가장 소중히 하고 싶은 것은…',
        ];
      case 'de':
        return [
          'Heute fühlte ich mich...',
          'Ich war überrascht, als...',
          'Das Beste an meinem Tag war...',
          'Ich wünschte, ich könnte...',
          'Rückblickend erkenne ich...',
          'In letzter Zeit genieße ich...',
          'Ich fühle mich friedlich, wenn...',
          'Heute habe ich gelernt, dass...',
          'Wenn... dann würde ich...',
          'Anders als gestern, heute...',
          'Was mir am wichtigsten ist...',
          'Mein Herz erwärmte sich, als ich sah...',
          'Als ich heute Morgen aufwachte...',
          'Das Denkwürdigste war...',
          'Wann immer ich denke über...',
          'Heute habe ich beschlossen...',
          'Durch... hat sich meine Perspektive geändert',
          'Mein Traum für die Zukunft ist...',
          'Kürzlich habe ich bemerkt...',
          'Was ich jetzt am meisten schätzen möchte ist...',
        ];
      case 'es':
        return [
          'Hoy me sentí...',
          'Me sorprendí cuando...',
          'La mejor parte de mi día fue...',
          'Desearía poder...',
          'Mirando hacia atrás, me doy cuenta...',
          'Últimamente, he estado disfrutando...',
          'Me siento en paz cuando...',
          'Hoy aprendí que...',
          'Si... entonces yo...',
          'A diferencia de ayer, hoy...',
          'Lo que más me importa es...',
          'Mi corazón se calentó cuando vi...',
          'Cuando me desperté esta mañana...',
          'Lo más memorable fue...',
          'Siempre que pienso en...',
          'Hoy decidí...',
          'A través de... mi perspectiva cambió',
          'Mi sueño para el futuro es...',
          'Recientemente me di cuenta...',
          'Lo que más quiero valorar ahora es...',
        ];
      case 'fr':
        return [
          'Aujourd\'hui je me suis senti...',
          'J\'ai été surpris quand...',
          'La meilleure partie de ma journée était...',
          'J\'aimerais pouvoir...',
          'En y repensant, je réalise...',
          'Dernièrement, j\'apprécie...',
          'Je me sens en paix quand...',
          'Aujourd\'hui j\'ai appris que...',
          'Si... alors je...',
          'Contrairement à hier, aujourd\'hui...',
          'Ce qui compte le plus pour moi est...',
          'Mon cœur s\'est réchauffé quand j\'ai vu...',
          'Quand je me suis réveillé ce matin...',
          'La chose la plus mémorable était...',
          'Chaque fois que je pense à...',
          'Aujourd\'hui j\'ai décidé...',
          'Grâce à... ma perspective a changé',
          'Mon rêve pour l\'avenir est...',
          'Récemment j\'ai remarqué...',
          'Ce que je veux le plus chérir maintenant est...',
        ];
      case 'pt':
        return [
          'Hoje me senti...',
          'Fiquei surpreso quando...',
          'A melhor parte do meu dia foi...',
          'Gostaria de poder...',
          'Olhando para trás, percebo...',
          'Ultimamente, tenho gostado de...',
          'Sinto-me em paz quando...',
          'Hoje aprendi que...',
          'Se... então eu...',
          'Ao contrário de ontem, hoje...',
          'O que mais importa para mim é...',
          'Meu coração aqueceu quando vi...',
          'Quando acordei esta manhã...',
          'A coisa mais memorável foi...',
          'Sempre que penso sobre...',
          'Hoje decidi...',
          'Através de... minha perspectiva mudou',
          'Meu sonho para o futuro é...',
          'Recentemente percebi...',
          'O que mais quero valorizar agora é...',
        ];
      case 'it':
        return [
          'Oggi mi sono sentito...',
          'Sono rimasto sorpreso quando...',
          'La parte migliore della mia giornata è stata...',
          'Vorrei poter...',
          'Guardando indietro, mi rendo conto...',
          'Ultimamente, mi sto godendo...',
          'Mi sento in pace quando...',
          'Oggi ho imparato che...',
          'Se... allora io...',
          'A differenza di ieri, oggi...',
          'Ciò che conta di più per me è...',
          'Il mio cuore si è scaldato quando ho visto...',
          'Quando mi sono svegliato stamattina...',
          'La cosa più memorabile è stata...',
          'Ogni volta che penso a...',
          'Oggi ho deciso...',
          'Attraverso... la mia prospettiva è cambiata',
          'Il mio sogno per il futuro è...',
          'Recentemente ho notato...',
          'Ciò che voglio apprezzare di più ora è...',
        ];
      case 'ru':
        return [
          'Сегодня я почувствовал...',
          'Я был удивлен, когда...',
          'Лучшая часть моего дня была...',
          'Я хотел бы...',
          'Оглядываясь назад, я понимаю...',
          'В последнее время я наслаждаюсь...',
          'Я чувствую покой, когда...',
          'Сегодня я узнал, что...',
          'Если... то я бы...',
          'В отличие от вчерашнего дня, сегодня...',
          'Что для меня важнее всего...',
          'Мое сердце согрелось, когда я увидел...',
          'Когда я проснулся этим утром...',
          'Самым запоминающимся было...',
          'Всякий раз, когда я думаю о...',
          'Сегодня я решил...',
          'Через... моя перспектива изменилась',
          'Моя мечта о будущем...',
          'Недавно я заметил...',
          'Что я больше всего хочу ценить сейчас...',
        ];
      case 'zh':
        return [
          '今天我感到...',
          '当...时我感到惊讶',
          '我今天最好的部分是...',
          '我希望我能...',
          '回顾过去，我意识到...',
          '最近，我一直在享受...',
          '当...时我感到平静',
          '今天我学到了...',
          '如果...那么我会...',
          '与昨天不同，今天...',
          '对我来说最重要的是...',
          '当我看到...时，我的心变暖了',
          '今天早上醒来时...',
          '最难忘的事情是...',
          '每当我想到...',
          '今天我决定...',
          '通过...我的视角改变了',
          '我对未来的梦想是...',
          '最近我注意到...',
          '我现在最想珍惜的是...',
        ];
      case 'ar':
        return [
          'اليوم شعرت...',
          'فوجئت عندما...',
          'أفضل جزء في يومي كان...',
          'أتمنى لو أستطيع...',
          'بالنظر إلى الوراء، أدرك...',
          'مؤخرًا، كنت أستمتع بـ...',
          'أشعر بالسلام عندما...',
          'اليوم تعلمت أن...',
          'إذا... ثم أنا...',
          'على عكس الأمس، اليوم...',
          'ما يهمني أكثر هو...',
          'دفئ قلبي عندما رأيت...',
          'عندما استيقظت هذا الصباح...',
          'الشيء الأكثر تذكرًا كان...',
          'كلما فكرت في...',
          'اليوم قررت...',
          'من خلال... تغيرت وجهة نظري',
          'حلمي للمستقبل هو...',
          'لاحظت مؤخرًا...',
          'ما أريد أن أقدره أكثر الآن هو...',
        ];
      case 'vi':
        return [
          'Hôm nay tôi cảm thấy...',
          'Tôi đã ngạc nhiên khi...',
          'Phần tốt nhất trong ngày của tôi là...',
          'Tôi ước tôi có thể...',
          'Nhìn lại, tôi nhận ra...',
          'Gần đây, tôi đang tận hưởng...',
          'Tôi cảm thấy bình yên khi...',
          'Hôm nay tôi học được rằng...',
          'Nếu... thì tôi sẽ...',
          'Không giống như hôm qua, hôm nay...',
          'Điều quan trọng nhất với tôi là...',
          'Trái tim tôi ấm lên khi tôi thấy...',
          'Khi tôi thức dậy sáng nay...',
          'Điều đáng nhớ nhất là...',
          'Mỗi khi tôi nghĩ về...',
          'Hôm nay tôi quyết định...',
          'Qua... quan điểm của tôi đã thay đổi',
          'Ước mơ của tôi cho tương lai là...',
          'Gần đây tôi nhận thấy...',
          'Điều tôi muốn trân trọng nhất bây giờ là...',
        ];
      case 'th':
        return [
          'วันนี้ฉันรู้สึก...',
          'ฉันประหลาดใจเมื่อ...',
          'ส่วนที่ดีที่สุดของวันฉันคือ...',
          'ฉันหวังว่าฉันจะสามารถ...',
          'มองย้อนกลับไป ฉันตระหนักว่า...',
          'เมื่อเร็วๆ นี้ ฉันเพลิดเพลินกับ...',
          'ฉันรู้สึกสงบเมื่อ...',
          'วันนี้ฉันเรียนรู้ว่า...',
          'ถ้า... แล้วฉันจะ...',
          'ไม่เหมือนเมื่อวาน วันนี้...',
          'สิ่งที่สำคัญที่สุดสำหรับฉันคือ...',
          'หัวใจฉันอบอุ่นเมื่อฉันเห็น...',
          'เมื่อฉันตื่นขึ้นเช้านี้...',
          'สิ่งที่น่าจดจำที่สุดคือ...',
          'ทุกครั้งที่ฉันคิดเกี่ยวกับ...',
          'วันนี้ฉันตัดสินใจ...',
          'ผ่าน... มุมมองของฉันเปลี่ยนไป',
          'ความฝันของฉันสำหรับอนาคตคือ...',
          'เมื่อเร็วๆ นี้ฉันสังเกตเห็น...',
          'สิ่งที่ฉันต้องการให้คุณค่ามากที่สุดตอนนี้คือ...',
        ];
      default: // 'en'
        return [
          'Today I felt...',
          'I was surprised when...',
          'The best part of my day was...',
          'I wish I could...',
          'Looking back, I realize...',
          'Lately, I\'ve been enjoying...',
          'I feel at peace when...',
          'Today I learned that...',
          'If... then I would...',
          'Unlike yesterday, today...',
          'What matters most to me is...',
          'My heart warmed when I saw...',
          'When I woke up this morning...',
          'The most memorable thing was...',
          'Whenever I think about...',
          'Today I decided...',
          'Through... my perspective changed',
          'My dream for the future is...',
          'Recently I noticed...',
          'What I want to cherish most now is...',
        ];
    }
  }

  List<String> _getAllReflectiveQuestions(String lang) {
    switch (lang) {
      case 'ja':
        return [
          '今日、どのように成長しましたか？',
          '何を違うやり方でやりますか？',
          '誰があなたを励ましましたか？なぜ？',
          '何を楽しみにしていますか？',
          '明日、どうすればもっと優しくなれますか？',
          '今日、自分を誇りに思える瞬間はありましたか？',
          '最近の失敗から何を学びましたか？',
          'あなたの強みは何だと思いますか？',
          '今週、誰かを助けることができましたか？',
          'ストレスを感じた時、どう対処しましたか？',
          '今日の自分に点数をつけるなら？その理由は？',
          '最近、習慣にしたいことは何ですか？',
          'あなたを幸せにする小さなことは何ですか？',
          '今の自分に必要なものは何だと思いますか？',
          '最近、時間を無駄にしたと感じたことは？',
          '今日の経験から、将来どう生かせますか？',
          '最も大切な人間関係は何ですか？',
          '今月達成したい個人的な目標は？',
          '最近変えたい習慣はありますか？',
          '感謝の気持ちを伝えたい人は誰ですか？',
        ];
      case 'ko':
        return [
          '오늘 어떻게 성장했나요?',
          '다르게 할 수 있었던 것은 무엇인가요?',
          '누가 당신에게 영감을 주었나요? 왜?',
          '무엇을 기대하고 있나요?',
          '내일 어떻게 더 친절할 수 있을까요?',
          '오늘 자신이 자랑스러웠던 순간이 있나요?',
          '최근의 실패에서 무엇을 배웠나요?',
          '당신의 강점은 무엇이라고 생각하나요?',
          '이번 주에 누군가를 도울 수 있었나요?',
          '스트레스를 받았을 때 어떻게 대처했나요?',
          '오늘의 나에게 점수를 준다면? 그 이유는?',
          '최근 습관으로 만들고 싶은 것은?',
          '당신을 행복하게 하는 작은 것은?',
          '지금의 나에게 필요한 것은 무엇인가요?',
          '최근 시간을 낭비했다고 느낀 적이 있나요?',
          '오늘의 경험을 미래에 어떻게 활용할 수 있을까요?',
          '가장 소중한 인간관계는 무엇인가요?',
          '이번 달 달성하고 싶은 개인적인 목표는?',
          '최근 바꾸고 싶은 습관이 있나요?',
          '감사의 마음을 전하고 싶은 사람은 누구인가요?',
        ];
      case 'de':
        return [
          'Wie bin ich heute gewachsen?',
          'Was würde ich anders machen?',
          'Wer hat mich inspiriert und warum?',
          'Worauf freue ich mich?',
          'Wie kann ich morgen freundlicher sein?',
          'Gab es heute einen Moment, in dem ich stolz auf mich war?',
          'Was hast du aus einem kürzlichen Misserfolg gelernt?',
          'Was denkst du, sind deine Stärken?',
          'Hast du diese Woche jemandem geholfen?',
          'Wie bist du damit umgegangen, als du gestresst warst?',
          'Wenn du dich heute bewerten würdest, welche Note und warum?',
          'Welche Gewohnheit möchtest du kürzlich entwickeln?',
          'Welche kleinen Dinge machen dich glücklich?',
          'Was brauchst du gerade jetzt?',
          'Hattest du das Gefühl, kürzlich Zeit verschwendet zu haben?',
          'Wie kann ich die heutige Erfahrung in Zukunft nutzen?',
          'Was ist die wichtigste Beziehung für mich?',
          'Welches persönliche Ziel möchte ich diesen Monat erreichen?',
          'Gibt es eine Gewohnheit, die ich ändern möchte?',
          'Wem möchte ich meine Dankbarkeit ausdrücken?',
        ];
      case 'es':
        return [
          '¿Cómo crecí hoy?',
          '¿Qué haría de manera diferente?',
          '¿Quién me inspiró y por qué?',
          '¿Qué espero con ansias?',
          '¿Cómo puedo ser más amable mañana?',
          '¿Hubo un momento hoy en que me sentí orgulloso de mí mismo?',
          '¿Qué aprendiste de un fracaso reciente?',
          '¿Cuáles crees que son tus fortalezas?',
          '¿Ayudaste a alguien esta semana?',
          '¿Cómo te las arreglaste cuando te sentiste estresado?',
          'Si te calificaras hoy, ¿qué puntuación y por qué?',
          '¿Qué hábito te gustaría desarrollar recientemente?',
          '¿Qué pequeñas cosas te hacen feliz?',
          '¿Qué necesitas ahora mismo?',
          '¿Sentiste que perdiste tiempo recientemente?',
          '¿Cómo puedo usar la experiencia de hoy en el futuro?',
          '¿Cuál es la relación más importante para mí?',
          '¿Qué objetivo personal quiero lograr este mes?',
          '¿Hay algún hábito que quiera cambiar?',
          '¿A quién le quiero expresar mi gratitud?',
        ];
      case 'fr':
        return [
          'Comment ai-je grandi aujourd\'hui?',
          'Que ferais-je différemment?',
          'Qui m\'a inspiré et pourquoi?',
          'Qu\'est-ce que j\'attends avec impatience?',
          'Comment puis-je être plus gentil demain?',
          'Y a-t-il eu un moment aujourd\'hui où j\'étais fier de moi?',
          'Qu\'as-tu appris d\'un échec récent?',
          'Quelles sont tes forces selon toi?',
          'As-tu aidé quelqu\'un cette semaine?',
          'Comment as-tu géré quand tu t\'es senti stressé?',
          'Si tu te notais aujourd\'hui, quelle note et pourquoi?',
          'Quelle habitude aimerais-tu développer récemment?',
          'Quelles petites choses te rendent heureux?',
          'De quoi as-tu besoin maintenant?',
          'As-tu eu l\'impression de perdre du temps récemment?',
          'Comment puis-je utiliser l\'expérience d\'aujourd\'hui à l\'avenir?',
          'Quelle est la relation la plus importante pour moi?',
          'Quel objectif personnel veux-je atteindre ce mois-ci?',
          'Y a-t-il une habitude que je veux changer?',
          'À qui veux-je exprimer ma gratitude?',
        ];
      case 'pt':
        return [
          'Como cresci hoje?',
          'O que eu faria diferente?',
          'Quem me inspirou e por quê?',
          'O que estou ansioso para?',
          'Como posso ser mais gentil amanhã?',
          'Houve um momento hoje em que me senti orgulhoso de mim mesmo?',
          'O que você aprendeu com um fracasso recente?',
          'Quais você acha que são seus pontos fortes?',
          'Você ajudou alguém esta semana?',
          'Como você lidou quando se sentiu estressado?',
          'Se você se avaliasse hoje, qual nota e por quê?',
          'Que hábito você gostaria de desenvolver recentemente?',
          'Que pequenas coisas te fazem feliz?',
          'Do que você precisa agora?',
          'Você sentiu que perdeu tempo recentemente?',
          'Como posso usar a experiência de hoje no futuro?',
          'Qual é o relacionamento mais importante para mim?',
          'Que objetivo pessoal quero alcançar este mês?',
          'Há algum hábito que quero mudar?',
          'A quem quero expressar minha gratidão?',
        ];
      case 'it':
        return [
          'Come sono cresciuto oggi?',
          'Cosa farei diversamente?',
          'Chi mi ha ispirato e perché?',
          'Cosa aspetto con impazienza?',
          'Come posso essere più gentile domani?',
          'C\'è stato un momento oggi in cui mi sono sentito orgoglioso di me stesso?',
          'Cosa hai imparato da un recente fallimento?',
          'Quali pensi siano i tuoi punti di forza?',
          'Hai aiutato qualcuno questa settimana?',
          'Come hai affrontato quando ti sei sentito stressato?',
          'Se ti valutassi oggi, quale voto e perché?',
          'Quale abitudine vorresti sviluppare di recente?',
          'Quali piccole cose ti rendono felice?',
          'Di cosa hai bisogno adesso?',
          'Hai sentito di aver sprecato tempo di recente?',
          'Come posso usare l\'esperienza di oggi in futuro?',
          'Qual è la relazione più importante per me?',
          'Quale obiettivo personale voglio raggiungere questo mese?',
          'C\'è un\'abitudine che voglio cambiare?',
          'A chi voglio esprimere la mia gratitudine?',
        ];
      case 'ru':
        return [
          'Как я вырос сегодня?',
          'Что бы я сделал иначе?',
          'Кто меня вдохновил и почему?',
          'Чего я с нетерпением жду?',
          'Как я могу быть добрее завтра?',
          'Был ли сегодня момент, когда я гордился собой?',
          'Что ты узнал из недавней неудачи?',
          'Какие, по-твоему, твои сильные стороны?',
          'Ты кому-нибудь помог на этой неделе?',
          'Как ты справлялся, когда чувствовал стресс?',
          'Если бы ты оценил себя сегодня, какую оценку и почему?',
          'Какую привычку ты хотел бы недавно развить?',
          'Какие мелочи делают тебя счастливым?',
          'Что тебе нужно прямо сейчас?',
          'Ты чувствовал, что недавно потратил время впустую?',
          'Как я могу использовать сегодняшний опыт в будущем?',
          'Какие отношения для меня самые важные?',
          'Какую личную цель я хочу достичь в этом месяце?',
          'Есть ли привычка, которую я хочу изменить?',
          'Кому я хочу выразить благодарность?',
        ];
      case 'zh':
        return [
          '我今天是如何成长的？',
          '我会做什么不同的事？',
          '谁激励了我，为什么？',
          '我期待什么？',
          '明天我怎样才能更友善？',
          '今天有没有一个时刻让我为自己感到骄傲？',
          '你从最近的失败中学到了什么？',
          '你认为你的优势是什么？',
          '这周你帮助过别人吗？',
          '当你感到压力时你是如何应对的？',
          '如果你今天给自己打分，什么分数，为什么？',
          '你最近想养成什么习惯？',
          '什么小事让你快乐？',
          '你现在需要什么？',
          '你最近有没有觉得浪费时间？',
          '我如何在未来利用今天的经验？',
          '对我来说最重要的关系是什么？',
          '我这个月想达成什么个人目标？',
          '有什么习惯我想改变？',
          '我想向谁表达感激之情？',
        ];
      case 'ar':
        return [
          'كيف نموت اليوم؟',
          'ماذا سأفعل بشكل مختلف؟',
          'من ألهمني ولماذا؟',
          'ما الذي أتطلع إليه؟',
          'كيف يمكنني أن أكون أكثر لطفًا غدًا؟',
          'هل كانت هناك لحظة اليوم شعرت فيها بالفخر بنفسي؟',
          'ماذا تعلمت من فشل حديث؟',
          'ما الذي تعتقد أنه نقاط قوتك؟',
          'هل ساعدت شخصًا ما هذا الأسبوع؟',
          'كيف تعاملت عندما شعرت بالتوتر؟',
          'إذا قيمت نفسك اليوم، ما الدرجة ولماذا؟',
          'ما العادة التي تود تطويرها مؤخرًا؟',
          'ما الأشياء الصغيرة التي تجعلك سعيدًا؟',
          'ما الذي تحتاجه الآن؟',
          'هل شعرت أنك أضعت الوقت مؤخرًا؟',
          'كيف يمكنني استخدام تجربة اليوم في المستقبل؟',
          'ما هي العلاقة الأكثر أهمية بالنسبة لي؟',
          'ما الهدف الشخصي الذي أريد تحقيقه هذا الشهر؟',
          'هل هناك عادة أريد تغييرها؟',
          'لمن أريد أن أعبر عن امتناني؟',
        ];
      case 'vi':
        return [
          'Tôi đã trưởng thành như thế nào hôm nay?',
          'Tôi sẽ làm gì khác đi?',
          'Ai đã truyền cảm hứng cho tôi và tại sao?',
          'Tôi đang mong đợi điều gì?',
          'Làm thế nào tôi có thể tử tế hơn vào ngày mai?',
          'Có khoảnh khắc nào hôm nay tôi cảm thấy tự hào về bản thân không?',
          'Bạn đã học được gì từ một thất bại gần đây?',
          'Bạn nghĩ điểm mạnh của bạn là gì?',
          'Bạn đã giúp ai đó tuần này chưa?',
          'Bạn đã đối phó như thế nào khi bạn cảm thấy căng thẳng?',
          'Nếu bạn tự đánh giá mình hôm nay, điểm số nào và tại sao?',
          'Thói quen nào bạn muốn phát triển gần đây?',
          'Những điều nhỏ nào làm bạn hạnh phúc?',
          'Bạn cần gì ngay bây giờ?',
          'Bạn có cảm thấy mình đã lãng phí thời gian gần đây không?',
          'Tôi có thể sử dụng kinh nghiệm hôm nay trong tương lai như thế nào?',
          'Mối quan hệ nào quan trọng nhất đối với tôi?',
          'Mục tiêu cá nhân nào tôi muốn đạt được tháng này?',
          'Có thói quen nào tôi muốn thay đổi không?',
          'Tôi muốn bày tỏ lòng biết ơn với ai?',
        ];
      case 'th':
        return [
          'วันนี้ฉันเติบโตขึ้นอย่างไร?',
          'ฉันจะทำอะไรแตกต่างออกไป?',
          'ใครเป็นแรงบันดาลใจให้ฉันและทำไม?',
          'ฉันกำลังตั้งตารออะไร?',
          'ฉันจะเป็นคนใจดีขึ้นในวันพรุ่งนี้ได้อย่างไร?',
          'มีช่วงเวลาไหนในวันนี้ที่ฉันรู้สึกภูมิใจในตัวเอง?',
          'คุณเรียนรู้อะไรจากความล้มเหลวเมื่อเร็วๆ นี้?',
          'คุณคิดว่าจุดแข็งของคุณคืออะไร?',
          'คุณช่วยใครบางคนในสัปดาห์นี้หรือไม่?',
          'คุณรับมืออย่างไรเมื่อคุณรู้สึกเครียด?',
          'ถ้าคุณให้คะแนนตัวเองวันนี้ คะแนนอะไรและทำไม?',
          'นิสัยอะไรที่คุณต้องการพัฒนาเมื่อเร็วๆ นี้?',
          'สิ่งเล็กๆ อะไรที่ทำให้คุณมีความสุข?',
          'คุณต้องการอะไรตอนนี้?',
          'คุณรู้สึกว่าคุณเสียเวลาเมื่อเร็วๆ นี้หรือไม่?',
          'ฉันจะใช้ประสบการณ์วันนี้ในอนาคตได้อย่างไร?',
          'ความสัมพันธ์ใดที่สำคัญที่สุดสำหรับฉัน?',
          'เป้าหมายส่วนตัวอะไรที่ฉันต้องการบรรลุในเดือนนี้?',
          'มีนิสัยอะไรที่ฉันต้องการเปลี่ยนแปลงหรือไม่?',
          'ฉันต้องการแสดงความกตัญญูต่อใคร?',
        ];
      default: // 'en'
        return [
          'How did I grow today?',
          'What would I do differently?',
          'Who inspired me and why?',
          'What am I looking forward to?',
          'How can I be kinder tomorrow?',
          'Was there a moment today I felt proud of myself?',
          'What did you learn from a recent failure?',
          'What do you think your strengths are?',
          'Did you help someone this week?',
          'How did you cope when you felt stressed?',
          'If you rated yourself today, what score and why?',
          'What habit would you like to develop recently?',
          'What small things make you happy?',
          'What do you need right now?',
          'Did you feel like you wasted time recently?',
          'How can I use today\'s experience in the future?',
          'What is the most important relationship for me?',
          'What personal goal do I want to achieve this month?',
          'Is there a habit I want to change?',
          'To whom do I want to express my gratitude?',
        ];
    }
  }

  List<String> _getTopicSuggestions(String lang) {
    final all = _getAllTopicSuggestions(lang);
    // _refreshCounter가 변경될 때마다 다시 섞임
    if (_refreshCounter >= 0) {
      all.shuffle();
    }
    return all.take(3).toList();
  }

  List<String> _getSentenceStarters(String lang) {
    final all = _getAllSentenceStarters(lang);
    // _refreshCounter가 변경될 때마다 다시 섞임
    if (_refreshCounter >= 0) {
      all.shuffle();
    }
    return all.take(4).toList();
  }

  List<String> _getReflectiveQuestions(String lang) {
    final all = _getAllReflectiveQuestions(lang);
    // _refreshCounter가 변경될 때마다 다시 섞임
    if (_refreshCounter >= 0) {
      all.shuffle();
    }
    return all.take(4).toList();
  }

  List<String> _deduplicateLangs(List<String> langs) {
    final seen = <String>{};
    final result = <String>[];
    for (final lang in langs) {
      if (lang.isEmpty) continue;
      if (seen.add(lang)) {
        result.add(lang);
      }
    }
    return result;
  }

  String _resolveSelectedLang(List<String> availableLangs, String fallback) {
    if (availableLangs.isEmpty) {
      final resolved = _selectedLang ?? fallback;
      if (_selectedLang != resolved) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _selectedLang = resolved;
          });
        });
      }
      return resolved;
    }

    final current = _selectedLang;
    if (current != null && availableLangs.contains(current)) {
      return current;
    }

    final resolved = availableLangs.first;
    if (_selectedLang != resolved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedLang = resolved;
        });
      });
    }
    return resolved;
  }

  Widget _buildLanguageSelector({
    required BuildContext context,
    required List<String> availableLangs,
    required String currentLang,
    required AppLocalizations l10n,
    required String uid,
  }) {
    if (availableLangs.isEmpty || availableLangs.length <= 1) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableLangs.map((lang) {
        final isSelected = currentLang == lang;
        return ActionChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageFlag(lang),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                localizedLanguageLabel(lang, l10n),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
          onPressed: () {
            if (lang != currentLang) {
              setState(() {
                _selectedLang = lang;
              });
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final userDoc = ref.watch(currentUserDocProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/');
            });
            return const Center(child: CircularProgressIndicator());
          }

          return userDoc.when(
            data: (userData) {
              if (userData == null) {
                return Center(child: Text(l10n.loadingUserData));
              }

              // 학습 언어 가져오기
              final availableLangs = _deduplicateLangs(userData.learnLangs);
              final primaryLang =
                  _resolveSelectedLang(availableLangs, userData.nativeLang);

              // 하드코딩된 제안 사용
              final topics = _getTopicSuggestions(primaryLang);
              final starters = _getSentenceStarters(primaryLang);
              final questions = _getReflectiveQuestions(primaryLang);

              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome section
                        Text(
                          l10n.welcome(userData.displayName),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => context.push('/streak'),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                l10n.dayStreak(userData.streak),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Write diary button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/editor');
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.writeTodayDiary),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Language Selector
                        if (availableLangs.isNotEmpty) ...[
                          _buildLanguageSelector(
                            context: context,
                            availableLangs: availableLangs,
                            currentLang: primaryLang,
                            l10n: l10n,
                            uid: user.uid,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Topic Suggestions
                        Row(
                          children: [
                            Icon(Icons.lightbulb,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              l10n.topicSuggestions,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              tooltip: l10n.refresh,
                              onPressed: () {
                                setState(() {
                                  _refreshCounter++;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSuggestionsList(context, topics),
                        const SizedBox(height: 24),

                        // Sentence Starters
                        Row(
                          children: [
                            Icon(Icons.create,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              l10n.sentenceSuggestions,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSuggestionsList(context, starters),
                        const SizedBox(height: 24),

                        // Reflective Questions
                        Row(
                          children: [
                            Icon(Icons.psychology,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              l10n.reflectiveSuggestions,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSuggestionsList(context, questions),
                      ],
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context, List<String> suggestions) {
    return Column(
      children: suggestions.map((suggestion) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push('/editor', extra: {'topic': suggestion});
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class LearningMethod {
  const LearningMethod({
    required this.id,
    required this.icon,
    required this.animation,
    required this.title,
    required this.description,
  });

  final String id;
  final String icon;
  final String animation;
  final String title;
  final String description;
}

abstract final class ModernLearningRepository {
  static List<LearningMethod> methods(String locale) {
    final copy = _copy[locale] ?? _copy['en']!;
    const definitions = [
      ('retrieval', '🧠', 'assets/lottie/brain_pulse.json'),
      ('spaced', '⏳', 'assets/lottie/spaced_review.json'),
      ('interleaving', '🔀', 'assets/lottie/interleave_cards.json'),
      ('dictation', '✍️', 'assets/lottie/dictation_pen.json'),
      ('chunks', '🧩', 'assets/lottie/chunk_builder.json'),
      ('shadow', '🎙️', 'assets/lottie/shadowing_wave.json'),
      ('input', '📖', 'assets/lottie/comprehensible_input.json'),
      ('conversation', '💬', 'assets/lottie/conversation_mission.json'),
      ('pronunciation', '👄', 'assets/lottie/pronunciation.json'),
      ('memory', '🗂️', 'assets/lottie/memory_clock.json'),
      ('error', '🛠️', 'assets/lottie/error_repair.json'),
      ('speed', '⚡', 'assets/lottie/fluency_sprint.json'),
    ];
    return [
      for (var i = 0; i < definitions.length; i++)
        LearningMethod(
          id: definitions[i].$1,
          icon: definitions[i].$2,
          animation: definitions[i].$3,
          title: copy.titles[i],
          description: copy.descriptions[i],
        ),
    ];
  }

  static _LearningCopy copy(String locale) => _copy[locale] ?? _copy['en']!;

  static const _copy = <String, _LearningCopy>{
    'en': _LearningCopy(
      hubTitle: 'Nexa Learning Labs',
      hubSubtitle:
          'Modern practice methods for memory, listening, speaking, grammar, and real-world fluency.',
      start: 'Start lab',
      reveal: 'Reveal meaning',
      next: 'Next card',
      knewIt: 'I knew it',
      reviewIt: 'Review again',
      sessionDone: 'Session complete',
      sessionHint: 'Say the phrase aloud before revealing the meaning.',
      titles: [
        'Active Retrieval',
        'Spaced Review',
        'Interleaving Mix',
        'Dictation Studio',
        'Chunk Builder',
        'Shadowing Loop',
        'Comprehensible Input',
        'Conversation Missions',
        'Pronunciation Focus',
        'Memory Decks',
        'Error Repair',
        'Fluency Sprint',
      ],
      descriptions: [
        'Recall before looking. Strengthen memory by forcing the answer to come from you.',
        'Return to material at expanding intervals so difficult items appear more often.',
        'Mix vocabulary, grammar, listening, and meaning instead of drilling one skill in isolation.',
        'Listen, write, compare, and repair small details that ordinary reading can hide.',
        'Learn reusable word groups and sentence frames instead of translating one word at a time.',
        'Repeat immediately after a model to train rhythm, timing, pronunciation, and automaticity.',
        'Read and listen to understandable messages with enough context to infer new language.',
        'Practice goal-based situations such as travel, health, study, work, and everyday life.',
        'Work on one sound or rhythm target at a time, then return it to a complete phrase.',
        'Build personal review decks from the language you actually encounter and need.',
        'Turn repeated mistakes into a focused review queue instead of ignoring them.',
        'Short timed rounds improve fast recognition and confident production under light pressure.',
      ],
    ),
    'ar': _LearningCopy(
      hubTitle: 'مختبرات Nexa للتعلّم',
      hubSubtitle:
          'طرق تدريب حديثة للذاكرة والاستماع والتحدث والقواعد والطلاقة في المواقف الحقيقية.',
      start: 'ابدأ المختبر',
      reveal: 'أظهر المعنى',
      next: 'البطاقة التالية',
      knewIt: 'كنت أعرفها',
      reviewIt: 'راجعها مرة أخرى',
      sessionDone: 'اكتملت الجلسة',
      sessionHint: 'انطق العبارة بصوت عالٍ قبل إظهار معناها.',
      titles: [
        'الاسترجاع النشط',
        'المراجعة المتباعدة',
        'التدريب المتداخل',
        'مختبر الإملاء',
        'بناء العبارات',
        'الترديد المتزامن',
        'المدخل المفهوم',
        'مهمات المحادثة',
        'تركيز النطق',
        'بطاقات الذاكرة',
        'إصلاح الأخطاء',
        'سباق الطلاقة',
      ],
      descriptions: [
        'استرجع الإجابة قبل رؤيتها لتقوية الذاكرة وتحويل المعرفة إلى قدرة جاهزة للاستخدام.',
        'عد إلى المادة على فترات متزايدة مع تكرار أكبر للعناصر الصعبة.',
        'اخلط المفردات والقواعد والاستماع والمعنى بدل تدريب مهارة واحدة بشكل منفصل.',
        'استمع واكتب ثم قارن وأصلح التفاصيل الصغيرة التي قد تخفيها القراءة العادية.',
        'تعلّم مجموعات الكلمات وقوالب الجمل القابلة لإعادة الاستخدام بدل الترجمة كلمة بكلمة.',
        'كرر مباشرة بعد النموذج لتدريب الإيقاع والتوقيت والنطق والسرعة التلقائية.',
        'اقرأ واستمع إلى رسائل مفهومة مع سياق كافٍ يساعدك على استنتاج اللغة الجديدة.',
        'تدرّب على مواقف لها هدف واضح مثل السفر والصحة والدراسة والعمل والحياة اليومية.',
        'ركّز على صوت أو إيقاع واحد ثم أعده إلى عبارة كاملة وطبيعية.',
        'أنشئ بطاقات مراجعة شخصية من اللغة التي تقابلها وتحتاجها فعلًا.',
        'حوّل الأخطاء المتكررة إلى قائمة مراجعة مركزة بدل تجاهلها.',
        'جولات قصيرة موقّتة ترفع سرعة التعرّف والثقة في الإنتاج تحت ضغط خفيف.',
      ],
    ),
    'es': _LearningCopy.simple(
      'Laboratorios Nexa', 'Métodos modernos para memoria, escucha, habla y fluidez.',
      ['Recuperación activa','Repaso espaciado','Práctica intercalada','Dictado','Bloques de frase','Shadowing','Input comprensible','Misiones de conversación','Pronunciación','Tarjetas de memoria','Reparar errores','Sprint de fluidez'],
    ),
    'fr': _LearningCopy.simple(
      'Laboratoires Nexa', 'Méthodes modernes pour la mémoire, l’écoute, l’oral et la fluidité.',
      ['Rappel actif','Révision espacée','Entraînement mélangé','Dictée','Blocs de phrases','Shadowing','Input compréhensible','Missions de conversation','Prononciation','Cartes mémoire','Correction des erreurs','Sprint de fluidité'],
    ),
    'de': _LearningCopy.simple(
      'Nexa Lernlabore', 'Moderne Methoden für Gedächtnis, Hören, Sprechen und Flüssigkeit.',
      ['Aktiver Abruf','Verteilte Wiederholung','Gemischtes Training','Diktat','Satzbausteine','Shadowing','Verständlicher Input','Gesprächsmissionen','Aussprache','Memory-Karten','Fehlerreparatur','Flüssigkeits-Sprint'],
    ),
    'tr': _LearningCopy.simple(
      'Nexa Öğrenme Laboratuvarları', 'Hafıza, dinleme, konuşma ve akıcılık için modern yöntemler.',
      ['Aktif hatırlama','Aralıklı tekrar','Karışık çalışma','Dikte','Cümle kalıpları','Gölgeleme','Anlaşılabilir girdi','Konuşma görevleri','Telaffuz','Hafıza kartları','Hata onarımı','Akıcılık sprinti'],
    ),
    'pt': _LearningCopy.simple(
      'Laboratórios Nexa', 'Métodos modernos para memória, escuta, fala e fluência.',
      ['Recuperação ativa','Revisão espaçada','Prática intercalada','Ditado','Blocos de frase','Shadowing','Input compreensível','Missões de conversa','Pronúncia','Cartões de memória','Reparar erros','Sprint de fluência'],
    ),
    'it': _LearningCopy.simple(
      'Laboratori Nexa', 'Metodi moderni per memoria, ascolto, parlato e fluidità.',
      ['Recupero attivo','Ripasso dilazionato','Pratica intercalata','Dettato','Blocchi di frase','Shadowing','Input comprensibile','Missioni di conversazione','Pronuncia','Schede di memoria','Riparazione errori','Sprint di fluidità'],
    ),
    'ru': _LearningCopy.simple(
      'Лаборатории Nexa', 'Современные методы для памяти, аудирования, речи и беглости.',
      ['Активное извлечение','Интервальное повторение','Смешанная практика','Диктант','Фразовые блоки','Шэдоуинг','Понятный ввод','Разговорные миссии','Произношение','Карточки памяти','Исправление ошибок','Спринт беглости'],
    ),
    'zh': _LearningCopy.simple(
      'Nexa 学习实验室', '面向记忆、听力、口语和流利度的现代训练方法。',
      ['主动回忆','间隔复习','交错练习','听写训练','语块构建','跟读训练','可理解输入','对话任务','发音训练','记忆卡片','错误修复','流利度冲刺'],
    ),
    'ja': _LearningCopy.simple(
      'Nexa 学習ラボ', '記憶・リスニング・会話・流暢さのための現代的な練習法。',
      ['能動的想起','間隔復習','交互練習','ディクテーション','チャンク練習','シャドーイング','理解可能なインプット','会話ミッション','発音練習','記憶カード','エラー修正','流暢さスプリント'],
    ),
    'ko': _LearningCopy.simple(
      'Nexa 학습 랩', '기억, 듣기, 말하기, 유창성을 위한 현대적 학습 방법.',
      ['능동 회상','간격 복습','교차 연습','받아쓰기','문장 덩어리','섀도잉','이해 가능한 입력','대화 미션','발음 집중','기억 카드','오류 수정','유창성 스프린트'],
    ),
  };
}

class _LearningCopy {
  const _LearningCopy({
    required this.hubTitle,
    required this.hubSubtitle,
    required this.start,
    required this.reveal,
    required this.next,
    required this.knewIt,
    required this.reviewIt,
    required this.sessionDone,
    required this.sessionHint,
    required this.titles,
    required this.descriptions,
  });

  const _LearningCopy.simple(this.hubTitle, this.hubSubtitle, this.titles)
      : start = 'Start',
        reveal = 'Reveal',
        next = 'Next',
        knewIt = 'Known',
        reviewIt = 'Review',
        sessionDone = 'Complete',
        sessionHint = 'Say the phrase aloud before revealing the meaning.',
        descriptions = const [
          'Recall the answer before looking at it.',
          'Review material again at expanding intervals.',
          'Mix several skills instead of isolating one pattern.',
          'Listen, write, compare, and repair details.',
          'Learn reusable groups of words and sentence frames.',
          'Repeat immediately after a model to train rhythm.',
          'Learn from messages that are understandable from context.',
          'Practice real situations with a clear communication goal.',
          'Focus on one sound or rhythm target at a time.',
          'Keep personal cards for language you really need.',
          'Turn repeated mistakes into focused review.',
          'Use short timed rounds to improve automaticity.',
        ];

  final String hubTitle;
  final String hubSubtitle;
  final String start;
  final String reveal;
  final String next;
  final String knewIt;
  final String reviewIt;
  final String sessionDone;
  final String sessionHint;
  final List<String> titles;
  final List<String> descriptions;
}

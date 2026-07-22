import 'dart:math';

import '../models/models.dart';
import 'global_content_repository.dart';

class _AlignedPhrase {
  const _AlignedPhrase({
    required this.target,
    required this.meaning,
    required this.visual,
    required this.category,
  });
  final String target;
  final String meaning;
  final String visual;
  final String category;
}

abstract final class CourseRepository {
  static const levels = [
    LearningLevel(
      code: 'A1',
      title: 'Foundation',
      description: 'Words, sounds, and essential exchanges',
      colorValue: 0xFF6C63FF,
    ),
    LearningLevel(
      code: 'A2',
      title: 'Everyday',
      description: 'Daily routines, travel, and simple stories',
      colorValue: 0xFF22C7A9,
    ),
    LearningLevel(
      code: 'B1',
      title: 'Independent',
      description: 'Opinions, experiences, and longer conversations',
      colorValue: 0xFFFFA94D,
    ),
    LearningLevel(
      code: 'B2',
      title: 'Confident',
      description: 'Nuance, work, media, and spontaneous speech',
      colorValue: 0xFF4DABF7,
    ),
    LearningLevel(
      code: 'C1',
      title: 'Advanced',
      description: 'Persuasion, academic language, and style',
      colorValue: 0xFFFF6B8A,
    ),
    LearningLevel(
      code: 'C2',
      title: 'Mastery',
      description: 'Precision, idiom, culture, and expert expression',
      colorValue: 0xFFB197FC,
    ),
  ];

  static const _topics = [
    (
      'First contact',
      'Introductions and useful social phrases',
      '👋',
      'Introductions',
    ),
    (
      'Essential communication',
      'Repair misunderstandings and ask for help',
      '🗣️',
      'Essentials',
    ),
    ('Café & food', 'Order naturally and understand the menu', '☕', 'Food'),
    (
      'Airport & flights',
      'Check in, find gates, and handle delays',
      '🛫',
      'Travel',
    ),
    (
      'Transport & directions',
      'Move around confidently and ask the way',
      '🗺️',
      'Travel',
    ),
    (
      'Hotel stay',
      'Reserve, check in, make requests, and check out',
      '🏨',
      'Hotel',
    ),
    (
      'Shopping & money',
      'Compare, choose, pay, and solve purchase problems',
      '🛍️',
      'Shopping',
    ),
    (
      'At the doctor',
      'Describe symptoms and understand basic care',
      '🩺',
      'Health',
    ),
    (
      'Emergencies',
      'Get urgent help and share essential information',
      '🚨',
      'Emergencies',
    ),
    (
      'People & relationships',
      'Connect, invite, respond, and share interests',
      '🤝',
      'Relationships',
    ),
    (
      'Home & daily life',
      'Talk about routines, needs, and responsibilities',
      '🏡',
      'Essentials',
    ),
    (
      'Work & meetings',
      'Communicate clearly in professional settings',
      '💼',
      'Work',
    ),
    (
      'Study & learning',
      'Ask questions and manage academic tasks',
      '🎓',
      'Work',
    ),
    (
      'Technology & support',
      'Use devices, internet, and digital services',
      '📱',
      'Technology',
    ),
    (
      'Stories & culture',
      'Understand context, tone, and local customs',
      '🎭',
      'Culture',
    ),
  ];

  static const Map<String, Map<String, String>> _instructionText = {
    'en': {
      'discover': 'Discover',
      'listen': 'Listen',
      'build': 'Build',
      'speak': 'Speak',
      'challenge': 'Challenge',
      'tap_recall': 'Tap the card when you can recall the meaning.',
      'choose_expression': 'Choose the expression for “{meaning}”.',
      'listen_rhythm': 'Listen for the rhythm, not only individual sounds.',
      'listen_choose': 'Listen, then choose what you heard.',
      'build_expression': 'Build the expression.',
      'start_word': 'Start with the word you recognize.',
      'say_expression': 'Say this expression with a steady rhythm.',
      'starts_with': 'It starts with “{letter}”.',
      'context_matters': 'Context matters',
      'context_note':
          'Notice formality, gesture, and tone. The same words can feel different across regions and situations.',
      'best_fit': 'Choose the phrase that best fits this real-world moment.',
      'use_naturally': 'Use “{meaning}” naturally and politely.',
      'complete_recall': 'Listen in your mind, then complete: {first} ____',
      'recall_hint': 'Recall the full expression before checking.',
      'use_three': 'Use all three expressions in a short real-life response.',
    },
    'ar': {
      'discover': 'اكتشف',
      'listen': 'استمع',
      'build': 'كوّن',
      'speak': 'تحدث',
      'challenge': 'تحدٍّ',
      'tap_recall': 'اضغط على البطاقة عندما تتذكر المعنى.',
      'choose_expression': 'اختر العبارة التي تعني «{meaning}».',
      'listen_rhythm': 'استمع إلى إيقاع العبارة، وليس إلى الأصوات المفردة فقط.',
      'listen_choose': 'استمع ثم اختر ما سمعته.',
      'build_expression': 'كوّن العبارة بالترتيب الصحيح.',
      'start_word': 'ابدأ بالكلمة التي تعرفها.',
      'say_expression': 'انطق هذه العبارة بإيقاع ثابت وواضح.',
      'starts_with': 'تبدأ بالحرف «{letter}».',
      'context_matters': 'السياق مهم',
      'context_note':
          'انتبه إلى الرسمية والإشارة ونبرة الصوت؛ فقد يختلف أثر الكلمات حسب المنطقة والموقف.',
      'best_fit': 'اختر العبارة الأنسب لهذا الموقف الحقيقي.',
      'use_naturally': 'استخدم معنى «{meaning}» بصورة طبيعية ومهذبة.',
      'complete_recall': 'تخيّل النطق ثم أكمل: {first} ____',
      'recall_hint': 'تذكر العبارة كاملة قبل التحقق.',
      'use_three': 'استخدم العبارات الثلاث في إجابة قصيرة من موقف حقيقي.',
    },
    'es': {
      'discover': 'Descubre',
      'listen': 'Escucha',
      'build': 'Construye',
      'speak': 'Habla',
      'challenge': 'Reto',
      'tap_recall': 'Toca la tarjeta cuando recuerdes el significado.',
      'choose_expression': 'Elige la expresión para «{meaning}».',
      'listen_rhythm': 'Escucha el ritmo, no solo los sonidos.',
      'listen_choose': 'Escucha y elige lo que oíste.',
      'build_expression': 'Construye la expresión.',
      'start_word': 'Empieza por la palabra que reconoces.',
      'say_expression': 'Di la expresión con un ritmo constante.',
      'starts_with': 'Empieza por «{letter}».',
      'context_matters': 'El contexto importa',
      'context_note':
          'Observa la formalidad, los gestos y el tono; las palabras cambian según la situación.',
      'best_fit': 'Elige la frase que mejor encaja en esta situación.',
      'use_naturally': 'Usa «{meaning}» con naturalidad y cortesía.',
      'complete_recall': 'Escúchala mentalmente y completa: {first} ____',
      'recall_hint': 'Recuerda la expresión completa antes de comprobar.',
      'use_three': 'Usa las tres expresiones en una respuesta breve y real.',
    },
    'fr': {
      'discover': 'Découvrir',
      'listen': 'Écouter',
      'build': 'Construire',
      'speak': 'Parler',
      'challenge': 'Défi',
      'tap_recall': 'Touchez la carte lorsque vous vous rappelez le sens.',
      'choose_expression': 'Choisissez l’expression pour « {meaning} ».',
      'listen_rhythm': 'Écoutez le rythme, pas seulement les sons.',
      'listen_choose': 'Écoutez puis choisissez ce que vous avez entendu.',
      'build_expression': 'Construisez l’expression.',
      'start_word': 'Commencez par le mot reconnu.',
      'say_expression': 'Dites cette expression avec un rythme régulier.',
      'starts_with': 'Elle commence par « {letter} ».',
      'context_matters': 'Le contexte compte',
      'context_note':
          'Observez la formalité, les gestes et le ton; l’effet varie selon la situation.',
      'best_fit': 'Choisissez la phrase adaptée à cette situation réelle.',
      'use_naturally': 'Utilisez « {meaning} » naturellement et poliment.',
      'complete_recall': 'Écoutez mentalement puis complétez : {first} ____',
      'recall_hint': 'Rappelez-vous toute l’expression avant de vérifier.',
      'use_three':
          'Utilisez les trois expressions dans une courte réponse réelle.',
    },
    'de': {
      'discover': 'Entdecken',
      'listen': 'Hören',
      'build': 'Bilden',
      'speak': 'Sprechen',
      'challenge': 'Aufgabe',
      'tap_recall':
          'Tippe auf die Karte, wenn du dich an die Bedeutung erinnerst.',
      'choose_expression': 'Wähle den Ausdruck für „{meaning}“.',
      'listen_rhythm': 'Achte auf den Rhythmus, nicht nur auf einzelne Laute.',
      'listen_choose': 'Höre zu und wähle das Gehörte.',
      'build_expression': 'Bilde den Ausdruck.',
      'start_word': 'Beginne mit dem Wort, das du erkennst.',
      'say_expression': 'Sprich den Ausdruck in gleichmäßigem Rhythmus.',
      'starts_with': 'Es beginnt mit „{letter}“.',
      'context_matters': 'Der Kontext zählt',
      'context_note':
          'Achte auf Förmlichkeit, Gestik und Ton; Wörter wirken je nach Situation anders.',
      'best_fit': 'Wähle den passenden Satz für diesen Moment.',
      'use_naturally': 'Verwende „{meaning}“ natürlich und höflich.',
      'complete_recall': 'Höre innerlich und ergänze: {first} ____',
      'recall_hint': 'Erinnere dich vor dem Prüfen an den ganzen Ausdruck.',
      'use_three': 'Verwende alle drei Ausdrücke in einer kurzen Antwort.',
    },
    'tr': {
      'discover': 'Keşfet',
      'listen': 'Dinle',
      'build': 'Oluştur',
      'speak': 'Konuş',
      'challenge': 'Görev',
      'tap_recall': 'Anlamı hatırladığınızda karta dokunun.',
      'choose_expression': '“{meaning}” anlamındaki ifadeyi seçin.',
      'listen_rhythm': 'Yalnız sesleri değil, ritmi de dinleyin.',
      'listen_choose': 'Dinleyin ve duyduğunuzu seçin.',
      'build_expression': 'İfadeyi oluşturun.',
      'start_word': 'Tanıdığınız kelimeyle başlayın.',
      'say_expression': 'İfadeyi düzenli bir ritimle söyleyin.',
      'starts_with': '“{letter}” ile başlıyor.',
      'context_matters': 'Bağlam önemlidir',
      'context_note':
          'Resmiyet, jest ve tona dikkat edin; sözcüklerin etkisi duruma göre değişir.',
      'best_fit': 'Bu gerçek duruma en uygun ifadeyi seçin.',
      'use_naturally': '“{meaning}” anlamını doğal ve kibar biçimde kullanın.',
      'complete_recall': 'Zihninizde dinleyip tamamlayın: {first} ____',
      'recall_hint': 'Kontrol etmeden önce tam ifadeyi hatırlayın.',
      'use_three': 'Üç ifadeyi kısa bir gerçek yaşam yanıtında kullanın.',
    },
    'pt': {
      'discover': 'Descobrir',
      'listen': 'Ouvir',
      'build': 'Construir',
      'speak': 'Falar',
      'challenge': 'Desafio',
      'tap_recall': 'Toque no cartão quando recordar o significado.',
      'choose_expression': 'Escolha a expressão para «{meaning}».',
      'listen_rhythm': 'Ouça o ritmo, não apenas os sons.',
      'listen_choose': 'Ouça e escolha o que ouviu.',
      'build_expression': 'Construa a expressão.',
      'start_word': 'Comece pela palavra que reconhece.',
      'say_expression': 'Diga a expressão com ritmo constante.',
      'starts_with': 'Começa por «{letter}».',
      'context_matters': 'O contexto importa',
      'context_note':
          'Observe formalidade, gesto e tom; o efeito muda conforme a situação.',
      'best_fit': 'Escolha a frase adequada a este momento real.',
      'use_naturally': 'Use «{meaning}» de forma natural e educada.',
      'complete_recall': 'Ouça mentalmente e complete: {first} ____',
      'recall_hint': 'Recorde a expressão inteira antes de verificar.',
      'use_three': 'Use as três expressões numa resposta breve e real.',
    },
    'it': {
      'discover': 'Scopri',
      'listen': 'Ascolta',
      'build': 'Costruisci',
      'speak': 'Parla',
      'challenge': 'Sfida',
      'tap_recall': 'Tocca la carta quando ricordi il significato.',
      'choose_expression': 'Scegli l’espressione per «{meaning}».',
      'listen_rhythm': 'Ascolta il ritmo, non solo i suoni.',
      'listen_choose': 'Ascolta e scegli ciò che hai sentito.',
      'build_expression': 'Costruisci l’espressione.',
      'start_word': 'Inizia dalla parola che riconosci.',
      'say_expression': 'Pronuncia l’espressione con ritmo regolare.',
      'starts_with': 'Inizia con «{letter}».',
      'context_matters': 'Il contesto conta',
      'context_note':
          'Nota formalità, gesti e tono; l’effetto cambia secondo la situazione.',
      'best_fit': 'Scegli la frase adatta a questa situazione reale.',
      'use_naturally': 'Usa «{meaning}» in modo naturale e cortese.',
      'complete_recall': 'Ascolta nella mente e completa: {first} ____',
      'recall_hint': 'Ricorda l’espressione completa prima di controllare.',
      'use_three': 'Usa le tre espressioni in una breve risposta reale.',
    },
    'ru': {
      'discover': 'Изучить',
      'listen': 'Слушать',
      'build': 'Составить',
      'speak': 'Говорить',
      'challenge': 'Задание',
      'tap_recall': 'Нажмите на карточку, когда вспомните значение.',
      'choose_expression': 'Выберите выражение со значением «{meaning}».',
      'listen_rhythm': 'Слушайте ритм, а не только отдельные звуки.',
      'listen_choose': 'Прослушайте и выберите услышанное.',
      'build_expression': 'Составьте выражение.',
      'start_word': 'Начните со знакомого слова.',
      'say_expression': 'Произнесите выражение в ровном ритме.',
      'starts_with': 'Начинается с «{letter}».',
      'context_matters': 'Контекст важен',
      'context_note':
          'Учитывайте официальность, жесты и тон; эффект слов зависит от ситуации.',
      'best_fit': 'Выберите фразу для этой реальной ситуации.',
      'use_naturally': 'Используйте «{meaning}» естественно и вежливо.',
      'complete_recall': 'Воспроизведите мысленно и дополните: {first} ____',
      'recall_hint': 'Вспомните всё выражение до проверки.',
      'use_three': 'Используйте три выражения в коротком ответе.',
    },
    'zh': {
      'discover': '发现',
      'listen': '听力',
      'build': '组句',
      'speak': '口语',
      'challenge': '挑战',
      'tap_recall': '想起含义后点击卡片。',
      'choose_expression': '选择表示“{meaning}”的表达。',
      'listen_rhythm': '注意节奏，而不仅是单个声音。',
      'listen_choose': '听后选择你听到的内容。',
      'build_expression': '组成正确表达。',
      'start_word': '从认识的词开始。',
      'say_expression': '用稳定节奏说出这个表达。',
      'starts_with': '以“{letter}”开头。',
      'context_matters': '语境很重要',
      'context_note': '注意正式程度、手势和语调；同一句话在不同场景中感受不同。',
      'best_fit': '选择最适合这个真实场景的短语。',
      'use_naturally': '自然、礼貌地表达“{meaning}”。',
      'complete_recall': '在脑中聆听，然后完成：{first} ____',
      'recall_hint': '检查前先回忆完整表达。',
      'use_three': '在简短的真实回答中使用三个表达。',
    },
    'ja': {
      'discover': '発見',
      'listen': '聞く',
      'build': '組み立て',
      'speak': '話す',
      'challenge': '挑戦',
      'tap_recall': '意味を思い出したらカードをタップします。',
      'choose_expression': '「{meaning}」を表す表現を選びます。',
      'listen_rhythm': '個々の音だけでなくリズムも聞きましょう。',
      'listen_choose': '聞いて、聞こえた内容を選びます。',
      'build_expression': '表現を組み立てます。',
      'start_word': '分かる単語から始めます。',
      'say_expression': '一定のリズムで表現を言いましょう。',
      'starts_with': '「{letter}」で始まります。',
      'context_matters': '文脈が大切です',
      'context_note': '丁寧さ、身振り、口調に注目しましょう。同じ言葉でも場面で印象が変わります。',
      'best_fit': 'この実際の場面に最適な表現を選びます。',
      'use_naturally': '「{meaning}」を自然かつ丁寧に使いましょう。',
      'complete_recall': '頭の中で聞いて完成させます：{first} ____',
      'recall_hint': '確認前に表現全体を思い出しましょう。',
      'use_three': '3つの表現を短い実生活の回答で使います。',
    },
    'ko': {
      'discover': '발견',
      'listen': '듣기',
      'build': '문장 만들기',
      'speak': '말하기',
      'challenge': '도전',
      'tap_recall': '뜻이 기억나면 카드를 누르세요.',
      'choose_expression': '“{meaning}”에 해당하는 표현을 고르세요.',
      'listen_rhythm': '개별 소리뿐 아니라 리듬을 들으세요.',
      'listen_choose': '듣고 들린 표현을 고르세요.',
      'build_expression': '표현을 완성하세요.',
      'start_word': '알아보는 단어부터 시작하세요.',
      'say_expression': '일정한 리듬으로 표현을 말하세요.',
      'starts_with': '“{letter}”로 시작합니다.',
      'context_matters': '문맥이 중요합니다',
      'context_note': '격식, 몸짓과 어조를 살피세요. 같은 말도 상황에 따라 느낌이 달라집니다.',
      'best_fit': '이 실제 상황에 가장 알맞은 표현을 고르세요.',
      'use_naturally': '“{meaning}”을 자연스럽고 공손하게 사용하세요.',
      'complete_recall': '머릿속으로 듣고 완성하세요: {first} ____',
      'recall_hint': '확인하기 전에 전체 표현을 떠올리세요.',
      'use_three': '세 표현을 짧은 실생활 답변에 사용하세요.',
    },
  };

  /// Starter lexicon bundled for every catalog language. Content teams can
  /// replace or expand it through the admin JSON workflow.
  static const Map<String, List<String>> starterLexicon = {
    'en': ['Hello', 'Thank you', 'Please', 'Goodbye'],
    'ar': ['مرحبًا', 'شكرًا', 'من فضلك', 'إلى اللقاء'],
    'es': ['Hola', 'Gracias', 'Por favor', 'Adiós'],
    'fr': ['Bonjour', 'Merci', "S’il vous plaît", 'Au revoir'],
    'de': ['Hallo', 'Danke', 'Bitte', 'Auf Wiedersehen'],
    'it': ['Ciao', 'Grazie', 'Per favore', 'Arrivederci'],
    'pt': ['Olá', 'Obrigado', 'Por favor', 'Adeus'],
    'ru': ['Здравствуйте', 'Спасибо', 'Пожалуйста', 'До свидания'],
    'tr': ['Merhaba', 'Teşekkür ederim', 'Lütfen', 'Hoşça kal'],
    'zh': ['你好', '谢谢', '请', '再见'],
    'ja': ['こんにちは', 'ありがとう', 'お願いします', 'さようなら'],
    'ko': ['안녕하세요', '감사합니다', '부탁합니다', '안녕히 가세요'],
    'hi': ['नमस्ते', 'धन्यवाद', 'कृपया', 'अलविदा'],
    'ur': ['السلام علیکم', 'شکریہ', 'براہ کرم', 'خدا حافظ'],
    'fa': ['سلام', 'ممنون', 'لطفاً', 'خداحافظ'],
    'he': ['שלום', 'תודה', 'בבקשה', 'להתראות'],
    'nl': ['Hallo', 'Dank je', 'Alsjeblieft', 'Tot ziens'],
    'sv': ['Hej', 'Tack', 'Snälla', 'Hej då'],
    'no': ['Hei', 'Takk', 'Vær så snill', 'Ha det'],
    'da': ['Hej', 'Tak', 'Vær venlig', 'Farvel'],
    'fi': ['Hei', 'Kiitos', 'Ole hyvä', 'Näkemiin'],
    'pl': ['Cześć', 'Dziękuję', 'Proszę', 'Do widzenia'],
    'cs': ['Ahoj', 'Děkuji', 'Prosím', 'Na shledanou'],
    'sk': ['Ahoj', 'Ďakujem', 'Prosím', 'Dovidenia'],
    'hu': ['Szia', 'Köszönöm', 'Kérem', 'Viszontlátásra'],
    'ro': ['Bună', 'Mulțumesc', 'Vă rog', 'La revedere'],
    'bg': ['Здравейте', 'Благодаря', 'Моля', 'Довиждане'],
    'uk': ['Привіт', 'Дякую', 'Будь ласка', 'До побачення'],
    'el': ['Γεια σας', 'Ευχαριστώ', 'Παρακαλώ', 'Αντίο'],
    'id': ['Halo', 'Terima kasih', 'Tolong', 'Selamat tinggal'],
    'ms': ['Helo', 'Terima kasih', 'Tolong', 'Selamat tinggal'],
    'th': ['สวัสดี', 'ขอบคุณ', 'กรุณา', 'ลาก่อน'],
    'vi': ['Xin chào', 'Cảm ơn', 'Làm ơn', 'Tạm biệt'],
    'fil': ['Kumusta', 'Salamat', 'Pakiusap', 'Paalam'],
    'sw': ['Jambo', 'Asante', 'Tafadhali', 'Kwaheri'],
    'am': ['ሰላም', 'አመሰግናለሁ', 'እባክዎ', 'ደህና ሁን'],
    'ha': ['Sannu', 'Na gode', 'Don Allah', 'Sai an jima'],
    'yo': ['Báwo', 'Ẹ ṣé', 'Jọ̀wọ́', 'Ó dàbọ̀'],
    'ig': ['Ndewo', 'Daalụ', 'Biko', 'Ka ọ dị'],
    'zu': ['Sawubona', 'Ngiyabonga', 'Ngiyacela', 'Hamba kahle'],
    'af': ['Hallo', 'Dankie', 'Asseblief', 'Totsiens'],
    'ca': ['Hola', 'Gràcies', 'Si us plau', 'Adéu'],
    'eu': ['Kaixo', 'Eskerrik asko', 'Mesedez', 'Agur'],
    'gl': ['Ola', 'Grazas', 'Por favor', 'Adeus'],
    'cy': ['Helo', 'Diolch', 'Os gwelwch yn dda', 'Hwyl fawr'],
    'ga': ['Dia dhuit', 'Go raibh maith agat', 'Le do thoil', 'Slán'],
    'is': ['Halló', 'Takk', 'Vinsamlegast', 'Bless'],
    'sq': ['Përshëndetje', 'Faleminderit', 'Ju lutem', 'Mirupafshim'],
    'hr': ['Bok', 'Hvala', 'Molim', 'Doviđenja'],
    'sr': ['Здраво', 'Хвала', 'Молим', 'Довиђења'],
    'sl': ['Živjo', 'Hvala', 'Prosim', 'Nasvidenje'],
    'mk': ['Здраво', 'Благодарам', 'Ве молам', 'Довидување'],
    'et': ['Tere', 'Aitäh', 'Palun', 'Head aega'],
    'lv': ['Sveiki', 'Paldies', 'Lūdzu', 'Uz redzēšanos'],
    'lt': ['Sveiki', 'Ačiū', 'Prašau', 'Viso gero'],
    'ka': ['გამარჯობა', 'გმადლობთ', 'გთხოვთ', 'ნახვამდის'],
    'hy': ['Բարև', 'Շնորհակալություն', 'Խնդրում եմ', 'Ցտեսություն'],
    'az': ['Salam', 'Təşəkkür edirəm', 'Zəhmət olmasa', 'Sağ olun'],
    'kk': ['Сәлем', 'Рақмет', 'Өтінемін', 'Сау болыңыз'],
    'uz': ['Salom', 'Rahmat', 'Iltimos', 'Xayr'],
    'mn': ['Сайн байна уу', 'Баярлалаа', 'Гуйя', 'Баяртай'],
    'ne': ['नमस्ते', 'धन्यवाद', 'कृपया', 'फेरि भेटौँला'],
    'bn': ['হ্যালো', 'ধন্যবাদ', 'অনুগ্রহ করে', 'বিদায়'],
    'ta': ['வணக்கம்', 'நன்றி', 'தயவுசெய்து', 'பிரியாவிடை'],
    'te': ['నమస్కారం', 'ధన్యవాదాలు', 'దయచేసి', 'వీడ్కోలు'],
    'ml': ['നമസ്കാരം', 'നന്ദി', 'ദയവായി', 'വിട'],
    'kn': ['ನಮಸ್ಕಾರ', 'ಧನ್ಯವಾದ', 'ದಯವಿಟ್ಟು', 'ವಿದಾಯ'],
  };

  static List<CourseUnit> unitsFor(
    String languageCode, {
    String meaningLanguageCode = 'en',
  }) {
    final lexicon = _alignedPhrasesFor(languageCode, meaningLanguageCode);
    return [
      for (final level in levels)
        for (var topicIndex = 0; topicIndex < _topics.length; topicIndex++)
          _unitFor(
            level,
            topicIndex,
            lexicon,
            languageCode,
            meaningLanguageCode,
          ),
    ];
  }

  static CourseUnit _unitFor(
    LearningLevel level,
    int topicIndex,
    List<_AlignedPhrase> lexicon,
    String languageCode,
    String instructionLanguageCode,
  ) {
    final topic = _topics[topicIndex];
    final levelIndex = levels.indexOf(level);
    final topicLexicon = lexicon
        .where((item) => item.category == topic.$4)
        .toList(growable: false);
    final lessonLexicon = topicLexicon.isEmpty ? lexicon : topicLexicon;
    return CourseUnit(
      id: '${languageCode}_${level.code}_$topicIndex',
      level: level.code,
      title: '${topic.$1} · ${level.code}',
      description: topic.$2,
      emoji: topic.$3,
      lessons: [
        for (var lessonIndex = 0; lessonIndex < 5; lessonIndex++)
          _lessonFor(
            languageCode,
            level,
            topicIndex,
            lessonIndex,
            lessonLexicon,
            levelIndex,
            instructionLanguageCode,
          ),
      ],
    );
  }

  static Lesson _lessonFor(
    String languageCode,
    LearningLevel level,
    int topicIndex,
    int lessonIndex,
    List<_AlignedPhrase> lexicon,
    int levelIndex,
    String instructionLanguageCode,
  ) {
    final phraseIndex =
        (levelIndex * 30 + topicIndex * 5 + lessonIndex) % lexicon.length;
    final aligned = lexicon[phraseIndex];
    final second = lexicon[(phraseIndex + 1) % lexicon.length];
    final third = lexicon[(phraseIndex + 2) % lexicon.length];
    final phrase = aligned.target;
    final meaning = aligned.meaning;
    final distractors = <String>{
      ...lexicon.map((item) => item.target),
      '…',
    }.where((item) => item != phrase).take(3).toList();
    final shuffled = [...distractors, phrase]
      ..shuffle(Random(lessonIndex + topicIndex));
    final secondOptions =
        <String>{
            ...lexicon.map((item) => item.target),
            '…',
          }.where((item) => item != second.target).take(3).toList()
          ..add(second.target)
          ..shuffle(Random(100 + lessonIndex + topicIndex));

    return Lesson(
      id: '${languageCode}_${level.code}_${topicIndex}_$lessonIndex',
      title: [
        _instruction(instructionLanguageCode, 'discover'),
        _instruction(instructionLanguageCode, 'listen'),
        _instruction(instructionLanguageCode, 'build'),
        _instruction(instructionLanguageCode, 'speak'),
        _instruction(instructionLanguageCode, 'challenge'),
      ][lessonIndex],
      subtitle: '${_topics[topicIndex].$1} · ${level.code}',
      emoji: ['✨', '🎧', '🧩', '🎙️', '🏆'][lessonIndex],
      durationMinutes: 5 + lessonIndex * 2,
      isPremium: levelIndex > 2 && lessonIndex == 4,
      steps: [
        LessonStep(
          type: ExerciseType.flashcard,
          prompt: phrase,
          answer: meaning,
          translation: meaning,
          hint: _instruction(instructionLanguageCode, 'tap_recall'),
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.choice,
          prompt: _instruction(instructionLanguageCode, 'choose_expression', {
            'meaning': meaning,
          }),
          answer: phrase,
          options: shuffled,
          hint: _instruction(instructionLanguageCode, 'listen_rhythm'),
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.listening,
          prompt: _instruction(instructionLanguageCode, 'listen_choose'),
          answer: second.target,
          options: secondOptions,
          translation: second.meaning,
          visual: second.visual,
        ),
        LessonStep(
          type: ExerciseType.arrange,
          prompt: _instruction(instructionLanguageCode, 'build_expression'),
          answer: second.target,
          options: second.target.split(' '),
          hint: _instruction(instructionLanguageCode, 'start_word'),
          translation: second.meaning,
          visual: second.visual,
        ),
        LessonStep(
          type: ExerciseType.speaking,
          prompt: _instruction(instructionLanguageCode, 'say_expression'),
          answer: third.target,
          translation: third.meaning,
          visual: third.visual,
        ),
        LessonStep(
          type: ExerciseType.fillBlank,
          prompt: '${third.meaning} → ____',
          answer: third.target,
          hint: third.target.isEmpty
              ? ''
              : _instruction(instructionLanguageCode, 'starts_with', {
                  'letter': third.target[0],
                }),
          visual: third.visual,
        ),
        LessonStep(
          type: ExerciseType.culture,
          prompt: _instruction(instructionLanguageCode, 'context_matters'),
          answer: 'Continue',
          translation: _instruction(instructionLanguageCode, 'context_note'),
          visual: _topics[topicIndex].$3,
        ),
        LessonStep(
          type: ExerciseType.choice,
          prompt: _instruction(instructionLanguageCode, 'best_fit'),
          answer: second.target,
          options: secondOptions,
          translation: _instruction(instructionLanguageCode, 'use_naturally', {
            'meaning': second.meaning,
          }),
          visual: second.visual,
        ),
        LessonStep(
          type: ExerciseType.fillBlank,
          prompt: _instruction(instructionLanguageCode, 'complete_recall', {
            'first': third.target.split(' ').take(1).join(),
          }),
          answer: third.target,
          hint: _instruction(instructionLanguageCode, 'recall_hint'),
          translation: third.meaning,
          visual: third.visual,
        ),
        LessonStep(
          type: ExerciseType.speaking,
          prompt: _instruction(instructionLanguageCode, 'use_three'),
          answer: phrase,
          translation: '$meaning · ${second.meaning} · ${third.meaning}',
          visual: _topics[topicIndex].$3,
        ),
      ],
    );
  }

  static String _instruction(
    String languageCode,
    String key, [
    Map<String, String> replacements = const {},
  ]) {
    var value =
        _instructionText[languageCode]?[key] ??
        _instructionText['en']![key] ??
        key;
    for (final entry in replacements.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }

  static List<_AlignedPhrase> _alignedPhrasesFor(
    String languageCode,
    String meaningLanguageCode,
  ) {
    const starterMeanings = ['Hello', 'Thank you', 'Please', 'Goodbye'];
    const starterVisuals = ['👋', '🙏', '🤲', '👋'];
    final starters = starterLexicon[languageCode] ?? starterLexicon['en']!;
    final sourceCode = meaningLanguageCode == languageCode
        ? 'en'
        : meaningLanguageCode;
    final localizedStarterMeanings =
        starterLexicon[sourceCode] ?? starterMeanings;
    final result = <_AlignedPhrase>[
      for (var index = 0; index < starters.length; index++)
        _AlignedPhrase(
          target: starters[index],
          meaning: localizedStarterMeanings[index],
          visual: starterVisuals[index],
          category: 'Essentials',
        ),
    ];
    final seen = result.map((item) => item.target.toLowerCase()).toSet();
    if (GlobalContentRepository.coreLanguageCodes.contains(languageCode)) {
      for (final phrase in GlobalContentRepository.phrasesFor(
        languageCode,
        sourceLanguageCode: meaningLanguageCode,
      )) {
        if (seen.add(phrase.target.toLowerCase())) {
          result.add(
            _AlignedPhrase(
              target: phrase.target,
              meaning: phrase.source,
              visual: phrase.visual,
              category: phrase.category,
            ),
          );
        }
      }
    }
    return result;
  }

  static List<PhraseEntry> verifiedStarterPhrasesFor(
    String languageCode, {
    String sourceLanguageCode = 'en',
  }) {
    final items = _alignedPhrasesFor(languageCode, sourceLanguageCode);
    return items
        .map(
          (item) => PhraseEntry(
            source: item.meaning,
            target: item.target,
            category: item.category,
            visual: item.visual,
            note: 'Verified aligned course entry',
          ),
        )
        .toList(growable: false);
  }

  static const articles = [
    CultureArticle(
      title: 'How greetings change with context',
      summary:
          'A practical guide to formal, neutral, and friendly openings across cultures.',
      readMinutes: 5,
      emoji: '🤝',
      category: 'Culture',
    ),
    CultureArticle(
      title: 'Train your ear before translating',
      summary:
          'Use rhythm, stress, and sound groups to understand natural speech faster.',
      readMinutes: 7,
      emoji: '🎧',
      category: 'Learning science',
    ),
    CultureArticle(
      title: 'A seven-day speaking ritual',
      summary:
          'A pressure-free routine that turns passive vocabulary into active speech.',
      readMinutes: 4,
      emoji: '🎙️',
      category: 'Speaking',
    ),
    CultureArticle(
      title: 'Memory that lasts',
      summary:
          'Why active recall and well-timed review beat rereading long vocabulary lists.',
      readMinutes: 6,
      emoji: '🧠',
      category: 'Memory',
    ),
  ];

  static const communityPosts = [
    CommunityPost(
      author: 'Maya',
      nativeLanguage: 'Arabic',
      learningLanguage: 'Spanish',
      text: 'Hoy practiqué pedir café. ¿Esta frase suena natural?',
      avatar: '👩🏽',
      likes: 42,
      comments: 11,
      correctedText: 'Hoy practiqué cómo pedir un café.',
    ),
    CommunityPost(
      author: 'Kenji',
      nativeLanguage: 'Japanese',
      learningLanguage: 'English',
      text: 'I have been learning for three month and I feel more confidence.',
      avatar: '👨🏻',
      likes: 31,
      comments: 8,
      correctedText:
          'I have been learning for three months, and I feel more confident.',
    ),
    CommunityPost(
      author: 'Amélie',
      nativeLanguage: 'French',
      learningLanguage: 'Arabic',
      text: 'مرحباً! أريد أن أتدرب على اللهجة الفلسطينية.',
      avatar: '👩🏻',
      likes: 57,
      comments: 19,
    ),
  ];
}

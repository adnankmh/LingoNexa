import '../models/models.dart';
import 'course_repository.dart';
import 'global_content_repository.dart';

abstract final class LearningContentRepository {
  static const categories = [
    'Essentials',
    'Introductions',
    'Travel',
    'Food',
    'Hotel',
    'Shopping',
    'Health',
    'Work',
    'Emergencies',
    'Relationships',
    'Technology',
    'Culture',
  ];

  static const specializedPaths = [
    SpecializedPath(
        id: 'travel',
        title: 'Travel Ready',
        subtitle: 'Airports, hotels, food, directions, and emergencies',
        emoji: '✈️',
        modules: 24,
        colorValue: 0xFF4DABF7),
    SpecializedPath(
        id: 'business',
        title: 'Business Fluency',
        subtitle: 'Meetings, email, negotiation, and presentations',
        emoji: '💼',
        modules: 32,
        colorValue: 0xFF6C63FF),
    SpecializedPath(
        id: 'health',
        title: 'Healthcare Language',
        subtitle: 'Symptoms, appointments, care, and medical teamwork',
        emoji: '🩺',
        modules: 28,
        colorValue: 0xFF20C997),
    SpecializedPath(
        id: 'academic',
        title: 'Academic Success',
        subtitle: 'Lectures, essays, research, and examination skills',
        emoji: '🎓',
        modules: 30,
        colorValue: 0xFFFFA94D),
    SpecializedPath(
        id: 'kids',
        title: 'Young Explorers',
        subtitle: 'Songs, pictures, stories, and family challenges',
        emoji: '🧸',
        modules: 36,
        colorValue: 0xFFF06595),
    SpecializedPath(
        id: 'citizenship',
        title: 'Life Abroad',
        subtitle: 'Services, housing, school, work, and civic life',
        emoji: '🌍',
        modules: 26,
        colorValue: 0xFF008F79),
    SpecializedPath(
        id: 'exam',
        title: 'Exam Preparation',
        subtitle: 'Timed reading, listening, writing, and speaking tasks',
        emoji: '📝',
        modules: 40,
        colorValue: 0xFFE76F51),
    SpecializedPath(
        id: 'media',
        title: 'Movies & Media',
        subtitle: 'Natural speed, idiom, humor, and cultural references',
        emoji: '🎬',
        modules: 22,
        colorValue: 0xFF845EF7),
  ];

  static const grammarTopics = [
    GrammarTopic(
        title: 'Word order foundations',
        level: 'A1',
        summary:
            'Recognize the usual position of subject, verb, object, questions, and negatives.',
        examples: [
          'I learn every day.',
          'Do you speak English?',
          'I do not understand yet.'
        ],
        emoji: '🧱'),
    GrammarTopic(
        title: 'Nouns, gender, and articles',
        level: 'A1',
        summary:
            'Learn how nouns interact with articles, number, gender, and definiteness.',
        examples: [
          'a book → the book',
          'one city → two cities',
          'new words in context'
        ],
        emoji: '📦'),
    GrammarTopic(
        title: 'Present time',
        level: 'A1',
        summary:
            'Describe identity, routine, repeated actions, and what is happening now.',
        examples: ['I work here.', 'She is reading.', 'We study on Fridays.'],
        emoji: '⏱️'),
    GrammarTopic(
        title: 'Questions that unlock conversation',
        level: 'A2',
        summary:
            'Build open and closed questions for people, places, time, reason, and method.',
        examples: [
          'Where are you from?',
          'How much is this?',
          'Why are you learning?'
        ],
        emoji: '❓'),
    GrammarTopic(
        title: 'Past experiences',
        level: 'A2',
        summary:
            'Tell what happened, describe background, and connect events in a clear sequence.',
        examples: [
          'I arrived yesterday.',
          'We were waiting.',
          'Then the bus came.'
        ],
        emoji: '🕰️'),
    GrammarTopic(
        title: 'Plans and predictions',
        level: 'A2',
        summary:
            'Express intention, arrangements, promises, probability, and future conditions.',
        examples: [
          'I am going to travel.',
          'We will call you.',
          'If it rains, we will stay.'
        ],
        emoji: '🔭'),
    GrammarTopic(
        title: 'Comparison and degree',
        level: 'B1',
        summary:
            'Compare people and ideas, soften claims, and express meaningful differences.',
        examples: ['faster than', 'the most useful', 'slightly more formal'],
        emoji: '⚖️'),
    GrammarTopic(
        title: 'Modality and politeness',
        level: 'B1',
        summary:
            'Use ability, permission, advice, obligation, probability, and polite distance.',
        examples: [
          'Could you help me?',
          'You should rest.',
          'It might be late.'
        ],
        emoji: '🤝'),
    GrammarTopic(
        title: 'Complex sentences',
        level: 'B2',
        summary:
            'Connect cause, contrast, purpose, result, concession, and condition.',
        examples: ['Although it was late…', 'so that we can…', 'as a result…'],
        emoji: '🔗'),
    GrammarTopic(
        title: 'Reported language',
        level: 'B2',
        summary:
            'Report speech, thought, questions, and claims while preserving meaning and stance.',
        examples: [
          'She said that…',
          'They asked whether…',
          'He was believed to…'
        ],
        emoji: '💬'),
    GrammarTopic(
        title: 'Style and emphasis',
        level: 'C1',
        summary:
            'Control information flow, focus, register, rhythm, and rhetorical impact.',
        examples: [
          'What matters most is…',
          'Rarely have we seen…',
          'The point I would stress…'
        ],
        emoji: '🎯'),
    GrammarTopic(
        title: 'Precision and nuance',
        level: 'C2',
        summary:
            'Choose forms for subtle certainty, implication, diplomacy, and voice.',
        examples: [
          'It would appear that…',
          'be that as it may',
          'notwithstanding the fact'
        ],
        emoji: '💎'),
  ];

  static const Map<String, List<PhraseEntry>> phrasebooks = {
    'en': [
      PhraseEntry(source: 'Hello', target: 'Hello', category: 'Essentials'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'Thank you very much',
          category: 'Essentials'),
      PhraseEntry(
          source: 'What is your name?',
          target: 'What is your name?',
          category: 'Introductions'),
      PhraseEntry(
          source: 'Where is the station?',
          target: 'Where is the station?',
          category: 'Travel'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'I would like to order',
          category: 'Food'),
      PhraseEntry(
          source: 'I have a reservation',
          target: 'I have a reservation',
          category: 'Hotel'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: 'How much does this cost?',
          category: 'Shopping'),
      PhraseEntry(
          source: 'I need a doctor',
          target: 'I need a doctor',
          category: 'Health'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: 'Could we schedule a meeting?',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'Please call emergency services',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'It was lovely to meet you',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: 'What is the Wi-Fi password?',
          category: 'Technology'),
    ],
    'ar': [
      PhraseEntry(
          source: 'Hello',
          target: 'مرحبًا',
          category: 'Essentials',
          pronunciation: 'marhaban'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'شكرًا جزيلًا',
          category: 'Essentials',
          pronunciation: 'shukran jazilan'),
      PhraseEntry(
          source: 'What is your name?',
          target: 'ما اسمك؟',
          category: 'Introductions',
          pronunciation: 'ma ismuk?'),
      PhraseEntry(
          source: 'Where is the station?',
          target: 'أين المحطة؟',
          category: 'Travel',
          pronunciation: 'ayna al-mahatta?'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'أود أن أطلب',
          category: 'Food',
          pronunciation: 'awaddu an atlub'),
      PhraseEntry(
          source: 'I have a reservation',
          target: 'لدي حجز',
          category: 'Hotel',
          pronunciation: 'ladayya hajz'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: 'كم سعر هذا؟',
          category: 'Shopping',
          pronunciation: 'kam siʿru hatha?'),
      PhraseEntry(
          source: 'I need a doctor',
          target: 'أحتاج إلى طبيب',
          category: 'Health',
          pronunciation: 'ahtaju ila tabib'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: 'هل يمكن أن نحدد موعدًا للاجتماع؟',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'اتصل بالطوارئ من فضلك',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'سعدت بلقائك',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: 'ما كلمة مرور الواي فاي؟',
          category: 'Technology'),
    ],
    'es': [
      PhraseEntry(source: 'Hello', target: 'Hola', category: 'Essentials'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'Muchas gracias',
          category: 'Essentials'),
      PhraseEntry(
          source: 'What is your name?',
          target: '¿Cómo te llamas?',
          category: 'Introductions'),
      PhraseEntry(
          source: 'Where is the station?',
          target: '¿Dónde está la estación?',
          category: 'Travel'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'Quisiera pedir',
          category: 'Food'),
      PhraseEntry(
          source: 'I have a reservation',
          target: 'Tengo una reserva',
          category: 'Hotel'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: '¿Cuánto cuesta esto?',
          category: 'Shopping'),
      PhraseEntry(
          source: 'I need a doctor',
          target: 'Necesito un médico',
          category: 'Health'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: '¿Podríamos programar una reunión?',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'Llame a emergencias, por favor',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'Fue un placer conocerte',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: '¿Cuál es la contraseña del wifi?',
          category: 'Technology'),
    ],
    'fr': [
      PhraseEntry(source: 'Hello', target: 'Bonjour', category: 'Essentials'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'Merci beaucoup',
          category: 'Essentials'),
      PhraseEntry(
          source: 'What is your name?',
          target: 'Comment vous appelez-vous ?',
          category: 'Introductions'),
      PhraseEntry(
          source: 'Where is the station?',
          target: 'Où est la gare ?',
          category: 'Travel'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'Je voudrais commander',
          category: 'Food'),
      PhraseEntry(
          source: 'I have a reservation',
          target: "J’ai une réservation",
          category: 'Hotel'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: 'Combien ça coûte ?',
          category: 'Shopping'),
      PhraseEntry(
          source: 'I need a doctor',
          target: "J’ai besoin d’un médecin",
          category: 'Health'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: 'Pourrions-nous fixer une réunion ?',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'Appelez les secours, s’il vous plaît',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'Ravi de vous avoir rencontré',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: 'Quel est le mot de passe Wi-Fi ?',
          category: 'Technology'),
    ],
    'de': [
      PhraseEntry(source: 'Hello', target: 'Hallo', category: 'Essentials'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'Vielen Dank',
          category: 'Essentials'),
      PhraseEntry(
          source: 'What is your name?',
          target: 'Wie heißen Sie?',
          category: 'Introductions'),
      PhraseEntry(
          source: 'Where is the station?',
          target: 'Wo ist der Bahnhof?',
          category: 'Travel'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'Ich möchte bestellen',
          category: 'Food'),
      PhraseEntry(
          source: 'I have a reservation',
          target: 'Ich habe eine Reservierung',
          category: 'Hotel'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: 'Wie viel kostet das?',
          category: 'Shopping'),
      PhraseEntry(
          source: 'I need a doctor',
          target: 'Ich brauche einen Arzt',
          category: 'Health'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: 'Könnten wir einen Termin vereinbaren?',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'Rufen Sie bitte den Notdienst',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'Es war schön, Sie kennenzulernen',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: 'Wie lautet das WLAN-Passwort?',
          category: 'Technology'),
    ],
    'tr': [
      PhraseEntry(source: 'Hello', target: 'Merhaba', category: 'Essentials'),
      PhraseEntry(
          source: 'Thank you very much',
          target: 'Çok teşekkür ederim',
          category: 'Essentials'),
      PhraseEntry(
          source: 'What is your name?',
          target: 'Adınız ne?',
          category: 'Introductions'),
      PhraseEntry(
          source: 'Where is the station?',
          target: 'İstasyon nerede?',
          category: 'Travel'),
      PhraseEntry(
          source: 'I would like to order',
          target: 'Sipariş vermek istiyorum',
          category: 'Food'),
      PhraseEntry(
          source: 'I have a reservation',
          target: 'Rezervasyonum var',
          category: 'Hotel'),
      PhraseEntry(
          source: 'How much does this cost?',
          target: 'Bu ne kadar?',
          category: 'Shopping'),
      PhraseEntry(
          source: 'I need a doctor',
          target: 'Bir doktora ihtiyacım var',
          category: 'Health'),
      PhraseEntry(
          source: 'Could we schedule a meeting?',
          target: 'Bir toplantı planlayabilir miyiz?',
          category: 'Work'),
      PhraseEntry(
          source: 'Please call emergency services',
          target: 'Lütfen acil servisi arayın',
          category: 'Emergencies'),
      PhraseEntry(
          source: 'It was lovely to meet you',
          target: 'Tanıştığımıza memnun oldum',
          category: 'Relationships'),
      PhraseEntry(
          source: 'What is the Wi-Fi password?',
          target: 'Wi-Fi şifresi nedir?',
          category: 'Technology'),
    ],
  };

  static List<PhraseEntry> phrasesFor(String languageCode,
      {String sourceLanguageCode = 'en'}) {
    final effectiveSourceCode =
        sourceLanguageCode == languageCode ? 'en' : sourceLanguageCode;
    // The legacy bundled phrasebooks have English meanings only. They are
    // included only when English is the requested meaning language; otherwise
    // the aligned global/starter records are used so no English meaning is
    // mislabeled as Arabic, Spanish, or another interface language.
    final bundled = effectiveSourceCode == 'en'
        ? phrasebooks[languageCode] ?? const <PhraseEntry>[]
        : const <PhraseEntry>[];
    final global = GlobalContentRepository.phrasesFor(languageCode,
        sourceLanguageCode: sourceLanguageCode);
    final verified = CourseRepository.verifiedStarterPhrasesFor(languageCode,
        sourceLanguageCode: sourceLanguageCode);
    final seen = <String>{};
    return [...global, ...bundled, ...verified]
        .where((item) => seen.add(item.target.toLowerCase()))
        .map((item) => item.visual == '🗣️'
            ? PhraseEntry(
                source: item.source,
                target: item.target,
                category: item.category,
                pronunciation: item.pronunciation,
                note: item.note,
                visual: GlobalContentRepository.visualFor(
                    item.category, item.source))
            : item)
        .toList(growable: false);
  }

  static List<SentenceDrill> sentenceDrillsFor(String languageCode,
      {String sourceLanguageCode = 'en'}) {
    const missions = [
      'Recognize the exact meaning',
      'Recall without looking',
      'Say it with the target-language voice',
      'Use it in a real situation'
    ];
    return [
      for (final phrase
          in phrasesFor(languageCode, sourceLanguageCode: sourceLanguageCode))
        for (final mission in missions)
          SentenceDrill(
              source: phrase.source,
              target: phrase.target,
              category: phrase.category,
              mission: mission,
              visual: phrase.visual),
    ];
  }

  static const alphabetSamples = {
    'Latin': 'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
    'Arabic': 'ا ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن هـ و ي',
    'Cyrillic':
        'А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ъ Ы Ь Э Ю Я',
    'Greek': 'Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω',
    'Hebrew': 'א ב ג ד ה ו ז ח ט י כ ל מ נ ס ע פ צ ק ר ש ת',
    'Hangul': 'ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ · ㅏ ㅑ ㅓ ㅕ ㅗ ㅛ ㅜ ㅠ ㅡ ㅣ',
    'Kana & Kanji': 'あ い う え お · か き く け こ · さ し す せ そ · 日 本 語',
    'Devanagari': 'अ आ इ ई उ ऊ ए ऐ ओ औ · क ख ग घ ङ · च छ ज झ ञ',
    'Hanzi': '一 人 大 小 中 国 日 月 山 水 火 木 金 土',
    'Thai': 'ก ข ฃ ค ฅ ฆ ง จ ฉ ช ซ ฌ ญ ฎ ฏ ฐ ฑ ฒ ณ ด ต ถ ท ธ น',
    'Georgian':
        'ა ბ გ დ ე ვ ზ თ ი კ ლ მ ნ ო პ ჟ რ ს ტ უ ფ ქ ღ ყ შ ჩ ც ძ წ ჭ ხ ჯ ჰ',
    'Armenian':
        'Ա Բ Գ Դ Ե Զ Է Ը Թ Ժ Ի Լ Խ Ծ Կ Հ Ձ Ղ Ճ Մ Յ Ն Շ Ո Չ Պ Ջ Ռ Ս Վ Տ Ր Ց Ու Փ Ք Օ Ֆ',
  };

  static List<Achievement> achievements(
          {required int xp, required int streak, required int lessons}) =>
      [
        Achievement(
            title: 'First Step',
            description: 'Complete your first lesson',
            emoji: '🌱',
            goal: 1,
            progress: lessons),
        Achievement(
            title: 'Focused Learner',
            description: 'Complete 10 lessons',
            emoji: '🎯',
            goal: 10,
            progress: lessons),
        Achievement(
            title: 'Course Explorer',
            description: 'Complete 50 lessons',
            emoji: '🧭',
            goal: 50,
            progress: lessons),
        Achievement(
            title: 'Seven-Day Flame',
            description: 'Maintain a 7-day streak',
            emoji: '🔥',
            goal: 7,
            progress: streak),
        Achievement(
            title: 'Thirty-Day Rhythm',
            description: 'Maintain a 30-day streak',
            emoji: '🌋',
            goal: 30,
            progress: streak),
        Achievement(
            title: 'XP Builder',
            description: 'Earn 1,000 XP',
            emoji: '⚡',
            goal: 1000,
            progress: xp),
        Achievement(
            title: 'Language Champion',
            description: 'Earn 5,000 XP',
            emoji: '🏆',
            goal: 5000,
            progress: xp),
        const Achievement(
            title: 'World Citizen',
            description: 'Study three different languages',
            emoji: '🌍',
            goal: 3,
            progress: 1),
      ];
}

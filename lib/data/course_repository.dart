import 'dart:math';

import '../models/models.dart';
import 'global_content_repository.dart';

class _AlignedPhrase {
  const _AlignedPhrase(
      {required this.target,
      required this.meaning,
      required this.visual,
      required this.category});
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
        colorValue: 0xFF6C63FF),
    LearningLevel(
        code: 'A2',
        title: 'Everyday',
        description: 'Daily routines, travel, and simple stories',
        colorValue: 0xFF22C7A9),
    LearningLevel(
        code: 'B1',
        title: 'Independent',
        description: 'Opinions, experiences, and longer conversations',
        colorValue: 0xFFFFA94D),
    LearningLevel(
        code: 'B2',
        title: 'Confident',
        description: 'Nuance, work, media, and spontaneous speech',
        colorValue: 0xFF4DABF7),
    LearningLevel(
        code: 'C1',
        title: 'Advanced',
        description: 'Persuasion, academic language, and style',
        colorValue: 0xFFFF6B8A),
    LearningLevel(
        code: 'C2',
        title: 'Mastery',
        description: 'Precision, idiom, culture, and expert expression',
        colorValue: 0xFFB197FC),
  ];

  static const _topics = [
    ('First contact', 'Introductions and useful social phrases', '👋'),
    ('Café & food', 'Order naturally and understand the menu', '☕'),
    ('Around town', 'Directions, transport, and city life', '🗺️'),
    ('People & home', 'Talk about family, friends, and routines', '🏡'),
    ('Work & study', 'Communicate clearly in professional settings', '💼'),
    ('Stories & culture', 'Understand context, tone, and local customs', '🎭'),
  ];

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

  static List<CourseUnit> unitsFor(String languageCode,
      {String meaningLanguageCode = 'en'}) {
    final lexicon = _alignedPhrasesFor(languageCode, meaningLanguageCode);
    return [
      for (final level in levels)
        for (var topicIndex = 0; topicIndex < _topics.length; topicIndex++)
          _unitFor(level, topicIndex, lexicon, languageCode),
    ];
  }

  static CourseUnit _unitFor(
    LearningLevel level,
    int topicIndex,
    List<_AlignedPhrase> lexicon,
    String languageCode,
  ) {
    final topic = _topics[topicIndex];
    final levelIndex = levels.indexOf(level);
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
            lexicon,
            levelIndex,
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
  ) {
    final phraseIndex =
        (levelIndex * 30 + topicIndex * 5 + lessonIndex) % lexicon.length;
    final aligned = lexicon[phraseIndex];
    final phrase = aligned.target;
    final meaning = aligned.meaning;
    final distractors = <String>{
      ...lexicon.map((item) => item.target),
      '…',
    }.where((item) => item != phrase).take(3).toList();
    final shuffled = [...distractors, phrase]
      ..shuffle(Random(lessonIndex + topicIndex));

    return Lesson(
      id: '${languageCode}_${level.code}_${topicIndex}_$lessonIndex',
      title: ['Discover', 'Listen', 'Build', 'Speak', 'Challenge'][lessonIndex],
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
          hint: 'Tap the card when you can recall the meaning.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.choice,
          prompt: 'Choose the expression for “$meaning”.',
          answer: phrase,
          options: shuffled,
          hint: 'Listen for the rhythm, not only individual sounds.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.listening,
          prompt: 'Listen, then choose what you heard.',
          answer: phrase,
          options: shuffled,
          translation: meaning,
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.arrange,
          prompt: 'Build the expression.',
          answer: phrase,
          options: phrase.split(' '),
          hint: 'Start with the word you recognize.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.speaking,
          prompt: 'Say this expression with a steady rhythm.',
          answer: phrase,
          translation: meaning,
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.fillBlank,
          prompt: '$meaning → ____',
          answer: phrase,
          hint: phrase.isEmpty ? '' : 'It starts with “${phrase[0]}”.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.culture,
          prompt: 'Context matters',
          answer: 'Continue',
          translation:
              'Notice formality, gesture, and tone. The same words can feel different across regions and situations.',
          visual: _topics[topicIndex].$3,
        ),
        LessonStep(
          type: ExerciseType.choice,
          prompt: 'Choose the phrase that best fits this real-world moment.',
          answer: phrase,
          options: shuffled,
          translation: 'Use “$meaning” naturally and politely.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.fillBlank,
          prompt:
              'Listen in your mind, then complete: ${phrase.split(' ').take(1).join()} ____',
          answer: phrase,
          hint: 'Recall the full expression before checking.',
          visual: aligned.visual,
        ),
        LessonStep(
          type: ExerciseType.speaking,
          prompt: 'Personalize this phrase with one extra detail.',
          answer: phrase,
          translation: meaning,
          visual: aligned.visual,
        ),
      ],
    );
  }

  static List<_AlignedPhrase> _alignedPhrasesFor(
      String languageCode, String meaningLanguageCode) {
    const starterMeanings = ['Hello', 'Thank you', 'Please', 'Goodbye'];
    const starterVisuals = ['👋', '🙏', '🤲', '👋'];
    final starters = starterLexicon[languageCode] ?? starterLexicon['en']!;
    final sourceCode =
        meaningLanguageCode == languageCode ? 'en' : meaningLanguageCode;
    final localizedStarterMeanings =
        starterLexicon[sourceCode] ?? starterMeanings;
    final result = <_AlignedPhrase>[
      for (var index = 0; index < starters.length; index++)
        _AlignedPhrase(
            target: starters[index],
            meaning: localizedStarterMeanings[index],
            visual: starterVisuals[index],
            category: 'Essentials'),
    ];
    final seen = result.map((item) => item.target.toLowerCase()).toSet();
    if (GlobalContentRepository.coreLanguageCodes.contains(languageCode)) {
      for (final phrase in GlobalContentRepository.phrasesFor(languageCode,
          sourceLanguageCode: meaningLanguageCode)) {
        if (seen.add(phrase.target.toLowerCase())) {
          result.add(_AlignedPhrase(
              target: phrase.target,
              meaning: phrase.source,
              visual: phrase.visual,
              category: phrase.category));
        }
      }
    }
    return result;
  }

  static List<PhraseEntry> verifiedStarterPhrasesFor(String languageCode,
      {String sourceLanguageCode = 'en'}) {
    final items = _alignedPhrasesFor(languageCode, sourceLanguageCode);
    return items
        .map((item) => PhraseEntry(
            source: item.meaning,
            target: item.target,
            category: item.category,
            visual: item.visual,
            note: 'Verified aligned course entry'))
        .toList(growable: false);
  }

  static const articles = [
    CultureArticle(
        title: 'How greetings change with context',
        summary:
            'A practical guide to formal, neutral, and friendly openings across cultures.',
        readMinutes: 5,
        emoji: '🤝',
        category: 'Culture'),
    CultureArticle(
        title: 'Train your ear before translating',
        summary:
            'Use rhythm, stress, and sound groups to understand natural speech faster.',
        readMinutes: 7,
        emoji: '🎧',
        category: 'Learning science'),
    CultureArticle(
        title: 'A seven-day speaking ritual',
        summary:
            'A pressure-free routine that turns passive vocabulary into active speech.',
        readMinutes: 4,
        emoji: '🎙️',
        category: 'Speaking'),
    CultureArticle(
        title: 'Memory that lasts',
        summary:
            'Why active recall and well-timed review beat rereading long vocabulary lists.',
        readMinutes: 6,
        emoji: '🧠',
        category: 'Memory'),
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
        correctedText: 'Hoy practiqué cómo pedir un café.'),
    CommunityPost(
        author: 'Kenji',
        nativeLanguage: 'Japanese',
        learningLanguage: 'English',
        text:
            'I have been learning for three month and I feel more confidence.',
        avatar: '👨🏻',
        likes: 31,
        comments: 8,
        correctedText:
            'I have been learning for three months, and I feel more confident.'),
    CommunityPost(
        author: 'Amélie',
        nativeLanguage: 'French',
        learningLanguage: 'Arabic',
        text: 'مرحباً! أريد أن أتدرب على اللهجة الفلسطينية.',
        avatar: '👩🏻',
        likes: 57,
        comments: 19),
  ];
}

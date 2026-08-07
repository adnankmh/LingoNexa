import '../models/models.dart';

class UnitStudyGuide {
  const UnitStudyGuide({
    required this.topicTitle,
    required this.overview,
    required this.objectives,
    required this.learningSequence,
    required this.commonMistakes,
    required this.masteryChecklist,
  });

  final String topicTitle;
  final List<String> overview;
  final List<String> objectives;
  final List<String> learningSequence;
  final List<String> commonMistakes;
  final List<String> masteryChecklist;
}

class AcademyCollection {
  const AcademyCollection({
    required this.id,
    required this.icon,
    required this.animationAsset,
    required this.colorValue,
    required this.titleKey,
    required this.subtitleKey,
    required this.metric,
  });

  final String id;
  final String icon;
  final String animationAsset;
  final int colorValue;
  final String titleKey;
  final String subtitleKey;
  final String metric;
}

/// Pedagogical copy for the complete academy experience.
///
/// The target-language examples always come from aligned course records. This
/// repository localizes the teaching explanation around those records so a
/// learner can understand the lesson in the interface language they selected.
abstract final class AcademyRepository {
  static const fullStudioLanguageCodes = [
    'en',
    'ar',
    'es',
    'fr',
    'de',
    'tr',
    'pt',
    'it',
    'ru',
    'zh',
    'ja',
    'ko',
  ];

  static const collections = [
    AcademyCollection(
      id: 'deep_lessons',
      icon: '🧠',
      animationAsset: 'assets/lottie/grammar_book.json',
      colorValue: 0xFF5B4CF0,
      titleKey: 'deep_lessons',
      subtitleKey: 'deep_lessons_subtitle',
      metric: '90',
    ),
    AcademyCollection(
      id: 'course_books',
      icon: '📚',
      animationAsset: 'assets/lottie/flashcards.json',
      colorValue: 0xFF0A8F78,
      titleKey: 'course_books',
      subtitleKey: 'course_books_subtitle',
      metric: '6',
    ),
    AcademyCollection(
      id: 'motion',
      icon: '🎬',
      animationAsset: 'assets/lottie/video_lesson.json',
      colorValue: 0xFFE5683E,
      titleKey: 'motion_lessons',
      subtitleKey: 'motion_lessons_subtitle',
      metric: '3',
    ),
    AcademyCollection(
      id: 'listening',
      icon: '🎧',
      animationAsset: 'assets/lottie/listening.json',
      colorValue: 0xFF1675D1,
      titleKey: 'listening_studio',
      subtitleKey: 'listening_studio_subtitle',
      metric: '108',
    ),
    AcademyCollection(
      id: 'reference',
      icon: '🧭',
      animationAsset: 'assets/lottie/culture_world.json',
      colorValue: 0xFFB347C7,
      titleKey: 'reference_guides',
      subtitleKey: 'reference_guides_subtitle',
      metric: '54',
    ),
    AcademyCollection(
      id: 'assessment',
      icon: '🏅',
      animationAsset: 'assets/lottie/learning_goal.json',
      colorValue: 0xFFF09A28,
      titleKey: 'exam_center',
      subtitleKey: 'exam_center_subtitle',
      metric: '6',
    ),
  ];

  static const _topics = <String, List<String>>{
    'en': [
      'First contact',
      'Essential communication',
      'Café and food',
      'Airport and flights',
      'Transport and directions',
      'Hotel stay',
      'Shopping and money',
      'At the doctor',
      'Emergencies',
      'People and relationships',
      'Home and daily life',
      'Work and meetings',
      'Study and learning',
      'Technology and support',
      'Stories and culture',
    ],
    'ar': [
      'التعارف الأول',
      'التواصل الأساسي',
      'المقهى والطعام',
      'المطار والرحلات',
      'المواصلات والاتجاهات',
      'الإقامة في الفندق',
      'التسوق والمال',
      'عند الطبيب',
      'حالات الطوارئ',
      'الأشخاص والعلاقات',
      'المنزل والحياة اليومية',
      'العمل والاجتماعات',
      'الدراسة والتعلّم',
      'التقنية والدعم',
      'القصص والثقافة',
    ],
    'es': [
      'Primer contacto',
      'Comunicación esencial',
      'Café y comida',
      'Aeropuerto y vuelos',
      'Transporte y direcciones',
      'Estancia en el hotel',
      'Compras y dinero',
      'En el médico',
      'Emergencias',
      'Personas y relaciones',
      'Casa y vida diaria',
      'Trabajo y reuniones',
      'Estudio y aprendizaje',
      'Tecnología y asistencia',
      'Historias y cultura',
    ],
    'fr': [
      'Premier contact',
      'Communication essentielle',
      'Café et restauration',
      'Aéroport et vols',
      'Transports et directions',
      'Séjour à l’hôtel',
      'Achats et argent',
      'Chez le médecin',
      'Urgences',
      'Personnes et relations',
      'Maison et quotidien',
      'Travail et réunions',
      'Études et apprentissage',
      'Technologie et assistance',
      'Histoires et culture',
    ],
    'de': [
      'Erster Kontakt',
      'Grundlegende Kommunikation',
      'Café und Essen',
      'Flughafen und Flüge',
      'Verkehr und Wegbeschreibung',
      'Hotelaufenthalt',
      'Einkaufen und Geld',
      'Beim Arzt',
      'Notfälle',
      'Menschen und Beziehungen',
      'Zuhause und Alltag',
      'Arbeit und Besprechungen',
      'Studium und Lernen',
      'Technik und Support',
      'Geschichten und Kultur',
    ],
    'tr': [
      'İlk tanışma',
      'Temel iletişim',
      'Kafe ve yemek',
      'Havalimanı ve uçuşlar',
      'Ulaşım ve yönler',
      'Otel konaklaması',
      'Alışveriş ve para',
      'Doktorda',
      'Acil durumlar',
      'İnsanlar ve ilişkiler',
      'Ev ve günlük yaşam',
      'İş ve toplantılar',
      'Eğitim ve öğrenme',
      'Teknoloji ve destek',
      'Hikâyeler ve kültür',
    ],
    'pt': [
      'Primeiro contato',
      'Comunicação essencial',
      'Café e alimentação',
      'Aeroporto e voos',
      'Transportes e direções',
      'Estadia no hotel',
      'Compras e dinheiro',
      'No médico',
      'Emergências',
      'Pessoas e relacionamentos',
      'Casa e vida diária',
      'Trabalho e reuniões',
      'Estudo e aprendizagem',
      'Tecnologia e suporte',
      'Histórias e cultura',
    ],
    'it': [
      'Primo contatto',
      'Comunicazione essenziale',
      'Caffè e cibo',
      'Aeroporto e voli',
      'Trasporti e indicazioni',
      'Soggiorno in hotel',
      'Acquisti e denaro',
      'Dal medico',
      'Emergenze',
      'Persone e relazioni',
      'Casa e vita quotidiana',
      'Lavoro e riunioni',
      'Studio e apprendimento',
      'Tecnologia e assistenza',
      'Storie e cultura',
    ],
    'ru': [
      'Первое знакомство',
      'Основное общение',
      'Кафе и еда',
      'Аэропорт и рейсы',
      'Транспорт и направления',
      'Проживание в отеле',
      'Покупки и деньги',
      'У врача',
      'Экстренные ситуации',
      'Люди и отношения',
      'Дом и повседневная жизнь',
      'Работа и встречи',
      'Учёба и обучение',
      'Технологии и поддержка',
      'Истории и культура',
    ],
    'zh': [
      '初次交流',
      '基本沟通',
      '咖啡馆与饮食',
      '机场与航班',
      '交通与问路',
      '酒店住宿',
      '购物与金钱',
      '看医生',
      '紧急情况',
      '人际与关系',
      '家庭与日常生活',
      '工作与会议',
      '学习与教育',
      '科技与支持',
      '故事与文化',
    ],
    'ja': [
      '初対面',
      '基本コミュニケーション',
      'カフェと食事',
      '空港とフライト',
      '交通と道案内',
      'ホテル滞在',
      '買い物とお金',
      '病院で',
      '緊急時',
      '人と関係',
      '家と日常生活',
      '仕事と会議',
      '勉強と学習',
      'テクノロジーとサポート',
      '物語と文化',
    ],
    'ko': [
      '첫 만남',
      '기본 의사소통',
      '카페와 음식',
      '공항과 항공편',
      '교통과 길 찾기',
      '호텔 숙박',
      '쇼핑과 돈',
      '병원에서',
      '긴급 상황',
      '사람과 관계',
      '집과 일상생활',
      '업무와 회의',
      '공부와 학습',
      '기술과 지원',
      '이야기와 문화',
    ],
  };

  static const _copy = <String, Map<String, String>>{
    'en': {
      'academy': 'LingoNexa Academy',
      'academy_subtitle':
          'A complete library for understanding, practising, and mastering your language.',
      'deep_lessons': 'Deep lessons',
      'deep_lessons_subtitle':
          'Meaning, structure, usage, culture, and common mistakes',
      'course_books': 'Course books',
      'course_books_subtitle':
          'Six CEFR books with guided chapters and reference pages',
      'motion_lessons': 'Motion & video guides',
      'motion_lessons_subtitle':
          'Animated explainers plus curated visual resources',
      'listening_studio': 'Listening studio',
      'listening_studio_subtitle':
          'Dialogues, stories, shadowing, and speed control',
      'reference_guides': 'Reference guides',
      'reference_guides_subtitle':
          'Grammar, phrases, pronunciation, culture, and study skills',
      'exam_center': 'Exam center',
      'exam_center_subtitle':
          'Level checks, mock exams, mistake repair, and certificates',
      'complete_path': 'Complete learning path',
      'complete_path_subtitle':
          'One clear journey from explanation to confident real-world use',
      'content_library': 'Knowledge library',
      'content_library_subtitle':
          'Choose a learning format that fits your goal and available time',
      'full_pack': 'Full Studio',
      'foundation_pack': 'Foundation Pack',
      'coverage_note':
          'Full explanations and aligned meanings are available for the 12 Studio languages. Other catalog languages keep a verified foundation pack until their expanded editorial pack is complete.',
      'overview': 'Complete explanation',
      'objectives': 'What you will master',
      'sequence': 'How to study this unit',
      'mistakes': 'Common mistakes and how to repair them',
      'checklist': 'Mastery checklist',
      'overview_1':
          'This unit starts with meaning in context, then shows how the expressions are formed and when native speakers actually use them.',
      'overview_2':
          'Do not memorise isolated words only. Listen to the whole phrase, notice its rhythm, compare it with your interface language, and reuse it in a short personal response.',
      'objective_1':
          'Understand the core meaning without translating word by word.',
      'objective_2': 'Recognise the expressions at natural and reduced speed.',
      'objective_3': 'Choose a polite, natural form for the situation.',
      'objective_4': 'Build and pronounce the key expressions accurately.',
      'objective_5': 'Use the lesson language in a new real-life response.',
      'sequence_1': 'Read the explanation and preview the lesson goal.',
      'sequence_2': 'Listen once for meaning and once for rhythm.',
      'sequence_3': 'Study the topic words with their aligned meanings.',
      'sequence_4': 'Shadow the model voice at a comfortable speed.',
      'sequence_5': 'Complete the ten interactive activities.',
      'sequence_6': 'Read the dialogue or story without stopping.',
      'sequence_7': 'Repair every mistake and repeat the missed item.',
      'sequence_8': 'Pass the unit check, then schedule a spaced review.',
      'mistake_1':
          'Translating every word instead of understanding the full message.',
      'mistake_2':
          'Using one expression in every formal and informal situation.',
      'mistake_3':
          'Reading silently without training listening and pronunciation.',
      'mistake_4':
          'Moving on after an error without explaining why it happened.',
      'check_1': 'I understand the lesson expressions in context.',
      'check_2': 'I can recognise them when I hear them.',
      'check_3': 'I can say them with clear rhythm and stress.',
      'check_4': 'I can adapt them to a new person, place, or time.',
      'check_5': 'I corrected my mistakes and reviewed weak items.',
      'check_6': 'I can complete the final task without hints.',
      'open': 'Open',
      'chapters': 'chapters',
      'lessons_count': 'lessons',
      'studio_languages': '12 complete Studio languages',
      'catalog_languages': '67 learning languages',
      'activities_count': '4,500+ activities',
      'resource_open_failed': 'This learning resource could not be opened.',
    },
    'ar': {
      'academy': 'أكاديمية LingoNexa',
      'academy_subtitle':
          'مكتبة متكاملة لفهم اللغة وتدريبها وإتقان استخدامها بثقة.',
      'deep_lessons': 'الدروس المتعمقة',
      'deep_lessons_subtitle':
          'المعنى والبنية والاستخدام والثقافة والأخطاء الشائعة',
      'course_books': 'كتب المستويات',
      'course_books_subtitle': 'ستة كتب حسب CEFR مع فصول موجهة وصفحات مرجعية',
      'motion_lessons': 'الشروحات المرئية والمتحركة',
      'motion_lessons_subtitle': 'شروحات متحركة وموارد مرئية مختارة بعناية',
      'listening_studio': 'استوديو الاستماع',
      'listening_studio_subtitle': 'حوارات وقصص وترديد وتحكم كامل بسرعة الصوت',
      'reference_guides': 'الأدلة والمراجع',
      'reference_guides_subtitle':
          'القواعد والعبارات والنطق والثقافة ومهارات الدراسة',
      'exam_center': 'مركز الامتحانات',
      'exam_center_subtitle':
          'اختبارات مستوى وامتحانات تجريبية وإصلاح الأخطاء وشهادات',
      'complete_path': 'مسار التعلّم الكامل',
      'complete_path_subtitle':
          'رحلة واضحة تبدأ بالشرح وتنتهي بالاستخدام الواثق في الحياة',
      'content_library': 'مكتبة المعرفة',
      'content_library_subtitle':
          'اختر طريقة التعلّم الأنسب لهدفك والوقت المتاح لديك',
      'full_pack': 'الحزمة الكاملة',
      'foundation_pack': 'الحزمة التأسيسية',
      'coverage_note':
          'تتوفر الشروحات الكاملة والمعاني المترابطة للغات الاستوديو الاثنتي عشرة. أما بقية لغات الدليل فتبقى بحزمة تأسيسية موثقة حتى يكتمل تحرير حزمتها الموسعة.',
      'overview': 'الشرح الكامل',
      'objectives': 'ما الذي ستتقنه',
      'sequence': 'كيف تدرس هذه الوحدة',
      'mistakes': 'الأخطاء الشائعة وكيفية إصلاحها',
      'checklist': 'قائمة التحقق من الإتقان',
      'overview_1':
          'تبدأ هذه الوحدة بفهم المعنى داخل الموقف، ثم تشرح طريقة بناء العبارات ومتى يستخدمها المتحدثون فعلًا.',
      'overview_2':
          'لا تحفظ كلمات منفصلة فقط؛ استمع إلى العبارة كاملة، ولاحظ إيقاعها، وقارنها بلغة واجهتك، ثم أعد استخدامها في رد قصير يخصك.',
      'objective_1': 'فهم المعنى الأساسي دون ترجمة كل كلمة حرفيًا.',
      'objective_2': 'تمييز العبارات عند سماعها بسرعة طبيعية أو مخففة.',
      'objective_3': 'اختيار صيغة طبيعية ومهذبة تناسب الموقف.',
      'objective_4': 'بناء العبارات الأساسية ونطقها بدقة.',
      'objective_5': 'استخدام لغة الدرس في رد جديد من الحياة الواقعية.',
      'sequence_1': 'اقرأ الشرح وتعرّف إلى هدف الدرس قبل التدريب.',
      'sequence_2': 'استمع مرة للمعنى ومرة ثانية للإيقاع.',
      'sequence_3': 'ادرس كلمات الموضوع مع معانيها المترابطة.',
      'sequence_4': 'ردد خلف الصوت النموذجي بسرعة مريحة.',
      'sequence_5': 'أكمل الأنشطة التفاعلية العشرة.',
      'sequence_6': 'اقرأ الحوار أو القصة كاملة دون توقف.',
      'sequence_7': 'أصلح كل خطأ وأعد العنصر الذي أخطأت فيه.',
      'sequence_8': 'اجتز فحص الوحدة ثم حدد مراجعة متباعدة.',
      'mistake_1': 'ترجمة كل كلمة بدل فهم الرسالة الكاملة.',
      'mistake_2': 'استخدام عبارة واحدة في كل المواقف الرسمية والعفوية.',
      'mistake_3': 'القراءة الصامتة دون تدريب الاستماع والنطق.',
      'mistake_4': 'الانتقال بعد الخطأ دون فهم سببه.',
      'check_1': 'أفهم عبارات الدرس داخل سياقها.',
      'check_2': 'أتعرف إليها عندما أسمعها.',
      'check_3': 'أنطقها بإيقاع ونبر واضحين.',
      'check_4': 'أكيّفها مع شخص أو مكان أو زمن جديد.',
      'check_5': 'صححت أخطائي وراجعت نقاط ضعفي.',
      'check_6': 'أنجز المهمة النهائية دون تلميحات.',
      'open': 'فتح',
      'chapters': 'فصلًا',
      'lessons_count': 'درسًا',
      'studio_languages': '12 لغة بحزمة كاملة',
      'catalog_languages': '67 لغة تعليمية',
      'activities_count': 'أكثر من 4,500 نشاط',
      'resource_open_failed': 'تعذر فتح هذا المورد التعليمي.',
    },
  };

  static const _essentialTranslations = <String, Map<String, String>>{
    'es': {
      'academy': 'Academia LingoNexa',
      'academy_subtitle':
          'Una biblioteca completa para comprender, practicar y dominar tu idioma.',
      'deep_lessons': 'Lecciones profundas',
      'deep_lessons_subtitle':
          'Significado, estructura, uso, cultura y errores frecuentes',
      'course_books': 'Libros del curso',
      'course_books_subtitle':
          'Seis libros CEFR con capítulos guiados y páginas de consulta',
      'motion_lessons': 'Guías visuales y animadas',
      'motion_lessons_subtitle':
          'Explicaciones animadas y recursos visuales seleccionados',
      'listening_studio': 'Estudio de escucha',
      'listening_studio_subtitle':
          'Diálogos, historias, repetición y control de velocidad',
      'reference_guides': 'Guías de referencia',
      'reference_guides_subtitle':
          'Gramática, frases, pronunciación, cultura y técnicas de estudio',
      'exam_center': 'Centro de exámenes',
      'exam_center_subtitle':
          'Pruebas, simulacros, corrección de errores y certificados',
      'complete_path': 'Ruta de aprendizaje completa',
      'complete_path_subtitle':
          'Un recorrido claro desde la explicación hasta el uso real',
      'content_library': 'Biblioteca de conocimientos',
      'content_library_subtitle':
          'Elige el formato adecuado para tu meta y tu tiempo',
      'full_pack': 'Estudio completo',
      'foundation_pack': 'Paquete inicial',
      'coverage_note':
          'Las 12 lenguas Studio incluyen explicaciones y significados alineados. Las demás conservan un paquete inicial verificado hasta completar su edición ampliada.',
      'chapters': 'capítulos',
      'lessons_count': 'lecciones',
      'studio_languages': '12 lenguas Studio completas',
      'catalog_languages': '67 idiomas de aprendizaje',
      'activities_count': 'Más de 4500 actividades',
      'resource_open_failed': 'No se pudo abrir este recurso educativo.',
      'overview': 'Explicación completa',
      'objectives': 'Lo que dominarás',
      'sequence': 'Cómo estudiar esta unidad',
      'mistakes': 'Errores frecuentes y cómo corregirlos',
      'checklist': 'Lista de dominio',
      'open': 'Abrir',
    },
    'fr': {
      'academy': 'Académie LingoNexa',
      'academy_subtitle':
          'Une bibliothèque complète pour comprendre, pratiquer et maîtriser votre langue.',
      'deep_lessons': 'Leçons approfondies',
      'deep_lessons_subtitle':
          'Sens, structure, usage, culture et erreurs fréquentes',
      'course_books': 'Livres de cours',
      'course_books_subtitle':
          'Six livres CECR avec chapitres guidés et pages de référence',
      'motion_lessons': 'Guides visuels et animés',
      'motion_lessons_subtitle':
          'Explications animées et ressources visuelles sélectionnées',
      'listening_studio': 'Studio d’écoute',
      'listening_studio_subtitle':
          'Dialogues, histoires, répétition et contrôle de vitesse',
      'reference_guides': 'Guides de référence',
      'reference_guides_subtitle':
          'Grammaire, expressions, prononciation, culture et méthodes',
      'exam_center': 'Centre d’examens',
      'exam_center_subtitle':
          'Tests, examens blancs, correction des erreurs et certificats',
      'complete_path': 'Parcours complet',
      'complete_path_subtitle':
          'Un parcours clair de l’explication à l’usage réel',
      'content_library': 'Bibliothèque de connaissances',
      'content_library_subtitle':
          'Choisissez le format adapté à votre objectif et votre temps',
      'full_pack': 'Studio complet',
      'foundation_pack': 'Pack fondamental',
      'coverage_note':
          'Les 12 langues Studio disposent d’explications et de sens alignés. Les autres conservent un pack fondamental vérifié jusqu’à la fin de leur édition étendue.',
      'chapters': 'chapitres',
      'lessons_count': 'leçons',
      'studio_languages': '12 langues Studio complètes',
      'catalog_languages': '67 langues à apprendre',
      'activities_count': 'Plus de 4 500 activités',
      'resource_open_failed':
          'Impossible d’ouvrir cette ressource pédagogique.',
      'overview': 'Explication complète',
      'objectives': 'Ce que vous maîtriserez',
      'sequence': 'Comment étudier cette unité',
      'mistakes': 'Erreurs fréquentes et corrections',
      'checklist': 'Liste de maîtrise',
      'open': 'Ouvrir',
    },
    'de': {
      'academy': 'LingoNexa Akademie',
      'academy_subtitle':
          'Eine vollständige Bibliothek zum Verstehen, Üben und Beherrschen deiner Sprache.',
      'deep_lessons': 'Vertiefende Lektionen',
      'deep_lessons_subtitle':
          'Bedeutung, Struktur, Gebrauch, Kultur und häufige Fehler',
      'course_books': 'Kursbücher',
      'course_books_subtitle':
          'Sechs GER-Bücher mit geführten Kapiteln und Nachschlageseiten',
      'motion_lessons': 'Visuelle und animierte Erklärungen',
      'motion_lessons_subtitle':
          'Animierte Erklärungen und ausgewählte visuelle Ressourcen',
      'listening_studio': 'Hörstudio',
      'listening_studio_subtitle':
          'Dialoge, Geschichten, Nachsprechen und Tempokontrolle',
      'reference_guides': 'Nachschlagewerke',
      'reference_guides_subtitle':
          'Grammatik, Redewendungen, Aussprache, Kultur und Lerntechnik',
      'exam_center': 'Prüfungszentrum',
      'exam_center_subtitle':
          'Einstufung, Probeprüfungen, Fehlerkorrektur und Zertifikate',
      'complete_path': 'Vollständiger Lernpfad',
      'complete_path_subtitle':
          'Ein klarer Weg von der Erklärung zur sicheren Anwendung',
      'content_library': 'Wissensbibliothek',
      'content_library_subtitle':
          'Wähle das passende Format für Ziel und verfügbare Zeit',
      'full_pack': 'Vollständiges Studio',
      'foundation_pack': 'Grundlagenpaket',
      'coverage_note':
          'Die 12 Studio-Sprachen bieten vollständige Erklärungen und abgestimmte Bedeutungen. Andere Sprachen behalten ein geprüftes Grundlagenpaket, bis die erweiterte Redaktion fertig ist.',
      'chapters': 'Kapitel',
      'lessons_count': 'Lektionen',
      'studio_languages': '12 vollständige Studio-Sprachen',
      'catalog_languages': '67 Lernsprachen',
      'activities_count': 'Über 4.500 Aktivitäten',
      'resource_open_failed':
          'Diese Lernressource konnte nicht geöffnet werden.',
      'overview': 'Vollständige Erklärung',
      'objectives': 'Das wirst du beherrschen',
      'sequence': 'So lernst du diese Einheit',
      'mistakes': 'Häufige Fehler und Korrekturen',
      'checklist': 'Beherrschungscheckliste',
      'open': 'Öffnen',
    },
    'tr': {
      'academy': 'LingoNexa Akademi',
      'academy_subtitle':
          'Dili anlamak, uygulamak ve ustalaşmak için eksiksiz bir kütüphane.',
      'deep_lessons': 'Derinlemesine dersler',
      'deep_lessons_subtitle':
          'Anlam, yapı, kullanım, kültür ve yaygın hatalar',
      'course_books': 'Kurs kitapları',
      'course_books_subtitle':
          'Yönlendirilmiş bölümler ve başvuru sayfalarıyla altı CEFR kitabı',
      'motion_lessons': 'Görsel ve hareketli rehberler',
      'motion_lessons_subtitle':
          'Hareketli açıklamalar ve seçilmiş görsel kaynaklar',
      'listening_studio': 'Dinleme stüdyosu',
      'listening_studio_subtitle':
          'Diyaloglar, hikâyeler, gölgeleme ve hız kontrolü',
      'reference_guides': 'Başvuru rehberleri',
      'reference_guides_subtitle':
          'Dil bilgisi, ifadeler, telaffuz, kültür ve çalışma becerileri',
      'exam_center': 'Sınav merkezi',
      'exam_center_subtitle':
          'Seviye testleri, deneme sınavları, hata onarımı ve sertifikalar',
      'complete_path': 'Eksiksiz öğrenme yolu',
      'complete_path_subtitle':
          'Açıklamadan gerçek yaşamda güvenli kullanıma uzanan net yol',
      'content_library': 'Bilgi kütüphanesi',
      'content_library_subtitle':
          'Hedefinize ve zamanınıza uygun öğrenme biçimini seçin',
      'full_pack': 'Tam Stüdyo',
      'foundation_pack': 'Başlangıç paketi',
      'coverage_note':
          '12 Stüdyo dilinde tam açıklamalar ve eşleşmiş anlamlar bulunur. Diğer diller, genişletilmiş editoryal paket tamamlanana kadar doğrulanmış başlangıç paketini korur.',
      'chapters': 'bölüm',
      'lessons_count': 'ders',
      'studio_languages': '12 tam Stüdyo dili',
      'catalog_languages': '67 öğrenme dili',
      'activities_count': '4.500’den fazla etkinlik',
      'resource_open_failed': 'Bu öğrenme kaynağı açılamadı.',
      'overview': 'Tam açıklama',
      'objectives': 'Neleri öğreneceksiniz',
      'sequence': 'Bu ünite nasıl çalışılır',
      'mistakes': 'Yaygın hatalar ve düzeltmeleri',
      'checklist': 'Ustalık kontrol listesi',
      'open': 'Aç',
    },
    'pt': {
      'academy': 'Academia LingoNexa',
      'academy_subtitle':
          'Uma biblioteca completa para compreender, praticar e dominar o seu idioma.',
      'deep_lessons': 'Lições aprofundadas',
      'deep_lessons_subtitle':
          'Significado, estrutura, uso, cultura e erros comuns',
      'course_books': 'Livros do curso',
      'course_books_subtitle':
          'Seis livros CEFR com capítulos guiados e páginas de referência',
      'motion_lessons': 'Guias visuais e animados',
      'motion_lessons_subtitle':
          'Explicações animadas e recursos visuais selecionados',
      'listening_studio': 'Estúdio de escuta',
      'listening_studio_subtitle':
          'Diálogos, histórias, repetição e controlo de velocidade',
      'reference_guides': 'Guias de referência',
      'reference_guides_subtitle':
          'Gramática, frases, pronúncia, cultura e técnicas de estudo',
      'exam_center': 'Centro de exames',
      'exam_center_subtitle':
          'Testes, exames simulados, correção de erros e certificados',
      'complete_path': 'Percurso completo',
      'complete_path_subtitle':
          'Um percurso claro da explicação ao uso confiante',
      'content_library': 'Biblioteca de conhecimento',
      'content_library_subtitle':
          'Escolha o formato adequado ao seu objetivo e tempo',
      'full_pack': 'Estúdio completo',
      'foundation_pack': 'Pacote inicial',
      'coverage_note':
          'Os 12 idiomas Studio têm explicações completas e significados alinhados. Os restantes mantêm um pacote inicial verificado até concluir a edição ampliada.',
      'chapters': 'capítulos',
      'lessons_count': 'lições',
      'studio_languages': '12 idiomas Studio completos',
      'catalog_languages': '67 idiomas de aprendizagem',
      'activities_count': 'Mais de 4.500 atividades',
      'resource_open_failed': 'Não foi possível abrir este recurso educativo.',
      'overview': 'Explicação completa',
      'objectives': 'O que irá dominar',
      'sequence': 'Como estudar esta unidade',
      'mistakes': 'Erros comuns e como corrigi-los',
      'checklist': 'Lista de domínio',
      'open': 'Abrir',
    },
    'it': {
      'academy': 'Accademia LingoNexa',
      'academy_subtitle':
          'Una biblioteca completa per capire, esercitare e padroneggiare la lingua.',
      'deep_lessons': 'Lezioni approfondite',
      'deep_lessons_subtitle':
          'Significato, struttura, uso, cultura ed errori comuni',
      'course_books': 'Libri del corso',
      'course_books_subtitle':
          'Sei libri CEFR con capitoli guidati e pagine di riferimento',
      'motion_lessons': 'Guide visive e animate',
      'motion_lessons_subtitle':
          'Spiegazioni animate e risorse visive selezionate',
      'listening_studio': 'Studio di ascolto',
      'listening_studio_subtitle':
          'Dialoghi, storie, ripetizione e controllo della velocità',
      'reference_guides': 'Guide di riferimento',
      'reference_guides_subtitle':
          'Grammatica, frasi, pronuncia, cultura e tecniche di studio',
      'exam_center': 'Centro esami',
      'exam_center_subtitle':
          'Test, simulazioni, correzione degli errori e certificati',
      'complete_path': 'Percorso completo',
      'complete_path_subtitle':
          'Un percorso chiaro dalla spiegazione all’uso sicuro',
      'content_library': 'Biblioteca della conoscenza',
      'content_library_subtitle':
          'Scegli il formato adatto al tuo obiettivo e al tuo tempo',
      'full_pack': 'Studio completo',
      'foundation_pack': 'Pacchetto base',
      'coverage_note':
          'Le 12 lingue Studio includono spiegazioni complete e significati allineati. Le altre mantengono un pacchetto base verificato fino al completamento dell’edizione estesa.',
      'chapters': 'capitoli',
      'lessons_count': 'lezioni',
      'studio_languages': '12 lingue Studio complete',
      'catalog_languages': '67 lingue da imparare',
      'activities_count': 'Oltre 4.500 attività',
      'resource_open_failed':
          'Non è stato possibile aprire questa risorsa didattica.',
      'overview': 'Spiegazione completa',
      'objectives': 'Cosa imparerai',
      'sequence': 'Come studiare questa unità',
      'mistakes': 'Errori comuni e correzioni',
      'checklist': 'Lista di padronanza',
      'open': 'Apri',
    },
    'ru': {
      'academy': 'Академия LingoNexa',
      'academy_subtitle':
          'Полная библиотека для понимания, практики и уверенного владения языком.',
      'deep_lessons': 'Углублённые уроки',
      'deep_lessons_subtitle':
          'Значение, структура, употребление, культура и частые ошибки',
      'course_books': 'Учебники курса',
      'course_books_subtitle':
          'Шесть книг CEFR с разделами и справочными страницами',
      'motion_lessons': 'Визуальные и анимированные материалы',
      'motion_lessons_subtitle':
          'Анимированные объяснения и отобранные видеоресурсы',
      'listening_studio': 'Студия аудирования',
      'listening_studio_subtitle':
          'Диалоги, рассказы, повторение и настройка скорости',
      'reference_guides': 'Справочники',
      'reference_guides_subtitle':
          'Грамматика, фразы, произношение, культура и навыки учёбы',
      'exam_center': 'Экзаменационный центр',
      'exam_center_subtitle':
          'Тесты, пробные экзамены, работа над ошибками и сертификаты',
      'complete_path': 'Полный учебный путь',
      'complete_path_subtitle':
          'Понятный путь от объяснения до уверенного применения',
      'content_library': 'Библиотека знаний',
      'content_library_subtitle':
          'Выберите формат под вашу цель и доступное время',
      'full_pack': 'Полная студия',
      'foundation_pack': 'Базовый пакет',
      'coverage_note':
          'Для 12 языков Studio доступны полные объяснения и согласованные значения. Остальные сохраняют проверенный базовый пакет до завершения расширенной редакции.',
      'chapters': 'разделов',
      'lessons_count': 'уроков',
      'studio_languages': '12 полных языков Studio',
      'catalog_languages': '67 изучаемых языков',
      'activities_count': 'Более 4 500 заданий',
      'resource_open_failed': 'Не удалось открыть этот учебный ресурс.',
      'overview': 'Полное объяснение',
      'objectives': 'Что вы освоите',
      'sequence': 'Как изучать этот раздел',
      'mistakes': 'Частые ошибки и их исправление',
      'checklist': 'Список освоения',
      'open': 'Открыть',
    },
    'zh': {
      'academy': 'LingoNexa 学院',
      'academy_subtitle': '集理解、练习与熟练运用语言于一体的完整学习库。',
      'deep_lessons': '深度课程',
      'deep_lessons_subtitle': '含义、结构、用法、文化和常见错误',
      'course_books': '分级教材',
      'course_books_subtitle': '六册 CEFR 分级教材，含导学章节和参考页',
      'motion_lessons': '视觉与动画讲解',
      'motion_lessons_subtitle': '动画讲解与精选视觉资源',
      'listening_studio': '听力工作室',
      'listening_studio_subtitle': '对话、故事、跟读和语速控制',
      'reference_guides': '参考指南',
      'reference_guides_subtitle': '语法、短语、发音、文化与学习技巧',
      'exam_center': '考试中心',
      'exam_center_subtitle': '分级测试、模拟考试、错题修复与证书',
      'complete_path': '完整学习路径',
      'complete_path_subtitle': '从详细讲解到真实自信运用的清晰路径',
      'content_library': '知识库',
      'content_library_subtitle': '按目标和可用时间选择学习形式',
      'full_pack': '完整工作室',
      'foundation_pack': '基础包',
      'coverage_note': '12 种 Studio 语言提供完整讲解与对应释义。其他语言在扩展内容完成编辑前保留经过验证的基础包。',
      'chapters': '章',
      'lessons_count': '课',
      'studio_languages': '12 种完整 Studio 语言',
      'catalog_languages': '67 种学习语言',
      'activities_count': '4,500 多项练习',
      'resource_open_failed': '无法打开此学习资源。',
      'overview': '完整讲解',
      'objectives': '你将掌握的内容',
      'sequence': '本单元学习方法',
      'mistakes': '常见错误与纠正方法',
      'checklist': '掌握检查表',
      'open': '打开',
    },
    'ja': {
      'academy': 'LingoNexa アカデミー',
      'academy_subtitle': '言語を理解し、練習し、使いこなすための総合ライブラリです。',
      'deep_lessons': '詳しいレッスン',
      'deep_lessons_subtitle': '意味、構造、用法、文化、よくある間違い',
      'course_books': 'コースブック',
      'course_books_subtitle': 'ガイド付き章と参考ページを備えたCEFR全6冊',
      'motion_lessons': '映像・アニメガイド',
      'motion_lessons_subtitle': 'アニメ解説と厳選された映像リソース',
      'listening_studio': 'リスニングスタジオ',
      'listening_studio_subtitle': '会話、物語、シャドーイング、速度調整',
      'reference_guides': 'リファレンスガイド',
      'reference_guides_subtitle': '文法、表現、発音、文化、学習スキル',
      'exam_center': '試験センター',
      'exam_center_subtitle': 'レベル確認、模擬試験、間違い直し、証明書',
      'complete_path': '総合学習パス',
      'complete_path_subtitle': '解説から実生活での自信ある使用まで',
      'content_library': '知識ライブラリ',
      'content_library_subtitle': '目標と使える時間に合う形式を選びましょう',
      'full_pack': 'フルスタジオ',
      'foundation_pack': '基礎パック',
      'coverage_note':
          '12のStudio言語には詳しい解説と対応した意味があります。その他は拡張編集が完了するまで検証済み基礎パックを提供します。',
      'chapters': '章',
      'lessons_count': 'レッスン',
      'studio_languages': '12の完全Studio言語',
      'catalog_languages': '67の学習言語',
      'activities_count': '4,500以上のアクティビティ',
      'resource_open_failed': 'この学習リソースを開けませんでした。',
      'overview': '詳しい解説',
      'objectives': '身につくこと',
      'sequence': 'このユニットの学び方',
      'mistakes': 'よくある間違いと直し方',
      'checklist': '習得チェックリスト',
      'open': '開く',
    },
    'ko': {
      'academy': 'LingoNexa 아카데미',
      'academy_subtitle': '언어를 이해하고 연습하며 능숙하게 사용하는 종합 학습 라이브러리입니다.',
      'deep_lessons': '심화 수업',
      'deep_lessons_subtitle': '의미, 구조, 사용법, 문화와 자주 하는 실수',
      'course_books': '과정 교재',
      'course_books_subtitle': '안내 단원과 참고 페이지를 갖춘 CEFR 6권',
      'motion_lessons': '영상 및 애니메이션 가이드',
      'motion_lessons_subtitle': '애니메이션 설명과 엄선한 영상 자료',
      'listening_studio': '듣기 스튜디오',
      'listening_studio_subtitle': '대화, 이야기, 따라 말하기와 속도 조절',
      'reference_guides': '참고 가이드',
      'reference_guides_subtitle': '문법, 표현, 발음, 문화와 학습 기술',
      'exam_center': '시험 센터',
      'exam_center_subtitle': '레벨 점검, 모의시험, 실수 교정과 인증서',
      'complete_path': '완전한 학습 경로',
      'complete_path_subtitle': '설명부터 실제 상황의 자신 있는 사용까지',
      'content_library': '지식 라이브러리',
      'content_library_subtitle': '목표와 가능한 시간에 맞는 형식을 선택하세요',
      'full_pack': '전체 스튜디오',
      'foundation_pack': '기초 팩',
      'coverage_note':
          '12개 Studio 언어에는 전체 설명과 연결된 의미가 제공됩니다. 나머지는 확장 편집이 완료될 때까지 검증된 기초 팩을 유지합니다.',
      'chapters': '개 단원',
      'lessons_count': '개 수업',
      'studio_languages': '12개 전체 Studio 언어',
      'catalog_languages': '67개 학습 언어',
      'activities_count': '4,500개 이상의 활동',
      'resource_open_failed': '이 학습 자료를 열 수 없습니다.',
      'overview': '전체 설명',
      'objectives': '학습 목표',
      'sequence': '이 단원 학습 방법',
      'mistakes': '자주 하는 실수와 교정',
      'checklist': '숙달 체크리스트',
      'open': '열기',
    },
  };

  static const _guideBlocks = <String, Map<String, String>>{
    'es': {
      'overview':
          'Esta unidad empieza por el significado en contexto y después explica cómo se forman las expresiones y cuándo se usan realmente.|No memorices palabras aisladas: escucha la frase completa, observa su ritmo, compárala con tu idioma de interfaz y úsala en una respuesta personal.',
      'objectives':
          'Comprender el significado sin traducir palabra por palabra.|Reconocer las expresiones a velocidad natural y reducida.|Elegir una forma natural y cortés para la situación.|Construir y pronunciar con precisión las expresiones clave.|Usar el lenguaje de la lección en una respuesta nueva.',
      'sequence':
          'Lee la explicación y revisa el objetivo.|Escucha una vez el significado y otra el ritmo.|Estudia las palabras con sus significados alineados.|Repite con la voz modelo a una velocidad cómoda.|Completa las diez actividades interactivas.|Lee el diálogo o la historia sin detenerte.|Corrige cada error y repite el elemento débil.|Aprueba la prueba y programa un repaso espaciado.',
      'mistakes':
          'Traducir cada palabra en vez del mensaje completo.|Usar la misma expresión en contextos formales e informales.|Leer en silencio sin entrenar oído y pronunciación.|Continuar después de un error sin entender su causa.',
      'checklist':
          'Entiendo las expresiones en contexto.|Las reconozco al escucharlas.|Las pronuncio con ritmo y acento claros.|Puedo adaptarlas a otra persona, lugar o tiempo.|Corregí mis errores y repasé mis puntos débiles.|Completo la tarea final sin pistas.',
    },
    'fr': {
      'overview':
          'Cette unité commence par le sens en contexte, puis explique la formation des expressions et leur usage réel.|Ne mémorisez pas seulement des mots isolés : écoutez la phrase entière, observez son rythme, comparez-la à votre langue d’interface et réutilisez-la.',
      'objectives':
          'Comprendre le sens sans traduire mot à mot.|Reconnaître les expressions à vitesse naturelle ou réduite.|Choisir une forme naturelle et polie selon la situation.|Construire et prononcer précisément les expressions clés.|Réutiliser la langue de la leçon dans une nouvelle réponse.',
      'sequence':
          'Lisez l’explication et l’objectif.|Écoutez une fois pour le sens, une fois pour le rythme.|Étudiez les mots et leurs sens alignés.|Répétez avec la voix modèle à une vitesse confortable.|Terminez les dix activités interactives.|Lisez le dialogue ou l’histoire sans vous arrêter.|Corrigez chaque erreur et répétez l’élément manqué.|Réussissez le contrôle puis programmez une révision espacée.',
      'mistakes':
          'Traduire chaque mot au lieu du message complet.|Employer la même expression dans tout contexte formel ou familier.|Lire en silence sans entraîner écoute et prononciation.|Continuer après une erreur sans en comprendre la cause.',
      'checklist':
          'Je comprends les expressions en contexte.|Je les reconnais à l’écoute.|Je les prononce avec un rythme et un accent clairs.|Je peux les adapter à une autre personne, un lieu ou un temps.|J’ai corrigé mes erreurs et revu mes faiblesses.|Je termine la tâche finale sans aide.',
    },
    'de': {
      'overview':
          'Diese Einheit beginnt mit der Bedeutung im Kontext und erklärt danach Aufbau und tatsächlichen Gebrauch der Ausdrücke.|Lerne nicht nur einzelne Wörter: Höre den ganzen Satz, beachte den Rhythmus, vergleiche ihn mit deiner Oberflächensprache und verwende ihn selbst.',
      'objectives':
          'Die Kernbedeutung ohne Wort-für-Wort-Übersetzung verstehen.|Ausdrücke in natürlichem und reduziertem Tempo erkennen.|Eine natürliche und höfliche Form für die Situation wählen.|Wichtige Ausdrücke genau bilden und aussprechen.|Die Lektionssprache in einer neuen Antwort verwenden.',
      'sequence':
          'Lies Erklärung und Lernziel.|Höre einmal auf die Bedeutung und einmal auf den Rhythmus.|Lerne Themenwörter mit ihren abgestimmten Bedeutungen.|Sprich der Modellstimme in angenehmem Tempo nach.|Bearbeite die zehn interaktiven Aufgaben.|Lies Dialog oder Geschichte ohne Unterbrechung.|Korrigiere jeden Fehler und wiederhole Schwachstellen.|Bestehe den Check und plane eine verteilte Wiederholung.',
      'mistakes':
          'Jedes Wort statt der Gesamtaussage übersetzen.|Einen Ausdruck in formellen und informellen Situationen gleich verwenden.|Nur still lesen, ohne Hören und Aussprache zu üben.|Nach einem Fehler weitergehen, ohne die Ursache zu verstehen.',
      'checklist':
          'Ich verstehe die Ausdrücke im Kontext.|Ich erkenne sie beim Hören.|Ich spreche sie mit klarem Rhythmus und Akzent.|Ich kann sie an Person, Ort oder Zeit anpassen.|Ich habe Fehler korrigiert und Schwächen wiederholt.|Ich löse die Abschlussaufgabe ohne Hinweise.',
    },
    'tr': {
      'overview':
          'Bu ünite önce anlamı bağlam içinde verir, ardından ifadelerin nasıl kurulduğunu ve gerçekte ne zaman kullanıldığını açıklar.|Yalnızca tek tek kelimeleri ezberlemeyin; tüm ifadeyi dinleyin, ritmini fark edin, arayüz dilinizle karşılaştırın ve kendi cevabınızda kullanın.',
      'objectives':
          'Kelime kelime çevirmeden temel anlamı kavramak.|İfadeleri doğal ve azaltılmış hızda tanımak.|Duruma uygun doğal ve nazik biçimi seçmek.|Temel ifadeleri doğru kurmak ve telaffuz etmek.|Ders dilini yeni bir gerçek yaşam cevabında kullanmak.',
      'sequence':
          'Açıklamayı ve ders hedefini okuyun.|Bir kez anlam, bir kez ritim için dinleyin.|Konu kelimelerini eşleşmiş anlamlarıyla çalışın.|Model sesi rahat bir hızda tekrar edin.|On etkileşimli etkinliği tamamlayın.|Diyaloğu veya hikâyeyi durmadan okuyun.|Her hatayı düzeltip kaçırdığınız öğeyi tekrarlayın.|Ünite kontrolünü geçip aralıklı tekrar planlayın.',
      'mistakes':
          'Bütün mesaj yerine her kelimeyi çevirmek.|Aynı ifadeyi her resmî ve samimi durumda kullanmak.|Dinleme ve telaffuz çalışmadan sessiz okumak.|Hatanın nedenini anlamadan devam etmek.',
      'checklist':
          'Ders ifadelerini bağlam içinde anlıyorum.|Duyduğumda tanıyorum.|Net ritim ve vurgu ile söyleyebiliyorum.|Kişi, yer veya zamana göre uyarlayabiliyorum.|Hatalarımı düzelttim ve zayıf noktaları tekrarladım.|Son görevi ipucu olmadan tamamlayabiliyorum.',
    },
    'pt': {
      'overview':
          'Esta unidade começa pelo significado em contexto e depois explica como as expressões são formadas e usadas na vida real.|Não memorize apenas palavras isoladas: ouça a frase completa, observe o ritmo, compare-a com o idioma da interface e reutilize-a numa resposta pessoal.',
      'objectives':
          'Compreender o significado sem traduzir palavra por palavra.|Reconhecer expressões em velocidade natural e reduzida.|Escolher uma forma natural e educada para a situação.|Construir e pronunciar corretamente as expressões principais.|Usar a linguagem da lição numa nova resposta real.',
      'sequence':
          'Leia a explicação e o objetivo.|Ouça uma vez o significado e outra o ritmo.|Estude as palavras com significados alinhados.|Repita com a voz modelo numa velocidade confortável.|Conclua as dez atividades interativas.|Leia o diálogo ou a história sem parar.|Corrija cada erro e repita o item fraco.|Passe no teste e programe uma revisão espaçada.',
      'mistakes':
          'Traduzir cada palavra em vez da mensagem completa.|Usar a mesma expressão em situações formais e informais.|Ler em silêncio sem treinar audição e pronúncia.|Continuar após um erro sem compreender a causa.',
      'checklist':
          'Compreendo as expressões em contexto.|Reconheço-as ao ouvir.|Pronuncio-as com ritmo e acento claros.|Consigo adaptá-las a outra pessoa, lugar ou tempo.|Corrigi os erros e revi os pontos fracos.|Concluo a tarefa final sem dicas.',
    },
    'it': {
      'overview':
          'Questa unità parte dal significato nel contesto, poi spiega come si formano le espressioni e quando vengono davvero usate.|Non memorizzare solo parole isolate: ascolta l’intera frase, nota il ritmo, confrontala con la lingua dell’interfaccia e riutilizzala in una risposta personale.',
      'objectives':
          'Capire il significato senza tradurre parola per parola.|Riconoscere le espressioni a velocità naturale e ridotta.|Scegliere una forma naturale e cortese per la situazione.|Costruire e pronunciare con precisione le espressioni chiave.|Usare la lingua della lezione in una nuova risposta reale.',
      'sequence':
          'Leggi la spiegazione e l’obiettivo.|Ascolta una volta per il senso e una per il ritmo.|Studia le parole con i significati allineati.|Ripeti la voce modello a velocità comoda.|Completa le dieci attività interattive.|Leggi il dialogo o la storia senza fermarti.|Correggi ogni errore e ripeti l’elemento debole.|Supera il controllo e pianifica un ripasso dilazionato.',
      'mistakes':
          'Tradurre ogni parola invece del messaggio completo.|Usare la stessa espressione in ogni situazione formale e informale.|Leggere in silenzio senza allenare ascolto e pronuncia.|Continuare dopo un errore senza capirne la causa.',
      'checklist':
          'Capisco le espressioni nel contesto.|Le riconosco quando le ascolto.|Le pronuncio con ritmo e accento chiari.|So adattarle a persona, luogo o tempo diversi.|Ho corretto gli errori e ripassato i punti deboli.|Completo l’attività finale senza suggerimenti.',
    },
    'ru': {
      'overview':
          'Раздел начинается со значения в контексте, затем показывает построение выражений и их реальное употребление.|Не запоминайте только отдельные слова: слушайте всю фразу, отмечайте ритм, сравнивайте с языком интерфейса и используйте её в личном ответе.',
      'objectives':
          'Понимать основной смысл без дословного перевода.|Узнавать выражения в естественном и замедленном темпе.|Выбирать естественную и вежливую форму для ситуации.|Точно строить и произносить ключевые выражения.|Использовать язык урока в новом жизненном ответе.',
      'sequence':
          'Прочитайте объяснение и цель.|Послушайте один раз смысл, второй раз ритм.|Изучите слова с согласованными значениями.|Повторяйте за образцом в удобном темпе.|Выполните десять интерактивных заданий.|Прочитайте диалог или рассказ без остановки.|Исправьте каждую ошибку и повторите слабый элемент.|Пройдите проверку и запланируйте интервальное повторение.',
      'mistakes':
          'Переводить каждое слово вместо общего сообщения.|Использовать одну форму во всех официальных и неофициальных ситуациях.|Читать молча без тренировки слуха и произношения.|Идти дальше после ошибки, не поняв её причину.',
      'checklist':
          'Я понимаю выражения в контексте.|Я узнаю их на слух.|Я произношу их с ясным ритмом и ударением.|Я адаптирую их к другому человеку, месту или времени.|Я исправил ошибки и повторил слабые места.|Я выполняю итоговое задание без подсказок.',
    },
    'zh': {
      'overview':
          '本单元先在语境中呈现含义，再说明表达的结构以及母语者实际使用的场合。|不要只背孤立单词；要听完整短语、注意节奏、与界面语言比较，并把它用于自己的简短回答。',
      'objectives':
          '不逐字翻译也能理解核心含义。|能在自然或弱读语速中识别表达。|根据情境选择自然礼貌的形式。|准确构成并发音关键表达。|在新的真实回答中运用本课语言。',
      'sequence':
          '阅读讲解并预习学习目标。|听一遍理解含义，再听一遍关注节奏。|结合对应释义学习主题词汇。|用舒适速度跟读示范语音。|完成十项互动练习。|不停顿地读完对话或故事。|纠正每个错误并重做薄弱项。|通过单元检查并安排间隔复习。',
      'mistakes': '逐字翻译而忽略完整信息。|在正式和非正式场合都使用同一种表达。|只默读而不练听力与发音。|出错后不理解原因就继续。',
      'checklist':
          '我能在语境中理解本课表达。|我听到时能够识别。|我能用清晰的节奏和重音说出。|我能根据人物、地点或时间进行调整。|我已纠正错误并复习薄弱项。|我能无提示完成最终任务。',
    },
    'ja': {
      'overview':
          'このユニットでは、まず文脈の中で意味を理解し、その後に表現の作り方と実際の使用場面を学びます。|単語だけを暗記せず、フレーズ全体を聞き、リズムに注目し、表示言語と比べて自分の短い答えで使いましょう。',
      'objectives':
          '一語ずつ訳さずに中心的な意味を理解する。|自然な速度や音が弱くなる発話で表現を聞き取る。|場面に合う自然で丁寧な形を選ぶ。|重要表現を正しく組み立てて発音する。|新しい実生活の答えでレッスン表現を使う。',
      'sequence':
          '解説と学習目標を読みます。|意味に一回、リズムに一回注目して聞きます。|対応する意味と一緒に語彙を学びます。|無理のない速度でモデル音声をまねます。|10問のインタラクティブ練習を終えます。|会話や物語を止まらずに読みます。|すべての間違いを直して弱い項目を繰り返します。|ユニット確認に合格し、間隔反復を予定します。',
      'mistakes':
          '全体のメッセージではなく一語ずつ訳す。|丁寧な場面と親しい場面で同じ表現だけを使う。|聞き取りと発音を練習せず黙読だけする。|間違いの理由を理解せず先に進む。',
      'checklist':
          '文脈の中で表現を理解できます。|聞いたときに認識できます。|明確なリズムとアクセントで言えます。|人・場所・時に合わせて変えられます。|間違いを直し、弱点を復習しました。|ヒントなしで最終課題を終えられます。',
    },
    'ko': {
      'overview':
          '이 단원은 맥락 속 의미부터 시작해 표현이 만들어지는 방식과 실제 사용 상황을 설명합니다.|낱말만 외우지 말고 전체 표현을 듣고 리듬을 살피며 인터페이스 언어와 비교한 뒤 자신의 짧은 답변에 다시 사용하세요.',
      'objectives':
          '낱말마다 번역하지 않고 핵심 의미 이해하기.|자연스러운 속도와 축약된 발음에서 표현 알아듣기.|상황에 맞는 자연스럽고 공손한 형태 선택하기.|핵심 표현을 정확히 만들고 발음하기.|새로운 실제 답변에서 수업 표현 사용하기.',
      'sequence':
          '설명과 학습 목표를 읽습니다.|의미에 한 번, 리듬에 한 번 집중해 듣습니다.|주제 어휘를 대응 의미와 함께 공부합니다.|편안한 속도로 모델 음성을 따라 말합니다.|10개의 상호작용 활동을 완료합니다.|대화나 이야기를 멈추지 않고 읽습니다.|모든 실수를 고치고 놓친 항목을 반복합니다.|단원 점검을 통과하고 간격 복습을 계획합니다.',
      'mistakes':
          '전체 메시지 대신 낱말마다 번역하기.|격식과 비격식 상황에서 한 표현만 사용하기.|듣기와 발음 연습 없이 묵독만 하기.|실수의 원인을 이해하지 않고 넘어가기.',
      'checklist':
          '맥락 속에서 수업 표현을 이해합니다.|들었을 때 알아봅니다.|분명한 리듬과 강세로 말합니다.|사람, 장소, 시간에 맞게 바꿀 수 있습니다.|실수를 고치고 약한 부분을 복습했습니다.|힌트 없이 최종 과제를 완료합니다.',
    },
  };

  static String text(String localeCode, String key) {
    return _essentialTranslations[localeCode]?[key] ??
        _copy[localeCode]?[key] ??
        _copy['en']![key] ??
        key;
  }

  static String topicTitle(CourseUnit unit, String localeCode) {
    final raw = unit.id.split('_').last;
    final index = int.tryParse(raw) ?? 0;
    final topics = _topics[localeCode] ?? _topics['en']!;
    return topics[index.clamp(0, topics.length - 1).toInt()];
  }

  static UnitStudyGuide guideFor(CourseUnit unit, String localeCode) {
    String value(String key) => text(localeCode, key);
    final blocks = _guideBlocks[localeCode];
    if (blocks != null) {
      List<String> lines(String key) => blocks[key]!.split('|');
      return UnitStudyGuide(
        topicTitle: topicTitle(unit, localeCode),
        overview: lines('overview'),
        objectives: lines('objectives'),
        learningSequence: lines('sequence'),
        commonMistakes: lines('mistakes'),
        masteryChecklist: lines('checklist'),
      );
    }
    return UnitStudyGuide(
      topicTitle: topicTitle(unit, localeCode),
      overview: [value('overview_1'), value('overview_2')],
      objectives: [
        for (var index = 1; index <= 5; index++) value('objective_$index'),
      ],
      learningSequence: [
        for (var index = 1; index <= 8; index++) value('sequence_$index'),
      ],
      commonMistakes: [
        for (var index = 1; index <= 4; index++) value('mistake_$index'),
      ],
      masteryChecklist: [
        for (var index = 1; index <= 6; index++) value('check_$index'),
      ],
    );
  }

  static bool hasFullStudioPack(String languageCode) =>
      fullStudioLanguageCodes.contains(languageCode);
}

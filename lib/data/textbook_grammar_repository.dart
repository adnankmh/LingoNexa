import 'grammar_book_repository.dart';
import '../models/models.dart';

class TextbookChapterContent {
  const TextbookChapterContent({
    required this.readingTitle,
    required this.examplesTitle,
    required this.readerNote,
    required this.paragraphs,
  });

  final String readingTitle;
  final String examplesTitle;
  final String readerNote;
  final List<String> paragraphs;
}

/// Produces original, textbook-style teaching prose without copying a
/// commercial grammar book. The interface language controls the explanation;
/// target-language facts are injected through the localized language profile.
abstract final class TextbookGrammarRepository {
  static TextbookChapterContent chapter({
    required String locale,
    required String topic,
    required String level,
    required LanguageOption language,
  }) {
    final pack = _packs[locale] ?? _packs['en']!;
    final profile = GrammarBookRepository.profileFor(locale, language);
    String fill(String value) => value
        .replaceAll('{topic}', topic)
        .replaceAll('{level}', level)
        .replaceAll('{language}', language.nativeName)
        .replaceAll('{profile}', profile);

    return TextbookChapterContent(
      readingTitle: pack.readingTitle,
      examplesTitle: fill(pack.examplesTitle),
      readerNote: fill(pack.readerNote),
      paragraphs: pack.paragraphs.map(fill).toList(growable: false),
    );
  }

  static const _packs = <String, _TextbookPack>{
    'en': _TextbookPack(
      readingTitle: 'Complete textbook explanation',
      examplesTitle: 'Extended examples in {language}',
      readerNote:
          'Read the chapter as a connected lesson. Do not memorise isolated rules: notice the pattern in the examples, say them aloud, then return to the learning labs for practice.',
      paragraphs: [
        '{topic} belongs to the core system that lets a learner turn vocabulary into precise messages. At {level}, the goal is not to recite a definition but to understand what the pattern contributes to a real sentence and to recognise it quickly when reading or listening.',
        '{profile} This profile matters because the same communicative idea may be expressed through word order, endings, particles, helper words, agreement, tone, or context. A form that is natural in one language can therefore be unnecessary, moved, or expressed differently in {language}.',
        'Begin by reading several complete examples before trying to generalise. Compare what stays stable and what changes. Pay attention to the smallest meaningful signal: a changed ending, a moved verb, a particle, a pronoun, a change of order, or the absence of an element that another language would normally require.',
        'Next, connect the structure to meaning. Ask what the speaker is doing with the sentence: identifying, describing, locating, comparing, reporting, asking, softening a claim, showing time, or organising information. Grammar becomes much easier when every form is attached to a communicative purpose instead of an abstract label.',
        'Now consider natural usage. Written language, careful speech, everyday conversation, and regional varieties may prefer different forms. Treat the neutral form as your anchor, but learn to recognise common spoken compression, formal expansion, and polite alternatives so that correct language also sounds appropriate.',
        'When you produce the pattern, build from a secure model. Keep the sentence frame intact and replace one meaningful element at a time. This reduces translation interference and makes agreement, word order, and pronunciation easier to control. Once the frame is stable, vary person, time, number, place, and register.',
        'For listening and pronunciation, hear the entire grammatical phrase rather than isolated words. Function words, endings, and particles are often short and unstressed, yet they carry essential information. Repeating the complete phrase at natural rhythm trains both recognition and production.',
        'Finally, test understanding by explaining the idea in simple words and creating an original sentence that fits your own life. If you can recognise the pattern, choose it for the intended meaning, and produce it without translating word by word, the chapter is becoming usable knowledge rather than passive information.',
      ],
    ),
    'ar': _TextbookPack(
      readingTitle: 'الشرح الكامل بأسلوب كتاب تعليمي',
      examplesTitle: 'أمثلة موسعة باللغة {language}',
      readerNote:
          'اقرأ الفصل كدرس مترابط. لا تحفظ قواعد منفصلة؛ لاحظ النمط داخل الأمثلة، وانطقه بصوت عالٍ، ثم انتقل إلى مختبرات التعلّم للتدريب والتثبيت.',
      paragraphs: [
        'يُعد موضوع {topic} جزءًا من النظام الأساسي الذي يحوّل المفردات إلى رسائل دقيقة ومفهومة. في مستوى {level} لا يكون الهدف حفظ تعريف نظري، بل فهم ما الذي يضيفه هذا النمط إلى الجملة الحقيقية وكيف تتعرّف إليه بسرعة أثناء القراءة أو الاستماع.',
        '{profile} وهذه البصمة مهمة لأن الفكرة التواصلية نفسها قد تُعبَّر عنها بترتيب الكلمات أو النهايات أو الأدوات أو الأفعال المساعدة أو المطابقة أو النبرة أو السياق. لذلك قد تكون الصيغة الطبيعية في لغة ما زائدة أو مختلفة الموضع أو مختلفة البناء في {language}.',
        'ابدأ بقراءة عدة أمثلة كاملة قبل محاولة استنتاج القاعدة. قارن ما يبقى ثابتًا بما يتغيّر، وراقب أصغر علامة تحمل معنى: نهاية تتبدل، أو فعل ينتقل، أو أداة قصيرة، أو ضمير، أو اختلاف في ترتيب الكلمات، أو حتى حذف عنصر تحتاجه لغة أخرى عادةً.',
        'بعد ذلك اربط البناء بالمعنى المقصود. اسأل: ماذا يفعل المتحدث بالجملة؟ هل يعرّف شيئًا، أم يصفه، أم يحدد مكانه، أم يقارن، أم ينقل كلامًا، أم يسأل، أم يخفف درجة التأكيد، أم يحدد الزمن، أم يرتب المعلومات؟ تصبح القواعد أسهل عندما ترتبط كل صيغة بوظيفة تواصلية واضحة.',
        'انتبه كذلك إلى الاستعمال الطبيعي. فاللغة المكتوبة والكلام المتأني والمحادثة اليومية وبعض التنوعات الإقليمية قد تفضّل صيغًا مختلفة. اجعل الصيغة المحايدة نقطة البداية، ثم تعلّم التعرف إلى الاختصار الشائع في الكلام والتوسّع الرسمي والبدائل المهذبة.',
        'عند الإنتاج ابدأ من نموذج آمن وكامل. ثبّت هيكل الجملة وغيّر عنصرًا ذا معنى واحدًا في كل مرة. بهذه الطريقة تقل ترجمة الكلمات حرفيًا وتصبح المطابقة والترتيب والنطق أسهل. وبعد استقرار النموذج غيّر الشخص والزمن والعدد والمكان ومستوى الرسمية.',
        'في الاستماع والنطق، تعامل مع العبارة النحوية كوحدة صوتية واحدة. فكثير من الأدوات والنهايات والجزيئات قصيرة وغير مشددة، لكنها تحمل معلومات ضرورية. تكرار العبارة كاملة بإيقاع طبيعي يطوّر الفهم السريع والإنتاج في الوقت نفسه.',
        'وفي النهاية اختبر فهمك بأن تشرح الفكرة بكلمات بسيطة ثم تنشئ جملة أصلية مرتبطة بحياتك. إذا استطعت التعرف إلى النمط واختياره للمعنى الصحيح وإنتاجه دون ترجمة كلمة بكلمة، فقد تحوّل الفصل من معلومات محفوظة إلى معرفة قابلة للاستخدام.',
      ],
    ),
    'es': _TextbookPack(
      readingTitle: 'Explicación completa de estilo académico',
      examplesTitle: 'Ejemplos ampliados en {language}',
      readerNote:
          'Lee el capítulo como una lección conectada. Observa el patrón en ejemplos completos, dilo en voz alta y usa después los laboratorios para practicar.',
      paragraphs: [
        '{topic} forma parte del sistema central que convierte vocabulario en mensajes precisos. En {level}, la meta no es recitar una definición, sino comprender qué aporta el patrón a una oración real y reconocerlo con rapidez.',
        '{profile} Este perfil importa porque una misma idea puede expresarse mediante orden, terminaciones, partículas, auxiliares, concordancia, tono o contexto. Por eso una forma natural en otra lengua puede aparecer de manera distinta en {language}.',
        'Empieza por varios ejemplos completos antes de generalizar. Compara lo estable con lo que cambia y localiza la señal mínima que lleva significado: una terminación, un verbo desplazado, una partícula, un pronombre, el orden o una omisión.',
        'Relaciona después la estructura con la intención: identificar, describir, localizar, comparar, informar, preguntar, matizar una afirmación, situar un evento en el tiempo u organizar información. La gramática es más clara cuando cada forma tiene una función comunicativa.',
        'Ten en cuenta el uso natural. La escritura, el habla cuidada, la conversación cotidiana y las variedades regionales pueden preferir formas diferentes. Usa la forma neutral como referencia y aprende a reconocer reducciones habladas y alternativas formales.',
        'Para producir, parte de un modelo seguro. Conserva el marco de la frase y cambia un elemento significativo cada vez. Luego varía persona, tiempo, número, lugar y registro sin perder la estructura.',
        'En escucha y pronunciación, oye la frase gramatical completa. Palabras funcionales, partículas y terminaciones suelen ser breves, pero transportan información esencial. Repetir la unidad completa entrena comprensión y producción.',
        'Comprueba el dominio explicando la idea con palabras sencillas y creando una frase propia. Cuando puedas reconocer, elegir y producir el patrón sin traducir palabra por palabra, el conocimiento ya es utilizable.',
      ],
    ),
    'fr': _TextbookPack(
      readingTitle: 'Explication complète, style manuel',
      examplesTitle: 'Exemples étendus en {language}',
      readerNote:
          'Lisez le chapitre comme une leçon continue, observez les formes dans des phrases complètes, puis utilisez les laboratoires pour vous entraîner.',
      paragraphs: [
        '{topic} fait partie du système qui transforme le vocabulaire en messages précis. Au niveau {level}, l’objectif est de comprendre la contribution réelle du schéma et de le reconnaître rapidement.',
        '{profile} Ce profil est essentiel, car une même intention peut être portée par l’ordre des mots, des terminaisons, des particules, des auxiliaires, l’accord, le ton ou le contexte dans {language}.',
        'Commencez par plusieurs exemples complets avant de généraliser. Comparez ce qui reste stable à ce qui change et repérez le plus petit signal grammatical porteur de sens.',
        'Reliez ensuite la structure à sa fonction : identifier, décrire, localiser, comparer, rapporter, interroger, nuancer, situer dans le temps ou organiser l’information. Une forme comprise par sa fonction se retient mieux.',
        'Tenez compte de l’usage naturel. Écrit, parole soignée, conversation quotidienne et variétés régionales peuvent préférer des formulations différentes. Gardez la forme neutre comme point d’ancrage.',
        'Pour produire, partez d’un modèle sûr et remplacez un seul élément significatif à la fois. Puis faites varier la personne, le temps, le nombre, le lieu et le registre.',
        'À l’oral, écoutez le groupe grammatical entier. Les mots outils et terminaisons sont parfois peu accentués mais portent une information essentielle. Répétez le groupe au rythme naturel.',
        'Enfin, reformulez l’idée simplement et créez un exemple personnel. Si vous pouvez reconnaître, choisir et produire le schéma sans traduction mot à mot, il devient une compétence active.',
      ],
    ),
    'de': _TextbookPack(
      readingTitle: 'Vollständige Erklärung im Lehrbuchstil',
      examplesTitle: 'Erweiterte Beispiele auf {language}',
      readerNote:
          'Lies das Kapitel als zusammenhängende Lektion, beobachte Muster in ganzen Sätzen und nutze danach die Lernlabore zum Üben.',
      paragraphs: [
        '{topic} gehört zum Kernsystem, das Wortschatz in präzise Aussagen verwandelt. Auf Niveau {level} geht es darum, die Funktion des Musters zu verstehen und es beim Lesen und Hören schnell zu erkennen.',
        '{profile} Dieses Profil ist wichtig, weil dieselbe kommunikative Idee in {language} durch Wortstellung, Endungen, Partikeln, Hilfswörter, Kongruenz, Ton oder Kontext ausgedrückt werden kann.',
        'Lies zuerst mehrere vollständige Beispiele. Vergleiche, was konstant bleibt und was sich verändert, und achte auf das kleinste bedeutungstragende Signal.',
        'Verbinde die Form anschließend mit ihrer Aufgabe: identifizieren, beschreiben, lokalisieren, vergleichen, berichten, fragen, Aussagen abschwächen, Zeit markieren oder Information strukturieren.',
        'Berücksichtige natürlichen Sprachgebrauch. Schrift, sorgfältige Sprache, Alltagssprache und regionale Varianten können unterschiedliche Formen bevorzugen. Die neutrale Form dient als Ausgangspunkt.',
        'Beim Produzieren arbeitest du von einem sicheren Satzmuster aus und ersetzt jeweils nur ein bedeutungsvolles Element. Danach variierst du Person, Zeit, Zahl, Ort und Register.',
        'Beim Hören und Sprechen sollte die ganze grammatische Phrase als Einheit wahrgenommen werden. Kurze Funktionswörter und Endungen tragen oft entscheidende Information.',
        'Erkläre die Idee zum Schluss in einfachen Worten und bilde einen persönlichen Satz. Sobald du das Muster ohne Wort-für-Wort-Übersetzung erkennen und einsetzen kannst, ist es aktiv verfügbar.',
      ],
    ),
    'tr': _TextbookPack(
      readingTitle: 'Ders kitabı düzeyinde tam açıklama',
      examplesTitle: '{language} dilinde genişletilmiş örnekler',
      readerNote:
          'Bölümü tek bir bağlantılı ders gibi okuyun; kalıbı tam cümlelerde fark edin, sesli söyleyin ve ardından öğrenme laboratuvarlarında pekiştirin.',
      paragraphs: [
        '{topic}, kelime bilgisini kesin ve doğal mesajlara dönüştüren temel sistemin bir parçasıdır. {level} düzeyinde amaç tanımı ezberlemek değil, kalıbın gerçek cümlede ne yaptığını anlamaktır.',
        '{profile} Bu profil önemlidir; çünkü aynı iletişimsel anlam {language} içinde sözcük sırası, ekler, parçacıklar, yardımcı yapılar, uyum, tonlama veya bağlamla aktarılabilir.',
        'Genelleme yapmadan önce birkaç tam örnek okuyun. Sabit kalan bölümlerle değişen bölümleri karşılaştırın ve anlamı taşıyan en küçük işareti bulun.',
        'Yapıyı iletişim amacıyla ilişkilendirin: tanımlamak, betimlemek, yer bildirmek, karşılaştırmak, aktarmak, soru sormak, iddiayı yumuşatmak, zamanı veya bilgiyi düzenlemek.',
        'Doğal kullanımı da hesaba katın. Yazı dili, özenli konuşma, günlük konuşma ve bölgesel çeşitler farklı biçimleri tercih edebilir; nötr biçimi güvenli başlangıç noktası yapın.',
        'Üretimde sağlam bir örnekten başlayın. Cümle iskeletini koruyup her seferinde tek bir anlamlı öğeyi değiştirin; sonra kişi, zaman, sayı, yer ve resmiyet düzeyini çeşitlendirin.',
        'Dinleme ve telaffuzda tüm dilbilgisel öbeği tek ses birimi olarak duyun. Kısa ekler ve parçacıklar vurgusuz olsa bile temel bilgi taşır.',
        'Son olarak fikri basitçe açıklayın ve kendi hayatınızdan özgün bir cümle kurun. Kalıbı kelime kelime çevirmeden seçip üretebiliyorsanız bilgi aktifleşmiştir.',
      ],
    ),
    'pt': _TextbookPack(
      readingTitle: 'Explicação completa em estilo de manual',
      examplesTitle: 'Exemplos ampliados em {language}',
      readerNote:
          'Leia o capítulo como uma lição contínua, observe o padrão em frases completas e depois use os laboratórios para praticar.',
      paragraphs: [
        '{topic} faz parte do sistema central que transforma vocabulário em mensagens precisas. No nível {level}, o objetivo é entender a função real do padrão e reconhecê-lo rapidamente.',
        '{profile} Este perfil importa porque a mesma intenção pode ser expressa em {language} por ordem, terminações, partículas, auxiliares, concordância, tom ou contexto.',
        'Comece com vários exemplos completos antes de generalizar. Compare o que permanece estável com o que muda e identifique o menor sinal que carrega significado.',
        'Depois relacione a estrutura à intenção: identificar, descrever, localizar, comparar, relatar, perguntar, suavizar uma afirmação, marcar tempo ou organizar informação.',
        'Considere o uso natural. Escrita, fala cuidada, conversa cotidiana e variedades regionais podem preferir formas diferentes. Use a forma neutra como referência.',
        'Para produzir, parta de um modelo seguro e altere apenas um elemento significativo de cada vez. Depois varie pessoa, tempo, número, lugar e registro.',
        'Na escuta e na pronúncia, ouça a frase gramatical como uma unidade. Palavras funcionais e terminações podem ser breves, mas levam informação essencial.',
        'Por fim, explique a ideia com palavras simples e crie uma frase pessoal. Quando puder reconhecer, escolher e produzir o padrão sem traduzir palavra por palavra, ele se torna conhecimento ativo.',
      ],
    ),
    'it': _TextbookPack(
      readingTitle: 'Spiegazione completa in stile manuale',
      examplesTitle: 'Esempi estesi in {language}',
      readerNote:
          'Leggi il capitolo come una lezione continua, osserva il modello in frasi complete e usa poi i laboratori per esercitarti.',
      paragraphs: [
        '{topic} fa parte del sistema che trasforma il lessico in messaggi precisi. Al livello {level}, l’obiettivo è capire la funzione reale del modello e riconoscerlo rapidamente.',
        '{profile} Questo profilo conta perché la stessa intenzione può essere espressa in {language} tramite ordine, desinenze, particelle, ausiliari, accordo, tono o contesto.',
        'Parti da diversi esempi completi prima di generalizzare. Confronta ciò che rimane stabile con ciò che cambia e individua il segnale minimo che porta significato.',
        'Collega poi la struttura allo scopo: identificare, descrivere, localizzare, confrontare, riferire, chiedere, attenuare un’affermazione, indicare il tempo o organizzare le informazioni.',
        'Considera l’uso naturale. Scrittura, parlato accurato, conversazione quotidiana e varietà regionali possono preferire forme diverse. Usa la forma neutra come riferimento.',
        'Per produrre, parti da un modello sicuro e sostituisci un solo elemento significativo alla volta. Poi varia persona, tempo, numero, luogo e registro.',
        'Nell’ascolto e nella pronuncia percepisci l’intera frase grammaticale come un’unità. Parole funzionali e desinenze brevi possono contenere informazioni essenziali.',
        'Infine, spiega l’idea con parole semplici e crea una frase personale. Se sai riconoscere, scegliere e produrre il modello senza tradurre parola per parola, la conoscenza è diventata attiva.',
      ],
    ),
    'ru': _TextbookPack(
      readingTitle: 'Полное объяснение в стиле учебника',
      examplesTitle: 'Расширенные примеры на {language}',
      readerNote:
          'Читайте главу как связный урок: замечайте модель в полных фразах, произносите её и затем закрепляйте в учебных лабораториях.',
      paragraphs: [
        '{topic} относится к базовой системе, которая превращает словарный запас в точные сообщения. На уровне {level} важно понять функцию модели и быстро узнавать её в речи и тексте.',
        '{profile} Этот профиль важен, потому что одна и та же идея в {language} может выражаться порядком слов, окончаниями, частицами, вспомогательными средствами, согласованием, тоном или контекстом.',
        'Сначала изучите несколько полных примеров. Сравните постоянные и изменяющиеся элементы и найдите минимальный сигнал, который несёт грамматическое значение.',
        'Свяжите структуру с коммуникативной задачей: назвать, описать, указать место, сравнить, передать информацию, спросить, смягчить утверждение, обозначить время или организовать информацию.',
        'Учитывайте естественное употребление. Письменная речь, нейтральная речь, разговорная речь и региональные варианты могут предпочитать разные формы. Нейтральная модель служит опорой.',
        'При самостоятельном построении начните с надёжной модели и меняйте по одному смысловому элементу. Затем варьируйте лицо, время, число, место и регистр.',
        'В аудировании и произношении воспринимайте всю грамматическую группу как звуковое целое. Короткие служебные элементы часто несут важную информацию.',
        'В конце объясните идею простыми словами и составьте собственную фразу. Если вы выбираете и используете модель без пословного перевода, знание стало активным.',
      ],
    ),
    'zh': _TextbookPack(
      readingTitle: '教材式完整讲解',
      examplesTitle: '{language} 扩展例句',
      readerNote: '把本章当作一节连贯课程来读：先在完整句子中观察结构，再朗读，并到学习实验室中巩固。',
      paragraphs: [
        '{topic} 是把词汇组织成准确表达的核心系统之一。在 {level} 阶段，重点不是背定义，而是理解这一结构在真实句子中的作用，并能在阅读和听力中迅速识别。',
        '{profile} 这一语言特征很重要，因为同一个交际意义在 {language} 中可能通过语序、词尾、助词、辅助成分、一致关系、语调或语境来表达。',
        '先阅读多个完整例句，再概括规律。比较哪些部分保持不变、哪些部分发生变化，并找出承载语法意义的最小信号。',
        '然后把形式和交际功能连接起来：说明身份、描述、定位、比较、转述、提问、缓和语气、表达时间或组织信息。理解“为什么这样说”比只记标签更牢固。',
        '同时注意自然用法。书面语、较正式的口语、日常会话和地区变体可能偏好不同形式。先掌握中性表达，再学会识别口语缩略和正式表达。',
        '自己造句时，从可靠范例出发，每次只替换一个有意义的成分。框架稳定后，再改变人称、时间、数量、地点和语体。',
        '听力和发音训练中，要把整个语法短语当作一个声音单位。短小的功能词、词尾或助词往往不重读，却包含关键信息。',
        '最后用简单语言解释这个结构，并写出与你生活有关的原创句子。如果能不逐词翻译而直接识别、选择并使用它，就说明知识已经变成可用能力。',
      ],
    ),
    'ja': _TextbookPack(
      readingTitle: '教科書スタイルの完全解説',
      examplesTitle: '{language} の拡張例文',
      readerNote: '章全体を一つのつながった授業として読み、完全な文の中で型を観察し、声に出してから学習ラボで定着させます。',
      paragraphs: [
        '{topic} は、語彙を正確なメッセージに組み立てる中核的な仕組みの一つです。{level} では定義の暗記ではなく、実際の文で何を表すのかを理解し、すばやく認識できることが目標です。',
        '{profile} この特徴は重要です。同じ意味でも、{language} では語順、語尾、助詞、補助表現、一致、イントネーション、文脈など別の手段で表されることがあります。',
        '一般化する前に、複数の完全な例文を読みます。変わらない部分と変化する部分を比べ、意味を担う最小の手掛かりを見つけてください。',
        '次に形と目的を結び付けます。特定する、説明する、場所を示す、比較する、伝聞する、質問する、断定を弱める、時間を示す、情報を整理する、などの働きを確認します。',
        '自然な使用域も確認します。書き言葉、丁寧な話し方、日常会話、地域差では好まれる形が異なることがあります。まず中立的な形を基準にします。',
        '自分で作るときは安全なモデル文から始め、意味のある要素を一つずつ入れ替えます。安定したら人称、時、数、場所、レジスターを変えます。',
        '聞き取りと発音では、文法的なまとまり全体を一つの音の単位として捉えます。短い機能語や語尾でも重要な情報を持つことがあります。',
        '最後に、仕組みを簡単な言葉で説明し、自分に関係する文を作ります。逐語訳せずに認識・選択・産出できれば、知識が実用的な技能になっています。',
      ],
    ),
    'ko': _TextbookPack(
      readingTitle: '교재형 완전 설명',
      examplesTitle: '{language} 확장 예문',
      readerNote: '한 장을 연결된 수업처럼 읽고, 완전한 문장 속에서 패턴을 관찰한 뒤 소리 내어 말하고 학습 랩에서 연습하세요.',
      paragraphs: [
        '{topic}은 어휘를 정확한 메시지로 만드는 핵심 체계의 일부입니다. {level}에서는 정의 암기보다 실제 문장에서 이 패턴이 하는 일을 이해하고 빠르게 알아보는 것이 중요합니다.',
        '{profile} 이 언어적 특징이 중요한 이유는 같은 의미도 {language}에서 어순, 어미, 조사, 보조 표현, 일치, 억양 또는 문맥으로 다르게 표현될 수 있기 때문입니다.',
        '규칙을 일반화하기 전에 여러 개의 완전한 예문을 읽으세요. 유지되는 부분과 바뀌는 부분을 비교하고 의미를 전달하는 가장 작은 신호를 찾습니다.',
        '그다음 구조와 의도를 연결합니다. 확인, 묘사, 위치, 비교, 전달, 질문, 주장 완화, 시간 표시, 정보 구성 등 실제 기능을 기준으로 이해하세요.',
        '자연스러운 사용도 살펴봅니다. 문어, 정중한 말, 일상 대화, 지역적 변이는 서로 다른 형태를 선호할 수 있습니다. 중립형을 기준으로 삼으세요.',
        '직접 만들 때는 안전한 모델 문장을 유지하고 의미 있는 요소를 하나씩 바꿉니다. 구조가 안정되면 사람, 시제, 수, 장소, 격식을 변화시킵니다.',
        '듣기와 발음에서는 문법 구 전체를 하나의 소리 단위로 들으세요. 짧은 기능어, 조사, 어미가 약하게 들려도 핵심 정보를 담을 수 있습니다.',
        '마지막으로 개념을 쉬운 말로 설명하고 자신의 생활과 관련된 문장을 만들어 보세요. 단어별 번역 없이 패턴을 선택하고 사용할 수 있다면 능동 지식이 된 것입니다.',
      ],
    ),
  };
}

class _TextbookPack {
  const _TextbookPack({
    required this.readingTitle,
    required this.examplesTitle,
    required this.readerNote,
    required this.paragraphs,
  });

  final String readingTitle;
  final String examplesTitle;
  final String readerNote;
  final List<String> paragraphs;
}

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
    'Airport',
    'Transport',
    'At the Doctor',
    'Pharmacy',
    'Home',
    'Family',
    'Education',
    'Banking',
    'Public Services',
    'Weather',
    'Sports',
    'Media',
    'Immigration',
    'Housing',
    'Childcare',
    'Driving',
    'Postal Services',
    'Events',
    'Fitness',
    'Nature',
    'Customer Service',
    'Hospitality',
  ];

  static const specializedPaths = [
    SpecializedPath(
      id: 'travel',
      title: 'Travel Ready',
      subtitle: 'Airports, hotels, food, directions, and emergencies',
      emoji: '✈️',
      modules: 24,
      colorValue: 0xFF4DABF7,
    ),
    SpecializedPath(
      id: 'business',
      title: 'Business Fluency',
      subtitle: 'Meetings, email, negotiation, and presentations',
      emoji: '💼',
      modules: 32,
      colorValue: 0xFF6C63FF,
    ),
    SpecializedPath(
      id: 'health',
      title: 'Healthcare Language',
      subtitle: 'Symptoms, appointments, care, and medical teamwork',
      emoji: '🩺',
      modules: 28,
      colorValue: 0xFF20C997,
    ),
    SpecializedPath(
      id: 'academic',
      title: 'Academic Success',
      subtitle: 'Lectures, essays, research, and examination skills',
      emoji: '🎓',
      modules: 30,
      colorValue: 0xFFFFA94D,
    ),
    SpecializedPath(
      id: 'kids',
      title: 'Young Explorers',
      subtitle: 'Songs, pictures, stories, and family challenges',
      emoji: '🧸',
      modules: 36,
      colorValue: 0xFFF06595,
    ),
    SpecializedPath(
      id: 'citizenship',
      title: 'Life Abroad',
      subtitle: 'Services, housing, school, work, and civic life',
      emoji: '🌍',
      modules: 26,
      colorValue: 0xFF008F79,
    ),
    SpecializedPath(
      id: 'exam',
      title: 'Exam Preparation',
      subtitle: 'Timed reading, listening, writing, and speaking tasks',
      emoji: '📝',
      modules: 40,
      colorValue: 0xFFE76F51,
    ),
    SpecializedPath(
      id: 'media',
      title: 'Movies & Media',
      subtitle: 'Natural speed, idiom, humor, and cultural references',
      emoji: '🎬',
      modules: 22,
      colorValue: 0xFF845EF7,
    ),
    SpecializedPath(
      id: 'doctor',
      title: 'At the Doctor',
      subtitle: 'Appointments, symptoms, body, tests, treatment, and follow-up',
      emoji: '👨‍⚕️',
      modules: 30,
      colorValue: 0xFFE8590C,
    ),
    SpecializedPath(
      id: 'airport',
      title: 'Airport & Flights',
      subtitle: 'Check-in, luggage, security, gates, delays, and arrivals',
      emoji: '🛫',
      modules: 28,
      colorValue: 0xFF1971C2,
    ),
    SpecializedPath(
      id: 'restaurant',
      title: 'Restaurants & Cafés',
      subtitle: 'Menus, dietary needs, ordering, service, and payment',
      emoji: '🍽️',
      modules: 26,
      colorValue: 0xFFF59F00,
    ),
    SpecializedPath(
      id: 'hotel',
      title: 'Hotel Confidence',
      subtitle: 'Reservations, check-in, requests, problems, and check-out',
      emoji: '🏨',
      modules: 24,
      colorValue: 0xFF7048E8,
    ),
    SpecializedPath(
      id: 'shopping',
      title: 'Shopping & Money',
      subtitle: 'Sizes, prices, comparison, returns, cards, and cash',
      emoji: '🛍️',
      modules: 24,
      colorValue: 0xFFD6336C,
    ),
    SpecializedPath(
      id: 'family',
      title: 'Family & Social Life',
      subtitle: 'Family, invitations, feelings, friendship, and celebrations',
      emoji: '👨‍👩‍👧‍👦',
      modules: 30,
      colorValue: 0xFF0CA678,
    ),
    SpecializedPath(
      id: 'technology',
      title: 'Digital Life',
      subtitle: 'Phones, internet, apps, support, privacy, and online work',
      emoji: '📱',
      modules: 24,
      colorValue: 0xFF1098AD,
    ),
    SpecializedPath(
      id: 'emergency',
      title: 'Emergency Survival',
      subtitle: 'Urgent help, safety, police, ambulance, and lost documents',
      emoji: '🚨',
      modules: 20,
      colorValue: 0xFFFA5252,
    ),
    SpecializedPath(
      id: 'relocation',
      title: 'Relocation & Immigration',
      subtitle: 'Documents, appointments, housing, services, and daily life',
      emoji: '🛂',
      modules: 30,
      colorValue: 0xFF4263EB,
    ),
    SpecializedPath(
      id: 'customer_service',
      title: 'Customer Service',
      subtitle: 'Welcoming, explaining, solving problems, and following up',
      emoji: '🎧',
      modules: 26,
      colorValue: 0xFF12B886,
    ),
    SpecializedPath(
      id: 'hospitality',
      title: 'Hospitality Careers',
      subtitle: 'Hotels, restaurants, reservations, guests, and teamwork',
      emoji: '🛎️',
      modules: 28,
      colorValue: 0xFFCC5DE8,
    ),
    SpecializedPath(
      id: 'driving',
      title: 'Driving & Road Life',
      subtitle: 'Directions, fuel, parking, repairs, rules, and emergencies',
      emoji: '🚗',
      modules: 24,
      colorValue: 0xFF339AF0,
    ),
    SpecializedPath(
      id: 'parents',
      title: 'Parents & Childcare',
      subtitle: 'School, health, routines, play, safety, and family support',
      emoji: '🧒',
      modules: 28,
      colorValue: 0xFFFF922B,
    ),
    SpecializedPath(
      id: 'wellness',
      title: 'Sport & Wellness',
      subtitle: 'Training, movement, goals, equipment, and healthy routines',
      emoji: '🏃',
      modules: 24,
      colorValue: 0xFF51CF66,
    ),
    SpecializedPath(
      id: 'medical_professionals',
      title: 'Medical Professionals',
      subtitle:
          'History, examination, consent, handover, treatment, and discharge',
      emoji: '🩻',
      modules: 42,
      colorValue: 0xFF087F8C,
    ),
    SpecializedPath(
      id: 'humanitarian',
      title: 'Humanitarian Fieldwork',
      subtitle:
          'Assessment, distribution, protection, coordination, and reporting',
      emoji: '🕊️',
      modules: 34,
      colorValue: 0xFF2F9E44,
    ),
    SpecializedPath(
      id: 'engineering',
      title: 'Engineering & Construction',
      subtitle: 'Plans, measurements, safety, materials, faults, and progress',
      emoji: '🏗️',
      modules: 36,
      colorValue: 0xFFF08C00,
    ),
    SpecializedPath(
      id: 'interpreter',
      title: 'Interpreting Skills',
      subtitle: 'Clarification, accuracy, turn-taking, note-taking, and ethics',
      emoji: '🎙️',
      modules: 32,
      colorValue: 0xFF5F3DC4,
    ),
    SpecializedPath(
      id: 'sales',
      title: 'Sales & Negotiation',
      subtitle: 'Needs, value, objections, offers, agreement, and follow-up',
      emoji: '🤝',
      modules: 30,
      colorValue: 0xFFE64980,
    ),
    SpecializedPath(
      id: 'public_speaking',
      title: 'Presentations & Public Speaking',
      subtitle:
          'Openings, structure, visuals, emphasis, questions, and closing',
      emoji: '🎤',
      modules: 30,
      colorValue: 0xFF1C7ED6,
    ),
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
        'I do not understand yet.',
      ],
      emoji: '🧱',
    ),
    GrammarTopic(
      title: 'Nouns, gender, and articles',
      level: 'A1',
      summary:
          'Learn how nouns interact with articles, number, gender, and definiteness.',
      examples: [
        'a book → the book',
        'one city → two cities',
        'new words in context',
      ],
      emoji: '📦',
    ),
    GrammarTopic(
      title: 'Present time',
      level: 'A1',
      summary:
          'Describe identity, routine, repeated actions, and what is happening now.',
      examples: ['I work here.', 'She is reading.', 'We study on Fridays.'],
      emoji: '⏱️',
    ),
    GrammarTopic(
      title: 'Pronouns and reference',
      level: 'A1',
      summary:
          'Track who or what a sentence refers to without repeating every noun.',
      examples: ['I / you / we', 'this / that', 'my / your / our'],
      emoji: '👥',
    ),
    GrammarTopic(
      title: 'Negation essentials',
      level: 'A1',
      summary: 'Make clear negative statements, commands, and short answers.',
      examples: ['not now', 'I cannot come', 'Please do not touch'],
      emoji: '🚫',
    ),
    GrammarTopic(
      title: 'Numbers, time, and dates',
      level: 'A1',
      summary:
          'Use numbers with age, prices, clock time, dates, and quantities.',
      examples: ['at three o’clock', 'twenty euros', 'on 12 May'],
      emoji: '🔢',
    ),
    GrammarTopic(
      title: 'Questions that unlock conversation',
      level: 'A2',
      summary:
          'Build open and closed questions for people, places, time, reason, and method.',
      examples: [
        'Where are you from?',
        'How much is this?',
        'Why are you learning?',
      ],
      emoji: '❓',
    ),
    GrammarTopic(
      title: 'Past experiences',
      level: 'A2',
      summary:
          'Tell what happened, describe background, and connect events in a clear sequence.',
      examples: [
        'I arrived yesterday.',
        'We were waiting.',
        'Then the bus came.',
      ],
      emoji: '🕰️',
    ),
    GrammarTopic(
      title: 'Plans and predictions',
      level: 'A2',
      summary:
          'Express intention, arrangements, promises, probability, and future conditions.',
      examples: [
        'I am going to travel.',
        'We will call you.',
        'If it rains, we will stay.',
      ],
      emoji: '🔭',
    ),
    GrammarTopic(
      title: 'Possession and belonging',
      level: 'A2',
      summary:
          'Show ownership, relationships, parts, and association naturally.',
      examples: ['my passport', 'the hotel’s address', 'a friend of mine'],
      emoji: '🔑',
    ),
    GrammarTopic(
      title: 'Requests, commands, and permission',
      level: 'A2',
      summary:
          'Ask for action, give directions, and request permission at the right level of politeness.',
      examples: ['Please wait here.', 'May I enter?', 'Could you write it?'],
      emoji: '🧭',
    ),
    GrammarTopic(
      title: 'Place, movement, and prepositions',
      level: 'A2',
      summary:
          'Describe location, direction, origin, destination, and movement through space.',
      examples: ['at the station', 'from home', 'toward the center'],
      emoji: '📍',
    ),
    GrammarTopic(
      title: 'Comparison and degree',
      level: 'B1',
      summary:
          'Compare people and ideas, soften claims, and express meaningful differences.',
      examples: ['faster than', 'the most useful', 'slightly more formal'],
      emoji: '⚖️',
    ),
    GrammarTopic(
      title: 'Modality and politeness',
      level: 'B1',
      summary:
          'Use ability, permission, advice, obligation, probability, and polite distance.',
      examples: ['Could you help me?', 'You should rest.', 'It might be late.'],
      emoji: '🤝',
    ),
    GrammarTopic(
      title: 'Habit, duration, and frequency',
      level: 'B1',
      summary: 'Explain how often, how long, and since when an action happens.',
      examples: ['usually', 'for two years', 'since Monday'],
      emoji: '🔁',
    ),
    GrammarTopic(
      title: 'Relative information',
      level: 'B1',
      summary:
          'Add identifying or descriptive information about people, things, places, and times.',
      examples: [
        'the person who called',
        'the book that I bought',
        'where we met',
      ],
      emoji: '🧩',
    ),
    GrammarTopic(
      title: 'Reason, result, and purpose',
      level: 'B1',
      summary:
          'Connect events by explaining why something happened and what it was intended to achieve.',
      examples: ['because…', 'therefore…', 'in order to…'],
      emoji: '🎯',
    ),
    GrammarTopic(
      title: 'Complex sentences',
      level: 'B2',
      summary:
          'Connect cause, contrast, purpose, result, concession, and condition.',
      examples: ['Although it was late…', 'so that we can…', 'as a result…'],
      emoji: '🔗',
    ),
    GrammarTopic(
      title: 'Reported language',
      level: 'B2',
      summary:
          'Report speech, thought, questions, and claims while preserving meaning and stance.',
      examples: [
        'She said that…',
        'They asked whether…',
        'He was believed to…',
      ],
      emoji: '💬',
    ),
    GrammarTopic(
      title: 'Conditional meaning',
      level: 'B2',
      summary:
          'Discuss real possibilities, imagined situations, regret, and mixed conditions.',
      examples: ['If I have time…', 'If I knew…', 'If we had left earlier…'],
      emoji: '🔀',
    ),
    GrammarTopic(
      title: 'Passive and impersonal structures',
      level: 'B2',
      summary:
          'Focus on an action, process, or result when the actor is unknown or less important.',
      examples: [
        'It was repaired.',
        'People say that…',
        'The form must be signed.',
      ],
      emoji: '⚙️',
    ),
    GrammarTopic(
      title: 'Aspect and viewpoint',
      level: 'B2',
      summary:
          'Choose whether to present an action as complete, ongoing, repeated, or relevant now.',
      examples: ['completed event', 'ongoing background', 'present result'],
      emoji: '🎥',
    ),
    GrammarTopic(
      title: 'Style and emphasis',
      level: 'C1',
      summary:
          'Control information flow, focus, register, rhythm, and rhetorical impact.',
      examples: [
        'What matters most is…',
        'Rarely have we seen…',
        'The point I would stress…',
      ],
      emoji: '🎯',
    ),
    GrammarTopic(
      title: 'Cohesion across paragraphs',
      level: 'C1',
      summary:
          'Guide readers and listeners through reference, substitution, connectors, and thematic progression.',
      examples: [
        'with regard to…',
        'the former / the latter',
        'this suggests that…',
      ],
      emoji: '🧵',
    ),
    GrammarTopic(
      title: 'Formal, neutral, and informal register',
      level: 'C1',
      summary:
          'Adapt grammar and vocabulary to professional, academic, friendly, and intimate contexts.',
      examples: ['Would you mind…', 'Can you…', 'Give me a hand…'],
      emoji: '🎚️',
    ),
    GrammarTopic(
      title: 'Information structure and focus',
      level: 'C1',
      summary:
          'Place known and new information strategically and highlight the element that matters.',
      examples: ['As for the budget…', 'What changed was…', 'It is X that…'],
      emoji: '🔦',
    ),
    GrammarTopic(
      title: 'Precision and nuance',
      level: 'C2',
      summary:
          'Choose forms for subtle certainty, implication, diplomacy, and voice.',
      examples: [
        'It would appear that…',
        'be that as it may',
        'notwithstanding the fact',
      ],
      emoji: '💎',
    ),
    GrammarTopic(
      title: 'Inference, stance, and evidentiality',
      level: 'C2',
      summary:
          'Signal evidence, confidence, distance, surprise, and responsibility for a claim.',
      examples: ['apparently', 'must have been', 'to the best of my knowledge'],
      emoji: '🔍',
    ),
    GrammarTopic(
      title: 'Idiomatic grammar and fixed patterns',
      level: 'C2',
      summary:
          'Recognize structures whose natural meaning cannot be assembled word by word.',
      examples: ['had better', 'be that as it may', 'far from being'],
      emoji: '🧬',
    ),
    GrammarTopic(
      title: 'Editing for native-like control',
      level: 'C2',
      summary:
          'Revise ambiguity, repetition, rhythm, agreement, reference, and register with expert precision.',
      examples: [
        'remove ambiguity',
        'tighten reference',
        'balance parallel forms',
      ],
      emoji: '✍️',
    ),
    GrammarTopic(
      title: 'Agreement inside the phrase',
      level: 'A1',
      summary:
          'Keep articles, nouns, adjectives, pronouns, and verbs consistent where the language marks number, gender, or person.',
      examples: [
        'one new book → two new books',
        'I am ready → we are ready',
        'this person → these people',
      ],
      emoji: '🧲',
    ),
    GrammarTopic(
      title: 'Building useful noun phrases',
      level: 'A1',
      summary:
          'Combine quantity, description, ownership, and location into compact phrases you can reuse in real situations.',
      examples: [
        'my new phone',
        'two tickets for tomorrow',
        'the room near the lift',
      ],
      emoji: '🧰',
    ),
    GrammarTopic(
      title: 'Connecting everyday ideas',
      level: 'A2',
      summary:
          'Link short messages with addition, contrast, choice, reason, result, and simple sequence.',
      examples: [
        'I called, but nobody answered.',
        'First check in, then find the gate.',
        'I stayed home because I was ill.',
      ],
      emoji: '🔗',
    ),
    GrammarTopic(
      title: 'Quantity and measurement',
      level: 'A2',
      summary:
          'Talk accurately about countable items, amounts, portions, distance, weight, and approximate quantity.',
      examples: ['a little water', 'three pieces', 'about five kilometres'],
      emoji: '🧮',
    ),
    GrammarTopic(
      title: 'Narrative sequence and interruption',
      level: 'B1',
      summary:
          'Organize a story by separating background, main events, interruptions, and the final result.',
      examples: [
        'I was waiting when the message arrived.',
        'After that, we changed our plan.',
        'In the end, everything worked.',
      ],
      emoji: '📖',
    ),
    GrammarTopic(
      title: 'Verbs with complements',
      level: 'B1',
      summary:
          'Choose the natural structure after common verbs: a noun, infinitive, clause, participle, or language-specific complement.',
      examples: [
        'decide to leave',
        'enjoy learning',
        'explain that the flight changed',
      ],
      emoji: '🧩',
    ),
    GrammarTopic(
      title: 'Focus through clause choice',
      level: 'B2',
      summary:
          'Choose active, passive, existential, and cleft-like structures according to what the listener already knows.',
      examples: [
        'Someone repaired the lift.',
        'The lift was repaired.',
        'What we need is a clear answer.',
      ],
      emoji: '🎬',
    ),
    GrammarTopic(
      title: 'Managing distance and certainty',
      level: 'B2',
      summary:
          'Calibrate claims with probability, evidence, hedging, approximation, and polite distance.',
      examples: [
        'It is likely to change.',
        'It seems that we misunderstood.',
        'I may be mistaken, but…',
      ],
      emoji: '🌡️',
    ),
    GrammarTopic(
      title: 'Nominalisation and information density',
      level: 'C1',
      summary:
          'Package actions and qualities as noun phrases when formal or academic writing needs compact, connected information.',
      examples: [
        'They decided → their decision',
        'The system failed → system failure',
        'Because demand increased → due to increased demand',
      ],
      emoji: '🗜️',
    ),
    GrammarTopic(
      title: 'Parallelism and rhetorical balance',
      level: 'C1',
      summary:
          'Coordinate matching grammatical forms to make complex speech and writing clearer, more memorable, and more persuasive.',
      examples: [
        'to plan, to test, and to improve',
        'not only accurate but also natural',
        'what we know and what we still need',
      ],
      emoji: '⚖️',
    ),
    GrammarTopic(
      title: 'Strategic ambiguity and implication',
      level: 'C2',
      summary:
          'Recognize when grammar leaves agency, commitment, time, or evaluation implicit—and decide whether that effect is useful or misleading.',
      examples: [
        'Mistakes were made.',
        'One might question whether…',
        'That is an interesting choice.',
      ],
      emoji: '🌫️',
    ),
    GrammarTopic(
      title: 'Grammar across dialect and genre',
      level: 'C2',
      summary:
          'Compare how conversation, journalism, academic prose, literature, and regional varieties reshape the same underlying message.',
      examples: [
        'spoken compression',
        'formal expansion',
        'regional preference versus universal norm',
      ],
      emoji: '🗺️',
    ),
    GrammarTopic(
      title: 'Core sentence order',
      level: 'A1',
      summary:
          'Build a dependable sentence frame and learn where the subject, action, object, time, and place normally appear.',
      explanation:
          'Begin with the neutral word order used in clear everyday statements. Then compare how questions, emphasis, and the target language may move or omit parts. Learn the pattern as a meaning frame rather than translating one word at a time.',
      keyRules: [
        'Identify who or what the message is about.',
        'Place the action in the normal position for the target language.',
        'Add time and place without separating words that belong together.',
      ],
      commonMistakes: [
        'Copying the source-language order exactly.',
        'Keeping a subject that the target language normally omits.',
      ],
      practicePrompts: [
        'Build a statement about today.',
        'Turn the statement into a question.',
        'Move one detail to add emphasis.',
      ],
      examples: [
        'I need help today.',
        'Where can I find the station?',
        'Tomorrow we start early.',
      ],
      emoji: '🧱',
    ),
    GrammarTopic(
      title: 'Negatives and short answers',
      level: 'A1',
      summary:
          'Say no accurately, answer yes/no questions naturally, and avoid double-negation errors across languages.',
      explanation:
          'A negative is more than adding one word. The verb, auxiliary, pronoun, or word order may change. Learn the full negative frame and the short answer that native speakers actually use.',
      keyRules: [
        'Place the negative marker in its language-specific position.',
        'Match the short answer to the form of the question.',
        'Learn whether multiple negative words agree or cancel each other.',
      ],
      commonMistakes: [
        'Using a literal yes where the target language answers the negative idea.',
        'Forgetting the auxiliary or verb change.',
      ],
      practicePrompts: [
        'Make three positive sentences negative.',
        'Answer one positive and one negative question.',
      ],
      examples: [
        'I do not understand.',
        'No, I cannot.',
        'I have never been there.',
      ],
      emoji: '🚫',
    ),
    GrammarTopic(
      title: 'Everyday prepositions and particles',
      level: 'A2',
      summary:
          'Choose natural markers for place, direction, time, transport, accompaniment, and purpose.',
      explanation:
          'Small linking words rarely match one-to-one across languages. Study them in complete chunks: at the airport, on Monday, by bus, with a friend. Contrast meaning groups and record exceptions as phrases.',
      keyRules: [
        'Learn prepositions with the noun or verb they accompany.',
        'Separate static location from movement toward a destination.',
        'Check whether the following word changes form.',
      ],
      commonMistakes: [
        'Choosing a preposition by dictionary translation alone.',
        'Using the same marker for time and place without checking usage.',
      ],
      practicePrompts: [
        'Describe a route using five location phrases.',
        'Schedule three events using time phrases.',
      ],
      examples: ['at the hotel', 'to the station', 'by train', 'for two days'],
      emoji: '📍',
    ),
    GrammarTopic(
      title: 'Requests, permission, and obligation',
      level: 'A2',
      summary:
          'Ask politely, give permission, express necessity, and distinguish strong rules from friendly advice.',
      explanation:
          'Modal meaning changes with power, distance, and urgency. Compare a direct command, a neutral request, a polite request, advice, and a strict obligation. Use tone and softeners where the culture expects them.',
      keyRules: [
        'Match the request form to the relationship and situation.',
        'Distinguish must, need to, should, may, and can.',
        'Use a question form when a direct command would sound harsh.',
      ],
      commonMistakes: [
        'Using the strongest modal for ordinary advice.',
        'Translating please without changing the grammar of the request.',
      ],
      practicePrompts: [
        'Rewrite one command in three levels of politeness.',
        'Explain a hotel rule and give a travel recommendation.',
      ],
      examples: [
        'Could you help me?',
        'You may enter now.',
        'You should rest.',
      ],
      emoji: '🤲',
    ),
    GrammarTopic(
      title: 'Reported speech and viewpoint',
      level: 'B1',
      summary:
          'Report what someone said, asked, promised, or believed while keeping time and viewpoint clear.',
      explanation:
          'When speech is reported, pronouns, tense, time expressions, and word order can shift. Some languages require backshifting; others keep the original tense. The key is to preserve who knew what and when.',
      keyRules: [
        'Choose a reporting verb that matches the communicative act.',
        'Adjust pronouns and time references to the new speaker.',
        'Use statement order inside reported questions where required.',
      ],
      commonMistakes: [
        'Keeping question word order inside an indirect question.',
        'Changing tense mechanically even when the fact is still true.',
      ],
      practicePrompts: [
        'Report a request, a question, and a promise.',
        'Retell a short conversation from another viewpoint.',
      ],
      examples: [
        'She said that the flight was delayed.',
        'He asked where the gate was.',
        'They promised to call.',
      ],
      emoji: '🗨️',
    ),
    GrammarTopic(
      title: 'Relative clauses for useful detail',
      level: 'B1',
      summary:
          'Identify people and things, add extra information, and avoid repeating short sentences.',
      explanation:
          'A relative clause connects a noun with the information that identifies or describes it. Learn when the marker changes for person, thing, place, ownership, or grammatical role, and when commas change the meaning.',
      keyRules: [
        'Decide whether the information identifies the noun or only adds detail.',
        'Choose the relative marker by its role inside the clause.',
        'Keep the clause next to the noun it describes.',
      ],
      commonMistakes: [
        'Repeating the noun or pronoun inside the clause unnecessarily.',
        'Using commas around information that is needed to identify the noun.',
      ],
      practicePrompts: [
        'Combine two sentences about a person.',
        'Describe a place using where and an object using that.',
      ],
      examples: [
        'The doctor who helped me was kind.',
        'This is the room that we booked.',
        'Gaza is a place where family matters deeply.',
      ],
      emoji: '🧷',
    ),
    GrammarTopic(
      title: 'Advanced conditionals and alternatives',
      level: 'B2',
      summary:
          'Discuss real possibilities, imagined situations, past regrets, mixed time, and alternatives to if.',
      explanation:
          'Conditional forms express more than time: they signal probability, distance, politeness, criticism, and regret. Map the time of the condition and result separately before choosing the form.',
      keyRules: [
        'Identify whether each clause refers to past, present, or future.',
        'Choose a real or hypothetical frame according to probability.',
        'Use alternatives such as unless, provided that, and otherwise accurately.',
      ],
      commonMistakes: [
        'Using the same tense pattern for every conditional.',
        'Confusing unless with if not in contexts where an exception exists.',
      ],
      practicePrompts: [
        'Write a real plan, an imaginary plan, and a past regret.',
        'Rewrite one condition using unless.',
      ],
      examples: [
        'If the weather improves, we will leave.',
        'If I had more time, I would study daily.',
        'Had we known, we would have changed the booking.',
      ],
      emoji: '🔀',
    ),
    GrammarTopic(
      title: 'Cohesion across a full paragraph',
      level: 'B2',
      summary:
          'Guide the reader through contrast, cause, reference, repetition, and topic development without sounding mechanical.',
      explanation:
          'Strong writing connects ideas through grammar, not only linking words. Use pronouns, repeated key terms, substitution, parallel structures, and information order so every sentence grows from the previous one.',
      keyRules: [
        'Make every pronoun refer to one clear noun.',
        'Use connectors only when the logical relationship is real.',
        'Move from known information to new information.',
      ],
      commonMistakes: [
        'Beginning every sentence with a connector.',
        'Using this or it without a clear reference.',
      ],
      practicePrompts: [
        'Repair a paragraph with unclear pronouns.',
        'Combine five notes into one coherent paragraph.',
      ],
      examples: [
        'The service was delayed. This affected every patient.',
        'Although the plan was difficult, the team completed it.',
      ],
      emoji: '🧵',
    ),
    GrammarTopic(
      title: 'Stance in academic and professional writing',
      level: 'C1',
      summary:
          'Express confidence, caution, limitation, evaluation, and responsibility with precise grammatical choices.',
      explanation:
          'Expert writing distinguishes evidence from interpretation. Combine reporting verbs, modal expressions, adverbs, impersonal structures, and first-person responsibility to show exactly how strongly you support a claim.',
      keyRules: [
        'Match certainty to the strength of the evidence.',
        'Attribute another person’s claim accurately.',
        'State limitations without weakening every sentence.',
      ],
      commonMistakes: [
        'Using proves when the evidence only suggests.',
        'Hiding responsibility behind passive language unnecessarily.',
      ],
      practicePrompts: [
        'Rewrite one absolute claim with appropriate caution.',
        'Compare two sources using different reporting verbs.',
      ],
      examples: [
        'The findings suggest that…',
        'This may be explained by…',
        'We acknowledge two limitations.',
      ],
      emoji: '🔬',
    ),
    GrammarTopic(
      title: 'Fronting, inversion, and marked emphasis',
      level: 'C1',
      summary:
          'Reshape normal word order to control emphasis, contrast, drama, and formal style without losing clarity.',
      explanation:
          'Marked word order tells the listener what deserves attention. It may require inversion, a resumptive form, or special intonation. Use it deliberately; excessive fronting makes ordinary information sound dramatic.',
      keyRules: [
        'Begin with the element that needs contrast or thematic focus.',
        'Apply any required inversion after restrictive or negative openings.',
        'Check that the marked structure remains natural in the genre.',
      ],
      commonMistakes: [
        'Fronting every important word without grammatical adjustment.',
        'Using literary inversion in casual conversation.',
      ],
      practicePrompts: [
        'Emphasize the time, then the object, in one sentence.',
        'Rewrite a neutral sentence for a formal speech.',
      ],
      examples: [
        'Only then did we understand.',
        'What matters most is consistency.',
        'This problem, we can solve.',
      ],
      emoji: '🎯',
    ),
    GrammarTopic(
      title: 'Pragmatic grammar and implied meaning',
      level: 'C2',
      summary:
          'Interpret how grammar communicates politeness, irony, criticism, solidarity, hesitation, and meanings left unsaid.',
      explanation:
          'At mastery level, the grammar chosen can communicate a second message beyond the literal words. Analyze tense distance, question forms, understatement, echo structures, and deliberate vagueness together with tone and context.',
      keyRules: [
        'Separate literal sentence meaning from the speaker’s likely intention.',
        'Use shared context to interpret omission and understatement.',
        'Avoid irony where cultural or power differences make it unsafe.',
      ],
      commonMistakes: [
        'Treating every question as a request for information.',
        'Assuming a grammatically polite form always sounds warm.',
      ],
      practicePrompts: [
        'Explain three possible intentions behind one question.',
        'Rewrite a direct criticism as tactful professional feedback.',
      ],
      examples: [
        'Could we perhaps reconsider that?',
        'You might want to check the figures again.',
        'So that was your plan, was it?',
      ],
      emoji: '🎭',
    ),
    GrammarTopic(
      title: 'Editing for native-like precision',
      level: 'C2',
      summary:
          'Diagnose subtle problems in agreement, information flow, idiomatic complementation, register, and rhythm.',
      explanation:
          'Final editing asks not only whether a sentence is correct, but whether it is the most natural choice for this audience and purpose. Review from structure to meaning, then from meaning to tone and sound.',
      keyRules: [
        'Check the sentence frame before replacing individual words.',
        'Keep parallel items in matching grammatical forms.',
        'Read aloud to detect overloaded rhythm and hidden ambiguity.',
      ],
      commonMistakes: [
        'Replacing words with formal synonyms that do not fit the structure.',
        'Editing every repeated word even when repetition supports cohesion.',
      ],
      practicePrompts: [
        'Edit a paragraph for clarity, then for register.',
        'Explain why each change improves meaning or tone.',
      ],
      examples: [
        'precise reference',
        'idiomatic verb pattern',
        'balanced information density',
      ],
      emoji: '💎',
    ),
  ];

  static const Map<String, List<PhraseEntry>> phrasebooks = {
    'en': [
      PhraseEntry(source: 'Hello', target: 'Hello', category: 'Essentials'),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'Thank you very much',
        category: 'Essentials',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: 'What is your name?',
        category: 'Introductions',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: 'Where is the station?',
        category: 'Travel',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'I would like to order',
        category: 'Food',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: 'I have a reservation',
        category: 'Hotel',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: 'How much does this cost?',
        category: 'Shopping',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: 'I need a doctor',
        category: 'Health',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: 'Could we schedule a meeting?',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'Please call emergency services',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'It was lovely to meet you',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: 'What is the Wi-Fi password?',
        category: 'Technology',
      ),
    ],
    'ar': [
      PhraseEntry(
        source: 'Hello',
        target: 'مرحبًا',
        category: 'Essentials',
        pronunciation: 'marhaban',
      ),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'شكرًا جزيلًا',
        category: 'Essentials',
        pronunciation: 'shukran jazilan',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: 'ما اسمك؟',
        category: 'Introductions',
        pronunciation: 'ma ismuk?',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: 'أين المحطة؟',
        category: 'Travel',
        pronunciation: 'ayna al-mahatta?',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'أود أن أطلب',
        category: 'Food',
        pronunciation: 'awaddu an atlub',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: 'لدي حجز',
        category: 'Hotel',
        pronunciation: 'ladayya hajz',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: 'كم سعر هذا؟',
        category: 'Shopping',
        pronunciation: 'kam siʿru hatha?',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: 'أحتاج إلى طبيب',
        category: 'Health',
        pronunciation: 'ahtaju ila tabib',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: 'هل يمكن أن نحدد موعدًا للاجتماع؟',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'اتصل بالطوارئ من فضلك',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'سعدت بلقائك',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: 'ما كلمة مرور الواي فاي؟',
        category: 'Technology',
      ),
    ],
    'es': [
      PhraseEntry(source: 'Hello', target: 'Hola', category: 'Essentials'),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'Muchas gracias',
        category: 'Essentials',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: '¿Cómo te llamas?',
        category: 'Introductions',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: '¿Dónde está la estación?',
        category: 'Travel',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'Quisiera pedir',
        category: 'Food',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: 'Tengo una reserva',
        category: 'Hotel',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: '¿Cuánto cuesta esto?',
        category: 'Shopping',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: 'Necesito un médico',
        category: 'Health',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: '¿Podríamos programar una reunión?',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'Llame a emergencias, por favor',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'Fue un placer conocerte',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: '¿Cuál es la contraseña del wifi?',
        category: 'Technology',
      ),
    ],
    'fr': [
      PhraseEntry(source: 'Hello', target: 'Bonjour', category: 'Essentials'),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'Merci beaucoup',
        category: 'Essentials',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: 'Comment vous appelez-vous ?',
        category: 'Introductions',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: 'Où est la gare ?',
        category: 'Travel',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'Je voudrais commander',
        category: 'Food',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: "J’ai une réservation",
        category: 'Hotel',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: 'Combien ça coûte ?',
        category: 'Shopping',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: "J’ai besoin d’un médecin",
        category: 'Health',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: 'Pourrions-nous fixer une réunion ?',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'Appelez les secours, s’il vous plaît',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'Ravi de vous avoir rencontré',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: 'Quel est le mot de passe Wi-Fi ?',
        category: 'Technology',
      ),
    ],
    'de': [
      PhraseEntry(source: 'Hello', target: 'Hallo', category: 'Essentials'),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'Vielen Dank',
        category: 'Essentials',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: 'Wie heißen Sie?',
        category: 'Introductions',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: 'Wo ist der Bahnhof?',
        category: 'Travel',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'Ich möchte bestellen',
        category: 'Food',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: 'Ich habe eine Reservierung',
        category: 'Hotel',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: 'Wie viel kostet das?',
        category: 'Shopping',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: 'Ich brauche einen Arzt',
        category: 'Health',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: 'Könnten wir einen Termin vereinbaren?',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'Rufen Sie bitte den Notdienst',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'Es war schön, Sie kennenzulernen',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: 'Wie lautet das WLAN-Passwort?',
        category: 'Technology',
      ),
    ],
    'tr': [
      PhraseEntry(source: 'Hello', target: 'Merhaba', category: 'Essentials'),
      PhraseEntry(
        source: 'Thank you very much',
        target: 'Çok teşekkür ederim',
        category: 'Essentials',
      ),
      PhraseEntry(
        source: 'What is your name?',
        target: 'Adınız ne?',
        category: 'Introductions',
      ),
      PhraseEntry(
        source: 'Where is the station?',
        target: 'İstasyon nerede?',
        category: 'Travel',
      ),
      PhraseEntry(
        source: 'I would like to order',
        target: 'Sipariş vermek istiyorum',
        category: 'Food',
      ),
      PhraseEntry(
        source: 'I have a reservation',
        target: 'Rezervasyonum var',
        category: 'Hotel',
      ),
      PhraseEntry(
        source: 'How much does this cost?',
        target: 'Bu ne kadar?',
        category: 'Shopping',
      ),
      PhraseEntry(
        source: 'I need a doctor',
        target: 'Bir doktora ihtiyacım var',
        category: 'Health',
      ),
      PhraseEntry(
        source: 'Could we schedule a meeting?',
        target: 'Bir toplantı planlayabilir miyiz?',
        category: 'Work',
      ),
      PhraseEntry(
        source: 'Please call emergency services',
        target: 'Lütfen acil servisi arayın',
        category: 'Emergencies',
      ),
      PhraseEntry(
        source: 'It was lovely to meet you',
        target: 'Tanıştığımıza memnun oldum',
        category: 'Relationships',
      ),
      PhraseEntry(
        source: 'What is the Wi-Fi password?',
        target: 'Wi-Fi şifresi nedir?',
        category: 'Technology',
      ),
    ],
  };

  static List<PhraseEntry> phrasesFor(
    String languageCode, {
    String sourceLanguageCode = 'en',
  }) {
    final effectiveSourceCode = sourceLanguageCode == languageCode
        ? 'en'
        : sourceLanguageCode;
    // The legacy bundled phrasebooks have English meanings only. They are
    // included only when English is the requested meaning language; otherwise
    // the aligned global/starter records are used so no English meaning is
    // mislabeled as Arabic, Spanish, or another interface language.
    final bundled = effectiveSourceCode == 'en'
        ? phrasebooks[languageCode] ?? const <PhraseEntry>[]
        : const <PhraseEntry>[];
    final global = GlobalContentRepository.phrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    );
    final verified = CourseRepository.verifiedStarterPhrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    );
    final seen = <String>{};
    return [...global, ...bundled, ...verified]
        .where((item) => seen.add(item.target.toLowerCase()))
        .map(
          (item) => item.visual == '🗣️'
              ? PhraseEntry(
                  source: item.source,
                  target: item.target,
                  category: item.category,
                  pronunciation: item.pronunciation,
                  note: item.note,
                  visual: GlobalContentRepository.visualFor(
                    item.category,
                    item.source,
                  ),
                )
              : item,
        )
        .toList(growable: false);
  }

  static List<SentenceDrill> sentenceDrillsFor(
    String languageCode, {
    String sourceLanguageCode = 'en',
  }) {
    const missions = [
      'Recognize the exact meaning',
      'Recall without looking',
      'Say it with the target-language voice',
      'Use it in a real situation',
    ];
    return [
      for (final phrase in phrasesFor(
        languageCode,
        sourceLanguageCode: sourceLanguageCode,
      ))
        for (final mission in missions)
          SentenceDrill(
            source: phrase.source,
            target: phrase.target,
            category: phrase.category,
            mission: mission,
            visual: phrase.visual,
          ),
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

  static List<Achievement> achievements({
    required int xp,
    required int streak,
    required int lessons,
  }) => [
    Achievement(
      title: 'First Step',
      description: 'Complete your first lesson',
      emoji: '🌱',
      goal: 1,
      progress: lessons,
    ),
    Achievement(
      title: 'Focused Learner',
      description: 'Complete 10 lessons',
      emoji: '🎯',
      goal: 10,
      progress: lessons,
    ),
    Achievement(
      title: 'Course Explorer',
      description: 'Complete 50 lessons',
      emoji: '🧭',
      goal: 50,
      progress: lessons,
    ),
    Achievement(
      title: 'Seven-Day Flame',
      description: 'Maintain a 7-day streak',
      emoji: '🔥',
      goal: 7,
      progress: streak,
    ),
    Achievement(
      title: 'Thirty-Day Rhythm',
      description: 'Maintain a 30-day streak',
      emoji: '🌋',
      goal: 30,
      progress: streak,
    ),
    Achievement(
      title: 'XP Builder',
      description: 'Earn 1,000 XP',
      emoji: '⚡',
      goal: 1000,
      progress: xp,
    ),
    Achievement(
      title: 'Language Champion',
      description: 'Earn 5,000 XP',
      emoji: '🏆',
      goal: 5000,
      progress: xp,
    ),
    const Achievement(
      title: 'World Citizen',
      description: 'Study three different languages',
      emoji: '🌍',
      goal: 3,
      progress: 1,
    ),
  ];
}

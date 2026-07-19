import '../models/models.dart';

class GlobalPhraseConcept {
  const GlobalPhraseConcept({required this.source, required this.category, required this.translations});

  final String source;
  final String category;
  final Map<String, String> translations;
}

class SentenceDrill {
  const SentenceDrill({required this.source, required this.target, required this.category, required this.mission, this.visual = '💬'});

  final String source;
  final String target;
  final String category;
  final String mission;
  final String visual;
}

/// Original, bundled content shared by the phrasebook, Sentence Lab, lessons,
/// and Nexa Live. The compact concept model keeps every translation aligned
/// and makes future JSON/admin imports predictable.
abstract final class GlobalContentRepository {
  static const coreLanguageCodes = ['en', 'ar', 'es', 'fr', 'de', 'tr', 'pt', 'it', 'ru', 'zh', 'ja', 'ko'];

  static const concepts = <GlobalPhraseConcept>[
    GlobalPhraseConcept(source: 'How are you?', category: 'Introductions', translations: {'en':'How are you?','ar':'كيف حالك؟','es':'¿Cómo estás?','fr':'Comment allez-vous ?','de':'Wie geht es Ihnen?','tr':'Nasılsınız?','pt':'Como está?','it':'Come sta?','ru':'Как вы?','zh':'你好吗？','ja':'お元気ですか？','ko':'어떻게 지내세요?'}),
    GlobalPhraseConcept(source: 'I am doing well, thank you', category: 'Introductions', translations: {'en':'I am doing well, thank you','ar':'أنا بخير، شكرًا لك','es':'Estoy bien, gracias','fr':'Je vais bien, merci','de':'Mir geht es gut, danke','tr':'İyiyim, teşekkür ederim','pt':'Estou bem, obrigado','it':'Sto bene, grazie','ru':'У меня всё хорошо, спасибо','zh':'我很好，谢谢','ja':'元気です、ありがとう','ko':'잘 지내요, 감사합니다'}),
    GlobalPhraseConcept(source: 'Nice to meet you', category: 'Introductions', translations: {'en':'Nice to meet you','ar':'سعدت بلقائك','es':'Mucho gusto','fr':'Enchanté de vous rencontrer','de':'Schön, Sie kennenzulernen','tr':'Tanıştığımıza memnun oldum','pt':'Prazer em conhecê-lo','it':'Piacere di conoscerla','ru':'Приятно познакомиться','zh':'很高兴认识你','ja':'はじめまして','ko':'만나서 반갑습니다'}),
    GlobalPhraseConcept(source: 'Where are you from?', category: 'Introductions', translations: {'en':'Where are you from?','ar':'من أين أنت؟','es':'¿De dónde eres?','fr':'D’où venez-vous ?','de':'Woher kommen Sie?','tr':'Nerelisiniz?','pt':'De onde é?','it':'Di dov’è?','ru':'Откуда вы?','zh':'你来自哪里？','ja':'ご出身はどちらですか？','ko':'어디에서 오셨어요?'}),
    GlobalPhraseConcept(source: 'I am learning this language', category: 'Introductions', translations: {'en':'I am learning this language','ar':'أنا أتعلم هذه اللغة','es':'Estoy aprendiendo este idioma','fr':'J’apprends cette langue','de':'Ich lerne diese Sprache','tr':'Bu dili öğreniyorum','pt':'Estou a aprender esta língua','it':'Sto imparando questa lingua','ru':'Я изучаю этот язык','zh':'我正在学习这门语言','ja':'この言語を勉強しています','ko':'이 언어를 배우고 있어요'}),
    GlobalPhraseConcept(source: 'I do not understand', category: 'Essentials', translations: {'en':'I do not understand','ar':'أنا لا أفهم','es':'No entiendo','fr':'Je ne comprends pas','de':'Ich verstehe nicht','tr':'Anlamıyorum','pt':'Não entendo','it':'Non capisco','ru':'Я не понимаю','zh':'我不明白','ja':'わかりません','ko':'이해하지 못했어요'}),
    GlobalPhraseConcept(source: 'Could you repeat that?', category: 'Essentials', translations: {'en':'Could you repeat that?','ar':'هل يمكنك أن تكرر ذلك؟','es':'¿Podría repetirlo?','fr':'Pourriez-vous répéter ?','de':'Könnten Sie das wiederholen?','tr':'Tekrar eder misiniz?','pt':'Pode repetir?','it':'Può ripetere?','ru':'Не могли бы вы повторить?','zh':'您能再说一遍吗？','ja':'もう一度言っていただけますか？','ko':'다시 말씀해 주시겠어요?'}),
    GlobalPhraseConcept(source: 'Please speak more slowly', category: 'Essentials', translations: {'en':'Please speak more slowly','ar':'تحدث ببطء أكثر من فضلك','es':'Hable más despacio, por favor','fr':'Parlez plus lentement, s’il vous plaît','de':'Bitte sprechen Sie langsamer','tr':'Lütfen daha yavaş konuşun','pt':'Fale mais devagar, por favor','it':'Parli più lentamente, per favore','ru':'Говорите, пожалуйста, медленнее','zh':'请说慢一点','ja':'もう少しゆっくり話してください','ko':'좀 더 천천히 말씀해 주세요'}),
    GlobalPhraseConcept(source: 'What does this mean?', category: 'Essentials', translations: {'en':'What does this mean?','ar':'ماذا يعني هذا؟','es':'¿Qué significa esto?','fr':'Qu’est-ce que cela signifie ?','de':'Was bedeutet das?','tr':'Bu ne anlama geliyor?','pt':'O que significa isto?','it':'Che cosa significa?','ru':'Что это значит?','zh':'这是什么意思？','ja':'これはどういう意味ですか？','ko':'이게 무슨 뜻이에요?'}),
    GlobalPhraseConcept(source: 'Can you help me?', category: 'Essentials', translations: {'en':'Can you help me?','ar':'هل يمكنك مساعدتي؟','es':'¿Puede ayudarme?','fr':'Pouvez-vous m’aider ?','de':'Können Sie mir helfen?','tr':'Bana yardım edebilir misiniz?','pt':'Pode ajudar-me?','it':'Può aiutarmi?','ru':'Вы можете мне помочь?','zh':'你能帮我吗？','ja':'手伝っていただけますか？','ko':'도와주실 수 있나요?'}),
    GlobalPhraseConcept(source: 'Where is the restroom?', category: 'Travel', translations: {'en':'Where is the restroom?','ar':'أين دورة المياه؟','es':'¿Dónde está el baño?','fr':'Où sont les toilettes ?','de':'Wo ist die Toilette?','tr':'Tuvalet nerede?','pt':'Onde fica a casa de banho?','it':'Dov’è il bagno?','ru':'Где находится туалет?','zh':'洗手间在哪里？','ja':'お手洗いはどこですか？','ko':'화장실이 어디예요?'}),
    GlobalPhraseConcept(source: 'I need a ticket to the city center', category: 'Travel', translations: {'en':'I need a ticket to the city center','ar':'أحتاج تذكرة إلى وسط المدينة','es':'Necesito un billete al centro','fr':'Il me faut un billet pour le centre-ville','de':'Ich brauche eine Fahrkarte ins Stadtzentrum','tr':'Şehir merkezine bir bilet istiyorum','pt':'Preciso de um bilhete para o centro','it':'Mi serve un biglietto per il centro','ru':'Мне нужен билет до центра города','zh':'我需要一张去市中心的票','ja':'市内中心部までの切符をお願いします','ko':'시내 중심가로 가는 표가 필요해요'}),
    GlobalPhraseConcept(source: 'What time does the train leave?', category: 'Travel', translations: {'en':'What time does the train leave?','ar':'متى يغادر القطار؟','es':'¿A qué hora sale el tren?','fr':'À quelle heure part le train ?','de':'Wann fährt der Zug ab?','tr':'Tren saat kaçta kalkıyor?','pt':'A que horas parte o comboio?','it':'A che ora parte il treno?','ru':'Во сколько отправляется поезд?','zh':'火车几点出发？','ja':'電車は何時に出ますか？','ko':'기차가 몇 시에 출발해요?'}),
    GlobalPhraseConcept(source: 'Is this the right platform?', category: 'Travel', translations: {'en':'Is this the right platform?','ar':'هل هذه هي المنصة الصحيحة؟','es':'¿Es este el andén correcto?','fr':'Est-ce le bon quai ?','de':'Ist das der richtige Bahnsteig?','tr':'Doğru peron burası mı?','pt':'Esta é a plataforma certa?','it':'È questo il binario giusto?','ru':'Это правильная платформа?','zh':'这是正确的站台吗？','ja':'このホームで合っていますか？','ko':'여기가 맞는 승강장인가요?'}),
    GlobalPhraseConcept(source: 'Turn left at the next street', category: 'Travel', translations: {'en':'Turn left at the next street','ar':'انعطف يسارًا عند الشارع التالي','es':'Gire a la izquierda en la próxima calle','fr':'Tournez à gauche à la prochaine rue','de':'Biegen Sie an der nächsten Straße links ab','tr':'Bir sonraki sokaktan sola dönün','pt':'Vire à esquerda na próxima rua','it':'Giri a sinistra alla prossima strada','ru':'Поверните налево на следующей улице','zh':'在下一个路口左转','ja':'次の通りを左に曲がってください','ko':'다음 길에서 왼쪽으로 도세요'}),
    GlobalPhraseConcept(source: 'Go straight ahead', category: 'Travel', translations: {'en':'Go straight ahead','ar':'اذهب إلى الأمام مباشرة','es':'Siga recto','fr':'Allez tout droit','de':'Gehen Sie geradeaus','tr':'Dümdüz gidin','pt':'Siga em frente','it':'Vada sempre dritto','ru':'Идите прямо','zh':'一直往前走','ja':'まっすぐ進んでください','ko':'곧장 가세요'}),
    GlobalPhraseConcept(source: 'May I see the menu?', category: 'Food', translations: {'en':'May I see the menu?','ar':'هل يمكنني رؤية قائمة الطعام؟','es':'¿Puedo ver el menú?','fr':'Puis-je voir le menu ?','de':'Darf ich die Speisekarte sehen?','tr':'Menüyü görebilir miyim?','pt':'Posso ver o menu?','it':'Posso vedere il menù?','ru':'Можно посмотреть меню?','zh':'我可以看看菜单吗？','ja':'メニューを見せていただけますか？','ko':'메뉴를 볼 수 있을까요?'}),
    GlobalPhraseConcept(source: 'I would like a glass of water', category: 'Food', translations: {'en':'I would like a glass of water','ar':'أود كوبًا من الماء','es':'Quisiera un vaso de agua','fr':'Je voudrais un verre d’eau','de':'Ich hätte gern ein Glas Wasser','tr':'Bir bardak su istiyorum','pt':'Queria um copo de água','it':'Vorrei un bicchiere d’acqua','ru':'Я хотел бы стакан воды','zh':'我想要一杯水','ja':'お水を一杯お願いします','ko':'물 한 잔 주세요'}),
    GlobalPhraseConcept(source: 'Do you have a vegetarian option?', category: 'Food', translations: {'en':'Do you have a vegetarian option?','ar':'هل لديكم خيار نباتي؟','es':'¿Tienen una opción vegetariana?','fr':'Avez-vous une option végétarienne ?','de':'Haben Sie eine vegetarische Option?','tr':'Vejetaryen seçeneğiniz var mı?','pt':'Tem uma opção vegetariana?','it':'Avete un’opzione vegetariana?','ru':'У вас есть вегетарианское блюдо?','zh':'有素食选择吗？','ja':'ベジタリアン向けの料理はありますか？','ko':'채식 메뉴가 있나요?'}),
    GlobalPhraseConcept(source: 'The food is delicious', category: 'Food', translations: {'en':'The food is delicious','ar':'الطعام لذيذ','es':'La comida está deliciosa','fr':'Le repas est délicieux','de':'Das Essen ist köstlich','tr':'Yemek çok lezzetli','pt':'A comida está deliciosa','it':'Il cibo è delizioso','ru':'Еда очень вкусная','zh':'食物很好吃','ja':'料理はとてもおいしいです','ko':'음식이 맛있어요'}),
    GlobalPhraseConcept(source: 'Could we have the bill, please?', category: 'Food', translations: {'en':'Could we have the bill, please?','ar':'الحساب من فضلك','es':'La cuenta, por favor','fr':'L’addition, s’il vous plaît','de':'Die Rechnung, bitte','tr':'Hesabı alabilir miyiz, lütfen?','pt':'A conta, por favor','it':'Il conto, per favore','ru':'Счёт, пожалуйста','zh':'请结账','ja':'お会計をお願いします','ko':'계산서 주세요'}),
    GlobalPhraseConcept(source: 'I have a reservation under my name', category: 'Hotel', translations: {'en':'I have a reservation under my name','ar':'لدي حجز باسمي','es':'Tengo una reserva a mi nombre','fr':'J’ai une réservation à mon nom','de':'Ich habe eine Reservierung auf meinen Namen','tr':'Adıma bir rezervasyonum var','pt':'Tenho uma reserva em meu nome','it':'Ho una prenotazione a mio nome','ru':'У меня бронь на моё имя','zh':'我有一个以我名字预订的房间','ja':'私の名前で予約しています','ko':'제 이름으로 예약했어요'}),
    GlobalPhraseConcept(source: 'What time is check-out?', category: 'Hotel', translations: {'en':'What time is check-out?','ar':'متى موعد تسجيل المغادرة؟','es':'¿A qué hora es la salida?','fr':'À quelle heure faut-il libérer la chambre ?','de':'Wann ist der Check-out?','tr':'Çıkış saati kaç?','pt':'A que horas é o check-out?','it':'A che ora è il check-out?','ru':'Во сколько выезд?','zh':'几点退房？','ja':'チェックアウトは何時ですか？','ko':'체크아웃이 몇 시예요?'}),
    GlobalPhraseConcept(source: 'The room key is not working', category: 'Hotel', translations: {'en':'The room key is not working','ar':'مفتاح الغرفة لا يعمل','es':'La llave de la habitación no funciona','fr':'La clé de la chambre ne fonctionne pas','de':'Der Zimmerschlüssel funktioniert nicht','tr':'Oda anahtarı çalışmıyor','pt':'A chave do quarto não funciona','it':'La chiave della camera non funziona','ru':'Ключ от номера не работает','zh':'房卡不能用','ja':'部屋の鍵が使えません','ko':'객실 열쇠가 작동하지 않아요'}),
    GlobalPhraseConcept(source: 'Do you have this in another size?', category: 'Shopping', translations: {'en':'Do you have this in another size?','ar':'هل لديكم هذا بمقاس آخر؟','es':'¿Lo tienen en otra talla?','fr':'L’avez-vous dans une autre taille ?','de':'Haben Sie das in einer anderen Größe?','tr':'Bunun başka bedeni var mı?','pt':'Tem isto noutro tamanho?','it':'Lo avete in un’altra taglia?','ru':'У вас есть это другого размера?','zh':'这个有其他尺码吗？','ja':'別のサイズはありますか？','ko':'다른 사이즈가 있나요?'}),
    GlobalPhraseConcept(source: 'Can I pay by card?', category: 'Shopping', translations: {'en':'Can I pay by card?','ar':'هل يمكنني الدفع بالبطاقة؟','es':'¿Puedo pagar con tarjeta?','fr':'Puis-je payer par carte ?','de':'Kann ich mit Karte bezahlen?','tr':'Kartla ödeyebilir miyim?','pt':'Posso pagar com cartão?','it':'Posso pagare con la carta?','ru':'Можно оплатить картой?','zh':'可以刷卡吗？','ja':'カードで支払えますか？','ko':'카드로 결제할 수 있나요?'}),
    GlobalPhraseConcept(source: 'Where is the nearest pharmacy?', category: 'Health', translations: {'en':'Where is the nearest pharmacy?','ar':'أين أقرب صيدلية؟','es':'¿Dónde está la farmacia más cercana?','fr':'Où est la pharmacie la plus proche ?','de':'Wo ist die nächste Apotheke?','tr':'En yakın eczane nerede?','pt':'Onde fica a farmácia mais próxima?','it':'Dov’è la farmacia più vicina?','ru':'Где ближайшая аптека?','zh':'最近的药店在哪里？','ja':'一番近い薬局はどこですか？','ko':'가장 가까운 약국이 어디예요?'}),
    GlobalPhraseConcept(source: 'I have pain here', category: 'Health', translations: {'en':'I have pain here','ar':'أشعر بألم هنا','es':'Me duele aquí','fr':'J’ai mal ici','de':'Ich habe hier Schmerzen','tr':'Buram ağrıyor','pt':'Tenho dor aqui','it':'Ho dolore qui','ru':'У меня болит здесь','zh':'我这里疼','ja':'ここが痛いです','ko':'여기가 아파요'}),
    GlobalPhraseConcept(source: 'Please call an ambulance', category: 'Emergencies', translations: {'en':'Please call an ambulance','ar':'اتصل بالإسعاف من فضلك','es':'Llame a una ambulancia, por favor','fr':'Appelez une ambulance, s’il vous plaît','de':'Rufen Sie bitte einen Krankenwagen','tr':'Lütfen ambulans çağırın','pt':'Chame uma ambulância, por favor','it':'Chiami un’ambulanza, per favore','ru':'Вызовите скорую помощь, пожалуйста','zh':'请叫救护车','ja':'救急車を呼んでください','ko':'구급차를 불러 주세요'}),
    GlobalPhraseConcept(source: 'Could we schedule a meeting?', category: 'Work', translations: {'en':'Could we schedule a meeting?','ar':'هل يمكننا تحديد موعد لاجتماع؟','es':'¿Podríamos programar una reunión?','fr':'Pourrions-nous fixer une réunion ?','de':'Könnten wir einen Termin vereinbaren?','tr':'Bir toplantı planlayabilir miyiz?','pt':'Podemos marcar uma reunião?','it':'Potremmo fissare una riunione?','ru':'Мы можем назначить встречу?','zh':'我们可以安排一次会议吗？','ja':'会議の日程を決められますか？','ko':'회의 일정을 잡을 수 있을까요?'}),
    GlobalPhraseConcept(source: 'I will send the email today', category: 'Work', translations: {'en':'I will send the email today','ar':'سأرسل البريد الإلكتروني اليوم','es':'Enviaré el correo hoy','fr':'J’enverrai le courriel aujourd’hui','de':'Ich werde die E-Mail heute senden','tr':'E-postayı bugün göndereceğim','pt':'Vou enviar o e-mail hoje','it':'Invierò l’e-mail oggi','ru':'Я отправлю письмо сегодня','zh':'我今天会发送邮件','ja':'今日メールを送ります','ko':'오늘 이메일을 보내겠습니다'}),
    GlobalPhraseConcept(source: 'When is the deadline?', category: 'Work', translations: {'en':'When is the deadline?','ar':'متى الموعد النهائي؟','es':'¿Cuándo es la fecha límite?','fr':'Quelle est la date limite ?','de':'Wann ist die Frist?','tr':'Son tarih ne zaman?','pt':'Qual é o prazo?','it':'Quando è la scadenza?','ru':'Когда крайний срок?','zh':'截止日期是什么时候？','ja':'締め切りはいつですか？','ko':'마감일이 언제인가요?'}),
    GlobalPhraseConcept(source: 'What do you like to do?', category: 'Relationships', translations: {'en':'What do you like to do?','ar':'ماذا تحب أن تفعل؟','es':'¿Qué te gusta hacer?','fr':'Qu’aimez-vous faire ?','de':'Was machen Sie gern?','tr':'Ne yapmaktan hoşlanırsınız?','pt':'O que gosta de fazer?','it':'Che cosa le piace fare?','ru':'Что вы любите делать?','zh':'你喜欢做什么？','ja':'何をするのが好きですか？','ko':'무엇을 하는 것을 좋아하세요?'}),
    GlobalPhraseConcept(source: 'I enjoy music and reading', category: 'Relationships', translations: {'en':'I enjoy music and reading','ar':'أستمتع بالموسيقى والقراءة','es':'Me gustan la música y la lectura','fr':'J’aime la musique et la lecture','de':'Ich mag Musik und Lesen','tr':'Müzik ve kitap okumayı severim','pt':'Gosto de música e leitura','it':'Mi piacciono la musica e la lettura','ru':'Я люблю музыку и чтение','zh':'我喜欢音乐和阅读','ja':'音楽と読書が好きです','ko':'음악과 독서를 좋아해요'}),
    GlobalPhraseConcept(source: 'What is the Wi-Fi password?', category: 'Technology', translations: {'en':'What is the Wi-Fi password?','ar':'ما كلمة مرور الواي فاي؟','es':'¿Cuál es la contraseña del wifi?','fr':'Quel est le mot de passe Wi-Fi ?','de':'Wie lautet das WLAN-Passwort?','tr':'Wi-Fi şifresi nedir?','pt':'Qual é a palavra-passe do Wi-Fi?','it':'Qual è la password del Wi-Fi?','ru':'Какой пароль от Wi-Fi?','zh':'Wi-Fi密码是什么？','ja':'Wi-Fiのパスワードは何ですか？','ko':'와이파이 비밀번호가 뭐예요?'}),
    GlobalPhraseConcept(source: 'My phone battery is low', category: 'Technology', translations: {'en':'My phone battery is low','ar':'بطارية هاتفي منخفضة','es':'La batería de mi teléfono está baja','fr':'La batterie de mon téléphone est faible','de':'Mein Handyakku ist fast leer','tr':'Telefonumun şarjı az','pt':'A bateria do meu telemóvel está fraca','it':'La batteria del telefono è quasi scarica','ru':'Телефон почти разрядился','zh':'我的手机快没电了','ja':'携帯電話の充電が少ないです','ko':'휴대폰 배터리가 부족해요'}),
    GlobalPhraseConcept(source: 'Could you take a photo for me?', category: 'Travel', translations: {'en':'Could you take a photo for me?','ar':'هل يمكنك التقاط صورة لي؟','es':'¿Podría hacerme una foto?','fr':'Pourriez-vous me prendre en photo ?','de':'Könnten Sie ein Foto von mir machen?','tr':'Fotoğrafımı çekebilir misiniz?','pt':'Pode tirar-me uma fotografia?','it':'Può farmi una foto?','ru':'Не могли бы вы меня сфотографировать?','zh':'你能帮我拍张照片吗？','ja':'写真を撮っていただけますか？','ko':'사진을 찍어 주실 수 있나요?'}),
  ];

  static List<PhraseEntry> phrasesFor(String languageCode, {String sourceLanguageCode = 'en'}) {
    if (!coreLanguageCodes.contains(languageCode)) return const [];
    final code = languageCode;
    final sourceCode = coreLanguageCodes.contains(sourceLanguageCode) && sourceLanguageCode != languageCode ? sourceLanguageCode : 'en';
    return concepts
        .map((item) => PhraseEntry(
              source: item.translations[sourceCode] ?? item.source,
              target: item.translations[code] ?? item.source,
              category: item.category,
              note: 'LingoNexa global core',
              visual: visualFor(item.category, item.source),
            ))
        .toList(growable: false);
  }

  static List<SentenceDrill> sentenceDrillsFor(String languageCode, {String sourceLanguageCode = 'en'}) {
    final phrases = phrasesFor(languageCode, sourceLanguageCode: sourceLanguageCode);
    const missions = ['Recognize the meaning', 'Recall without looking', 'Say it with natural rhythm', 'Use it in a real situation'];
    return [
      for (final phrase in phrases)
        for (final mission in missions)
          SentenceDrill(source: phrase.source, target: phrase.target, category: phrase.category, mission: mission, visual: phrase.visual),
    ];
  }

  static int get localizedPhrasePairs => concepts.length * coreLanguageCodes.length;
  static int get sentenceDrillCount => localizedPhrasePairs * 4;

  static String visualFor(String category, String source) {
    final lower = source.toLowerCase();
    if (lower.contains('train') || lower.contains('ticket') || lower.contains('platform')) return '🚆';
    if (lower.contains('water')) return '💧';
    if (lower.contains('food') || lower.contains('menu') || lower.contains('vegetarian')) return '🍽️';
    if (lower.contains('bill') || lower.contains('pay') || lower.contains('card')) return '💳';
    if (lower.contains('hotel') || lower.contains('room') || lower.contains('reservation')) return '🏨';
    if (lower.contains('pharmacy') || lower.contains('pain') || lower.contains('ambulance')) return '🩺';
    if (lower.contains('email') || lower.contains('meeting') || lower.contains('deadline')) return '💼';
    if (lower.contains('phone') || lower.contains('wi-fi')) return '📱';
    if (lower.contains('photo')) return '📷';
    return switch (category) {
      'Introductions' => '👋',
      'Travel' => '🧭',
      'Food' => '🍽️',
      'Hotel' => '🏨',
      'Shopping' => '🛍️',
      'Health' => '🩺',
      'Emergencies' => '🆘',
      'Work' => '💼',
      'Relationships' => '🤝',
      'Technology' => '📱',
      _ => '💬',
    };
  }
}

<?php
namespace App\Support;

final class UiCopy
{
    public const SUPPORTED = ['en','ar','es','fr','de','tr','pt','it','ru','zh','ja','ko'];

    public static function get(string $locale): array
    {
        $all = self::all();
        return $all[$locale] ?? $all['en'];
    }

    public static function direction(string $locale): string
    {
        return $locale === 'ar' ? 'rtl' : 'ltr';
    }

    public static function languageProfile(string $locale, string $language): string
    {
        $templates = [
            'en' => 'In {language}, pay particular attention to the language’s characteristic word order, morphology, agreement, particles, register, sound system, and the way context carries grammatical meaning.',
            'ar' => 'في {language} انتبه بصورة خاصة إلى ترتيب الكلمات المميز للغة، وبنية الكلمات، والمطابقة، والأدوات، ومستوى الرسمية، والنظام الصوتي، والطريقة التي يساهم بها السياق في حمل المعنى النحوي.',
            'es' => 'En {language}, presta especial atención al orden característico, la morfología, la concordancia, las partículas, el registro, el sistema sonoro y la forma en que el contexto aporta significado gramatical.',
            'fr' => 'En {language}, observez particulièrement l’ordre des mots, la morphologie, l’accord, les particules, le registre, le système sonore et la manière dont le contexte porte le sens grammatical.',
            'de' => 'Achten Sie in {language} besonders auf die typische Wortstellung, Morphologie, Kongruenz, Partikeln, Register, das Lautsystem und darauf, wie der Kontext grammatische Bedeutung trägt.',
            'tr' => '{language} dilinde özellikle sözcük dizilişine, biçimbilime, uyuma, parçacıklara, resmiyet düzeyine, ses sistemine ve bağlamın dilbilgisel anlamı nasıl taşıdığına dikkat edin.',
            'pt' => 'Em {language}, observe especialmente a ordem das palavras, a morfologia, a concordância, as partículas, o registo, o sistema sonoro e a forma como o contexto transporta significado gramatical.',
            'it' => 'In {language}, presta particolare attenzione all’ordine delle parole, alla morfologia, all’accordo, alle particelle, al registro, al sistema sonoro e al ruolo del contesto nel significato grammaticale.',
            'ru' => 'В {language} особенно обращайте внимание на характерный порядок слов, морфологию, согласование, частицы, регистр, звуковую систему и роль контекста в передаче грамматического значения.',
            'zh' => '学习 {language} 时，要特别注意该语言特有的语序、词形变化、一致关系、助词、语体、语音系统，以及语境如何共同表达语法意义。',
            'ja' => '{language} では、その言語特有の語順、形態変化、一致、助詞、レジスター、音体系、そして文脈が文法的意味を担う仕組みに特に注目してください。',
            'ko' => '{language}에서는 그 언어 특유의 어순, 형태 변화, 일치, 조사·기능어, 격식, 소리 체계, 그리고 문맥이 문법 의미를 전달하는 방식에 특히 주목하세요.',
        ];
        return str_replace('{language}', $language, $templates[$locale] ?? $templates['en']);
    }

    private static function all(): array
    {
        return [
            'en'=>['home'=>'Home','learn'=>'Learn','practice'=>'Practice','academy'=>'Academy','community'=>'Community','profile'=>'Profile','tagline'=>'Learn boldly. Speak naturally.','interface'=>'Interface','grammar'=>'Grammar Library','chapters'=>'All chapters','openChapter'=>'Open a chapter to read the complete explanation.','bookExplanation'=>'Complete textbook explanation','examples'=>'Extended examples','readerNote'=>"Reader's note",'signOut'=>'Sign out'],
            'ar'=>['home'=>'الرئيسية','learn'=>'تعلّم','practice'=>'تدريب','academy'=>'الأكاديمية','community'=>'المجتمع','profile'=>'الملف الشخصي','tagline'=>'تعلّم بثقة. وتحدث بطبيعية.','interface'=>'لغة الواجهة','grammar'=>'مكتبة القواعد','chapters'=>'جميع الفصول','openChapter'=>'افتح أي فصل لقراءة الشرح الكامل المترابط.','bookExplanation'=>'الشرح الكامل بأسلوب كتاب تعليمي','examples'=>'أمثلة موسعة','readerNote'=>'ملاحظة للقارئ','signOut'=>'تسجيل الخروج'],
            'es'=>['home'=>'Inicio','learn'=>'Aprender','practice'=>'Práctica','academy'=>'Academia','community'=>'Comunidad','profile'=>'Perfil','tagline'=>'Aprende con confianza. Habla con naturalidad.','interface'=>'Interfaz','grammar'=>'Biblioteca de gramática','chapters'=>'Todos los capítulos','openChapter'=>'Abre un capítulo para leer la explicación completa.','bookExplanation'=>'Explicación completa','examples'=>'Ejemplos ampliados','readerNote'=>'Nota del lector','signOut'=>'Cerrar sesión'],
            'fr'=>['home'=>'Accueil','learn'=>'Apprendre','practice'=>'Pratique','academy'=>'Académie','community'=>'Communauté','profile'=>'Profil','tagline'=>'Apprenez avec assurance. Parlez naturellement.','interface'=>'Interface','grammar'=>'Bibliothèque de grammaire','chapters'=>'Tous les chapitres','openChapter'=>'Ouvrez un chapitre pour lire l’explication complète.','bookExplanation'=>'Explication complète','examples'=>'Exemples étendus','readerNote'=>'Note au lecteur','signOut'=>'Déconnexion'],
            'de'=>['home'=>'Start','learn'=>'Lernen','practice'=>'Üben','academy'=>'Akademie','community'=>'Community','profile'=>'Profil','tagline'=>'Mutig lernen. Natürlich sprechen.','interface'=>'Oberfläche','grammar'=>'Grammatikbibliothek','chapters'=>'Alle Kapitel','openChapter'=>'Öffnen Sie ein Kapitel für die vollständige Erklärung.','bookExplanation'=>'Vollständige Erklärung','examples'=>'Erweiterte Beispiele','readerNote'=>'Hinweis','signOut'=>'Abmelden'],
            'tr'=>['home'=>'Ana Sayfa','learn'=>'Öğren','practice'=>'Pratik','academy'=>'Akademi','community'=>'Topluluk','profile'=>'Profil','tagline'=>'Cesur öğren. Doğal konuş.','interface'=>'Arayüz','grammar'=>'Dilbilgisi Kütüphanesi','chapters'=>'Tüm bölümler','openChapter'=>'Tam açıklamayı okumak için bir bölüm açın.','bookExplanation'=>'Tam ders kitabı açıklaması','examples'=>'Genişletilmiş örnekler','readerNote'=>'Okuyucu notu','signOut'=>'Çıkış'],
            'pt'=>['home'=>'Início','learn'=>'Aprender','practice'=>'Prática','academy'=>'Academia','community'=>'Comunidade','profile'=>'Perfil','tagline'=>'Aprenda com confiança. Fale naturalmente.','interface'=>'Interface','grammar'=>'Biblioteca de gramática','chapters'=>'Todos os capítulos','openChapter'=>'Abra um capítulo para ler a explicação completa.','bookExplanation'=>'Explicação completa','examples'=>'Exemplos ampliados','readerNote'=>'Nota do leitor','signOut'=>'Sair'],
            'it'=>['home'=>'Home','learn'=>'Impara','practice'=>'Pratica','academy'=>'Accademia','community'=>'Comunità','profile'=>'Profilo','tagline'=>'Impara con sicurezza. Parla naturalmente.','interface'=>'Interfaccia','grammar'=>'Biblioteca di grammatica','chapters'=>'Tutti i capitoli','openChapter'=>'Apri un capitolo per leggere la spiegazione completa.','bookExplanation'=>'Spiegazione completa','examples'=>'Esempi estesi','readerNote'=>'Nota del lettore','signOut'=>'Esci'],
            'ru'=>['home'=>'Главная','learn'=>'Учиться','practice'=>'Практика','academy'=>'Академия','community'=>'Сообщество','profile'=>'Профиль','tagline'=>'Учитесь уверенно. Говорите естественно.','interface'=>'Интерфейс','grammar'=>'Библиотека грамматики','chapters'=>'Все главы','openChapter'=>'Откройте главу, чтобы прочитать полное объяснение.','bookExplanation'=>'Полное объяснение','examples'=>'Расширенные примеры','readerNote'=>'Примечание','signOut'=>'Выйти'],
            'zh'=>['home'=>'首页','learn'=>'学习','practice'=>'练习','academy'=>'学院','community'=>'社区','profile'=>'个人资料','tagline'=>'自信学习，自然表达。','interface'=>'界面语言','grammar'=>'语法库','chapters'=>'全部章节','openChapter'=>'打开章节阅读完整讲解。','bookExplanation'=>'教材式完整讲解','examples'=>'扩展例句','readerNote'=>'读者提示','signOut'=>'退出'],
            'ja'=>['home'=>'ホーム','learn'=>'学ぶ','practice'=>'練習','academy'=>'アカデミー','community'=>'コミュニティ','profile'=>'プロフィール','tagline'=>'自信を持って学び、自然に話す。','interface'=>'表示言語','grammar'=>'文法ライブラリ','chapters'=>'すべての章','openChapter'=>'章を開いて完全な解説を読みます。','bookExplanation'=>'教科書スタイルの完全解説','examples'=>'拡張例文','readerNote'=>'読者メモ','signOut'=>'ログアウト'],
            'ko'=>['home'=>'홈','learn'=>'학습','practice'=>'연습','academy'=>'아카데미','community'=>'커뮤니티','profile'=>'프로필','tagline'=>'자신 있게 배우고 자연스럽게 말하세요.','interface'=>'인터페이스','grammar'=>'문법 라이브러리','chapters'=>'모든 챕터','openChapter'=>'챕터를 열어 전체 설명을 읽으세요.','bookExplanation'=>'교재형 완전 설명','examples'=>'확장 예문','readerNote'=>'학습자 노트','signOut'=>'로그아웃'],
        ];
    }
}

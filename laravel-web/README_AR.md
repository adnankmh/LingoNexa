# LingoNexa Laravel Web + API

هذه هي طبقة الويب والـBackend المرافقة لتطبيق Flutter في إصدار 3.1.0.

## ماذا تعمل؟

- موقع Responsive للجوال واللابتوب قريب بصريًا من التطبيق.
- تسجيل حساب ودخول حقيقيان باستخدام قاعدة بيانات Laravel.
- Laravel Sanctum لتسجيل تطبيق Flutter عبر Bearer Token.
- مزامنة XP والمستوى والهدف اليومي والدروس والمراجعات والاختبارات والمهارات واللغة والدولة ولغة الواجهة والثيم.
- 67 لغة تعلم و249 دولة/إقليم بالأعلام.
- مكتبة القواعد 54 فصلًا A1–C2.
- شرح القواعد بـ12 لغة واجهة، مع RTL للعربية.
- Nexa Learning Labs وPractice وAcademy وCommunity وProfile.
- Phrasebook قابل للبحث، Course-bank Translator، تقييم Server-side، Achievements، Specialized Paths، وتنزيل Language Pack بصيغة JSON.
- حماية CSRF للويب، rate limiting للمصادقة، Security Headers، كلمة مرور قوية، وتشفير Session اختياري/مفعل في ملف البيئة المقترح.

## تشغيل سريع على Windows

1. ثبّت PHP 8.2 أو أحدث وComposer.
2. افتح مجلد `laravel-web`.
3. شغّل `SETUP_WINDOWS.bat` مرة واحدة.
4. بعد نجاح الإعداد شغّل `START_WINDOWS.bat`.
5. افتح `http://127.0.0.1:8000`.

## تشغيل يدوي

```bash
composer install
copy .env.example .env
php artisan key:generate
php -r "file_exists('database/database.sqlite') || touch('database/database.sqlite');"
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```

على Linux/macOS استخدم `cp .env.example .env` بدل `copy`.

## ربط Flutter

داخل شاشة تسجيل الدخول يوجد **Connect Laravel server**. للتجربة:

- Android Emulator: `http://10.0.2.2:8000`
- Flutter Web على نفس الجهاز: `http://127.0.0.1:8000`
- هاتف حقيقي: استخدم IP الكمبيوتر داخل الشبكة، مثل `http://192.168.1.20:8000` أثناء Debug فقط.
- Production: استخدم دومين HTTPS مثل `https://learn.example.com`.

يمكن أيضًا البناء مباشرة بعنوان الخادم:

```bash
flutter run --dart-define=LINGONEXA_API_URL=https://learn.example.com
flutter build apk --release --dart-define=LINGONEXA_API_URL=https://learn.example.com
```

## Production

- `APP_ENV=production`
- `APP_DEBUG=false`
- `SESSION_SECURE_COOKIE=true`
- استخدم HTTPS فقط.
- غيّر `CORS_ALLOWED_ORIGINS` من `*` إلى دومينات Flutter Web المسموحة.
- استخدم MySQL/PostgreSQL بدل SQLite عند الحاجة للتوسع.
- نفّذ `php artisan config:cache` و`php artisan route:cache` بعد ضبط البيئة.
- شغّل الاختبارات: `php artisan test`.

لا يتم الادعاء بأن Community/Voice Rooms realtime جاهزة قبل ربط خدمة realtime/moderation فعلية؛ الواجهة والبنية موجودتان لكن التفعيل العام يحتاج خدمة إنتاجية منفصلة.

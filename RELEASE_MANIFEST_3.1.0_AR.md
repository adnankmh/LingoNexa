# LingoNexa 3.1.0+15 — Full-Stack Learning Edition

هذه النسخة مبنية فوق 3.0.0+14 وليست إعادة إنشاء للمشروع.

## التعديلات الأساسية

- إعادة تصميم فصول القواعد لتعرض **الشرح الكامل + الأمثلة** فقط.
- إزالة واجهة أقسام: كيف تعمل اللغة، المعنى/الصيغة/الاستخدام، قواعد الاختيار، الأخطاء الشائعة، والاسترجاع الموجه من الفصل.
- 12 مثالًا في كل فصل عندما يتوفر بنك عبارات اللغة.
- شرح كتابي أصلي ومترابط بـ12 لغة واجهة، مع بصمة نحوية خاصة بكل واحدة من 67 لغة تعلم.
- إضافة Nexa Learning Labs: 12 أسلوب تعلم حديث.
- إضافة 9 ملفات Lottie جديدة، مع استخدام ملفات Lottie منفصلة لكل مختبر (إجمالي مكتبة الحركة أكبر من السابق).
- رفع عدد Themes إلى 12.
- إضافة 249 علم دولة/إقليم واختيار الدولة في الملف الشخصي.
- طبقة Laravel API حقيقية + Sanctum + تسجيل مستخدمين + تقدم مرتبط بالحساب.
- Secure Storage لرمز Flutter مع إبقاء cleartext HTTP محصورًا في Android Debug.
- موقع Laravel Responsive موسع: Landing, Auth, Dashboard, Learn, Practice, Academy, Grammar, Labs, Community, Profile, Phrasebook, Translator, Assessment, Achievements, Specialized Paths, Downloads.
- مزامنة لغة الواجهة والثيم مع حساب المستخدم، مع 12 Theme مشتركة بالمعرّفات نفسها بين Flutter وLaravel.
- Validation تفصيلي لأنواع بيانات progress على API مع دمج آمن للتحديثات الجزئية.
- موقع القواعد يدعم نفس 12 لغات الواجهة وعناوين 54 فصلًا المترجمة.
- Security headers + throttling + CSRF web + password policy + token expiration.

## ملاحظة نزاهة المحتوى

النصوص التعليمية الجديدة أصلية ومكتوبة بأسلوب كتب تعليمية احترافية. لا توجد عملية نسخ حرفي لمحتوى كتب تجارية محمية بحقوق النشر.

- تم حذف مجلد `build/` القديم الخاص بـ3.0 من حزمة التسليم لأنه لا يمثل مصدر 3.1؛ يتم توليد APK/AAB/Web جديدًا من المصدر أو GitHub Actions.

## التحقق داخل بيئة الإنشاء

- `scripts/validate_project.py`: PASS.
- جميع ملفات PHP المخصصة: `php -l` PASS.
- ملفات JSON الجديدة: parsing PASS.
- لا يتوفر Flutter/Dart CLI في بيئة الإنشاء الحالية، لذلك لم يتم الادعاء بتشغيل `flutter analyze/test` هنا. شغّلها بعد `flutter pub get` على جهاز البناء/GitHub Actions.
- لا يتوفر Composer في بيئة الإنشاء الحالية، لذلك لم يتم تثبيت `vendor/` أو تشغيل Laravel Feature Tests هنا؛ ملفات الاختبار والإعداد مرفقة للتنفيذ بعد `composer install`.

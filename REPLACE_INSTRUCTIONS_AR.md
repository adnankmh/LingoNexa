# استبدال النسخة وإصلاح Workflow

## الطريقة الأسهل الموصى بها

1. انسخ محتويات الإصدار الجديد فوق مستودع `LingoNexa` ووافق على Replace.
2. من داخل مجلد المستودع انقر مرتين على:
   `APPLY_LINGONEXA_FIX_WINDOWS.bat`
3. سيحذف تلقائيًا `dart.yml` و`dart.yaml` وأي ملفات Gradle قديمة تتعارض مع ملفات Kotlin DSL الحديثة.
4. ارجع إلى GitHub Desktop ونفّذ **Commit to main** ثم **Push origin** لكل التغييرات، بما فيها الملفات المحذوفة.

هذه الخطوة لا تحتاج Flutter أو Android Studio؛ هي مجرد تنظيف آمن للملفات القديمة.

## السبب

الرسالة `Flutter SDK is not available` تعني أن GitHub شغّل Workflow خاصًا بـ
Dart يحتوي `dart pub get`. مشروع LingoNexa هو Flutter ويجب أن يستخدم
`flutter pub get` بعد تثبيت Flutter SDK.

أما خطأ `checkReleaseAarMetadata` فسببه أن `android/settings.gradle` القديم كان
يفرض AGP 8.7.3 وKotlin 2.1.0. الإصدار الجديد يعتمد AGP 8.11.1 وKotlin 2.2.20
وGradle 8.13، ويحذف ملف Groovy القديم تلقائيًا داخل GitHub Actions أيضًا.

ملاحظة: تشغيلات Dart الحمراء القديمة تبقى ظاهرة في سجل Actions حتى بعد حذف
الملف. المهم ألّا يبدأ تشغيل جديد باسم Dart بعد آخر Push.

## الخطوات عبر GitHub Desktop

1. فك ضغط الحزمة الجديدة.
2. في GitHub Desktop اختر مستودع `LingoNexa` ثم **Repository → Show in Explorer**.
3. افتح داخل المستودع المسار `.github\workflows`.
4. انسخ **محتويات** مجلد الحزمة الجديدة فوق محتويات المستودع ووافق على Replace.
5. شغّل `APPLY_LINGONEXA_FIX_WINDOWS.bat` بنقرة مزدوجة.
6. تأكد أن الملف الوحيد بامتداد YAML داخل `.github\workflows` هو `build.yml`.
   ملف `README.md` الموجود معه طبيعي ولا يتم تشغيله.
7. ارجع إلى GitHub Desktop. اكتب Summary مثل `Upgrade LingoNexa 1.1.2 and fix Android build`.
8. اضغط **Commit to main** ثم **Push origin**.
9. في موقع GitHub افتح **Actions**. يجب أن يظهر Workflow باسم:
   `Flutter CI - APK - AAB - Web`.
10. افتحه ثم **Run workflow → Run workflow**، أو انتظر التشغيل الناتج عن Push.

## حذف Dart Workflow من موقع GitHub مباشرة

إذا استمر تشغيله بعد رفع النسخة الجديدة:

1. افتح المستودع ثم **Code**.
2. ادخل إلى `.github` ثم `workflows`.
3. افتح `dart.yml` أو `dart.yaml` إذا بقي أحدهما بعد الـPush.
4. اضغط قائمة النقاط `…` ثم **Delete file**.
5. اكتب رسالة مثل `Remove obsolete Dart workflow` ثم نفّذ **Commit changes** إلى `main`.
6. بديلًا عن الحذف: من **Actions** اختر Workflow باسم Dart، ثم قائمة `…` واختر **Disable workflow**.

بعد ذلك يجب أن يبدأ فقط `Flutter CI - APK - AAB - Web`. لا تحاول إعادة تشغيل
السجل الأحمر القديم؛ شغّل تشغيلًا جديدًا من Workflow الخاص بـFlutter.

لا تستخدم زر **Configure** لقالب Dart أو Simple workflow من صفحة Actions؛ ملف
البناء الصحيح موجود مسبقًا داخل المشروع.

بعد النجاح افتح التشغيل ثم قسم **Artifacts** ونزّل `lingonexa-android` لتحصل
على APK وAAB. GitHub Pages يعرض نسخة الويب ولا يحوّل الموقع بنفسه إلى APK.

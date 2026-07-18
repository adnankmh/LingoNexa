# استبدال النسخة وإصلاح Workflow

## الطريقة الأسهل الموصى بها

1. انسخ محتويات الإصدار الجديد فوق مستودع `LingoNexa` ووافق على Replace.
2. من داخل مجلد المستودع انقر مرتين على:
   `APPLY_LINGONEXA_FIX_WINDOWS.bat`
3. سيحذف تلقائيًا Workflows القديمة `dart.yml` و`dart.yaml` و`build.yml` وأي ملفات Gradle قديمة تتعارض مع ملفات Kotlin DSL الحديثة.
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
6. تأكد أن ملفات YAML الأساسية داخل `.github\workflows` هي: `flutter_ci.yml` و`apk.yml` و`aab.yml` و`web.yml` و`pages.yml`.
   ملف `README.md` الموجود معها طبيعي ولا يتم تشغيله.
7. ارجع إلى GitHub Desktop. اكتب Summary مثل `Upgrade LingoNexa 1.1.3 and split workflows`.
8. اضغط **Commit to main** ثم **Push origin**.
9. في موقع GitHub افتح **Actions**. يجب أن تظهر Workflows منفصلة بأسماء: `Flutter CI` و`APK` و`AAB` و`Web` و`Deploy GitHub Pages`.
10. يبدأ `Flutter CI` بعد Push، وبعد نجاحه تبدأ APK وAAB وWeb كل واحدة في تشغيل مستقل. ويمكن تشغيل أي واحدة يدويًا من **Run workflow**.

## حذف Dart Workflow من موقع GitHub مباشرة

إذا استمر تشغيله بعد رفع النسخة الجديدة:

1. افتح المستودع ثم **Code**.
2. ادخل إلى `.github` ثم `workflows`.
3. افتح `dart.yml` أو `dart.yaml` إذا بقي أحدهما بعد الـPush.
4. اضغط قائمة النقاط `…` ثم **Delete file**.
5. اكتب رسالة مثل `Remove obsolete Dart workflow` ثم نفّذ **Commit changes** إلى `main`.
6. بديلًا عن الحذف: من **Actions** اختر Workflow باسم Dart، ثم قائمة `…` واختر **Disable workflow**.

بعد ذلك يجب أن يبدأ `Flutter CI` فقط مباشرة بعد Push، ثم تبدأ Workflows البناء
المستقلة بعد نجاحه. لا تحاول إعادة تشغيل السجل الأحمر القديم.

لا تستخدم زر **Configure** لقالب Dart أو Simple workflow من صفحة Actions؛ ملف
البناء الصحيح موجود مسبقًا داخل المشروع.

بعد النجاح نزّل `lingonexa-apk` من Workflow APK و`lingonexa-aab` من Workflow
AAB و`lingonexa-web` من Workflow Web. GitHub Pages يعرض نسخة الويب فقط.

## تفعيل GitHub Pages مرة واحدة

1. افتح **Settings → Pages**.
2. تحت **Build and deployment** اختر **GitHub Actions** كمصدر النشر واحفظ.
3. افتح **Actions → Deploy GitHub Pages → Run workflow**.

إذا لم تكن Pages مفعلة، يفحص Workflow ذلك ويعرض Notice ثم يتخطى البناء والنشر
دون خطأ 404. بعد تفعيلها شغّله مرة ثانية.

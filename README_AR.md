# LingoNexa — منصة Flutter عالمية لتعلّم اللغات

الإصدار الحالي: **1.2.0+6**

LingoNexa مشروع أصلي مبني بـ Flutter، يعمل على Android والويب، ويقدّم أساسًا احترافيًا لمنصة تعليم لغات واسعة قابلة للتوسّع. لا يحتوي المشروع على أكواد أو صور أو شخصيات من Duolingo أو Babbel أو غيرهما.

## ما الموجود في النسخة

- كتالوج 67 لغة، مع الاسم الأصلي والعَلَم ونوع الكتابة واتجاه RTL عند الحاجة.
- ستة مستويات CEFR من A1 إلى C2.
- 36 وحدة و180 عقدة درس ديناميكية لكل لغة، أي 12,060 درسًا عبر الكتالوج.
- عشرة أنماط/خطوات تدريب داخل كل درس، أي أكثر من 120,000 خطوة تعليمية مولّدة من المحرك.
- نواة عالمية من 37 مفهومًا عمليًا مترجمًا إلى 12 لغة أساسية (444 زوج عبارة)، ومنها 1,776 مهمة جمل واستدعاء ونطق وسياق.
- نطق آلي TTS وتعرّف على الكلام عند دعم الجهاز للغة.
- مراجعة متباعدة، بنك أخطاء، مختبر نطق، قصص، مقالات، وروابط تعليمية.
- **Nexa Live**: شريك محادثة أصلي بالصوت والكتابة، ثلاث شخصيات، ستة سيناريوهات، نطق تلقائي، ترجمة، ملاحظات تصحيح، موجة صوت ودرجة طلاقة محلية، مع نقطة دمج جاهزة لخدمة AI حقيقية.
- مجتمع تجريبي: منشورات، تصحيحات، شركاء، غرف صوت، إبلاغ وحظر.
- ثمانية ثيمات وواجهة بـ12 لغة: العربية RTL، الإنجليزية، الإسبانية، الفرنسية، الألمانية، التركية، البرتغالية، الإيطالية، الروسية، الصينية، اليابانية، والكورية.
- الشعار الرسمي المرفق وهوية LingoNexa الجديدة داخل التطبيق، مع أيقونات Android وWeb وPWA عالية الدقة.
- لوحة إدارة محلية للبراند والهدف اليومي وتفعيل الوحدات وتصدير الإعدادات.
- تجربة بدء من أربع مراحل، تحديد هدف يومي وسبب التعلّم، واختبار تحديد مستوى.
- مركز عبارات وقاموس قابل للبحث والحفظ والنطق لعدة لغات رئيسية.
- مختبر جمل عالمي للبحث والتصفية والاستماع وإتقان أربع مهمات لكل عبارة.
- أطلس قواعد يغطي A1–C2 ومختبر أبجديات مع لوحة تدريب على الكتابة.
- ثمانية مسارات متخصصة: السفر، الأعمال، الصحة، الدراسة، الأطفال، الحياة بالخارج، الامتحانات، والإعلام.
- خطة تعلّم أسبوعية، إنجازات ودوري XP، تنزيلات دون إنترنت لكل اللغات، وسجل شهادات.
- GitHub Actions لفحص المشروع وبناء APK وAAB والويب ونشر GitHub Pages.

> مهم: النسخة تحتوي بنية تعليم كاملة وStarter Lexicon لكل اللغات، لكنها ليست بديلًا عن آلاف الساعات من المحتوى اللغوي الذي يراجعه مختصون ومتحدثون أصليون. قبل الإطلاق التجاري يجب إضافة حزم دروس موسعة وصوت مرخّص لكل لغة، وربط المجتمع والذكاء الاصطناعي بخادم إنتاج.

## أسهل طريقة بدون Android Studio — GitHub Desktop فقط

أنت لا تحتاج Android Studio لبناء APK أو AAB. GitHub Actions يقوم بالبناء على خوادم GitHub:

1. فك ضغط الحزمة، وافتح GitHub Desktop ثم **File → Add local repository** واختر مجلد المشروع نفسه الذي يحتوي `pubspec.yaml`.
2. إذا ظهر أنه ليس Repository اختر **create a repository**، واجعل الفرع `main`، ثم اضغط **Publish repository**.
3. من GitHub Desktop تأكد أن الملفات `.github/workflows/` موجودة ضمن التغييرات، اكتب Summary مثل `LingoNexa 1.2.0` واضغط **Commit to main** ثم **Push origin**.
4. افتح المستودع في المتصفح ثم **Actions**. شغّل **Flutter CI** أولًا من زر **Run workflow**.
5. بعد نجاحه، يتم تشغيل **APK** و**AAB** تلقائيًا. ويمكن تشغيل كل واحد يدويًا لأنه Workflow منفصل.
6. ادخل إلى التشغيل الناجح ثم قسم **Artifacts** ونزّل `lingonexa-apk` أو `lingonexa-aab`.
7. لبناء الويب نزّل `lingonexa-web` من Workflow **Web**.
8. لنشر الموقع: **Settings → Pages → Build and deployment → Source: GitHub Actions** ثم شغّل **Deploy GitHub Pages**. رابط Pages يشغّل نسخة Web فقط ولا يحوّل الموقع بذاته إلى APK.

إذا لم تظهر Workflows بعد الرفع، تحقق في GitHub Desktop أن المجلد المخفي `.github` موجود داخل جذر المشروع وأنك رفعت **محتويات المشروع** لا ملف ZIP.

## تشغيل المشروع محليًا على Windows — اختياري

1. ثبّت Flutter Stable. لتشغيل Android محليًا ستحتاج Android SDK (يمكن تثبيته بأدوات سطر الأوامر، ولا يلزم فتح Android Studio). هذه الخطوة غير مطلوبة إذا كنت ستبني عبر GitHub Actions.
2. ثبّت JDK 17 وGit، ثم أضف مجلد `flutter/bin` إلى PATH.
3. فك ضغط المشروع في مسار قصير، مثل:

   ```text
   C:\Projects\LingoNexa
   ```

4. افتح PowerShell داخل مجلد المشروع وشغّل:

   ```powershell
   flutter doctor
   flutter create --platforms=android,web --org com.lingonexa .
   flutter pub get
   flutter analyze
   flutter test
   ```

   أو ببساطة انقر مرتين على `setup_windows.bat` ليتم تنفيذ التجهيز والفحص تلقائيًا.

5. وصّل هاتف Android وفعّل USB debugging، ثم تحقّق منه:

   ```powershell
   flutter devices
   flutter run
   ```

6. لتشغيل نسخة الويب محليًا:

   ```powershell
   flutter run -d chrome
   ```

## بناء APK

لنسخة اختبار قابلة للتثبيت:

```powershell
flutter build apk --release
```

ستجدها في:

```text
build\app\outputs\flutter-apk\app-release.apk
```

## بناء AAB صالح لـ Google Play

Google Play يحتاج مفتاح Upload خاصًا بك. أنشئه مرة واحدة واحفظه خارج المشروع:

```powershell
keytool -genkeypair -v -keystore C:\Keys\lingonexa-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

انسخ المفتاح إلى `android/app/upload-keystore.jks` وأنشئ ملفًا باسم `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

ثم:

```powershell
flutter build appbundle --release
```

الناتج:

```text
build\app\outputs\bundle\release\app-release.aab
```

لا تشارك ملف JKS أو كلمات مروره، ولا ترفعه إلى GitHub.

## الرفع إلى GitHub والبناء تلقائيًا

1. أنشئ Repository جديدًا، مثل `LingoNexa`.
2. ارفع **محتويات** مجلد المشروع إلى الفرع `main`.
3. شغّل `APPLY_LINGONEXA_FIX_WINDOWS.bat` ثم Commit وPush لإزالة Workflows القديمة.
4. افتح تبويب **Actions**؛ ستجد خمسة Workflows مستقلة: **Flutter CI** و**APK** و**AAB** و**Web** و**Deploy GitHub Pages**.
5. بعد نجاح **APK** نزّل `lingonexa-apk`، وبعد نجاح **AAB** نزّل `lingonexa-aab`، وبعد نجاح **Web** نزّل `lingonexa-web`.
6. للنشر: من **Settings → Pages → Build and deployment** اختر **GitHub Actions** واحفظ، ثم شغّل **Deploy GitHub Pages** يدويًا.

إذا ظهر في السجل `dart pub get` فهذا تشغيل خاطئ لقالب Dart وليس ملف المشروع. اتبع ملف `REPLACE_INSTRUCTIONS_AR.md` خطوة بخطوة.

على Windows يمكنك تنفيذ التنظيف المطلوب تلقائيًا بالنقر مرتين على
`APPLY_LINGONEXA_FIX_WINDOWS.bat` ثم عمل Commit وPush من GitHub Desktop.

بناء Android مثبت على JDK 17 وAGP 8.11.1 وKotlin 2.2.20 وGradle 8.13 لتوافق
مكتبات AndroidX الحديثة مع Flutter Stable.

GitHub Pages يستضيف نسخة الويب فقط؛ أما APK وAAB فيتم بناؤهما داخل GitHub Actions.

### توقيع AAB داخل GitHub Actions

حوّل المفتاح إلى Base64 محليًا، ثم أضف القيم التالية في **Settings → Secrets and variables → Actions**:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_STORE_PASSWORD`

عند غيابها يبني CI نسخة تجريبية بمفتاح debug لا تصلح للنشر على Google Play.

## الشعار والأيقونات

- الشعار الكامل: `assets/branding/lingonexa_logo.png`.
- الرمز الشفاف: `assets/branding/lingonexa_icon.png`.
- أيقونات Android موجودة داخل مجلدات `android/app/src/main/res/mipmap-*`.
- أيقونات Web/PWA موجودة داخل `web/icons` ومسجلة في `web/manifest.json`.

## تغيير اسم الحزمة والبراند

- اسم التطبيق المرئي: من **Profile → Admin Studio**.
- Application ID الحالي: `com.lingonexa.app`.
- قبل النشر اختر ID تملكه، مثل `com.yourcompany.lingonexa`، ثم شغّل `flutter create` بالقيمة الجديدة وحدّث مسار `MainActivity.kt`.
- الأيقونة الحالية جاهزة. عند استبدالها لاحقًا حدّث ملفات mipmap و`web/icons` مع الحفاظ على الأسماء نفسها.

## ما يلزم قبل إطلاق تجاري عالمي

1. مراجعة بشرية لكل محتوى لغة ولهجة وترجمة.
2. تسجيل صوت أصلي أو ترخيص مكتبة صوت موثوقة.
3. Firebase أو Supabase للمصادقة والمزامنة والمجتمع.
4. خادم AI يحمي المفتاح ويطبّق حدود الاستخدام وسياسة الخصوصية؛ لا تضع مفتاح API داخل التطبيق.
5. WebRTC أو خدمة صوت مُدارة للغرف والمكالمات.
6. إدارة اشتراكات Google Play Billing، شروط استخدام، سياسة خصوصية، حذف الحساب، وموافقة الوالدين عند الحاجة.
7. نظام إشراف حقيقي للمجتمع، مع بلاغات وتدقيق وأدوار وصلاحيات من الخادم.
8. اختبارات أجهزة، قارئ شاشة، RTL، أداء، انقطاع الشبكة، وأمان.

راجع ملفات `docs/` للتفاصيل المعمارية وخطة المحتوى والإطلاق.

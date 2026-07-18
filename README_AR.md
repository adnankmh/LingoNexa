# LingoNexa — منصة Flutter عالمية لتعلّم اللغات

الإصدار الحالي: **1.1.1+3**

LingoNexa مشروع أصلي مبني بـ Flutter، يعمل على Android والويب، ويقدّم أساسًا احترافيًا لمنصة تعليم لغات واسعة قابلة للتوسّع. لا يحتوي المشروع على أكواد أو صور أو شخصيات من Duolingo أو Babbel أو غيرهما.

## ما الموجود في النسخة

- كتالوج 67 لغة، مع الاسم الأصلي والعَلَم ونوع الكتابة واتجاه RTL عند الحاجة.
- ستة مستويات CEFR من A1 إلى C2.
- 36 وحدة و180 عقدة درس ديناميكية لكل لغة.
- سبعة أنماط تمارين: اختيار، ترتيب، استماع، نطق، بطاقات، استدعاء كتابي، وملاحظة ثقافية.
- نطق آلي TTS وتعرّف على الكلام عند دعم الجهاز للغة.
- مراجعة متباعدة، بنك أخطاء، مختبر نطق، قصص، مقالات، وروابط تعليمية.
- معلّم سيناريوهات محلي مع نقطة دمج جاهزة لخدمة AI حقيقية.
- مجتمع تجريبي: منشورات، تصحيحات، شركاء، غرف صوت، إبلاغ وحظر.
- ثمانية ثيمات، واجهة عربية RTL وإنجليزية، وتصميم متجاوب للهاتف والويب.
- لوحة إدارة محلية للبراند والهدف اليومي وتفعيل الوحدات وتصدير الإعدادات.
- تجربة بدء من أربع مراحل، تحديد هدف يومي وسبب التعلّم، واختبار تحديد مستوى.
- مركز عبارات وقاموس قابل للبحث والحفظ والنطق لعدة لغات رئيسية.
- أطلس قواعد يغطي A1–C2 ومختبر أبجديات مع لوحة تدريب على الكتابة.
- ثمانية مسارات متخصصة: السفر، الأعمال، الصحة، الدراسة، الأطفال، الحياة بالخارج، الامتحانات، والإعلام.
- خطة تعلّم أسبوعية، إنجازات ودوري XP، تنزيلات دون إنترنت لكل اللغات، وسجل شهادات.
- GitHub Actions لفحص المشروع وبناء APK وAAB والويب ونشر GitHub Pages.

> مهم: النسخة تحتوي بنية تعليم كاملة وStarter Lexicon لكل اللغات، لكنها ليست بديلًا عن آلاف الساعات من المحتوى اللغوي الذي يراجعه مختصون ومتحدثون أصليون. قبل الإطلاق التجاري يجب إضافة حزم دروس موسعة وصوت مرخّص لكل لغة، وربط المجتمع والذكاء الاصطناعي بخادم إنتاج.

## تشغيل المشروع على Windows — خطوة بخطوة

1. ثبّت [Flutter Stable](https://docs.flutter.dev/get-started/install/windows/mobile) وثبّت Android Studio مع Android SDK.
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
3. داخل `.github/workflows` احذف أي ملف Dart قديم مثل `dart.yml` واترك `build.yml` فقط.
4. افتح تبويب **Actions** وشغّل Workflow باسم **Flutter CI - APK - AAB - Web**.
5. بعد النجاح افتح تشغيل الـ Workflow ثم قسم **Artifacts** وحمّل `lingonexa-android`؛ بداخله APK وAAB.
6. للنشر على GitHub Pages: من **Settings → Pages → Build and deployment** اختر **GitHub Actions**.

إذا ظهر في السجل `dart pub get` فهذا تشغيل خاطئ لقالب Dart وليس ملف المشروع. اتبع ملف `REPLACE_INSTRUCTIONS_AR.md` خطوة بخطوة.

GitHub Pages يستضيف نسخة الويب فقط؛ أما APK وAAB فيتم بناؤهما داخل GitHub Actions.

### توقيع AAB داخل GitHub Actions

حوّل المفتاح إلى Base64 محليًا، ثم أضف القيم التالية في **Settings → Secrets and variables → Actions**:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_STORE_PASSWORD`

عند غيابها يبني CI نسخة تجريبية بمفتاح debug لا تصلح للنشر على Google Play.

## تغيير اسم الحزمة والبراند

- اسم التطبيق المرئي: من **Profile → Admin Studio**.
- Application ID الحالي: `com.lingonexa.app`.
- قبل النشر اختر ID تملكه، مثل `com.yourcompany.lingonexa`، ثم شغّل `flutter create` بالقيمة الجديدة وحدّث مسار `MainActivity.kt`.
- استبدل أيقونة التطبيق عبر حزمة `flutter_launcher_icons` أو عبر Android Studio.

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

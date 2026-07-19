# تشغيل ونشر LingoNexa Web

## ما هي نسخة الويب؟

نسخة الويب موجودة داخل المشروع نفسه ومبنية بـFlutter، لذلك الهاتف والموقع يستخدمان الواجهات والمحتوى والثيمات نفسها. ملف `web/index.html` هو نقطة البداية، وWorkflow باسم `Web` ينشئ مجلد `build/web` ويرفعه كـArtifact باسم `lingonexa-web`.

## النشر على GitHub Pages

1. ارفع محتويات المشروع إلى فرع `main` بواسطة GitHub Desktop.
2. افتح المستودع ثم `Settings → Pages`.
3. في `Build and deployment` اختر `GitHub Actions` كمصدر النشر واحفظ.
4. افتح `Actions → Deploy GitHub Pages` واضغط `Run workflow`.
5. انتظر نجاح `check-pages` ثم `build-pages` ثم `deploy-pages`.
6. افتح `https://adnankmh.github.io/LingoNexa/`.

إذا عرض `check-pages` ملاحظة أن Pages غير مفعّلة، ارجع إلى الخطوتين 2 و3 ثم شغّل Workflow مرة أخرى. تحذير `punycode` الصادر من Action خارجي ليس خطأ في التطبيق، بينما خطأ 404 يعني عادة أن Pages لم تُفعّل بعد.

## تشغيل الويب محليًا

بعد تثبيت Flutter Stable:

```powershell
flutter pub get
flutter run -d chrome
```

ولإنشاء نسخة Release محلية:

```powershell
flutter build web --release --no-wasm-dry-run --base-href "/LingoNexa/"
```

## لماذا لم تتم إضافة Laravel؟

المطلوب المشروط كان إنشاء Laravel إذا لم تكن هناك نسخة Web. النسخة موجودة وتم بناؤها بنجاح، كما أن GitHub Pages لا يشغّل PHP أو Laravel؛ هو يستضيف ملفات الويب الثابتة الناتجة من Flutter. يمكن لاحقًا إنشاء Laravel كخادم API للمستخدمين والمزامنة ولوحة الإدارة وقاعدة البيانات، لكن ذلك يحتاج استضافة PHP وقاعدة بيانات ومفاتيح إنتاج، ويكون عنوانه منفصلًا عن GitHub Pages.

## حدود النسخة الحالية

الحسابات والتقدم في النسخة الحالية محلية على الجهاز/المتصفح. المزامنة بين أجهزة متعددة، تسجيل Google وFacebook الحقيقي، المجتمع الحي، ولوحة إدارة مركزية تحتاج Backend إنتاج آمن مثل Laravel API أو Firebase/Supabase، مع قاعدة بيانات وسياسة خصوصية وحماية مفاتيح الخدمة.

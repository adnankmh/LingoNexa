import 'package:flutter/widgets.dart';

class AppText {
  const AppText(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  static const _ar = {
    'learn': 'تعلّم',
    'practice': 'تدرّب',
    'explore': 'استكشف',
    'community': 'المجتمع',
    'profile': 'حسابي',
    'continue': 'تابع التعلّم',
    'daily_goal': 'هدف اليوم',
    'minutes': 'دقيقة',
    'streak': 'سلسلة الأيام',
    'xp': 'نقاط الخبرة',
    'choose_language': 'اختر اللغة التي تريد تعلّمها',
    'search': 'ابحث عن لغة…',
    'level': 'المستوى',
    'review': 'المراجعة الذكية',
    'mistakes': 'بنك الأخطاء',
    'pronunciation': 'مختبر النطق',
    'stories': 'القصص',
    'tutor': 'المعلّم الذكي',
    'dictionary': 'القاموس',
    'articles': 'مقالات وثقافة',
    'voice_rooms': 'غرف المحادثة',
    'settings': 'الإعدادات',
    'themes': 'المظهر والثيمات',
    'admin': 'لوحة الإدارة',
    'sign_out': 'تسجيل الخروج',
    'start': 'ابدأ',
    'check': 'تحقق',
    'next': 'التالي',
    'correct': 'إجابة رائعة!',
    'try_again': 'حاول مرة أخرى',
    'completed': 'أكملت الدرس',
    'offline': 'التعلّم دون إنترنت',
    'premium': 'LingoNexa Pro',
    'weekly': 'تقدمك هذا الأسبوع',
    'members': 'متعلم متصل',
  };

  static const _en = {
    'learn': 'Learn',
    'practice': 'Practice',
    'explore': 'Explore',
    'community': 'Community',
    'profile': 'Profile',
    'continue': 'Continue learning',
    'daily_goal': 'Daily goal',
    'minutes': 'min',
    'streak': 'Day streak',
    'xp': 'XP earned',
    'choose_language': 'Choose a language to learn',
    'search': 'Search languages…',
    'level': 'Level',
    'review': 'Smart review',
    'mistakes': 'Mistake bank',
    'pronunciation': 'Pronunciation lab',
    'stories': 'Stories',
    'tutor': 'AI tutor',
    'dictionary': 'Dictionary',
    'articles': 'Articles & culture',
    'voice_rooms': 'Voice rooms',
    'settings': 'Settings',
    'themes': 'Themes & appearance',
    'admin': 'Admin studio',
    'sign_out': 'Sign out',
    'start': 'Start',
    'check': 'Check',
    'next': 'Next',
    'correct': 'Great answer!',
    'try_again': 'Try again',
    'completed': 'Lesson complete',
    'offline': 'Offline learning',
    'premium': 'LingoNexa Pro',
    'weekly': 'Your week',
    'members': 'learners online',
  };

  String get(String key) => (isArabic ? _ar : _en)[key] ?? key;
}

extension AppTextContext on BuildContext {
  AppText get text => AppText(Localizations.localeOf(this));
}


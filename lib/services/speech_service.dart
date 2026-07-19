import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();

  bool get isListening => _speech.isListening;

  /// Speaks only with the requested language. It never falls back to English,
  /// because an English voice reading another language is educationally wrong.
  Future<bool> speak(String text, String languageCode, {double rate = .42}) async {
    final locale = voiceLocale(languageCode);
    try {
      final availability = await _tts.isLanguageAvailable(locale);
      if (availability == false || availability == 0 || availability == '0') return false;
      final languageResult = await _tts.setLanguage(locale);
      if (languageResult == false || languageResult == 0 || languageResult == '0') return false;
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSpeechRate(rate.clamp(.25, .60).toDouble());
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(text);
      return result != false && result != 0 && result != '0';
    } catch (_) {
      return false;
    }
  }

  /// Resolves an installed recognition locale. If the target language is not
  /// installed, recognition is not started instead of silently using the
  /// phone's default (often English) locale.
  Future<bool> listen({
    required String languageCode,
    required void Function(String words, double confidence) onResult,
  }) async {
    final available = await _speech.initialize();
    if (!available) return false;
    final installed = await _speech.locales();
    final requested = voiceLocale(languageCode).replaceAll('_', '-').toLowerCase();
    final requestedLanguage = requested.split('-').first;
    LocaleName? selected;
    for (final locale in installed) {
      final candidate = locale.localeId.replaceAll('_', '-').toLowerCase();
      if (candidate == requested) {
        selected = locale;
        break;
      }
    }
    if (selected == null) {
      for (final locale in installed) {
        final candidateLanguage = locale.localeId.replaceAll('_', '-').toLowerCase().split('-').first;
        if (candidateLanguage == requestedLanguage) {
          selected = locale;
          break;
        }
      }
    }
    if (selected == null) return false;
    await _speech.listen(
      localeId: selected.localeId,
      listenOptions: SpeechListenOptions(partialResults: true, cancelOnError: true, listenMode: ListenMode.confirmation),
      onResult: (SpeechRecognitionResult result) => onResult(result.recognizedWords, result.confidence),
    );
    return true;
  }

  Future<void> stopListening() => _speech.stop();

  static String voiceLocale(String code) => _voiceLocales[code] ?? code;

  static const Map<String, String> _voiceLocales = {
    'en':'en-US','ar':'ar-SA','es':'es-ES','fr':'fr-FR','de':'de-DE','it':'it-IT','pt':'pt-PT','ru':'ru-RU','tr':'tr-TR','zh':'zh-CN','ja':'ja-JP','ko':'ko-KR',
    'hi':'hi-IN','ur':'ur-PK','fa':'fa-IR','he':'he-IL','nl':'nl-NL','sv':'sv-SE','no':'nb-NO','da':'da-DK','fi':'fi-FI','pl':'pl-PL','cs':'cs-CZ','sk':'sk-SK',
    'hu':'hu-HU','ro':'ro-RO','bg':'bg-BG','uk':'uk-UA','el':'el-GR','id':'id-ID','ms':'ms-MY','th':'th-TH','vi':'vi-VN','fil':'fil-PH','sw':'sw-KE','am':'am-ET',
    'ha':'ha-NG','yo':'yo-NG','ig':'ig-NG','zu':'zu-ZA','af':'af-ZA','ca':'ca-ES','eu':'eu-ES','gl':'gl-ES','cy':'cy-GB','ga':'ga-IE','is':'is-IS','sq':'sq-AL',
    'hr':'hr-HR','sr':'sr-RS','sl':'sl-SI','mk':'mk-MK','et':'et-EE','lv':'lv-LV','lt':'lt-LT','ka':'ka-GE','hy':'hy-AM','az':'az-AZ','kk':'kk-KZ','uz':'uz-UZ',
    'mn':'mn-MN','ne':'ne-NP','bn':'bn-BD','ta':'ta-IN','te':'te-IN','ml':'ml-IN','kn':'kn-IN',
  };

  void dispose() {
    _tts.stop();
    _speech.cancel();
  }
}

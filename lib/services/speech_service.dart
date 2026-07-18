import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();

  bool get isListening => _speech.isListening;

  Future<void> speak(String text, String languageCode) async {
    await _tts.setLanguage(_voiceLocale(languageCode));
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<bool> listen({
    required String languageCode,
    required void Function(String words, double confidence) onResult,
  }) async {
    final available = await _speech.initialize();
    if (!available) return false;
    await _speech.listen(
      localeId: _voiceLocale(languageCode),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      ),
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.confidence);
      },
    );
    return true;
  }

  Future<void> stopListening() => _speech.stop();

  String _voiceLocale(String code) {
    const locales = {
      'en': 'en-US',
      'ar': 'ar-SA',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-PT',
      'ru': 'ru-RU',
      'tr': 'tr-TR',
      'zh': 'zh-CN',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'hi': 'hi-IN',
    };
    return locales[code] ?? code;
  }

  void dispose() {
    _tts.stop();
    _speech.cancel();
  }
}


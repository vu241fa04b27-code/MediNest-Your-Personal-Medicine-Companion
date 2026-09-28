import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isSpeaking = false;
  bool _isInitialized = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setSpeechRate(0.45); // Slower rate for elderly clarity
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);

      _flutterTts?.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts?.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts?.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint("TTS error: $msg");
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  Future<void> speak(String text, {String languageCode = 'en'}) async {
    try {
      await init();
      if (_flutterTts == null) return;

      String ttsLang = 'en-US';
      if (languageCode == 'te') {
        ttsLang = 'te-IN';
      } else if (languageCode == 'hi') {
        ttsLang = 'hi-IN';
      }

      await _flutterTts?.setLanguage(ttsLang);
      _isSpeaking = true;
      await _flutterTts?.speak(text);
    } catch (e) {
      _isSpeaking = false;
      debugPrint("TTS speak error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint("TTS stop error: $e");
    }
  }
}

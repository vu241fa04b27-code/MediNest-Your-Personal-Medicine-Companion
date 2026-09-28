import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../utils/app_colors.dart';

class VoiceReadingBar extends StatefulWidget {
  final String textToSpeak;
  final String languageCode;
  final String label;

  const VoiceReadingBar({
    super.key,
    required this.textToSpeak,
    this.languageCode = 'en',
    this.label = 'Listen to Today\'s Medicines (Voice Reader)',
  });

  @override
  State<VoiceReadingBar> createState() => _VoiceReadingBarState();
}

class _VoiceReadingBarState extends State<VoiceReadingBar> {
  final TtsService _tts = TtsService();
  bool _isPlaying = false;

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _tts.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (mounted) setState(() => _isPlaying = true);
      await _tts.speak(widget.textToSpeak, languageCode: widget.languageCode);
      // Wait or listen to completion
      Future.delayed(const Duration(seconds: 8), () {
        if (mounted && _isPlaying) {
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _isPlaying ? AppColors.accentBlueLight : AppColors.cardBgTintedBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isPlaying ? AppColors.accentBlue : AppColors.accentBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: _togglePlay,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPlaying ? AppColors.accentBlue : AppColors.accentBlueLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                color: _isPlaying ? Colors.white : AppColors.accentBlueDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isPlaying ? 'Reading Aloud...' : widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _isPlaying ? AppColors.accentBlueDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _isPlaying ? 'Tap to stop voice reading' : 'Voice assistant for elderly accessibility',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_isPlaying)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

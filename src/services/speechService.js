class SpeechService {
  constructor() {
    this.isSpeaking = false;
  }

  speak(text, lang = 'en', onStart, onEnd) {
    if (!('speechSynthesis' in window)) {
      console.warn('Speech synthesis not supported in this browser.');
      return;
    }

    window.speechSynthesis.cancel(); // cancel any active speech

    const utterance = new SpeechSynthesisUtterance(text);
    
    // Choose appropriate voice/locale
    if (lang === 'te') {
      utterance.lang = 'te-IN';
    } else if (lang === 'hi') {
      utterance.lang = 'hi-IN';
    } else {
      utterance.lang = 'en-US';
    }

    utterance.rate = 0.85; // slightly slower for elderly clarity
    utterance.pitch = 1.0;

    utterance.onstart = () => {
      this.isSpeaking = true;
      if (onStart) onStart();
    };

    utterance.onend = () => {
      this.isSpeaking = false;
      if (onEnd) onEnd();
    };

    utterance.onerror = (e) => {
      console.error('Speech synthesis error:', e);
      this.isSpeaking = false;
      if (onEnd) onEnd();
    };

    window.speechSynthesis.speak(utterance);
  }

  stop() {
    if ('speechSynthesis' in window) {
      window.speechSynthesis.cancel();
      this.isSpeaking = false;
    }
  }
}

export const speechService = new SpeechService();

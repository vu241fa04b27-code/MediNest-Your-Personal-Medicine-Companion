class NotificationService {
  constructor() {
    this.audioCtx = null;
    this.activeSnoozes = new Map();
  }

  // Request actual browser notification permission
  async requestPermission() {
    if (!('Notification' in window)) {
      alert('This browser does not support desktop notifications.');
      return false;
    }

    if (Notification.permission === 'granted') {
      return true;
    }

    if (Notification.permission !== 'denied') {
      const permission = await Notification.requestPermission();
      return permission === 'granted';
    }

    return false;
  }

  // Play an actual medical bell chime using Web Audio API
  playChime() {
    try {
      const AudioContext = window.AudioContext || window.webkitAudioContext;
      if (!AudioContext) return;
      if (!this.audioCtx) {
        this.audioCtx = new AudioContext();
      }
      if (this.audioCtx.state === 'suspended') {
        this.audioCtx.resume();
      }

      const now = this.audioCtx.currentTime;
      
      // Dual chime tone (E5 -> G#5)
      const osc1 = this.audioCtx.createOscillator();
      const osc2 = this.audioCtx.createOscillator();
      const gain = this.audioCtx.createGain();

      osc1.type = 'sine';
      osc1.frequency.setValueAtTime(659.25, now); // E5
      osc1.frequency.exponentialRampToValueAtTime(830.61, now + 0.3); // G#5

      osc2.type = 'triangle';
      osc2.frequency.setValueAtTime(329.63, now); // E4

      gain.gain.setValueAtTime(0.3, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 1.2);

      osc1.connect(gain);
      osc2.connect(gain);
      gain.connect(this.audioCtx.destination);

      osc1.start(now);
      osc2.start(now);
      osc1.stop(now + 1.2);
      osc2.stop(now + 1.2);
    } catch (e) {
      console.warn('Audio chime error:', e);
    }
  }

  // Trigger REAL browser notification
  async triggerMedicineNotification({ medicineName, timing, purpose, onTaken, onSnooze, escalationLevel = 0 }) {
    await this.requestPermission();
    this.playChime();

    const title = escalationLevel === 0
      ? `💊 Time to take your medicine: ${medicineName}`
      : `⚠️ Reminder (${escalationLevel * 10}m): Take ${medicineName}`;

    const body = `${timing ? timing + ' • ' : ''}Purpose: ${purpose || 'Health Maintenance'}\nClick to acknowledge your dose.`;

    if ('Notification' in window && Notification.permission === 'granted') {
      const notif = new Notification(title, {
        body,
        icon: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%234CAF50"><path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5h15c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5h-15z"/></svg>',
        requireInteraction: true, // Remains on screen until clicked
        tag: `medinest-${medicineName}`
      });

      notif.onclick = () => {
        window.focus();
        if (window.confirm(`Mark ${medicineName} as Taken? (Click Cancel to Snooze 10 mins)`)) {
          if (onTaken) onTaken();
          notif.close();
        } else {
          if (onSnooze) onSnooze();
          this.scheduleEscalation({ medicineName, timing, purpose, onTaken, onSnooze, escalationLevel: escalationLevel + 1 });
          notif.close();
        }
      };
    } else {
      // Fallback in-app modal prompt if permission denied
      if (window.confirm(`${title}\n\n${body}\n\nClick OK if you took this dose. Click Cancel to snooze 10m.`)) {
        if (onTaken) onTaken();
      } else {
        if (onSnooze) onSnooze();
        this.scheduleEscalation({ medicineName, timing, purpose, onTaken, onSnooze, escalationLevel: escalationLevel + 1 });
      }
    }
  }

  // Escalating snooze: 10m, 20m, 30m
  scheduleEscalation(params) {
    if (params.escalationLevel > 3) return; // max 3 escalations (30m)
    const delayMs = 10 * 60 * 1000; // 10 minutes

    const timerId = setTimeout(() => {
      this.triggerMedicineNotification(params);
    }, delayMs);

    this.activeSnoozes.set(params.medicineName, timerId);
  }

  // Public alias used by Settings test button
  testSound() {
    this.playChime();
  }

  clearSnooze(medicineName) {
    if (this.activeSnoozes.has(medicineName)) {
      clearTimeout(this.activeSnoozes.get(medicineName));
      this.activeSnoozes.delete(medicineName);
    }
  }
}

export const notificationService = new NotificationService();

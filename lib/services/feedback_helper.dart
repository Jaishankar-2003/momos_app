import 'package:flutter/services.dart';

class FeedbackHelper {
  /// 🔔 Beep / click when item is added
  static void itemAdded() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.selectionClick();
  }

  /// ✅ Strong feedback when order is confirmed
  static void orderConfirmed() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }

  /// 🚚 Delivery feedback (distinct & clear)
  static void orderDelivered() {
    // Slightly stronger + longer feel than confirm
    HapticFeedback.heavyImpact();

    // Double click sound feel (very noticeable)
    SystemSound.play(SystemSoundType.click);
    Future.delayed(const Duration(milliseconds: 120), () {
      SystemSound.play(SystemSoundType.click);
    });
  }
}





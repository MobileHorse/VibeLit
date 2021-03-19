import 'package:vibelit/config/params.dart';

import 'preference_helper.dart';

class TimeUtils {
  static int calculateRemainedTimeInMinutes() {
    DateTime startTime = PreferenceHelper.getDate(Params.purificationStartedTime);
    if (startTime == null) return -9999;
    int volume = PreferenceHelper.getInt(Params.volume);
    return (volume / 20).ceil() - DateTime.now().difference(startTime).inMinutes;
  }
}
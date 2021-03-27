import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';

class Utils {
  static List<String> getDeviceStatus() {
    String values = PreferenceHelper.getString(Params.values);
    if (values.isEmpty) return [];
    return values.split(" ");
  }

  static bool isDeviceOn() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return false;
    return values[0] != Constants.OFF_MODE;
  }

  static int getDeviceIntensity() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return Constants.INTENSITY_MIN;
    return int.parse(values[1]);
  }

  static int getDeviceVolume() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return Constants.VOLUME_MIN;
    return int.parse(values[2]);
  }

  static int getDeviceFanPWM() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[3]);
  }

  static int getDeviceTL() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[4]);
  }

  static int getDeviceTM() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[5]);
  }

  static int getDeviceTH() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[6]);
  }

  static int getDeviceTMr() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[7]);
  }

  static int getDeviceTHr() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[8]);
  }

  static int getDeviceFanPWMor() {
    List<String> values = getDeviceStatus();
    if (values.isEmpty) return 0;
    return int.parse(values[9]);
  }
}
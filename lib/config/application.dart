import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static final String WEATHER_API_KEY = "ee3ea3c138da18505bb8125cb2d16611";
  static final int INTENSITY_MIN = 1;
  static final int INTENSITY_MAX = 50;
  static SharedPreferences preferences;
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibelit/api/weather_api.dart';
import 'package:vibelit/bloc/weather_bloc/bloc.dart';
import 'package:vibelit/config/application.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoadingState());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherFetchEvent) {
      yield* _mapWeatherFetchEventToState();
    }
  }

  Stream<WeatherState> _mapWeatherFetchEventToState() async* {
    yield WeatherLoadingState();
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var decoded = await (WeatherAPI(url: "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${Application.WEATHER_API_KEY}")).fetchData();
    if (decoded != null && decoded['name'] != null) {
      yield WeatherFetchedState(city: decoded['name'], icon: decoded['weather'][0]['icon'], temperature: decoded['main']['temp'].toDouble() - 273.15);
    } else {
      yield WeatherFailedState();
    }
  }
}

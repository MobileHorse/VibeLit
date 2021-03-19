import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibelit/bloc/app_bloc.dart';
import 'package:vibelit/bloc/weather_bloc/bloc.dart';
import 'package:vibelit/config/application.dart';

import 'bloc.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(ApplicationInitialState());

  @override
  Stream<ApplicationState> mapEventToState(ApplicationEvent event) async* {
    if (event is ApplicationStartupEvent) {
      yield* _mapApplicationStartupEventToState();
    }
  }

  Stream<ApplicationState> _mapApplicationStartupEventToState() async* {
    /// Start Application Setup
    yield ApplicationLoadingState();

    /// Setup SharedPreferences
    Application.preferences = await SharedPreferences.getInstance();

    AppBloc.weatherBloc.add(WeatherFetchEvent());

    /// Application Setup Completed
    yield ApplicationSetupState();
  }
}
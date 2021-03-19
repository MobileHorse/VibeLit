import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibelit/bloc/app_bloc.dart';
import 'package:vibelit/config/application.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';

import '../bloc.dart';
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
    if (PreferenceHelper.getInt(Params.intensity) == 0) {
      PreferenceHelper.setInt(Params.intensity, 1);
    }
    if (PreferenceHelper.getInt(Params.volume) == 0) {
      PreferenceHelper.setInt(Params.volume, 100);
    }

    AppBloc.weatherBloc.add(WeatherFetchEvent());
    AppBloc.statusBloc.add(StatusCheckEvent());

    /// Application Setup Completed
    yield ApplicationSetupState();
  }
}
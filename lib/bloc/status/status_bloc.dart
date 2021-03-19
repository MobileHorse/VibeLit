import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/status/status_event.dart';
import 'package:vibelit/bloc/status/status_state.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusOffState());

  @override
  Stream<StatusState> mapEventToState(StatusEvent event) async* {
    if (event is StatusCheckEvent) {
      yield* _mapStatusCheckEventToState();
    } else if (event is StatusOnEvent) {
      yield* _mapStatusOnEventToState();
    } else if (event is StatusOffEvent) {
      yield* _mapStatusOffEventToState();
    }
  }


  Stream<StatusState> _mapStatusCheckEventToState() async* {
    bool status = PreferenceHelper.getBool(Params.status);
    if (status) yield StatusOnState();
    else yield StatusOffState();
  }

  Stream<StatusState> _mapStatusOnEventToState() async* {
    await PreferenceHelper.setBool(Params.status, true);
    yield StatusOnState();
  }

  Stream<StatusState> _mapStatusOffEventToState() async* {
    await PreferenceHelper.setBool(Params.status, false);
    yield StatusOffState();
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/purification/bloc.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/time_utils.dart';

class PurificationBloc extends Bloc<PurificationEvent, PurificationState> {
  PurificationBloc() : super(PurificationStoppedState());

  @override
  Stream<PurificationState> mapEventToState(PurificationEvent event) async* {
    if (event is PurificationStatusEvent) {
      yield* _mapPurificationStatusEventToState();
    } else if (event is PurificationStartEvent) {
      yield* _mapPurificationStartEventToState();
    } else if (event is PurificationStopEvent) {
      yield* _mapPurificationStopEventToState();
    }
  }

  Stream<PurificationState> _mapPurificationStatusEventToState() async* {
    yield PurificationLoadingState();
    if (TimeUtils.calculateRemainedTimeInMinutes() < 0) yield PurificationStoppedState();
    else yield PurificationInProgressState();
  }

  Stream<PurificationState> _mapPurificationStartEventToState() async* {
    await PreferenceHelper.setDate(Params.purificationStartedTime, DateTime.now());
    yield PurificationInProgressState();
  }

  Stream<PurificationState> _mapPurificationStopEventToState() async* {
    await PreferenceHelper.remove(Params.purificationStartedTime);
    yield PurificationStoppedState();
  }
}
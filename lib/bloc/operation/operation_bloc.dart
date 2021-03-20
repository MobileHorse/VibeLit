import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/time_utils.dart';

import 'bloc.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState> {
  OperationBloc() : super(OperationLoadingState());

  @override
  Stream<OperationState> mapEventToState(OperationEvent event) async* {
    if (event is OperationStatusEvent) {
      yield* _mapOperationStatusEventToState();
    } else if (event is OperationStartEvent) {
      yield* _mapOperationStartEventToState(event);
    } else if (event is OperationStopEvent) {
      yield* _mapOperationStopEventToState();
    }
  }

  Stream<OperationState> _mapOperationStatusEventToState() async* {
    yield OperationLoadingState();
    String mode = PreferenceHelper.getString(Params.operationMode);
    DateTime startedAt = PreferenceHelper.getDate(Params.operationStartedAt);
    if (mode.isEmpty)
      yield OperationStoppedState();
    else {
      if (mode == Constants.Air_Purification || TimeUtils.calculateRemainedTimeInMinutes() > 0)
        yield OperationInProgressState(mode: mode, startedAt: startedAt);
      else {
        await PreferenceHelper.remove(Params.operationMode);
        await PreferenceHelper.remove(Params.operationStartedAt);
        yield OperationStoppedState();
      }
    }
  }

  Stream<OperationState> _mapOperationStartEventToState(OperationStartEvent event) async* {
    String mode = event.mode;
    DateTime startedAt = DateTime.now();
    await PreferenceHelper.setString(Params.operationMode, mode);
    await PreferenceHelper.setDate(Params.operationStartedAt, startedAt);
    yield OperationInProgressState(mode: mode, startedAt: startedAt);
  }

  Stream<OperationState> _mapOperationStopEventToState() async* {
    await PreferenceHelper.remove(Params.operationMode);
    await PreferenceHelper.remove(Params.operationStartedAt);
    yield OperationStoppedState();
  }
}

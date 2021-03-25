import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/util/preference_helper.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothAppState> {
  BluetoothBloc() : super(BluetoothLoadingState());

  @override
  Stream<BluetoothAppState> mapEventToState(BluetoothEvent event) async* {
    if (event is BluetoothCheckEvent) {
      yield* _mapBluetoothCheckEventToState();
    } else if (event is BluetoothConnectedEvent) {
      yield* _mapBluetoothConnectedEventToState(event);
    }
  }

  Stream<BluetoothAppState> _mapBluetoothCheckEventToState() async* {
    yield BluetoothLoadingState();
    BluetoothState bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (bluetoothState == BluetoothState.STATE_OFF) {
      bool isEnabled = await FlutterBluetoothSerial.instance.requestEnable();
      if (!isEnabled)
        yield BluetoothDisabledState();
      else
        yield* _checkConnections();
    } else
      yield* _checkConnections();
  }

  Stream<BluetoothAppState> _checkConnections() async* {
    String lastDevice = PreferenceHelper.getString(Params.lastDevice);
    if (lastDevice.isEmpty) yield BluetoothPairState();
    else {
      BluetoothConnection connection = await BluetoothConnection.toAddress(lastDevice);
      if (connection.isConnected) yield BluetoothConnectedState(connection: connection);
      else yield BluetoothPairState();
    }
  }

  Stream<BluetoothAppState> _mapBluetoothConnectedEventToState(BluetoothConnectedEvent event) async* {
    yield BluetoothConnectedState(connection: event.connection);
  }
}

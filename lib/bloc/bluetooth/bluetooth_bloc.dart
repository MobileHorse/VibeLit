import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibelit/bloc/bloc.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothAppState> {
  BluetoothBloc() : super(BluetoothDisconnectedState());

  @override
  Stream<BluetoothAppState> mapEventToState(BluetoothEvent event) async* {
    if (event is BluetoothCheckEvent) {
      yield* _mapBluetoothCheckEventToState();
    } else if (event is BluetoothConnectEvent) {}
  }

  Stream<BluetoothAppState> _mapBluetoothCheckEventToState() async* {
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

  }
}

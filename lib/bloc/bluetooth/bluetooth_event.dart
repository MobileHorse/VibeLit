import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

@immutable
abstract class BluetoothEvent {}

class BluetoothCheckEvent extends BluetoothEvent {}

class BluetoothConnectedEvent extends BluetoothEvent {
  final BluetoothConnection connection;
  BluetoothConnectedEvent({this.connection});
}


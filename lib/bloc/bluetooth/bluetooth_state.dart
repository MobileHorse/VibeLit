import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

@immutable
abstract class BluetoothAppState {}

class BluetoothDisabledState extends BluetoothAppState {}

class BluetoothDisconnectedState extends BluetoothAppState {}

class BluetoothConnectedState extends BluetoothAppState {
  final BluetoothConnection connection;

  BluetoothConnectedState({this.connection});
}
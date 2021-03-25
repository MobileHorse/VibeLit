import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

@immutable
abstract class BluetoothAppState {}

class BluetoothLoadingState extends BluetoothAppState {}

class BluetoothDisabledState extends BluetoothAppState {}

class BluetoothPairState extends BluetoothAppState {}

class BluetoothConnectedState extends BluetoothAppState {
  final BluetoothConnection connection;

  BluetoothConnectedState({this.connection});
}
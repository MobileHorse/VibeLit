import 'package:flutter/material.dart';

@immutable
abstract class BluetoothEvent {}

class BluetoothCheckEvent extends BluetoothEvent {}

class BluetoothConnectEvent extends BluetoothEvent {}


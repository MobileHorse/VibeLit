import 'package:flutter/material.dart';

@immutable
abstract class StatusEvent {}

class StatusCheckEvent extends StatusEvent {}

class StatusOnEvent extends StatusEvent {}

class StatusOffEvent extends StatusEvent {}

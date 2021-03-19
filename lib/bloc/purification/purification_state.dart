import 'package:flutter/material.dart';

@immutable
abstract class PurificationState {}

class PurificationLoadingState extends PurificationState {}

class PurificationInProgressState extends PurificationState {}

class PurificationStoppedState extends PurificationState {}
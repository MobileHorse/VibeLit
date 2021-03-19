import 'package:flutter/material.dart';

@immutable
abstract class StatusState {}

class StatusOnState extends StatusState {}

class StatusOffState extends StatusState {}
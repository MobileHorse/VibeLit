import 'package:flutter/material.dart';

@immutable
abstract class WeatherEvent {}

class WeatherFetchEvent extends WeatherEvent {}
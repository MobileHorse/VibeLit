import 'package:flutter/material.dart';

@immutable
abstract class WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherFetchedState extends WeatherState {
  final String city, icon;
  final double temperature;

  WeatherFetchedState({this.city, this.icon, this.temperature});
}

class WeatherFailedState extends WeatherState {}

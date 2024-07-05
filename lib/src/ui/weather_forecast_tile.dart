import 'package:flutter/material.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';

class WeatherForecastTile extends StatelessWidget {
  final ForecastDay day;
  final UnitGroup unitGroup;

  const WeatherForecastTile({
    super.key,
    required this.day,
    required this.unitGroup,
  });

  @override
  Widget build(BuildContext context) {
    final temperatureSymbol = unitGroup == UnitGroup.metric ? "°C" : "°F";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${day.datetime.day}"),
        Text(day.icon),
        Text("${day.temp}$temperatureSymbol"),
      ],
    );
  }
}

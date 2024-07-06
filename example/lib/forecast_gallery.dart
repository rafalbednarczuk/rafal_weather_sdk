import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

final _cloudyFogSnowWindMetricUnitsSample = [
  ForecastDay(
    datetime: DateTime(2024, 6, 6),
    temp: 5,
    icon: "cloudy",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 7),
    temp: 10,
    icon: "fog",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 8),
    temp: -5,
    icon: "snow",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 9),
    temp: 5,
    icon: "wind",
  ),
];

final _imperialUnitsSample = [
  ForecastDay(
    datetime: DateTime(2024, 6, 10),
    temp: 65,
    icon: "clear-day",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 11),
    temp: 68,
    icon: "partly-cloudy-day",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 12),
    temp: 70,
    icon: "clear-day",
  ),
  ForecastDay(
    datetime: DateTime(2024, 6, 13),
    temp: 75,
    icon: "partly-cloudy-day",
  ),
];

class ForecastGallery extends StatelessWidget {
  const ForecastGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecast widgets gallery"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text("WeatherForecastView Cloudy/Fog/Snow/Wind"),
          WeatherForecastView.fromForecastDays(
            forecastData: _cloudyFogSnowWindMetricUnitsSample,
            unitGroup: UnitGroup.metric,
          ),
          const SizedBox(height: 24),
          const Text("WeatherForecastView Imperial units, clear/partly-cloudy"),
          WeatherForecastView.fromForecastDays(
            forecastData: _imperialUnitsSample,
            unitGroup: UnitGroup.us,
          ),
          const SizedBox(height: 24),
          const Text("Single WeatherForecastTile, sunny day"),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: WeatherForecastTile(
                day: ForecastDay(
                  datetime: DateTime(2024, 6, 6),
                  temp: 30,
                  icon: "clear-day",
                ),
                unitGroup: UnitGroup.metric,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

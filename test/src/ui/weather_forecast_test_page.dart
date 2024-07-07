import 'package:flutter/material.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

class WeatherForecastTestPage extends StatefulWidget {
  final WeatherApiClient weatherApiClient;

  const WeatherForecastTestPage({super.key, required this.weatherApiClient});

  @override
  State<WeatherForecastTestPage> createState() =>
      _WeatherForecastTestPageState();
}

class _WeatherForecastTestPageState extends State<WeatherForecastTestPage> {
  String _location = "Warsaw";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WeatherForecastView.fromApiClient(
            location: _location,
            weatherApiClient: widget.weatherApiClient,
            unitGroup: UnitGroup.metric,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _location = "New York";
              });
            },
            child: const Text("change location to New york"),
          )
        ],
      ),
    );
  }
}

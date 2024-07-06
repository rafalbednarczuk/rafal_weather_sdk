import 'package:flutter/material.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/ui/weather_forecast_tile.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';

/// A widget that displays daily forecast for the next 4 days.
///
/// [WeatherForecastView] uses [date] as a start of a forecast.
///
/// [location] should be provided as a city name, for example "New York" or
/// provided as latitude and longitude coordinates, for example  "40.73,-73.93".
///
/// [weatherApiClient] provides actual forecast data from a network API
///
/// See also:
///
///  * [WeatherApiClient], which accesses forecast data directly

class WeatherForecastView extends StatefulWidget {
  final String location;
  final WeatherApiClient weatherApiClient;
  final DateTime date;
  final UnitGroup unitGroup;

  WeatherForecastView({
    super.key,
    required this.location,
    required this.weatherApiClient,
    required this.unitGroup,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  @override
  State<WeatherForecastView> createState() => _WeatherForecastViewState();
}

class _WeatherForecastViewState extends State<WeatherForecastView> {
  late bool _loadingData;
  bool _error = false;
  List<ForecastDay>? _forecast;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void didUpdateWidget(WeatherForecastView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadingData = true;
      _error = false;
      _forecast = null;
    });

    final data = await widget.weatherApiClient.getForecast(
      location: widget.location,
      unitGroup: widget.unitGroup,
    );

    if (data == null) {
      setState(() {
        _loadingData = false;
        _error = true;
      });
      return;
    }

    setState(() {
      _loadingData = false;
      _error = false;
      _forecast = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingData) {
      return const Center(
        child: SizedBox(
          height: 84,
          width: 84,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (_error) {
      return Column(
        children: [
          const Text(
            "There was a problem fetching forcast data.\n"
            "Please check if the location and date you provided is valid",
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: _refreshData, child: const Text("Refresh")),
        ],
      );
    }
    return Row(
      children: _forecast!
          .take(4)
          .map(
            (day) => Expanded(
              child: WeatherForecastTile(
                day: day,
                unitGroup: widget.unitGroup,
              ),
            ),
          )
          .toList(),
    );
  }
}

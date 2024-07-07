import 'package:flutter/material.dart';
import 'package:rafal_weather_sdk/src/ui/weather_forecast_tile.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';
import 'package:rafal_weather_sdk/src/weather_api/unit_group.dart';
import 'package:rafal_weather_sdk/src/weather_api/weather_api_client.dart';

/// A widget that displays daily forecast for the next 4 days.
///
/// [WeatherForecastView] uses [date] as the start of a forecast.
///
/// [location] should be provided as a city name, for example "New York" or
/// provided as latitude and longitude coordinates, for example  "40.73,-73.93".
///
/// [weatherApiClient] provides actual forecast data from the network API
///
/// [unitGroup] sets the temperature unit, °C for [UnitGroup.metric], °F for [UnitGroup.us].
///
/// [forecastData] can be used to display already prepared forecast data,
/// in such case there is no network request to fetch the data from the network API
///
/// See also:
///
///  * [WeatherApiClient], which accesses forecast data directly
class WeatherForecastView extends StatefulWidget {
  final String? location;
  final WeatherApiClient? weatherApiClient;
  final DateTime? date;
  final UnitGroup? unitGroup;
  final List<ForecastDay>? forecastData;

  /// Creates [WeatherForecastView] based on live data from [WeatherApiClient]
  WeatherForecastView.fromApiClient({
    super.key,
    required this.location,
    required this.weatherApiClient,
    required this.unitGroup,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        forecastData = null;

  /// Creates [WeatherForecastView] based on provided [ForecastDay] list
  const WeatherForecastView.fromForecastData({
    super.key,
    required List<ForecastDay> this.forecastData,
    required this.unitGroup,
  })  : location = null,
        weatherApiClient = null,
        date = null;

  @override
  State<WeatherForecastView> createState() => WeatherForecastViewState();
}

class WeatherForecastViewState extends State<WeatherForecastView> {
  late bool _loadingData;
  bool _error = false;
  List<ForecastDay>? _forecast;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(WeatherForecastView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location ||
        widget.weatherApiClient != oldWidget.weatherApiClient ||
        widget.date != oldWidget.date ||
        widget.unitGroup != oldWidget.unitGroup ||
        widget.unitGroup != oldWidget.unitGroup ||
        widget.forecastData != oldWidget.forecastData) {
      loadData();
    }
  }

  Future<void> loadData() async {
    if (widget.forecastData != null) {
      setState(() {
        _loadingData = false;
        _error = false;
        _forecast = widget.forecastData;
      });
      return;
    }

    setState(() {
      _loadingData = true;
      _error = false;
      _forecast = null;
    });

    final data = await widget.weatherApiClient!.getForecast(
      location: widget.location!,
      unitGroup: widget.unitGroup!,
      date: widget.date,
    );
    if (!mounted) {
      return;
    }

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
          height: 128,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (_error) {
      return Column(
        children: [
          const Text(
            "There was a problem fetching forecast data.\n"
            "Please check if the location you provided is valid and you have internet connection",
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: loadData, child: const Text("Refresh")),
        ],
      );
    }
    if (_forecast!.isEmpty) {
      return const Text("No forecast available for selected parameters");
    }
    return Row(
      children: _forecast!
          .take(4)
          .map(
            (day) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: WeatherForecastTile(
                  day: day,
                  unitGroup: widget.unitGroup!,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';

final _dayOfWeekDateFormat = DateFormat(DateFormat.ABBR_WEEKDAY);

/// A widget that displays single [ForecastDay]
/// The widget is used in [WeatherForecastView]
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey.shade300,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_dayOfWeekDateFormat.format(day.datetime)),
              Image.asset(
                day.toAssetString(),
                package: "rafal_weather_sdk",
                height: 64,
              ),
              // Text(day.icon),
              Text("${day.temp}${unitGroup.toTemperatureSymbol()}"),
            ],
          ),
        ),
      ),
    );
  }
}

extension _IconAssetExtension on ForecastDay {
  String toAssetString() {
    return "assets/$icon.png";
  }
}

extension _TemperatureSymbolExtension on UnitGroup {
  String toTemperatureSymbol() {
    return this == UnitGroup.metric ? "°C" : "°F";
  }
}

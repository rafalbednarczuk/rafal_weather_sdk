import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

part 'forecast_day.freezed.dart';

part 'forecast_day.g.dart';

/// Core class for displaying data in [WeatherForecastView] and [WeatherForecastTile].
/// The class is used to receive and parse data inside [WeatherApiClient].
@freezed
class ForecastDay with _$ForecastDay {
  const factory ForecastDay({
    required DateTime datetime,
    required double temp,
    required String icon,
  }) = _ForecastDay;

  factory ForecastDay.fromJson(Map<String, Object?> json) =>
      _$ForecastDayFromJson(json);
}

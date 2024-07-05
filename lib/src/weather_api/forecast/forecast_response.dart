import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';

part 'forecast_response.freezed.dart';
part 'forecast_response.g.dart';

@freezed
class ForecastResponse with _$ForecastResponse {
  const factory ForecastResponse({
    required List<ForecastDay> days,
  }) = _ForecastResponse;

  factory ForecastResponse.fromJson(Map<String, Object?> json) =>
      _$ForecastResponseFromJson(json);
}

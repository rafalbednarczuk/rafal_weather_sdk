import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_day.freezed.dart';

part 'forecast_day.g.dart';

@freezed
class ForecastDay with _$ForecastDay {
  const factory ForecastDay({
    required DateTime datetime,
    required double temp,
    required String icon,
    required String description,
  }) = _ForecastDay;

  factory ForecastDay.fromJson(Map<String, Object?> json) =>
      _$ForecastDayFromJson(json);
}

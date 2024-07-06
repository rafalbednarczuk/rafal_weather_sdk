// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForecastDayImpl _$$ForecastDayImplFromJson(Map<String, dynamic> json) =>
    _$ForecastDayImpl(
      datetime: DateTime.parse(json['datetime'] as String),
      temp: (json['temp'] as num).toDouble(),
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$ForecastDayImplToJson(_$ForecastDayImpl instance) =>
    <String, dynamic>{
      'datetime': instance.datetime.toIso8601String(),
      'temp': instance.temp,
      'icon': instance.icon,
    };

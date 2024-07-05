// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForecastDayImpl _$$ForecastDayImplFromJson(Map<String, dynamic> json) =>
    _$ForecastDayImpl(
      datetime: json['datetime'] as String,
      temp: json['temp'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$ForecastDayImplToJson(_$ForecastDayImpl instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      'temp': instance.temp,
      'icon': instance.icon,
      'description': instance.description,
    };

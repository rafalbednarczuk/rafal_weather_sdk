// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForecastResponseImpl _$$ForecastResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ForecastResponseImpl(
      days: (json['days'] as List<dynamic>)
          .map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ForecastResponseImplToJson(
        _$ForecastResponseImpl instance) =>
    <String, dynamic>{
      'days': instance.days,
    };

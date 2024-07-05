import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_response.dart';
import 'package:rafal_weather_sdk/src/weather_api/unit_group.dart';

/// API client for [https://www.visualcrossing.com]
///
/// API docs: [https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/]
class WeatherApiClient {
  final String apiKey;
  final bool logHttpRequests;
  final _dioClient = Dio(
    BaseOptions(
      baseUrl:
          "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
    ),
  );
  final UnitGroup _unitGroup = UnitGroup.metric;

  WeatherApiClient({required this.apiKey, this.logHttpRequests = false}) {
    _dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters["key"] = apiKey;
          options.queryParameters["unitGroup"] = _unitGroup.name.toLowerCase();
          options.queryParameters["include"] = "days";
          options.queryParameters["contentType"] = "json";
          handler.next(options);
        },
      ),
    );
    if (logHttpRequests) {
      _dioClient.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
  }

  /// Get a forecast in form of a list of [ForecastDay] for the next 15 days for the given location
  /// Location can be used as the the address, partial address or latitude,longitude
  Future<List<ForecastDay>?> getForecast(String location) async {
    try {
      final response = await _dioClient.get(location);
      final forecastResponse =
          ForecastResponse.fromJson(response.data as Map<String, Object?>);
      return forecastResponse.days;
    } on Exception catch (e) {
      return null;
    }
  }
}

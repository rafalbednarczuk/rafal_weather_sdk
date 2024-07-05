import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_response.dart';
import 'package:rafal_weather_sdk/src/weather_api/unit_group.dart';

/// API client for [https://www.visualcrossing.com]
///
/// API docs: [https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/]
///
/// See also:
///
///  * [WeatherForecastView], which displays forecast as a Widget

class WeatherApiClient {
  final String _apiKey;
  final bool _logHttpRequests;
  final _dioClient = Dio(
    BaseOptions(
      baseUrl:
          "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
    ),
  );

  WeatherApiClient({
    required String apiKey,
    bool logHttpRequests = false,
  })  : _logHttpRequests = logHttpRequests,
        _apiKey = apiKey {
    _dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters["key"] = _apiKey;
          options.queryParameters["include"] = "days";
          options.queryParameters["contentType"] = "json";
          handler.next(options);
        },
      ),
    );
    if (_logHttpRequests) {
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

  /// Get a forecast in form of a list of [ForecastDay] for the next 15 days for the given location.
  /// location can be provided as a city name, for example "New York" or
  /// provided as latitude and longitude coordinates, for example  "40.73,-73.93".
  /// unitGroup parameter sets the type of units in the [ForecastDay] model.
  Future<List<ForecastDay>?> getForecast({
    required String location,
    required UnitGroup unitGroup,
  }) async {
    try {
      final response = await _dioClient.get(
        location,
        queryParameters: {"unitGroup": unitGroup.name.toLowerCase()},
      );
      final forecastResponse =
          ForecastResponse.fromJson(response.data as Map<String, Object?>);
      return forecastResponse.days;
    } on Exception catch (e) {
      //TODO: handle different types of errors
      return null;
    }
  }
}

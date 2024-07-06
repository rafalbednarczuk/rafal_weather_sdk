import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_response.dart';

final _dateQueryParameterFormat = DateFormat("yyyy-MM-dd");

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

  /// Default constructor, requires valid [https://www.visualcrossing.com] apiKey.
  /// If logHttpRequests parameter is set to true, it logs each network request to visual crossing API.
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
  /// location parameter can be provided as a city name, for example "New York" or
  /// provided as latitude and longitude coordinates, for example  "40.73,-73.93".
  /// unitGroup parameter sets the type of units in the [ForecastDay] model.
  /// date parameter sets the start of the forecast.
  ///
  /// returns null if there is a connection error, API error or data parsing error
  Future<List<ForecastDay>?> getForecast({
    required String location,
    required UnitGroup unitGroup,
    DateTime? date,
  }) async {
    final forecastStartDate = date ?? DateTime.now();
    final forecastEndDate = forecastStartDate.add(const Duration(days: 15));
    final forecastStartFormatted =
        _dateQueryParameterFormat.format(forecastStartDate);
    final forecastEndFormatted =
        _dateQueryParameterFormat.format(forecastEndDate);

    try {
      final response = await _dioClient.get(
        "$location/$forecastStartFormatted/$forecastEndFormatted",
        queryParameters: {"unitGroup": unitGroup.name.toLowerCase()},
      );
      final forecastResponse =
          ForecastResponse.fromJson(response.data as Map<String, Object?>);
      return forecastResponse.days;
    } catch (_) {
      return null;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_response.dart';

final _dateQueryParameterFormat = DateFormat("yyyy-MM-dd");
const _baseUrl =
    "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/";

/// API client for [https://www.visualcrossing.com]
///
/// API docs: [https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/]
///
/// See also:
///
///  * [WeatherForecastView], which displays forecast as a Widget
class WeatherApiClient {
  final String _apiKey;
  late Dio _dio;

  /// Creates [WeatherApiClient] based on [https://www.visualcrossing.com] [apiKey].
  /// A [dio] can be provided to for example add network logging.
  WeatherApiClient({
    required String apiKey,
    Dio? dio,
  }) : _apiKey = apiKey {
    _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters["key"] = _apiKey;
          options.queryParameters["include"] = "days";
          options.queryParameters["contentType"] = "json";
          handler.next(options);
        },
      ),
    );
  }

  /// Get a forecast in form of a list of [ForecastDay] for the next 15 days for the given location.
  /// [location] can be provided as a city name, for example "New York" or
  /// provided as latitude and longitude coordinates, for example  "40.73,-73.93".
  /// [unitGroup] sets the type of units in the [ForecastDay] model.
  /// [date] sets the start of the forecast.
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
      final response = await _dio.get(
        "$_baseUrl$location/$forecastStartFormatted/$forecastEndFormatted",
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

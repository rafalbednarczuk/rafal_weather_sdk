import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

void main() async {
  group("WeatherApiClient", () {
    late Object successfulResponseData;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      successfulResponseData = jsonDecode(await rootBundle
          .loadString("assets/json/forecast_successful_metric_response.json"));
    });

    test("Successful response", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          successfulResponseData,
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast!.length, 15);
      expect(
        forecast[0],
        ForecastDay(
          datetime: DateTime(2024, 7, 7),
          temp: 21.4,
          icon: "rain",
        ),
      );
      expect(
        forecast[3],
        ForecastDay(
          datetime: DateTime(2024, 7, 10),
          temp: 26.0,
          icon: "partly-cloudy-day",
        ),
      );
    });

    test("Wrong status code, successful response data", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          400,
          successfulResponseData,
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast, null);
    });

    test("Malformed data response", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          "malformed data example",
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast, null);
    });

    test("Malformed json response", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          {"malformed json example": "malformed json example"},
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast, null);
    });

    test("Api wrong response code and wrong response data", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          400,
          "Bad request",
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast, null);
    });

    test("Exception thrown", () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.throws(
          401,
          DioException(
            requestOptions: RequestOptions(
              path: "/",
            ),
          ),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);

      final forecast = await weatherApiClient.getForecast(
        location: "",
        unitGroup: UnitGroup.metric,
      );
      expect(forecast, null);
    });
  });
}

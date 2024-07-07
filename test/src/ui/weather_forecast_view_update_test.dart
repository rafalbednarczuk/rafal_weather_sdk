import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';
import 'weather_forecast_test_page.dart';

void main() {
  group("WeatherForecastView update test", () {
    late Object successfulResponseWarsawData;
    late Object successfulResponseNewYorkData;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      successfulResponseWarsawData = jsonDecode(await rootBundle
          .loadString("assets/json/forecast_successful_metric_response.json"));
      successfulResponseNewYorkData = jsonDecode(await rootBundle.loadString(
          "assets/json/forecast_successful_metric_new_york_response.json"));
    });

    testWidgets('Location update, from Warsaw to New York', (tester) async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          successfulResponseWarsawData,
          delay: const Duration(milliseconds: 100),
        ),
      );
      dioAdapter.onGet(
        RegExp(r'.*New York.*'),
        (server) => server.reply(
          200,
          successfulResponseNewYorkData,
          delay: const Duration(milliseconds: 100),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);
      await tester.pumpWidget(
        MaterialApp(
          home: WeatherForecastTestPage(
            weatherApiClient: weatherApiClient,
          ),
        ),
      );

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until Warsaw data is fetched
      await tester.pumpAndSettle();

      expect(find.text("21.4°C"), findsOneWidget);
      expect(find.text("21.1°C"), findsOneWidget);
      expect(find.text("24.1°C"), findsOneWidget);
      expect(find.text("26.0°C"), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until New York data is fetched
      await tester.pumpAndSettle();

      expect(find.text("28.0°C"), findsOneWidget);
      expect(find.text("27.0°C"), findsOneWidget);
      expect(find.text("26.6°C"), findsOneWidget);
      expect(find.text("27.1°C"), findsOneWidget);
    });
  });
}

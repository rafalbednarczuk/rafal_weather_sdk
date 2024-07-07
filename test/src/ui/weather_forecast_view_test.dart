import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:rafal_weather_sdk/src/ui/weather_forecast_view.dart';
import 'package:rafal_weather_sdk/src/weather_api/forecast/forecast_day.dart';
import 'package:rafal_weather_sdk/src/weather_api/unit_group.dart';
import 'package:rafal_weather_sdk/src/weather_api/weather_api_client.dart';

import '../../load_test_file.dart';

void main() {
  group("WeatherForecastView tests", () {
    late Object successfulResponseMetricData;
    late Object successfulResponseImperialData;
    late Object successfulResponseEmptyData;

    setUp(() async {
      successfulResponseMetricData = jsonDecode(
          await loadTestResource("forecast_successful_metric_response.json"));
      successfulResponseImperialData = jsonDecode(
          await loadTestResource("forecast_successful_imperial_response.json"));
      successfulResponseEmptyData = jsonDecode(await loadTestResource(
          "forecast_successful_metric_empty_data_response.json"));
    });

    testWidgets('View from forecast data, metrics unit', (tester) async {
      final days = [
        ForecastDay(
          datetime: DateTime(2024, 7, 6),
          temp: 5,
          icon: "fog",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 7),
          temp: 10,
          icon: "fog",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 8),
          temp: -5,
          icon: "snow",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 9),
          temp: 5,
          icon: "wind",
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromForecastData(
              forecastData: days,
              unitGroup: UnitGroup.metric,
            ),
          ),
        ),
      );

      expect(find.text("Jul 6"), findsOneWidget);
      expect(find.text("Jul 7"), findsOneWidget);
      expect(find.text("Jul 8"), findsOneWidget);
      expect(find.text("Jul 9"), findsOneWidget);
      //The WeatherForecastView should display only 4 days
      expect(find.text("Jul 10"), findsNothing);

      expect(
        find.image(
          const AssetImage(
            "assets/icon/snow.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.image(
          const AssetImage(
            "assets/icon/wind.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      //2 days with fog icon
      expect(
        find.image(
          const AssetImage(
            "assets/icon/fog.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsNWidgets(2),
      );

      //2 days with 5.0°C temperature
      expect(find.text("5.0°C"), findsNWidgets(2));
      expect(find.text("10.0°C"), findsOneWidget);
      expect(find.text("-5.0°C"), findsOneWidget);
    });

    testWidgets('View from forecast days, imperial unit', (tester) async {
      final days = [
        ForecastDay(
          datetime: DateTime(2024, 7, 6),
          temp: 65,
          icon: "fog",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 7),
          temp: 66,
          icon: "fog",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 8),
          temp: 67,
          icon: "snow",
        ),
        ForecastDay(
          datetime: DateTime(2024, 7, 9),
          temp: 65,
          icon: "wind",
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromForecastData(
              forecastData: days,
              unitGroup: UnitGroup.us,
            ),
          ),
        ),
      );

      //2 days with 65.0°F temperature
      expect(find.text("65.0°F"), findsNWidgets(2));
      expect(find.text("66.0°F"), findsOneWidget);
      expect(find.text("67.0°F"), findsOneWidget);
    });

    testWidgets('View from api client, successful response, metrics unit',
        (tester) async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          successfulResponseMetricData,
          delay: const Duration(milliseconds: 100),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromApiClient(
              location: "Warsaw",
              weatherApiClient: weatherApiClient,
              unitGroup: UnitGroup.metric,
            ),
          ),
        ),
      );

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until data is fetched
      await tester.pumpAndSettle();

      expect(find.text("Jul 7"), findsOneWidget);
      expect(find.text("Jul 8"), findsOneWidget);
      expect(find.text("Jul 9"), findsOneWidget);
      expect(find.text("Jul 10"), findsOneWidget);
      //The WeatherForecastView should display only 4 days
      expect(find.text("Jul 11"), findsNothing);

      expect(
        find.image(
          const AssetImage(
            "assets/icon/rain.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.image(
          const AssetImage(
            "assets/icon/partly-cloudy-day.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsNWidgets(2),
      );
      expect(
        find.image(
          const AssetImage(
            "assets/icon/clear-day.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );

      expect(find.text("21.4°C"), findsOneWidget);
      expect(find.text("21.1°C"), findsOneWidget);
      expect(find.text("24.1°C"), findsOneWidget);
      expect(find.text("26.0°C"), findsOneWidget);
    });

    testWidgets('View from api client, successful response, imperial unit',
        (tester) async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          successfulResponseImperialData,
          delay: const Duration(milliseconds: 100),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromApiClient(
              location: "Warsaw",
              weatherApiClient: weatherApiClient,
              unitGroup: UnitGroup.us,
            ),
          ),
        ),
      );

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until data is fetched
      await tester.pumpAndSettle();

      expect(find.text("Jul 7"), findsOneWidget);
      expect(find.text("Jul 8"), findsOneWidget);
      expect(find.text("Jul 9"), findsOneWidget);
      expect(find.text("Jul 10"), findsOneWidget);
      //The WeatherForecastView should display only 4 days
      expect(find.text("Jul 11"), findsNothing);

      expect(
        find.image(
          const AssetImage(
            "assets/icon/rain.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.image(
          const AssetImage(
            "assets/icon/partly-cloudy-day.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsNWidgets(2),
      );
      expect(
        find.image(
          const AssetImage(
            "assets/icon/clear-day.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );

      expect(find.text("70.5°F"), findsOneWidget);
      expect(find.text("70.0°F"), findsOneWidget);
      expect(find.text("75.2°F"), findsOneWidget);
      expect(find.text("78.7°F"), findsOneWidget);
    });

    testWidgets('View from api client, empty data', (tester) async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          200,
          successfulResponseEmptyData,
          delay: const Duration(milliseconds: 100),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromApiClient(
              location: "Warsaw",
              weatherApiClient: weatherApiClient,
              unitGroup: UnitGroup.metric,
            ),
          ),
        ),
      );

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until data is fetched
      await tester.pumpAndSettle();

      expect(
        find.text("No forecast available for selected parameters"),
        findsOneWidget,
      );
    });

    testWidgets('View from api client, error response', (tester) async {
      final dio = Dio();
      final dioAdapter = DioAdapter(
        dio: dio,
      );
      dioAdapter.onGet(
        RegExp(r'.*'),
        (server) => server.reply(
          401,
          "Authentication error",
          delay: const Duration(milliseconds: 100),
        ),
      );

      final weatherApiClient = WeatherApiClient(apiKey: "", dio: dio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastView.fromApiClient(
              location: "Warsaw",
              weatherApiClient: weatherApiClient,
              unitGroup: UnitGroup.metric,
            ),
          ),
        ),
      );

      //Check if loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      //Wait until data is fetched
      await tester.pumpAndSettle();

      expect(
        find.text("There was a problem fetching forecast data.\n"
            "Please check if the location you provided is valid and you have internet connection"),
        findsOneWidget,
      );
    });
  });
}

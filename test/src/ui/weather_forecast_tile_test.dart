import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

void main() {
  group("WeatherForecastTile tests", () {
    testWidgets('Tile metrics unit', (tester) async {
      final day = ForecastDay(
        datetime: DateTime(2024, 7, 6),
        temp: 20.123,
        icon: "clear-day",
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastTile(
              day: day,
              unitGroup: UnitGroup.metric,
            ),
          ),
        ),
      );
      expect(find.text("Jul 6"), findsOneWidget);
      expect(
        find.image(
          const AssetImage(
            "assets/icon/clear-day.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      expect(find.text("20.1°C"), findsOneWidget);
    });
    testWidgets('Tile imperial unit', (tester) async {
      final day = ForecastDay(
          datetime: DateTime(2024, 7, 8), temp: 65.001, icon: "rain");
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherForecastTile(
              day: day,
              unitGroup: UnitGroup.us,
            ),
          ),
        ),
      );
      expect(find.text("Jul 8"), findsOneWidget);
      expect(
        find.image(
          const AssetImage(
            "assets/icon/rain.png",
            package: "rafal_weather_sdk",
          ),
        ),
        findsOneWidget,
      );
      expect(find.text("65.0°F"), findsOneWidget);
    });
  });
}

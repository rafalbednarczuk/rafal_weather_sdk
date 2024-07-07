import 'package:example/picker_page.dart';
import 'package:example/weather_api_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO: remove the import as the file is gitignored to not leak the key
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

void main() async {
  final weatherApiClient = WeatherApiClient(
    // TODO: replace with https://www.visualcrossing.com key
    apiKey: weatherApiComKey,
  );
  runApp(
    Provider.value(
      value: weatherApiClient,
      child: const MaterialApp(
        home: PickerPage(),
      ),
    ),
  );
}

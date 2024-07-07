# rafal_weather_sdk

A library for accessing and displaying the weather forecast.

### Installation
Add git dependency to your `pubspec.yaml` file:
```
dependencies:
  rafal_weather_sdk:
    git:
      url: https://github.com/rafalbednarczuk/rafal_weather_sdk.git
```

### WeatherApiClient usage

`WeatherAPIClient` is visualcrossing.com API wrapper that requires API key that you can get at https://www.visualcrossing.com/

An example of how to use `WeatherAPIClient`:
```dart
final weatherApiClient = WeatherApiClient(
  // TODO: replace with https://www.visualcrossing.com key
  apiKey: weatherApiComKey,
);
final forecast = await weatherApiClient.getForecast(
  location: "New York", 
  unitGroup: UnitGroup.metric,
);
forecast?.forEach((forecastDay) {
  print(forecastDay);
});
```


### WeatherForecastView
![](https://raw.githubusercontent.com/rafalbednarczuk/rafal_weather_sdk/master/images/view.jpg)

`WeatherForecastView` is a widget that can be used with live data that comes from `WeatherApiClient`
or with provided forecast data.  
It supports two temperature units groups:
- `metric` (°C)
- `us` (°F)

An example of how to use `WeatherForecastView` with `WeatherApiClient`:
```dart
WeatherForecastView.fromApiClient(
  location: "New york",
  weatherApiClient: weatherApiClient,
  unitGroup: UnitGroup.metric,
)
```

An example of how to use `WeatherForecastView` with provided forecast data:
```dart
WeatherForecastView.fromForecastData(
    forecastData: [
        ForecastDay(
            datetime: DateTime(2024, 7, 6),
            temp: 5,
            icon: "cloudy",
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
    ],
    unitGroup: UnitGroup.metric,
)
```

### WeatherForecastTile
![](https://raw.githubusercontent.com/rafalbednarczuk/rafal_weather_sdk/master/images/single.jpg)

`WeatherForecastTile` is a widget that displays a single day widget using `ForecastDay` model.

An example of how to use it:
```dart
WeatherForecastTile(
    day: ForecastDay(
      datetime: DateTime(2024, 7, 6),
      temp: 30,
      icon: "clear-day",
    ),
    unitGroup: UnitGroup.metric,
)
```


### Weather icons

To see all the weather icons with their names, see [assets folder](https://github.com/rafalbednarczuk/rafal_weather_sdk/tree/master/assets/icon) 
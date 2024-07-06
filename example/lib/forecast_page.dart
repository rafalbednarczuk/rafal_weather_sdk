import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafal_weather_sdk/rafal_weather_sdk.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late GlobalKey<WeatherForecastViewState> _forecastViewKey;
  late String _location;
  late TextEditingController _locationController;
  late UnitGroup _unitGroup = UnitGroup.metric;
  DateTime? _forecastDate;

  @override
  void initState() {
    super.initState();
    _forecastViewKey = GlobalKey();
    _location = "Warsaw";
    _locationController = TextEditingController(text: _location);
    _unitGroup = UnitGroup.metric;
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecast"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
                onPressed: _pickForecastDate,
                child: const Text("Pick forecast date")),
            OutlinedButton(
              onPressed: _pickUnitGroup,
              child: const Text("Pick temperature units"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: "Location",
                      suffixIcon: IconButton(
                        onPressed: _submitLocation,
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    onSubmitted: (_) {
                      _submitLocation();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            WeatherForecastView.fromApiClient(
              key: _forecastViewKey,
              location: _location,
              weatherApiClient: Provider.of(context),
              unitGroup: _unitGroup,
              date: _forecastDate,
            ),
            OutlinedButton(
              onPressed: () {
                _forecastViewKey.currentState?.loadData();
              },
              child: const Text("Force refresh"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickForecastDate() async {
    final today = DateTime.now();
    final todayPlusTwoWeeks = today.add(const Duration(days: 14));
    final date = await showDatePicker(
      context: context,
      initialDate: _forecastDate,
      firstDate: today,
      lastDate: todayPlusTwoWeeks,
    );
    if (date == null) {
      return;
    }
    setState(() {
      _forecastDate = date;
    });
  }

  Future<void> _pickUnitGroup() async {
    final unitGroup = await showDialog<UnitGroup?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Pick temperate units"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(UnitGroup.metric);
            },
            child: const Text("Metric (°C)"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(UnitGroup.us);
            },
            child: const Text("Imperial (°F)"),
          ),
        ],
      ),
    );
    if (unitGroup == null) {
      return;
    }
    setState(() {
      _unitGroup = unitGroup;
    });
  }

  void _submitLocation() {
    setState(() {
      _location = _locationController.text;
    });
  }
}

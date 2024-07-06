import 'package:example/forecast_gallery.dart';
import 'package:example/forecast_page.dart';
import 'package:flutter/material.dart';

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Picker")),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForecastPage(),
                ),
              );
            },
            title: const Text("Real data Forecast page"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForecastGallery(),
                ),
              );
            },
            title: const Text("Forecast widgets gallery page"),
          ),
        ],
      ),
    );
  }
}

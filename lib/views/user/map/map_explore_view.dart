import 'package:Mobile/utils/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapExploreView extends StatelessWidget {
  const MapExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('mapExploreTitle')),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(10.7769, 106.7009),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.sfinity.mobile',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(10.7769, 106.7009),
                width: 46,
                height: 46,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class UserFilterView extends StatefulWidget {
  const UserFilterView({super.key});

  @override
  State<UserFilterView> createState() => _UserFilterViewState();
}

class _UserFilterViewState extends State<UserFilterView> {
  bool showPlaces = true;
  bool showDocuments = true;
  bool onlyFeatured = false;
  double maxDistance = 10;

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('filterPageTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: [
          SwitchListTile(
            value: showPlaces,
            onChanged: (value) => setState(() => showPlaces = value),
            title: Text(appLanguage.get('placeTag')),
          ),
          SwitchListTile(
            value: showDocuments,
            onChanged: (value) => setState(() => showDocuments = value),
            title: Text(appLanguage.get('documentTag')),
          ),
          SwitchListTile(
            value: onlyFeatured,
            onChanged: (value) => setState(() => onlyFeatured = value),
            title: Text(appLanguage.get('featuredOnly')),
          ),
          const SizedBox(height: 12),
          Text(appLanguage.get('distanceRangeLabel')),
          Slider(
            value: maxDistance,
            min: 1,
            max: 30,
            divisions: 29,
            label: '${maxDistance.toInt()} km',
            onChanged: (value) => setState(() => maxDistance = value),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appLanguage.get('applyFilterButton')),
          ),
        ],
      ),
    );
  }
}

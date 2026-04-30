import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ShareDocumentView extends StatelessWidget {
  const ShareDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('shareDocumentButton')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: appLanguage.get('documentTitleLabel'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: appLanguage.get('documentSubjectLabel'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: appLanguage.get('documentDescriptionLabel'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_outlined),
            label: Text(appLanguage.get('pickDocumentButton')),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_outlined),
            label: Text(appLanguage.get('submitDocumentButton')),
          ),
        ],
      ),
    );
  }
}

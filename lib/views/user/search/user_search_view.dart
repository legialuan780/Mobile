import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class UserSearchView extends StatelessWidget {
  const UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    final suggestions = [
      'Cafe học bài mở khuya',
      'Tài liệu IELTS Speaking',
      'Địa điểm yên tĩnh gần đại học',
      'Mindmap môn Toán cao cấp',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('searchPageTitle')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: appLanguage.get('searchHint'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              appLanguage.get('suggestedKeywords'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AdminFeaturedContentView extends StatelessWidget {
  const AdminFeaturedContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('featuredContent')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: const [
          _FeaturedCard(
            title: 'IELTS Speaking Notes',
            metric: '320 lượt tải • 95% phản hồi tích cực',
            category: 'Tài liệu',
          ),
          SizedBox(height: 10),
          _FeaturedCard(
            title: 'Quan cafe học nhóm gần trường',
            metric: '120 lượt lưu • 4.8 sao',
            category: 'Địa điểm',
          ),
          SizedBox(height: 10),
          _FeaturedCard(
            title: 'Checklist ôn thi cuối kỳ',
            metric: '280 lượt lưu • 1.1k lượt xem',
            category: 'Bài đăng',
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.title,
    required this.metric,
    required this.category,
  });

  final String title;
  final String metric;
  final String category;

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.star_outline, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(metric),
        trailing: OutlinedButton(
          onPressed: () {},
          child: Text(appLanguage.get('setFeaturedButton')),
        ),
      ),
    );
  }
}

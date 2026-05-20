import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AdminPlacesView extends StatelessWidget {
  const AdminPlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('managePlaces')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: [
          _buildTopActions(context, appLanguage),
          const SizedBox(height: 12),
          const _AdminPlaceCard(
            title: 'Cafe Study Corner - Q3',
            subtitle: 'Đang hoạt động • 4.7 sao • 132 lượt lưu',
            status: 'Đã duyệt',
          ),
          const SizedBox(height: 10),
          const _AdminPlaceCard(
            title: 'Phòng học nhóm Campus A',
            subtitle: 'Chờ kiểm duyệt • bổ sung ảnh bìa',
            status: 'Chờ duyệt',
          ),
          const SizedBox(height: 10),
          const _AdminPlaceCard(
            title: 'Thư viện mini GreenSpace',
            subtitle: 'Bị báo cáo • cần rà soát thông tin',
            status: 'Cần xử lý',
          ),
        ],
      ),
    );
  }

  Widget _buildTopActions(BuildContext context, AppLanguge appLanguage) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_location_alt_outlined),
            label: Text(appLanguage.get('quickActionAddPlace')),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fact_check_outlined),
            label: Text(appLanguage.get('quickActionReviewPlace')),
          ),
        ),
      ],
    );
  }
}

class _AdminPlaceCard extends StatelessWidget {
  const _AdminPlaceCard({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.place_outlined, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}

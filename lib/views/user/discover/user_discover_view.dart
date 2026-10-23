import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class UserDiscoverView extends StatelessWidget {
  const UserDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('discoverPageTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: const [
          _DiscoverItem(
            icon: Icons.place_outlined,
            title: 'Cafe Study Hub - Q1',
            subtitle: 'Địa điểm mới • 4.8 sao • 350m',
            tag: 'Địa điểm',
          ),
          SizedBox(height: 10),
          _DiscoverItem(
            icon: Icons.menu_book_outlined,
            title: 'Bộ đề ôn thi Data Structure',
            subtitle: 'Tài liệu nổi bật • 1.2k lượt tải',
            tag: 'Tài liệu',
          ),
          SizedBox(height: 10),
          _DiscoverItem(
            icon: Icons.place_outlined,
            title: 'Không gian học nhóm Riverside',
            subtitle: 'Địa điểm nổi bật • wifi mạnh • mở đến 22h',
            tag: 'Địa điểm',
          ),
        ],
      ),
    );
  }
}

class _DiscoverItem extends StatelessWidget {
  const _DiscoverItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(label: Text(tag)),
      ),
    );
  }
}

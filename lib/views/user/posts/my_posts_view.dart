import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class MyPostsView extends StatelessWidget {
  const MyPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('myPostsButton')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: const [
          _PostCard(
            title: 'Review quán học nhóm mở khuya',
            subtitle: 'Đăng 2 ngày trước • 45 lượt xem',
            status: 'Đã duyệt',
          ),
          SizedBox(height: 10),
          _PostCard(
            title: 'Tổng hợp tài liệu ôn OOP',
            subtitle: 'Đăng 5 ngày trước • 88 lượt xem',
            status: 'Đang chờ duyệt',
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
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
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}

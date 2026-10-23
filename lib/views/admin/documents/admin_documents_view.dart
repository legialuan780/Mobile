import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AdminDocumentsView extends StatelessWidget {
  const AdminDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('manageDocuments')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.note_add_outlined),
                  label: Text(appLanguage.get('quickActionAddDocument')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.rule_folder_outlined),
                  label: Text(appLanguage.get('quickActionReviewDocument')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _DocumentCard(
            title: 'IELTS Writing Task 2 - Full Notes',
            subtitle: 'Đã xuất bản • 1.2k lượt tải • Cập nhật 2 ngày trước',
            status: 'Đã duyệt',
          ),
          const SizedBox(height: 10),
          const _DocumentCard(
            title: 'Cheat sheet môn Data Structure',
            subtitle: 'Chờ kiểm duyệt • thiếu mô tả bản quyền',
            status: 'Chờ duyệt',
          ),
          const SizedBox(height: 10),
          const _DocumentCard(
            title: 'Slide OOP midterm',
            subtitle: 'Bị báo cáo trùng lặp nội dung',
            status: 'Cần xử lý',
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
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
          child: const Icon(Icons.menu_book_outlined, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}

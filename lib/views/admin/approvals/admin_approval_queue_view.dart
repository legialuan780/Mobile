import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AdminApprovalQueueView extends StatelessWidget {
  const AdminApprovalQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('approvalQueue')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: const [
          _ApprovalCard(
            title: 'Địa điểm mới: Quiet Room Cafe',
            subtitle: 'Gửi bởi user_hieu • 20 phút trước',
          ),
          SizedBox(height: 10),
          _ApprovalCard(
            title: 'Tài liệu mới: Mindmap Giải tích',
            subtitle: 'Gửi bởi user_mai • 45 phút trước',
          ),
          SizedBox(height: 10),
          _ApprovalCard(
            title: 'Bài đăng mới: Tips học nhóm hiệu quả',
            subtitle: 'Gửi bởi user_anh • 1 giờ trước',
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.pending_actions_outlined, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton<String>(
          onSelected: (_) {},
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'approve',
              child: Text(appLanguage.get('approveButton')),
            ),
            PopupMenuItem(
              value: 'reject',
              child: Text(appLanguage.get('rejectButton')),
            ),
          ],
        ),
      ),
    );
  }
}

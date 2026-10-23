import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('reviewReports')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: const [
          _ReportCard(
            target: 'Bài đăng: Cafe học nhóm gần ga metro',
            reason: 'Nội dung không chính xác',
            reporter: 'user_thanhha',
          ),
          SizedBox(height: 10),
          _ReportCard(
            target: 'Tài liệu: TOEIC full PDF',
            reason: 'Nghi ngờ vi phạm bản quyền',
            reporter: 'user_minhtri',
          ),
          SizedBox(height: 10),
          _ReportCard(
            target: 'Địa điểm: Study Lab A',
            reason: 'Spam quảng cáo',
            reporter: 'user_linh',
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.target,
    required this.reason,
    required this.reporter,
  });

  final String target;
  final String reason;
  final String reporter;

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(target, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('${appLanguage.get('reportReasonLabel')}: $reason'),
            Text('${appLanguage.get('reportByLabel')}: $reporter'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(appLanguage.get('dismissReportButton')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(appLanguage.get('takeActionButton')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

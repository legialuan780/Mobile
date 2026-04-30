import 'package:flutter/material.dart';
import '../../app/route_names.dart';
import '../../utils/app_language.dart';
import '../../utils/app_styles.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = AppLanguge.of(context)!;
    final moderationItems = [
      _AdminItem(
        title: appLanguage.get('reviewReports'),
        subtitle: '${appLanguage.get('pending')}: 6',
        total: 6,
        icon: Icons.report_problem_outlined,
        routeName: RouteNames.adminReports,
      ),
      _AdminItem(
        title: appLanguage.get('approvalQueue'),
        subtitle: '${appLanguage.get('pending')}: 11',
        total: 11,
        icon: Icons.approval_outlined,
        routeName: RouteNames.adminApprovalQueue,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('adminPanelTitle')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppStyles.primaryColor,
                    AppStyles.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      appLanguage.get('adminPanelSubtitle'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailedManagementCard(
              context: context,
              icon: Icons.place_outlined,
              title: appLanguage.get('managePlaces'),
              description: appLanguage.get('placesAdminDescription'),
              activeCount: 18,
              pendingCount: 3,
              totalCount: 24,
              quickActions: [
                appLanguage.get('quickActionAddPlace'),
                appLanguage.get('quickActionReviewPlace'),
              ],
              onViewAll: () {
                Navigator.pushNamed(context, RouteNames.adminPlaces);
              },
              onQuickActionPressed: (action) {
                Navigator.pushNamed(context, RouteNames.adminPlaces);
              },
            ),
            const SizedBox(height: 12),
            _buildDetailedManagementCard(
              context: context,
              icon: Icons.menu_book_outlined,
              title: appLanguage.get('manageDocuments'),
              description: appLanguage.get('documentsAdminDescription'),
              activeCount: 42,
              pendingCount: 8,
              totalCount: 57,
              quickActions: [
                appLanguage.get('quickActionAddDocument'),
                appLanguage.get('quickActionReviewDocument'),
              ],
              onViewAll: () {
                Navigator.pushNamed(context, RouteNames.adminDocuments);
              },
              onQuickActionPressed: (action) {
                Navigator.pushNamed(context, RouteNames.adminDocuments);
              },
            ),
            const SizedBox(height: 16),
            Text(
              appLanguage.get('moderationSectionTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...moderationItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                      child: Icon(item.icon, color: AppStyles.primaryColor),
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.subtitle} • ${appLanguage.get('totalItems')}: ${item.total}',
                    ),
                    onTap: () => Navigator.pushNamed(context, item.routeName),
                    trailing: TextButton(
                      onPressed: () => Navigator.pushNamed(context, item.routeName),
                      child: Text(appLanguage.get('viewAll')),
                    ),
                  ),
                ),
              );
            }),
            Text(
              appLanguage.get('featuredContent'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, RouteNames.adminFeatured),
                leading: CircleAvatar(
                  backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.star_outline, color: AppStyles.primaryColor),
                ),
                title: Text(appLanguage.get('featuredContent')),
                subtitle: const Text(
                  'Top tài liệu và địa điểm có tương tác cao tuần này',
                ),
                trailing: TextButton(
                  onPressed: () => Navigator.pushNamed(context, RouteNames.adminFeatured),
                  child: Text(appLanguage.get('viewAll')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedManagementCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required int activeCount,
    required int pendingCount,
    required int totalCount,
    required List<String> quickActions,
    required VoidCallback onViewAll,
    required ValueChanged<String> onQuickActionPressed,
  }) {
    final appLanguage = AppLanguge.of(context)!;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                  child: Icon(icon, color: AppStyles.primaryColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(appLanguage.get('viewAll')),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCountChip(
                  context,
                  '${appLanguage.get('active')}: $activeCount',
                ),
                _buildCountChip(
                  context,
                  '${appLanguage.get('pending')}: $pendingCount',
                ),
                _buildCountChip(
                  context,
                  '${appLanguage.get('totalItems')}: $totalCount',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              appLanguage.get('quickActions'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quickActions
                  .map(
                    (action) => OutlinedButton(
                      onPressed: () => onQuickActionPressed(action),
                      child: Text(action),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _AdminItem {
  const _AdminItem({
    required this.title,
    required this.subtitle,
    required this.total,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String subtitle;
  final int total;
  final IconData icon;
  final String routeName;
}

import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/data/repositories/auth_repository.dart';
import 'package:Mobile/utils/app_language.dart';
import 'package:Mobile/utils/app_styles.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final appLanguage = AppLanguge.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLanguage.get('homeTitle')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.admin);
            },
            icon: const Icon(Icons.admin_panel_settings_outlined),
            tooltip: appLanguage.get('adminPanelTitle'),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.settings);
            },
            icon: const Icon(Icons.settings),
            tooltip: appLanguage.get('settingsTitle'),
          ),
          IconButton(
            onPressed: () async {
              try {
                await authRepository.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.login,
                    (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi đăng xuất: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: appLanguage.get('logout'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppStyles.smallPadding),
        children: [
          _buildHeroHeader(context, appLanguage),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pushNamed(context, RouteNames.userSearch),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: appLanguage.get('searchHint'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildDashMetric(context, title: appLanguage.get('newPlacesMetric'), value: '12'),
                _buildVerticalDivider(context),
                _buildDashMetric(context, title: appLanguage.get('newDocumentsMetric'), value: '18'),
                _buildVerticalDivider(context),
                _buildDashMetric(context, title: appLanguage.get('savedMetric'), value: '7'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(
            context,
            title: appLanguage.get('newAndFeaturedSection'),
            onFilterPressed: () => Navigator.pushNamed(context, RouteNames.userFilter),
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            context,
            icon: Icons.place_outlined,
            title: appLanguage.get('featuredPlaceTitle'),
            subtitle: appLanguage.get('featuredPlaceSubtitle'),
            tagText: appLanguage.get('placeTag'),
            onTap: () => Navigator.pushNamed(context, RouteNames.userDiscover),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            context,
            icon: Icons.menu_book_outlined,
            title: appLanguage.get('featuredDocTitle'),
            subtitle: appLanguage.get('featuredDocSubtitle'),
            tagText: appLanguage.get('documentTag'),
            onTap: () => Navigator.pushNamed(context, RouteNames.userDiscover),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.userDiscover),
              child: Text(appLanguage.get('viewAll')),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appLanguage.get('mySharingSection'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, RouteNames.userMyPosts),
                  icon: const Icon(Icons.article_outlined),
                  label: Text(appLanguage.get('myPostsButton')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, RouteNames.userCreatePost),
                  icon: const Icon(Icons.post_add_outlined),
                  label: Text(appLanguage.get('newPostButton')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, RouteNames.userShareDocument),
              icon: const Icon(Icons.upload_file_outlined),
              label: Text(appLanguage.get('shareDocumentButton')),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, RouteNames.map),
              icon: const Icon(Icons.map_outlined),
              label: Text(appLanguage.get('openMapButton')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, AppLanguge appLanguage) {
    return Container(
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
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sfinity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  appLanguage.get('homeWelcomeSubtitle'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashMetric(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return SizedBox(
      height: 36,
      child: VerticalDivider(
        color: Theme.of(context).dividerColor,
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onFilterPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        OutlinedButton.icon(
          onPressed: onFilterPressed,
          icon: const Icon(Icons.tune, size: 18),
          label: Text(AppLanguge.of(context)!.get('filterButton')),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String tagText,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: AppStyles.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(
          label: Text(tagText),
        ),
      ),
    );
  }
}

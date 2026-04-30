import 'package:Mobile/app/route_names.dart';
import 'package:Mobile/views/auth/forgot_password_view.dart';
import 'package:Mobile/views/auth/login_view.dart';
import 'package:Mobile/views/auth/register_view.dart';
import 'package:Mobile/views/admin/admin_dashboard_view.dart';
import 'package:Mobile/views/admin/approvals/admin_approval_queue_view.dart';
import 'package:Mobile/views/admin/documents/admin_documents_view.dart';
import 'package:Mobile/views/admin/featured/admin_featured_content_view.dart';
import 'package:Mobile/views/admin/places/admin_places_view.dart';
import 'package:Mobile/views/admin/reports/admin_reports_view.dart';
import 'package:Mobile/views/settings/settings_view.dart';
import 'package:Mobile/views/user/discover/user_discover_view.dart';
import 'package:Mobile/views/user/documents/share_document_view.dart';
import 'package:Mobile/views/user/filter/user_filter_view.dart';
import 'package:Mobile/views/user/home/home_view.dart';
import 'package:Mobile/views/user/map/map_explore_view.dart';
import 'package:Mobile/views/user/posts/create_post_view.dart';
import 'package:Mobile/views/user/posts/my_posts_view.dart';
import 'package:Mobile/views/user/search/user_search_view.dart';
import 'package:Mobile/main.dart';
import 'package:flutter/material.dart';

class Routes{
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => SettingsView(controller: settingsController));
      case RouteNames.admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboardView());
      case RouteNames.map:
        return MaterialPageRoute(builder: (_) => const MapExploreView());
      case RouteNames.userSearch:
        return MaterialPageRoute(builder: (_) => const UserSearchView());
      case RouteNames.userFilter:
        return MaterialPageRoute(builder: (_) => const UserFilterView());
      case RouteNames.userDiscover:
        return MaterialPageRoute(builder: (_) => const UserDiscoverView());
      case RouteNames.userMyPosts:
        return MaterialPageRoute(builder: (_) => const MyPostsView());
      case RouteNames.userCreatePost:
        return MaterialPageRoute(builder: (_) => const CreatePostView());
      case RouteNames.userShareDocument:
        return MaterialPageRoute(builder: (_) => const ShareDocumentView());
      case RouteNames.adminPlaces:
        return MaterialPageRoute(builder: (_) => const AdminPlacesView());
      case RouteNames.adminDocuments:
        return MaterialPageRoute(builder: (_) => const AdminDocumentsView());
      case RouteNames.adminReports:
        return MaterialPageRoute(builder: (_) => const AdminReportsView());
      case RouteNames.adminApprovalQueue:
        return MaterialPageRoute(builder: (_) => const AdminApprovalQueueView());
      case RouteNames.adminFeatured:
        return MaterialPageRoute(builder: (_) => const AdminFeaturedContentView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
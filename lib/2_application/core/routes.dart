import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_cleanarch/1_domain/entities/unique_id.dart';
import 'package:todo_cleanarch/2_application/core/go_router_observer.dart';
import 'package:todo_cleanarch/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';
import 'package:todo_cleanarch/2_application/pages/overview/overview_page.dart';

import '../pages/dashboard/dashboard_page.dart';
import '../pages/detail/todo_detail_page.dart';
import '../pages/home/home_page.dart';
import '../pages/setting/setting_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

const String _basePath = '/home';

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '$_basePath/${DasboardPage.pageConfig.name}',
  observers: [GoRouterObserver()],
  routes: [
    GoRoute(
      name: SettingsPage.pageConfig.name,
      path: '$_basePath/${SettingsPage.pageConfig.name}',
      builder: (context, state) {
        return const SettingsPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          name: HomePage.pageConfig.name,
          path: '$_basePath/:tab',
          builder: (context, state) => HomePage(
            key: state.pageKey,
            tab: state.pathParameters['tab']!,
          ),
        ),
      ],
    ),
    GoRoute(
      name: ToDoDetailPage.pageConfig.name,
      path: '$_basePath/overview/:collectionId',
      builder: (context, state) {
        return BlocListener<NavigationTodoCubit, NavigationTodoCubitState>(
          listenWhen: (previous, current) =>
              previous.isSecondBodyIsDisplayed !=
              current.isSecondBodyIsDisplayed,
          listener: (context, state) {
            if (context.canPop() && (state.isSecondBodyIsDisplayed ?? false)) {
              context.pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('details'),
              leading: BackButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(
                      HomePage.pageConfig.name,
                      pathParameters: {'tab': OverviewPage.pageConfig.name},
                    );
                  }
                },
              ),
            ),
            body: ToDoDetailPageProvider(
              collectionId: CollectionId.fromUniqueString(
                state.pathParameters['collectionId'] ?? '',
              ),
            ),
          ),
        );
      },
    ),
  ],
);

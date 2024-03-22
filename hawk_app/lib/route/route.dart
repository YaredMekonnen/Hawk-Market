import "package:hawk_app/auth/pages/index.dart";
import "package:hawk_app/chat/pages/index.dart";
import 'package:hawk_app/create_post/pages/create_post_page.dart';
import "package:hawk_app/home/pages/index.dart";
import "package:hawk_app/profile/pages/index.dart";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hawk_app/theme/theme.dart";

class AppRouter extends StatelessWidget {


  static GlobalKey<NavigatorState> parentKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> createPostKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final GoRouter router = GoRouter(
        navigatorKey: parentKey,
        initialLocation: "/",
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return HomePage(child: navigationShell, scaffoldKey: scaffoldKey,);
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                navigatorKey: homeKey,
                routes: [
                  GoRoute(
                    path: "/",
                    builder: (context, state) {
                      return ItemListPage(scaffoldKey: scaffoldKey);
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: "search",
                        builder: (context, state) {
                          return SearchPage();
                        }
                      ),
                      GoRoute(
                        path: "profile",
                        builder: (context, state) {
                          return SelfProfilePage();
                        }
                      ),
                      GoRoute(
                        path: "profile/:id",
                        builder: (context, state) {
                          return OtherProfilePage();
                        }
                      ),
                      GoRoute(
                        path: "chat",
                        builder: (context, state) {
                          return ChatPage();
                        }
                      ),
                    ]
                  ),
                ]
              ),
              StatefulShellBranch(
                navigatorKey: createPostKey,
                routes: [
                  GoRoute(
                    path: "/create-post",
                    builder: (context, state) {
                      return CreatePostPage();
                    }
                  ),
                ]
              ),
              StatefulShellBranch(
                navigatorKey: profileKey,
                routes: [
                  GoRoute(
                    path: "/account",
                    builder: (context, state) {
                      return SelfProfilePage();
                    }
                  ),
                ]
              ),
            ]
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              return SignInPage();
            },
          ),
           GoRoute(
            path: '/signup',
            builder: (context, state) {
              return SignUpPage();
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      title: "Hawk",
      theme: ThemeClass.lightTheme,
      routerConfig: router
    );
  }

}
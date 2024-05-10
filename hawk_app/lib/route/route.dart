import "package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart";
import "package:hawk_app/auth/pages/index.dart";
import "package:hawk_app/chat/pages/index.dart";
import "package:hawk_app/commons/utils/go_router_refresh_stream.dart";
import 'package:hawk_app/create_product/pages/create_product_page.dart';
import "package:hawk_app/home/pages/index.dart";
import "package:hawk_app/profile/pages/index.dart";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class AppRouter extends StatelessWidget {


  static GlobalKey<NavigatorState> parentKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  // static GlobalKey<NavigatorState> itemListKey = GlobalKey<NavigatorState>();
  // static GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
  // static GlobalKey<NavigatorState> createPostKey = GlobalKey<NavigatorState>();
  // static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late GoRouter router;

  AppRouter(AuthCubit authCubit){
    router = getRouter(authCubit);
  }

  GoRouter getRouter(AuthCubit authCubit){
    return GoRouter(
        initialLocation: "/",
        navigatorKey: parentKey,
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return HomePage(child: navigationShell);
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                navigatorKey: homeKey,
                routes: [
                  GoRoute(
                    path: "/",
                    builder: (context, state) {
                      return ItemListPage();
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
                routes: [
                  GoRoute(
                    path: "/create-post",
                    builder: (context, state) {
                      return CreateProductPage();
                    }
                  ),
                ]
              ),
              StatefulShellBranch(
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
            path: '/verify-otp',
            builder: (context, state) {
              return OtpPage();
            },
          ),
          GoRoute(
            path: '/forgot-password',
            builder: (context, state) {
              return ForgotPasswordPage();
            },
          ),
          GoRoute(
            path: '/reset-password',
            builder: (context, state) {
              return ResetPasswordPage();
            },
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
        redirect: (context, state) {
          final loggedIn = authCubit.state is Authenticated;
          final loggingIn = state.fullPath == '/login';
          final authPages = ['/login', '/signup', '/forgot-password', '/reset-password', '/verify-otp'];

          if (!loggedIn && !authPages.contains(state.fullPath)) {
            return '/login';
          }

          if (loggedIn && loggingIn){
            return '/';
          }

          return null;
        },
        refreshListenable: GoRouterRefreshStream(authCubit.stream),
      );
  }

  @override
  Widget build(BuildContext context){
    return Container();
  }

}
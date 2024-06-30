import "package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart";
import "package:hawk_app/auth/models/user.dart";
import "package:hawk_app/auth/pages/index.dart";
import "package:hawk_app/auth/pages/splash_page.dart";
import "package:hawk_app/chat/pages/index.dart";
import "package:hawk_app/chat/service/socket_service.dart";
import "package:hawk_app/commons/utils/go_router_refresh_stream.dart";
import 'package:hawk_app/create_product/pages/create_product_page.dart';
import "package:hawk_app/home/models/story.dart";
import "package:hawk_app/home/pages/index.dart";
import "package:hawk_app/home/pages/story_page.dart";
import "package:hawk_app/payment/pages/index.dart";
import "package:hawk_app/profile/pages/index.dart";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class AppRouter extends StatelessWidget {
  static GlobalKey<NavigatorState> parentKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late GoRouter router;

  AppRouter(AuthCubit authCubit, SocketService socketService) {
    router = getRouter(authCubit);
  }

  GoRouter getRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: "/",
      navigatorKey: parentKey,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return HomePage(
                child: navigationShell,
                scaffoldKey: scaffoldKey,
              );
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(navigatorKey: homeKey, routes: [
                GoRoute(
                    path: "/",
                    builder: (context, state) {
                      String? from = state.uri.queryParameters["from"];
                      return ItemListPage(
                        scaffoldKey: scaffoldKey,
                        from: from ?? "/",
                      );
                    },
                    routes: <RouteBase>[
                      GoRoute(
                          path: "search",
                          builder: (context, state) {
                            return SearchPage();
                          }),
                      GoRoute(
                          path: "product/:id",
                          builder: (context, state) {
                            String? from = state.uri.queryParameters["from"];
                            String? productId = state.pathParameters["id"];
                            return ItemDescriptionPage(productId!, from ?? "/");
                          }),
                    ]),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/create-post",
                    builder: (context, state) {
                      return CreateProductPage();
                    }),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/account",
                    builder: (context, state) {
                      return SelfProfilePage(
                        scaffoldKey: scaffoldKey,
                      );
                    },
                    routes: <RouteBase>[
                      GoRoute(
                          path: "product/:id",
                          builder: (context, state) {
                            String? from = state.uri.queryParameters["from"];
                            String? productId = state.pathParameters["id"];
                            return ItemDescriptionPage(productId!, from ?? "/");
                          }),
                    ]),
              ]),
            ]),
        GoRoute(
            path: "/chat",
            builder: (context, state) {
              return ChatsPage();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: ":id",
                  builder: (context, state) {
                    String? userId = state.uri.queryParameters["userId"];
                    String? otherUserId =
                        state.uri.queryParameters["otherUserId"];
                    return ChatPage(
                      chatId: state.pathParameters['id'] ?? "-1",
                      userId: userId ?? "-1",
                      otherUserId: otherUserId ?? "-1",
                    );
                  })
            ]),
        GoRoute(
            path: "/profile/:id",
            builder: (context, state) {
              String? userId = state.pathParameters['id'];
              return OtherProfilePage(
                userId: userId!,
              );
            }),
        GoRoute(
          path: "/story/:id",
          builder: (context, state) {
            String? from = state.uri.queryParameters["from"];
            return StoryPage(
                id: state.pathParameters['id']!, from: from ?? '/');
          },
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
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) {
            return PaymentPage();
          },
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            return SplashPage();
          },
        )
      ],
      redirect: (context, state) {
        final unauthenticated = authCubit.state is Unauthenticated;
        final authenticating = authCubit.state is Authenticating;
        final loggedIn = authCubit.state is Authenticated;
        final loggingIn =
            state.fullPath == '/login' || state.fullPath == '/splash';
        final authPages = [
          '/login',
          '/signup',
          '/forgot-password',
          '/reset-password',
          '/verify-otp',
        ];

        if (authenticating && !loggingIn) return '/splash';

        if (unauthenticated && !authPages.contains(state.fullPath)) {
          return '/login';
        }

        if (loggedIn && loggingIn) {
          return '/';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

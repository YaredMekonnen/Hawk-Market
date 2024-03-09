import "package:hawk_app/auth/pages/index.dart";
import "package:hawk_app/chat/pages/index.dart";
import "package:hawk_app/create_post/pages/create_post.dart";
import "package:hawk_app/home/pages/index.dart";
import "package:hawk_app/profile/pages/index.dart";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class AppRouter extends StatelessWidget {


  late GoRouter _router = GoRouter(
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        branches: <StatefulShellBranch>[
          StatefulShellBranch(routes: [])
        ]
      )
    ], 
    initialLocation: "/");


  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: "/",
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return HomePage();
            },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: "/",
                    builder: (context, state) {
                      return HomePage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: "/profile",
                        builder: (context, state) {
                          return SelfProfilePage();
                        }
                      ),
                      GoRoute(
                        path: "/profile/:id",
                        builder: (context, state) {
                          return OtherProfilePage();
                        }
                      ),
                      GoRoute(
                        path: "/chat",
                        builder: (context, state) {
                          return ChatPage();
                        }
                      ),
                    ]
                  ),
                  GoRoute(
                    path: "/create-post",
                    builder: (context, state) {
                      return CreatePostPage();
                    }
                  ),
                  GoRoute(
                    path: "/chat",
                    builder: (context, state) {
                      return ChatPage();
                    }
                  ),
                ]
              )
            ]
          )
        ],
      ),
    );
  }

}
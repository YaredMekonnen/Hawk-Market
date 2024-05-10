import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/commons/utils/chopper_client.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:hawk_app/home/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:hawk_app/profile/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:hawk_app/profile/blocs/posted_product_bloc/posted_bloc.dart';
import 'package:hawk_app/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:hawk_app/profile/service/profile.service.dart';
import 'package:hawk_app/route/route.dart';
import 'package:hawk_app/theme/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AppChopperClient(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(context
              .read<AppChopperClient>()
              .getChopperService<AuthChopperService>()),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(context
              .read<AppChopperClient>()
              .getChopperService<ProductChooperService>()),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(context
              .read<AppChopperClient>()
              .getChopperService<ProfileChooperService>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) { 
              AuthCubit authCubit = AuthCubit(context.read<AuthRepository>())..checkAuthentication();
              context.read<AppChopperClient>().authCubit = authCubit;
              return authCubit;
            }
          ),
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(context.read<AuthRepository>()),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(context.read<AuthRepository>()),
          ),
          BlocProvider<CreateProductBloc>(
            create: (context) =>
                CreateProductBloc(context.read<ProductRepository>()),
          ),
          BlocProvider<ProductListBloc>(
            create: (context) =>
                ProductListBloc(context.read<ProductRepository>()),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
          ),
          BlocProvider<PostedBloc>(
            create: (context) => PostedBloc(context.read<ProductRepository>()),
          ),
          BlocProvider<BookmarkBloc>(
            create: (context) =>
                BookmarkBloc(context.read<ProfileRepository>()),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (context) =>
                ForgotPasswordBloc(context.read<AuthRepository>()),
          )
        ],
        child: RepositoryProvider(
          create: (context) => AppRouter(context.read<AuthCubit>()),
          child: ResponsiveSizer(builder: (context, orientation, deviceType) {
            return MaterialApp.router(
              title: "Hawk",
              theme: ThemeClass.lightTheme,
              routerConfig: context.read<AppRouter>().router,
            );
          }),
        ),
      ),
    );
  }
}

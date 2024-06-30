import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:hawk_app/auth/repository/auth.repository.dart';
import 'package:hawk_app/auth/service/auth_service.dart';
import 'package:hawk_app/chat/blocs/chat/chat_bloc.dart';
import 'package:hawk_app/chat/blocs/chats/chats_bloc.dart';
import 'package:hawk_app/chat/blocs/messages/messages_bloc.dart';
import 'package:hawk_app/chat/repository/chats.repository.dart';
import 'package:hawk_app/chat/service/chat_service.dart';
import 'package:hawk_app/chat/service/socket_service.dart';
import 'package:hawk_app/commons/utils/chopper_client.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:hawk_app/home/blocs/load_story_bloc/load_story_bloc.dart';
import 'package:hawk_app/home/blocs/product_detail_bloc/product_detail_bloc.dart';
import 'package:hawk_app/home/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:hawk_app/home/blocs/search_product_bloc/search_product_bloc.dart';
import 'package:hawk_app/home/repository/story.repository.dart';
import 'package:hawk_app/home/service/story.service.dart';
import 'package:hawk_app/payment/blocs/payment_bloc/payment_bloc.dart';
import 'package:hawk_app/payment/repository/payment.repository.dart';
import 'package:hawk_app/payment/service/payment_service.dart';
import 'package:hawk_app/profile/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:hawk_app/profile/blocs/edit_profile_bloc/profile_bloc.dart';
import 'package:hawk_app/profile/blocs/load_profile/load_profile_bloc.dart';
import 'package:hawk_app/profile/blocs/load_user_story_bloc/load_user_story_bloc.dart';
import 'package:hawk_app/profile/blocs/posted_product_bloc/posted_bloc.dart';
import 'package:hawk_app/profile/repository/profile.repository.dart';
import 'package:hawk_app/profile/service/profile.service.dart';
import 'package:hawk_app/route/route.dart';
import 'package:hawk_app/theme/theme.dart';
import 'package:hawk_app/theme/theme_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51PNgiHFTsTcgokVBOGyf2yQl1Q7O9kDjaBoDcbidteLlLp8FZWNuWJxHseuR1D4FrsWnAPV9x7Gsw5o957EvXnwU00Modtb26e';
  await Stripe.instance.applySettings();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepository(context
              .read<AppChopperClient>()
              .getChopperService<ChatChopperService>()),
        ),
        RepositoryProvider<StoryRepository>(
            create: (context) => StoryRepository(context
                .read<AppChopperClient>()
                .getChopperService<StoryChooperService>())),
        RepositoryProvider<PaymentRepository>(
            create: (context) => PaymentRepository(context
                .read<AppChopperClient>()
                .getChopperService<PaymentChopperService>()))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) {
            AuthCubit authCubit = AuthCubit(context.read<AuthRepository>())
              ..checkAuthentication();
            context.read<AppChopperClient>().authCubit = authCubit;
            return authCubit;
          }),
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
          BlocProvider(
              create: (context) =>
                  LoadStoryBloc(context.read<StoryRepository>())),
          BlocProvider(
              create: (context) =>
                  LoadUserStoryBloc(context.read<StoryRepository>())),
          BlocProvider(
              create: (context) =>
                  ProductDetailBloc(context.read<ProductRepository>())),
          BlocProvider(
              create: (context) =>
                  SearchProductBloc(context.read<ProductRepository>())),
          BlocProvider<LoadProfileBloc>(
            create: (context) =>
                LoadProfileBloc(context.read<ProfileRepository>()),
          ),
          BlocProvider<UpdateProfileBloc>(
            create: (context) =>
                UpdateProfileBloc(context.read<ProfileRepository>()),
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
          ),
          BlocProvider<ChatsBloc>(
            create: (context) => ChatsBloc(context.read<ChatRepository>()),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(context.read<ChatRepository>()),
          ),
          BlocProvider<MessagesBloc>(
            create: (context) => MessagesBloc(context.read<ChatRepository>()),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(context.read<PaymentRepository>()),
          ),
        ],
        child: RepositoryProvider(
          create: (context) => SocketService(
              authCubit: context.read<AuthCubit>(),
              chatBloc: context.read<ChatBloc>(),
              chatsBloc: context.read<ChatsBloc>(),
              messagesBloc: context.read<MessagesBloc>()),
          child: RepositoryProvider(
            create: (context) => AppRouter(
                context.read<AuthCubit>(), context.read<SocketService>()),
            child: ResponsiveSizer(
              builder: (context, orientation, deviceType) {
                return MaterialApp.router(
                  builder: FToastBuilder(),
                  debugShowCheckedModeBanner: false,
                  title: "Hawk",
                  theme: ThemeClass.lightTheme,
                  darkTheme: ThemeClass.darkTheme,
                  themeMode: themeProvider.themeMode,
                  routerConfig: context.read<AppRouter>().router,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

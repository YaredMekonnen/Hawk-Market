import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 85.h,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hawk Market',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10.w,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90.w,
                      ),
                      Text("Welcome back,"),
                      Text("Sign in to your account.")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomeTextField(
                        hintText: "Email",
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                        hintText: "Password",
                        controller: passwordController,
                      ),
                      TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/forgot-password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ))
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<SignInBloc>(context).add(SignIn(
                          email: emailController.text,
                          password: passwordController.text));
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith(
                          (states) => Size(90.w, 13.w)),
                    ),
                    child: BlocBuilder<SignInBloc, SignInState>(
                      builder: (context, state) {
                        if (state is SigningIn) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.background,
                            strokeWidth: 1.w,
                          );
                        }
                        if (state is SignInFailed) {
                          return Text(
                            'Error',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        if (state is SignInSuccess) {
                          context.read<AuthCubit>().checkAuthentication();
                          return Text(
                          'Success',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        );
                        }
                        return Text(
                          'Login',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith(
                                  (states) => EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 0.w)),
                              minimumSize: MaterialStateProperty.resolveWith(
                                  (states) => Size(0, 0))),
                          onPressed: (){
                            GoRouter.of(context).go('/signup');
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 4.w),
                          ))
                    ],
                  )
                ]),
          ),
        ));
  }
}

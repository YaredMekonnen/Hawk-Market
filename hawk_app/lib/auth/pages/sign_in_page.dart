import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _formKey = GlobalKey<FormState>();

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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hawk Market',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10.w,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 90.w,
                ),
                Text(
                  "Welcome back,",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text("Sign in to your account.")
              ],
            ),
            SizedBox(
              height: 15.w,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomeTextField(
                    hintText: "Email",
                    controller: emailController,
                    validator: emailValidator,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CustomeTextField(
                    hintText: "Password",
                    controller: passwordController,
                    password: true,
                    validator: passwordValidator,
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
            ),
            SizedBox(
              height: 10.w,
            ),
            BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                if (state is SignInSuccess) {
                  context.read<AuthCubit>().checkAuthentication();
                }
                return ElevatedButton(
                  onPressed: state is SignInSuccess || state is SigningIn
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInBloc>().add(SignIn(
                                email: emailController.text,
                                password: passwordController.text));
                          }
                        },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(90.w, 13.w)),
                  ),
                  child: state is SigningIn
                      ? ButtonProgress()
                      : state is SignInFailed
                          ? const ButtonText(text: 'Error')
                          : state is SignInSuccess
                              ? const ButtonText(text: 'Success')
                              : const ButtonText(text: 'Login'),
                );
              },
            ),
            SizedBox(
              height: 10.w,
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
                        padding: MaterialStateProperty.resolveWith((states) =>
                            EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 0.w)),
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => const Size(0, 0))),
                    onPressed: () {
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
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            GoRouter.of(context).go('/login');
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
                Column(
                  children: [
                    Image(
                      image: AssetImage('assets/forgot.png'),
                      width: 90.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      'Don’t worry it happens. Please enter the email address associated with your account.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    CustomeTextField(
                      hintText: "Email",
                      controller: emailController,
                      validator: emailValidator,
                    ),
                  ],
                ),
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ForgotPasswordLoading ||
                              state is ForgotPasswordSuccess
                          ? null
                          : () {
                              BlocProvider.of<ForgotPasswordBloc>(context).add(
                                  ForgotPassword(email: emailController.text));
                            },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => Size(90.w, 13.w)),
                      ),
                      child: state is ForgotPasswordLoading
                          ? ButtonProgress()
                          : state is ForgotPasswordFailed
                              ? const ButtonText(text: 'Error')
                              : state is ForgotPasswordSuccess
                                  ? TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).go('/verify-otp');
                                      },
                                      child: const ButtonText(
                                          text: 'Success! Tap'))
                                  : const ButtonText(text: 'Send Code'),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

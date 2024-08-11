import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import "package:responsive_sizer/responsive_sizer.dart";

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            GoRouter.of(context).go('/verify-email');
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 100.w,
          height: 85.h,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90.w,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/reset-password.png'),
                        width: 90.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Text(
                        'Please enter a secure password that you can easily remember.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                        hintText: "New Password",
                        controller: newPasswordController,
                        validator: passwordValidator,
                        password: true,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ResetPasswordLoading ||
                              state is ResetPasswordSuccess
                          ? null
                          : () {
                              BlocProvider.of<ForgotPasswordBloc>(context).add(
                                  ResetPassword(
                                      password: newPasswordController.text));
                            },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => Size(90.w, 13.w)),
                      ),
                      child: state is ResetPasswordLoading
                          ? ButtonProgress()
                          : state is ResetPasswordFailed
                              ? const ButtonText(text: 'Error')
                              : state is ResetPasswordSuccess
                                  ? TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).go('/login');
                                      },
                                      child: const ButtonText(
                                        text: 'Success! Tap',
                                      ),
                                    )
                                  : const ButtonText(
                                      text: 'Reset Password',
                                    ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

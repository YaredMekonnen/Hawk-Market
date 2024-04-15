import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
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
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            GoRouter.of(context).go('/verify-email');
          },
        ),
        backgroundColor: Colors.transparent,
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
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4.w,),
                    Text(
                      'Please enter a secure password that you can easily remember.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.w,),
                    CustomeTextField(hintText: "Old Password", controller: oldPasswordController),
                    SizedBox(
                      height: 4.w,
                    ),
                    CustomeTextField(hintText: "New Password", controller: newPasswordController),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: ()=>{
                  BlocProvider.of<ForgotPasswordBloc>(context).add(ResetPassword(password: newPasswordController.text))
                }, 
                child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                        if (state is ResetPasswordLoading) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.background,
                            strokeWidth: 1.w,
                          );
                        }
                        if (state is ResetPasswordFailed) {
                          return Text(
                            'Error',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        if (state is ResetPasswordSuccess) {
                          GoRouter.of(context).go('/login');
                          return Text(
                          'Success',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        );
                        }
                        return Text(
                          'Verify',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        );
                      },
                    ),
                style: ButtonStyle(

                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.w, 13.w)),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 85.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/forgot.png'),
                width: 90.w,
                fit: BoxFit.contain,
              ),
              Column(
                children: [
                  Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 4.w,),
                  Text(
                    'Don’t worry it happens. Please enter the email address associated with your account.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomeTextField(hintText: "Email"),
                ],
              ),
              ElevatedButton(
                onPressed: (){
                  GoRouter.of(context).go('/reset-password');
                }, 
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background
                  ),
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
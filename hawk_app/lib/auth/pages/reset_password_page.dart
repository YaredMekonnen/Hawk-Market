import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/textfield.dart';
import "package:responsive_sizer/responsive_sizer.dart";

class ResetPasswordPage extends StatefulWidget {
  
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              Image(
                image: AssetImage('assets/reset-password.png'),
                width: 90.w,
                fit: BoxFit.contain,
              ),
              Container(
                width: 90.w,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomeTextField(hintText: "Old Password"),
                  SizedBox(
                    height: 4.w,
                  ),
                  CustomeTextField(hintText: "New Password")
                ],
              ),
          
              ElevatedButton(
                onPressed: ()=>{}, 
                child: Text(
                  'Set Password',
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
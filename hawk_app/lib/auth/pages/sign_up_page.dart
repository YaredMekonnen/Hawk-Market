import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatefulWidget {
  
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                'Sign Up',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Hawk Market',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10.w,
                  fontWeight: FontWeight.bold
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomeTextField(hintText: "Email"),
                  SizedBox(
                    height: 4.w,
                  ),
                  CustomeTextField(hintText: "Username"),
                  SizedBox(
                    height: 4.w,
                  ),
                  CustomeTextField(hintText: "Password")
                ],
              ),
          
              ElevatedButton(
                onPressed: ()=>{}, 
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background
                  ),
                ),
                style: ButtonStyle(

                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.w, 13.w)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You already have an account?',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w)),
                      minimumSize: MaterialStateProperty.resolveWith((states) => Size(0, 0))
                    ),
                    onPressed: ()=>{
                      GoRouter.of(context).go('/login')
                    }, 
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 4.w
                      ),
                      
                    )
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }
}
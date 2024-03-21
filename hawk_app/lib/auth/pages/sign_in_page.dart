import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInPage extends StatefulWidget {
  
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hawk Market',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            width: 100.w,
            height: 100.w,
            child: Column(
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Sign in to your account',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ]
            ),
          ),
          Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              TextButton(
                onPressed:()=>{} , 
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              )
            ],
          ),

          ElevatedButton(
            onPressed: ()=>{}, 
            child: Text('Login')
          ),
          Row(
            children: [
              Text(
                'Don\'t have an account?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: ()=>{}, 
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              )
            ],
          )
        ]
      )
    );
  }
}
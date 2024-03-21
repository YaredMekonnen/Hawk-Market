import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatefulWidget {
  
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),

          ElevatedButton(
            onPressed: ()=>{}, 
            child: Text('Sign Up')
          ),
          Row(
            children: [
              Text(
                'You already have an account?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: ()=>{}, 
                child: Text(
                  'Login',
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
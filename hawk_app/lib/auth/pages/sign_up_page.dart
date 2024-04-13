import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomeTextField(
                          hintText: "Email", controller: emailController),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                          hintText: "Name", controller: nameController),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                          hintText: "Password", controller: passwordController)
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<SignUpBloc>(context).add(SignUp(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text));
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith(
                          (states) => Size(90.w, 13.w)),
                    ),
                    child: BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        if (state is SigningIn) {
                          return CircularProgressIndicator();
                        }
                        if (state is SignUpFailed) {
                          return Text(
                            'Error',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        if (state is SignUpSuccess) {
                          return Text(
                            'Success',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        return Text(
                          'Sign Up',
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
                        'You already have an account?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith(
                                  (states) => EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 0.w)),
                              minimumSize: MaterialStateProperty.resolveWith(
                                  (states) => Size(0, 0))),
                          onPressed: () => {GoRouter.of(context).go('/login')},
                          child: Text(
                            'Login',
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

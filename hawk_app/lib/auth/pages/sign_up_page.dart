import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:hawk_app/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool visible = false;

  XFile? _image = null;

  pickImage() async {
    _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                  SizedBox(
                    height: 2.w,
                  ),
                  _image != null
                      ? Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.w),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_image!.path)),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: IconButton(
                                iconSize: 10.w,
                                onPressed: pickImage,
                                color: Theme.of(context).colorScheme.background,
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            SizedBox(
                              height: 2.w,
                            ),
                            Text(
                              'Profile Picture(optional)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            )
                          ],
                        ),
                ],
              ),
              SizedBox(
                height: 7.w,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomeTextField(
                      hintText: "Username",
                      controller: nameController,
                      validator: textValidator,
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
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
                    SizedBox(
                      height: 4.w,
                    ),
                    Stack(alignment: Alignment.centerRight, children: [
                      TextFormField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        obscureText: !visible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          return confirmPasswordValidator(
                              value, passwordController.text);
                        },
                        controller: confirmPasswordController,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                            constraints: BoxConstraints(maxWidth: 90.w),
                            label: const Text('Confirm Password'),
                            hintText: "Confirm Password",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.w)),
                            alignLabelWithHint: true),
                      ),
                      IconButton(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                        iconSize: 6.w,
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          setState(() {
                            visible = !visible;
                          });
                        },
                      )
                    ]),
                    SizedBox(
                      height: 4.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 7.w,
              ),
              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is SigningUp || state is SignUpSuccess
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<SignUpBloc>(context).add(
                                SignUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  username: nameController.text,
                                  image: _image,
                                ),
                              );
                            }
                          },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith(
                          (states) => Size(90.w, 13.w)),
                    ),
                    child: state is SigningUp
                        ? ButtonProgress()
                        : state is SignUpFailed
                            ? ButtonText(text: "Failed! Retry")
                            : state is SignUpSuccess
                                ? TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go('/login');
                                    },
                                    child: ButtonText(text: "Success! Tap"),
                                  )
                                : ButtonText(text: "Sign Up"),
                  );
                },
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
                        padding: MaterialStateProperty.resolveWith((states) =>
                            EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 0.w)),
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => Size(0, 0))),
                    onPressed: () => {GoRouter.of(context).go('/login')},
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 4.w),
                    ),
                  )
                ],
              )
            ]),
      ),
    );
  }
}

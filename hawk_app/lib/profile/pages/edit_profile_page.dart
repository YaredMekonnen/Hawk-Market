import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:hawk_app/profile/blocs/edit_profile_bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  EditProfilePage({required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 85.h,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: _image != null
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
                          : widget.user.profileUrl != ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5.w),
                                  child: CustomeNetworkImage(
                                      imageUrl: widget.user.profileUrl),
                                )
                              : Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/avatar/profile.jpg'),
                                    ),
                                  ),
                                ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Icon(
                            size: 7.w,
                            Icons.photo_camera_outlined,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomeTextField(
                        hintText: "Username",
                        controller: usernameController,
                        validator: textValidator,
                        value: widget.user.username,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                        hintText: "Bio",
                        controller: bioController,
                        validator: textValidator,
                        value: widget.user.bio,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      CustomeTextField(
                        hintText: "New Password",
                        controller: passwordController,
                        password: true,
                        validator: passwordValidator,
                      )
                    ],
                  ),
                  BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: UpdateProfileState is UpdateProfileSuccess ||
                                state is UpdateProfileLoading
                            ? null
                            : () {
                                BlocProvider.of<UpdateProfileBloc>(context).add(
                                  UpdateProfile(
                                    id: widget.user.id,
                                    bio: bioController.text,
                                    username: usernameController.text,
                                    image: _image,
                                  ),
                                );
                              },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith(
                              (states) => Size(90.w, 13.w)),
                        ),
                        child: state is UpdateProfileLoading
                            ? ButtonProgress()
                            : state is UpdateProfileFailure
                                ? const ButtonText(text: 'Error')
                                : state is UpdateProfileSuccess
                                    ? const ButtonText(text: 'Success')
                                    : const ButtonText(text: 'Save Changes'),
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

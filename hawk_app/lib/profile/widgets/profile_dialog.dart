import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:hawk_app/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileDialog extends StatefulWidget {
  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  User user = User.fromJson({
    "bio": "",
    "bookmarks": [],
    "_id": "661a8ff309f2058c0ff25822",
    "name": "Leul",
    "email": "leulabay1@gmail.com",
    "password": "123456",
    "createdAt": "2024-04-13T14:00:19.438Z",
    "updatedAt": "2024-04-27T12:08:10.451Z",
    "firstName": "Leul",
    "lastName": "Abay",
    "profileUrl":
        "https://res.cloudinary.com/dsk2pubrq/image/upload/v1713617471/gyfe3tfztfuvw24uscds.jpg"
  });

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  XFile? _image = null;

  pickImage() async {
    _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: const Key("profile dialog"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -15.w,
              child: Stack(children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.8.w,
                    ),
                  ),
                  child: _image == null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.profileUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                constraints: BoxConstraints(
                                    maxHeight: 10.w, maxWidth: 10.w),
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  strokeWidth: 1.w,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          radius: 15.w,
                          backgroundImage: FileImage(File(_image!.path))),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        onPressed: pickImage,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.all(5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15.w),
                  CustomeTextField(
                    hintText: 'First Name',
                    controller: firstNameController,
                    value: user.firstName,
                  ),
                  SizedBox(height: 5.w),
                  CustomeTextField(
                    hintText: 'Last Name',
                    controller: lastNameController,
                    value: user.lastName,
                  ),
                  SizedBox(height: 5.w),
                  CustomeTextField(
                    hintText: 'Bio',
                    controller: bioController,
                    value: user.bio,
                    lines: 3,
                  ),
                  SizedBox(height: 5.w),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(UpdateProfile(
                          bio: bioController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          id: user.id,
                          image: _image));
                    },
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoading){
                          return CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,);
                        }
                        if (state is ProfileFailure ) {
                          return Text('Failed');
                        }
                        if (state is ProfileSuccess) {
                          return Text('Success');
                        }
                        return Text("Save");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

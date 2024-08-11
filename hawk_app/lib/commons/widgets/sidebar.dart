import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart";
import "package:hawk_app/auth/blocs/sign_in_bloc/sign_in_bloc.dart";
import "package:hawk_app/auth/blocs/sign_up_bloc/sign_up_bloc.dart";
import "package:hawk_app/auth/models/user.dart";
import "package:hawk_app/auth/repository/auth.repository.dart";
import "package:hawk_app/commons/widgets/custom_network_image.dart";
import "package:hawk_app/commons/widgets/sidebar-rows.dart";
import "package:hawk_app/theme/theme_provider.dart";
import "package:provider/provider.dart";
import "package:responsive_sizer/responsive_sizer.dart";

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthCubit>().user!;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return (Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h, bottom: 2.h),
            child: ListTile(
              leading: Container(
                width: 15.w,
                height: 15.w,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: user.profileUrl != ""
                    ? CustomeNetworkImage(imageUrl: user.profileUrl)
                    : Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.w),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/avatar/profile.jpg'),
                          ),
                        ),
                      ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  Text(
                    user.bio,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SidebarRow(Icons.notifications_outlined, 'Notifications'),
                  SidebarRow(Icons.pending_outlined, "Pending Payment"),
                  SidebarRow(Icons.history_outlined, 'Payment History'),
                  SidebarRow(Icons.bookmark_outline, 'Bookmarked Items'),
                  SidebarRow(Icons.sell_outlined, 'Your Items'),
                  SidebarRow(Icons.wallet, 'Payment Methods'),
                  SidebarRow(Icons.settings_outlined, 'Settings'),
                  SidebarRow(Icons.error_outline, 'About Us'),
                  SidebarRow(Icons.phone_outlined, 'Support'),
                ],
              ),
            ),
          ),
          Container(
            width: 50.w,
            margin: EdgeInsets.symmetric(vertical: 2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    themeProvider.saveTheme('light');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      color: themeProvider.themeMode == ThemeMode.light
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.light_mode,
                          size: 5.w,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: 1.6.w,
                        ),
                        Text(
                          'Light',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    themeProvider.saveTheme('dark');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dark_mode_outlined,
                          color: Theme.of(context).colorScheme.background,
                          size: 5.w,
                        ),
                        SizedBox(
                          width: 1.6.w,
                        ),
                        Text(
                          'Dark',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            thickness: 0.1.w,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SignUpBloc>().add(CloseSignUp());
              context.read<SignInBloc>().add(CloseSignIn());
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
                maximumSize: Size(40.w, 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.w),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0.5.w,
                )),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.secondary,
                size: 6.w,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                "Logout",
                style: Theme.of(context).textTheme.titleMedium,
              )
            ]),
          ),
          SizedBox(
            height: 4.w,
          ),
        ],
      ),
    ));
  }
}

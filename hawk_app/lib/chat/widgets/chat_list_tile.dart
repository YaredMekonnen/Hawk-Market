import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/commons/constants/message_type.dart';
import 'package:hawk_app/commons/utils/some_time_ago.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatListTile extends StatefulWidget {
  final Chat chat;
  ChatListTile({
    required this.chat,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthCubit>().user!;
  }

  @override
  Widget build(BuildContext context) {
    User otherOwner =
        widget.chat.owners.firstWhere((element) => element.id != user.id);

    return InkWell(
      onTap: () {
        GoRouter.of(context).go(
            '/chat/${widget.chat.id}?userId=${user.id}&otherUserId=${otherOwner.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              5.w,
            ),
          ),
        ),
        padding: EdgeInsets.all(1.w),
        margin: EdgeInsets.all(1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoudndedSquareProfile(
              profileUrl: otherOwner.profileUrl,
              length: 16,
            ),
            SizedBox(
              width: 2.w,
            ),
            SizedBox(
              width: 70.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherOwner.username,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Text(
                            widget.chat.messages[0].type ==
                                    MessageType.image.name
                                ? '🖼 photo'
                                : widget.chat.messages[0].text,
                            style: TextStyle(
                              color: Color.fromARGB(255, 168, 168, 168),
                              fontSize: 3.6.w,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      SizedBox(
                        height: 1.6.w,
                      )
                    ],
                  ),
                  widget.chat.numberOfUnread[user.id] != null &&
                          widget.chat.numberOfUnread[user.id]! > 0
                      ? Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                1.3.w,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.chat.numberOfUnread[user.id]!.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: 3.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 20.w,
                          child: Text(
                            getTimeAgo(widget.chat.messages[0].createdAt),
                            style: TextStyle(
                              color: Color.fromARGB(255, 168, 168, 168),
                              fontSize: 3.w,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/chat/blocs/chat/chat_bloc.dart';
import 'package:hawk_app/chat/blocs/messages/messages_bloc.dart';
import 'package:hawk_app/chat/models/message.dart';
import 'package:hawk_app/chat/service/socket_service.dart';
import 'package:hawk_app/commons/constants/message_type.dart';
import 'package:hawk_app/commons/utils/some_time_ago.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userId;
  final String otherUserId;

  ChatPage(
      {required this.chatId, required this.userId, required this.otherUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller;
  late ScrollController _textEditorScrollController;
  late ScrollController _messageScrollController;
  late bool _emojiShowing;
  bool dialogShowing = false;
  List<XFile> _imageList = [];

  pickImage() async {
    _imageList = await ImagePicker().pickMultiImage();
    setState(() {
      _imageList = _imageList;
    });
  }

  removeImage(int index) {
    setState(() {
      if (_imageList.length == 1) {
        Navigator.pop(context);
        dialogShowing = false;
      }
      _imageList.removeAt(index);
    });
  }

  void _onScroll() {
    if (_messageScrollController.position.pixels >=
        _messageScrollController.position.maxScrollExtent - 100) {
      context.read<MessagesBloc>().add(LoadMoreMessages(userId: widget.userId));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _textEditorScrollController = ScrollController();
    _messageScrollController = ScrollController();
    _emojiShowing = false;
    _messageScrollController.addListener(_onScroll);

    if (widget.chatId != '-1') {
      context
          .read<ChatBloc>()
          .add(LoadChat(widget.chatId, widget.userId, widget.otherUserId));
    } else {
      context
          .read<ChatBloc>()
          .add(LoadChatWithUserIds(widget.userId, widget.otherUserId));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _textEditorScrollController.dispose();
    _messageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (_imageList.isNotEmpty && !dialogShowing) {
        imageDialog(context);
        dialogShowing = true;
      }
    });
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatError) {
          return const Center(
            child: Text('Error while loading chat'),
          );
        }
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewChatLoaded) {
          return _buildChatPage(context, state.otherOwner, '-1');
        }
        if (state is ChatLoaded) {
          return _buildChatPage(context, state.otherOwner, state.chat.id);
        }

        return Container();
      },
    );
  }

  Widget _buildChatPage(BuildContext context, User otherOwner, String chatId) {
    if (chatId != '-1') {
      context
          .read<MessagesBloc>()
          .add(LoadMessages(chatId: chatId, userId: widget.userId));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 100.w,
        leading: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 0.1.w,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  RoudndedSquareProfile(
                    profileUrl: otherOwner.profileUrl,
                    length: 13,
                  ),
                  SizedBox(
                    width: 2.5.w,
                  ),
                  Text(otherOwner.username,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            overflow: TextOverflow.ellipsis,
                          )),
                ],
              ),
              PopupMenuButton(
                  iconColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.background,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          child: Row(children: [
                        Icon(
                          Icons.search,
                          size: 5.5.w,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Search",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 4.5.w,
                                  ),
                        )
                      ])),
                      PopupMenuItem(
                          child: Row(children: [
                        Icon(
                          Icons.block,
                          size: 5.5.w,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Block",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 4.5.w,
                                  ),
                        )
                      ]))
                    ];
                  })
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is MessageLoadingFaild) {
                  return const Center(
                    child: Text('Error while loading messages'),
                  );
                }
                context.read<SocketService>().readMessage(chatId: chatId);
                List<Message> messages = context.read<MessagesBloc>().messages;

                return ListView.separated(
                  controller: _messageScrollController,
                  padding: EdgeInsets.only(bottom: 2.5.w),
                  reverse: true,
                  itemBuilder: (context, index) {
                    if (messages[index].type == MessageType.image.name &&
                        messages[index].senderId == widget.userId) {
                      return _imageMessageBuilder(context, messages[index]);
                    } else if (messages[index].type == MessageType.image.name &&
                        messages[index].senderId != widget.userId) {
                      return _otherImageMessageBuilder(
                          context, messages[index]);
                    } else if (messages[index].type == MessageType.text.name &&
                        messages[index].senderId == widget.userId) {
                      return _messageBuilder(context, messages[index]);
                    } else if (messages[index].type == MessageType.text.name &&
                        messages[index].senderId != widget.userId) {
                      return _otherMesageBuilder(context, messages[index]);
                    }
                    return SizedBox(
                      width: 100.w,
                    );
                  },
                  separatorBuilder: (context, idx) {
                    return SizedBox(
                      height: 2.5.w,
                    );
                  },
                  itemCount: messages.length,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 2.5.w, left: 2.5.w, right: 2.5.w),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(7.w)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    controller: _controller,
                    scrollController: _textEditorScrollController,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 4.5.w,
                        color: Theme.of(context).colorScheme.background),
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      focusColor: Theme.of(context).colorScheme.background,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              fontSize: 4.5.w,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.7)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      constraints: BoxConstraints(maxWidth: 66.w),
                      contentPadding: EdgeInsets.only(left: 4.w),
                    ),
                  ),
                  Container(
                    width: 8.w,
                    margin: EdgeInsets.only(right: 1.w),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: chatId != "-1"
                          ? () {
                              pickImage();
                            }
                          : null,
                      icon: const Icon(Icons.photo_outlined),
                      iconSize: 8.w,
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.7),
                    ),
                  ),
                  Container(
                    width: 8.w,
                    margin: EdgeInsets.only(right: 1.w),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          _emojiShowing = !_emojiShowing;
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      iconSize: 8.w,
                      color: _emojiShowing
                          ? Colors.blue
                          : Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        if (chatId == '-1') {
                          context.read<SocketService>().createChat(
                              recieverId: otherOwner.id,
                              text: _controller.text);
                        } else {
                          context.read<SocketService>().sendMessage(
                              chatId: chatId, text: _controller.text);
                        }
                        _controller.clear();
                      },
                      icon: const Icon(Icons.send),
                      iconSize: 8.w,
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !_emojiShowing,
            child: EmojiPicker(
              textEditingController: _controller,
              scrollController: _textEditorScrollController,
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                swapCategoryAndBottomBar: false,
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: BottomActionBarConfig(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  buttonColor: Theme.of(context).colorScheme.secondary,
                  buttonIconColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.6),
                ),
                searchViewConfig: SearchViewConfig(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _messageBuilder(BuildContext context, Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.only(right: 5.w),
              constraints: BoxConstraints(maxWidth: 75.w),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(255, 21, 134, 254),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5.w, top: 1.w),
              child: Text(
                getChatTime(message.createdAt),
                style: TextStyle(
                  color: const Color.fromARGB(255, 168, 168, 168),
                  fontSize: 3.w,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _otherMesageBuilder(BuildContext context, Message message) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.only(left: 5.w),
              constraints: BoxConstraints(maxWidth: 75.w),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(255, 49, 49, 49),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
              ),
              child: Text(
                  style: Theme.of(context).textTheme.bodyMedium, message.text),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.w, top: 1.w),
              child: Text(
                getChatTime(message.createdAt),
                style: TextStyle(
                  color: const Color.fromARGB(255, 168, 168, 168),
                  fontSize: 3.w,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _imageMessageBuilder(BuildContext context, Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(0.8.w),
              margin: EdgeInsets.only(right: 5.w),
              constraints: BoxConstraints(maxWidth: 75.w, maxHeight: 100.w),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(255, 21, 134, 254),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
              ),
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w),
                    ),
                  ),
                  child: CustomeNetworkImage(
                    imageUrl: message.image,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(right: 5.w, top: 1.w),
              child: Text(
                getChatTime(message.createdAt),
                style: TextStyle(
                  color: const Color.fromARGB(255, 168, 168, 168),
                  fontSize: 3.w,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _otherImageMessageBuilder(BuildContext context, Message message) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(0.8.w),
              margin: EdgeInsets.only(left: 5.w),
              constraints: BoxConstraints(maxWidth: 75.w, maxHeight: 100.w),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(255, 49, 49, 49),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3.w),
                    bottomRight: Radius.circular(3.w),
                    bottomLeft: Radius.circular(3.w),
                  ),
                ),
                child: CustomeNetworkImage(
                  imageUrl: message.image,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.w, top: 1.w),
              child: Text(
                getChatTime(message.createdAt),
                style: TextStyle(
                  color: const Color.fromARGB(255, 168, 168, 168),
                  fontSize: 3.w,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  imageDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        key: const Key("message dialog"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.w),
                    Container(
                      height: 23.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 5.w),
                      constraints:
                          BoxConstraints(maxWidth: 100.w, maxHeight: 23.w),
                      child: _imageList.isNotEmpty
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Container(
                                  width: 20.w,
                                  height: 20.w,
                                  margin: EdgeInsets.all(0.8.w),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(_imageList[index].path)),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.w)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0.5.w,
                                        blurRadius: 1.w,
                                      ),
                                    ],
                                  ),
                                  child: Text('')),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 3.w),
                              itemCount: _imageList.length,
                            )
                          : Text('Select a Photo',
                              style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    SizedBox(height: 5.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              dialogShowing = false;
                              _imageList.clear();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.1)),
                            child: Text('Discard',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: const Color.fromARGB(
                                            255, 214, 70, 59),
                                        fontSize: 5.w))),
                        ElevatedButton(
                          onPressed: _imageList.isNotEmpty
                              ? () {
                                  context.read<MessagesBloc>().add(
                                      SendImagesMessage(
                                          senderId: widget.userId,
                                          chatId: widget.chatId,
                                          images: _imageList));
                                }
                              : null,
                          child: BlocBuilder<MessagesBloc, MessagesState>(
                            builder: (context, state) {
                              if (state is ImageMessageLoading) {
                                return ButtonProgress();
                              }
                              if (state is MessageSendingFaild) {
                                return const ButtonText(text: 'Error');
                              }
                              if (state is ImageMessageLoaded) {
                                context.read<SocketService>().sendImagesMessage(
                                    state.messages,
                                    widget.otherUserId,
                                    widget.chatId);
                                Navigator.pop(context);
                                dialogShowing = false;
                                _imageList.clear();
                                return const ButtonText(text: 'Success');
                              }
                              return ButtonText(text: 'Send');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

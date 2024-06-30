import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/chat/blocs/chats/chats_bloc.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/chat/widgets/chat_list_tile.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatsBloc>().add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 6.5.w,
              ),
        ),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ChatsError) {
            return Center(
              child: Column(
                children: [
                  Text('Error while loading chats'),
                  ElevatedButton(
                      onPressed: () {
                        context.read<ChatsBloc>().add(LoadChats());
                      },
                      child: const ButtonText(text: "Reload"))
                ],
              ),
            );
          }

          List<Chat> chats = context.read<ChatsBloc>().chats;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ChatListTile(chat: chats[index]);
            },
          );
        },
      ),
    );
  }
}

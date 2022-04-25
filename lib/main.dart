
import 'package:chatapp/app.dart';
import 'package:chatapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';


void main() {
  final client  = StreamChatClient(streamkey);
  runApp(MyApp(client: client,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);

  final StreamChatClient client;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Home',
      theme: AppTheme.light(),
      //darkTheme: AppTheme.dark(),
      //themeMode: ThemeMode.dark,
      builder: (context,child){
          return StreamChatCore(
            client: client,
            child: ChannelsBloc
            (child: UsersBloc
            (child: child!)),
          );
      },
      home: const SelectUserScreen(),

    );
  }
}


import 'dart:async';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {

  final int conversationID;
  final int index;
  const ChatScreen({this.conversationID, this.index});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  bool _isLoggedIn;
  StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Text("chat Screen"),
      ),
    );
  }
}

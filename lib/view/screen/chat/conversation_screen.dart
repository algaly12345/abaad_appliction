
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: Center(
        child: Text("conversion Screen"),
      ),
    );
  }
  }


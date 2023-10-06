import 'package:flutter/material.dart';

import '../chat/chat_bottom_sheet.dart';

class AppDetailShell extends StatefulWidget {
  final Widget body;
  final String title;

  const AppDetailShell({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  State<AppDetailShell> createState() => _AppDetailShellState();
}

class _AppDetailShellState extends State<AppDetailShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBottomSheetOpen = false;
  late final ChatBottomSheet _chatBottomSheet;

  @override
  void initState() {
    super.initState();
    _chatBottomSheet = ChatBottomSheet(
      context: context,
      scaffoldKey: _scaffoldKey,
      onSheetClosed: _handleSheetClosed,
    );
  }

  void _handleSheetClosed() {
    setState(() {
      _isBottomSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.body,
      floatingActionButton: !_isBottomSheetOpen
          ? FloatingActionButton(
              onPressed: () {
                _chatBottomSheet.show(name: widget.title);
                setState(() {
                  _isBottomSheetOpen = true;
                });
              },
              child: const Icon(Icons.chat),
            )
          : null,
    );
  }
}

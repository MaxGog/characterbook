import 'package:flutter/material.dart';

class BaseEditPageScaffold extends StatelessWidget {
  final Widget appBar;
  final Widget body;
  final Future<bool> Function()? onWillPop;

  const BaseEditPageScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBar as PreferredSizeWidget?,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: body,
        ),
      ),
    );
  }
}
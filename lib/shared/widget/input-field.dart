import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class InputField extends StatefulWidget {
  InputField({Key key, this.label, this.onChanged, this.validator}) : super(key: key);

  final String label;
  final void Function(String) onChanged;
  final String Function(String) validator;

  @override
  _InputFieldState createState() => _InputFieldState(
    label: label);
}

class _InputFieldState extends State<InputField> {

  String label;
  final TextEditingController controller = TextEditingController();

  _InputFieldState({
    this.label
  });

  void onChange() {
    String text = controller.text;
    widget.onChanged(text);
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onChange);
  }

  @override
  void dispose() {
    controller.removeListener(onChange);
    controller.dispose();
    super.dispose();
  }

  Widget buildError() {
    String e;

    if (widget.validator != null) {
      e = widget.validator(controller.text);
      if (e == null) {
        return null;
      }
    }

    final w = Text(
      e,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.destructiveRed,
      ),
    );
    return w;
  }

  @override
  Widget build(BuildContext context) {
    Widget txt = CupertinoTextField(
      controller: controller,
      placeholder: label,
      clearButtonMode: OverlayVisibilityMode.editing,
    );

    Widget err = buildError();

    if (err == null) {
      err = Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        txt,
        err,
      ],
    );
  }
}
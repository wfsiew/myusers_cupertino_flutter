import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (s) {
        if (widget.validator != null) {
          return widget.validator(s);
        }

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: _kDefaultRoundedBorderSide,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        labelText: label,
        suffixIcon: controller.text.isEmpty ? null : 
        IconButton(
          icon: Icon(CupertinoIcons.clear_thick_circled),
          onPressed: () async {
            await Future.delayed(Duration(milliseconds: 10));
            setState(() {
             controller.text = ''; 
            });
          },
        ),
        errorStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
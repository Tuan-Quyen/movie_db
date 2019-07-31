import 'package:flutter/material.dart';

class PasswordInputFieldWidget extends StatelessWidget {
  String Hintext;
  TextEditingController _passwordController;
  FocusNode _focusNode;

  PasswordInputFieldWidget(
      this.Hintext, this._passwordController, this._focusNode);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: new TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: Hintext,
            hintStyle: _focusNode.hasFocus
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
          ),
          focusNode: _focusNode,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          enabled: true,
        ),
      ),
    );
  }
}

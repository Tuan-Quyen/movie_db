import 'package:flutter/material.dart';
import 'package:movie_db/utils/string_utils.dart';

class EmailInputFieldWidget extends StatelessWidget {
  final TextEditingController _emailController;
  final FocusNode _focusNode;

  EmailInputFieldWidget(this._emailController, this._focusNode);

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
          decoration: InputDecoration(
            hintText: StringUtils.email,
            hintStyle: _focusNode.hasFocus?TextStyle(color: Colors.white):TextStyle(color: Colors.grey),
           focusedBorder: UnderlineInputBorder(
             borderSide: BorderSide(
               color: Colors.orange
             )
           )
          ),
          focusNode: _focusNode,
          controller: _emailController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          enabled: true,
        ),
      ),
    );
  }
}

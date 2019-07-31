import 'package:flutter/material.dart';
import 'package:movie_db/interface/onclick_listener.dart';
import 'package:movie_db/other/constant.dart';

class CustomDialog extends StatelessWidget {
  String title, message, buttonText;
  Image image;
  ConfirmListener listener;

  CustomDialog(
      {this.title, this.message, this.buttonText, this.image, this.listener});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Constant.avatarRadius,
            bottom: Constant.padding,
            left: Constant.padding,
            right: Constant.padding,
          ),
          margin: EdgeInsets.only(top: Constant.padding),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Constant.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              title.isNotEmpty
                  ? Text(
                      title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context);
                      if (listener != null) listener.onConfirmClick();
                    },
                    child: Text(buttonText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

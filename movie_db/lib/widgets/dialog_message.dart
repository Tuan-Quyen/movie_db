import 'package:flutter/material.dart';
import 'package:movie_db/interface/onclick_listener.dart';
import 'package:movie_db/utils/string_utils.dart';

import 'custom_dialog.dart';

class MessageDialog {
  information(BuildContext context, String title, String message,
      ConfirmListener listener) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
            title: title,
            message: message,
            buttonText: "Ok",
            listener: listener,
          ),
    );
  }
  connection(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: StringUtils.connectionError,
        message: StringUtils.messageConnectionError,
        buttonText: "Ok",
      ),
    );
  }
}

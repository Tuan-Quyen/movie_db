import 'package:flutter/material.dart';

class ProgressIndicator {

  Widget pageToDisplay(bool isLoading) {
    if (isLoading) {
      return _loadingView;
    }
  }

  // new
  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

}
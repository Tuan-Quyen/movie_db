import 'package:flutter/material.dart';

class LoadWidget {
  Widget buildLoadingWidget(context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Loading data from API...",
            style: Theme.of(context).textTheme.subtitle),
        Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ],
    ));
  }

  Widget buildErrorWidget(String error, context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error",
            style: TextStyle(color: Colors.red,fontSize: 20))
      ],
    ));
  }

  Widget buildLoadingMoreWidget(context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          )),
    );
  }
}

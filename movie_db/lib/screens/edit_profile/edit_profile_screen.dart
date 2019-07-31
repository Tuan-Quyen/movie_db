import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

import 'edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_EDIT_PROFILE;
  UserModel userModel;

  EditProfileScreen({this.userModel});

  @override
  _StateEditProfileScreen createState() => _StateEditProfileScreen();
}

class _StateEditProfileScreen extends State<EditProfileScreen> {
  final bloc = EditProfileBloc();

  var txtFullName = new TextEditingController();
  var txtEmail = new TextEditingController();

  // State Widget Life Cycle.
  @override
  void initState() {
    super.initState();
    bloc.getUser();
    txtEmail.text = widget.userModel.email;
    txtFullName.text = widget.userModel.userName;
  }

  @override
  void didUpdateWidget(EditProfileScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // other dispose methods
    bloc.dispose();

    txtFullName.dispose();
    txtEmail.dispose();

    super.dispose();
  }

  // Widget Screen.
  Container imageProfile() {
    return Container(
      height: 250,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Center(
        child: new Container(
          width: 130.0,
          height: 130.0,
          child: FlatButton(
            onPressed: () => ontapImageProfile(),
            padding: EdgeInsets.all(0.0),
            child: StreamBuilder(
                stream: bloc.image.stream,
                builder: (context, snapshot) {
                  return Container(
                    width: 130.0,
                    height: 130.0,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        image: snapshot.hasData
                            ? FileImage(snapshot.data)
                            : widget.userModel.profileImage != null
                                ? AdvancedNetworkImage(
                                    widget.userModel.profileImage,
                                    fallbackAssetImage:
                                        "assets/images/ic_caster_failed.png")
                                : AssetImage(
                                    "assets/images/ic_caster_failed.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(65.0)),
                      border: new Border.all(
                        color: Color.fromRGBO(255, 156, 0, 1),
                        width: 4.0,
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Padding lineView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Container(
        color: Colors.grey,
        height: 0.5,
      ),
    );
  }

  Container textTitle(String string) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
      child: Text(
        string,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Color.fromRGBO(255, 156, 0, 1),
          fontSize: 13,
        ),
      ),
    );
  }

  Container textDataProfile(TextEditingController txt) {
    return Container(
        padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
        child: new Theme(
          data: new ThemeData(
            primaryColor: Color.fromRGBO(255, 156, 0, 1),
          ),
          child: TextField(
            controller: txt,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: new InputDecoration(
                labelStyle: new TextStyle(color: const Color(0xFF424242)),
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                  color: Color.fromRGBO(255, 156, 0, 1),
                ))),
          ),
        ));
  }

  Expanded saveButton(double width) {
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: width,
            height: 60,
            color: Color.fromRGBO(255, 156, 0, 1),
            child: FlatButton(
              onPressed: () => ontapSaveButton(),
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
            ),
          )),
    );
  }

  // Action Save Profile
  void ontapSaveButton() {
    bloc.updateProfile(
        widget.userModel.userId, txtEmail.text, txtFullName.text, context);
  }

  //Action Change Image Profile
  void ontapImageProfile() {
    bloc.getImage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBarWidget(
        context: context,
        hasLeft: true,
        isCenterTitle: true,
        fontSizeTitle: 20,
        titleAppBar: Constant.PROFILE,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            imageProfile(),
            textTitle('Fullname'),
            textDataProfile(txtFullName),
            lineView(),
            textTitle('Email'),
            textDataProfile(txtEmail),
            lineView(),
            Center(
                child: StreamBuilder(
                    stream: bloc.isLoading,
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return LoadWidget().buildLoadingWidget(context);
                      return Container();
                    })),
            saveButton(width)
          ],
        ),
      )),
    );
  }
}

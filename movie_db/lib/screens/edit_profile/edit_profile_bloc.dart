import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/utils/validator_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileBloc {
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject();
  final BehaviorSubject<UserModel> _user = BehaviorSubject();
  final BehaviorSubject<File> _image = BehaviorSubject();
  final BehaviorSubject<bool> _isLoading = BehaviorSubject();

  String _userID = "";
  String _imageURl = "";
  File _imageFile;

  BehaviorSubject<bool> get isLoading => _isLoading;

  BehaviorSubject<UserModel> get user => _user;

  BehaviorSubject<File> get image => _image;
  UserModel _userModel;
  String _password = "";

  showDiaLog(BuildContext context, String title, String value) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(value),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //get user from cloud firestore
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userID = await prefs.getString("user_id");
    _password = await prefs.getString(Constant.PASSWORD);
    print("user_id: $_userID");
    if (_userID != null) {
      _userModel = await UserManagement().getUser(_userID);
      _user.sink.add(_userModel);
    }
  }

  // Show Gallery to Select Image and return Path
  Future getImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("ImageFile : $_imageFile");
    if (image != null) {
      _image.sink.add(_imageFile);
    }
  }

  updateProfile(
      String id, String email, String userName, BuildContext context) async {
    _isLoading.sink.add(true);
    var password = SharePreference().getString(Constant.PASSWORD);
    print("Password : $password");
    if (checkValid(email, userName, context)) {
      FirebaseAuth _auth = await FirebaseAuth.instance;
      await _auth.currentUser().then((value) async {
        print(value.email);
        AuthCredential credential = EmailAuthProvider.getCredential(
            email: value.email, password: _password);
        value.reauthenticateWithCredential(credential).then((value) {
          value.updateEmail(email).then((value) {
            if (_imageFile != null) {
              final StorageReference storageReference = FirebaseStorage.instance
                  .ref()
                  .child('profile_image/${_userModel.userId}.png');
              StorageUploadTask task = storageReference.putFile(_imageFile);
              task.onComplete.then((value) {
                value.ref.getDownloadURL().then((data) {
                  print(data.toString());
                  _imageURl = data.toString();
                  UserManagement()
                      .updateProfile(id, _imageURl, email, userName, context);
                });
              }).catchError((e) {
                MessageDialog().information(
                    context, "Error", StringUtils.updateProfileFail, null);
              });
            } else {
              _imageURl = _userModel.profileImage;
              UserManagement()
                  .updateProfile(id, _imageURl, email, userName, context);
            }
          }).catchError((e) {
            _isLoading.add(false);
            print(e);
          });
        });
      });
    } else
      MessageDialog()
          .information(context, "Error", StringUtils.updateProfileFail, null);
  }

  // Check validate Text Field
  bool checkValid(String email, String userName, BuildContext context) {
    String errorText = "";
    if (!Validator.isValidEmail(email)) {
      errorText = StringUtils.validEmail;
    } else if (userName.length == 0) {
      errorText = StringUtils.userName;
    }
    if (errorText.isNotEmpty) {
      MessageDialog().information(context, "Error", errorText, null);
      return false;
    }
    return true;
  }

  dispose() {
    _subject.close();
    _user.close();
    _isLoading.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

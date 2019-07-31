import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';

class UserManagement {
  storeNewUser(user, BuildContext context) {
    Firestore.instance
        .collection(ApiKeyParam.USER)
        .document(user.uid)
        .setData({
          ApiKeyParam.USER_NAME: user.displayName,
          ApiKeyParam.USER_EMAIL: user.email,
          ApiKeyParam.USER_PROFILE_IMAGE: user.photoUrl,
          ApiKeyParam.USER_ID: user.uid,
          'session_id': "3d7d89a5a578de78539157b65748f29c49845898",
        })
        .then((value) {})
        .catchError((e) {
          MessageDialog().information(
              context, StringUtils.message, StringUtils.signUpFail, null);
          print(e);
        });
  }

  Future<UserModel> getUser(String userId) async {
    UserModel user;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot ds) {
      user = UserModel.fromJson(ds.data);
      print("User : ${user.email}");
    });
    return user;
  }

  updateProfile(String id, String imageUrl, String email, String userName,
      BuildContext context) async {
    await Firestore.instance
        .collection(ApiKeyParam.USER)
        .document(id)
        .updateData({
      ApiKeyParam.USER_NAME: userName,
      ApiKeyParam.USER_EMAIL: email,
      ApiKeyParam.USER_PROFILE_IMAGE: imageUrl,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((e) {
      MessageDialog().information(
          context, StringUtils.error, StringUtils.updateProfileFail, null);
      print(e);
    });
  }
}

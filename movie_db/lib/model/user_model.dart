class UserModel{
  final String userId,userName,email,profileImage,sessionId;

  UserModel(this.userId,this.userName, this.email, this.profileImage, this.sessionId);

  UserModel.fromJson(Map<String, dynamic> json)
    :   userId = json['userid'],
        userName = json['user_name'],
        email = json['email'],
        profileImage = json['profile_image'],
        sessionId = json['session_id'];
  Map<String, dynamic> toJson() =>
      {
        'user_name': userName ,
        'email': email,
        'profile_image': profileImage,
        'session_id':sessionId,
        'userid':userId
      };
}
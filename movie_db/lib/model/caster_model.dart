class CasterModel {
  final String casterName, characterName, casterImage;
  final int id;
  CasterModel({this.id, this.casterName, this.characterName, this.casterImage});
  factory CasterModel.fromJson(Map<String, dynamic> json) => new CasterModel(
    id : json['cast_id'],
    casterName :json ['name'],
    characterName : json['character'],
    casterImage :json['profile_path']!=null? json['profile_path']:"",
  );
}

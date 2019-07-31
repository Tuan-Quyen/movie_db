import 'dart:convert';

import 'caster_model.dart';
class CasterResponse{
  final List<CasterModel> casters;
  final String error;

  CasterResponse(this.casters, this.error);
  CasterResponse.fromJson(Map<String,dynamic> json)
    : casters = (json['cast']as List).map((i)=>new CasterModel.fromJson(i)).toList(),
      error = "";
  CasterResponse.withError(String errorValue)
      : casters = null,
        error = errorValue;
}
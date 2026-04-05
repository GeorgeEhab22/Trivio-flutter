import 'package:auth/domain/entities/tags.dart';

class TagsModel extends Tags {
  const TagsModel({required super.enName, required super.arName});

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(enName: json['en'] ?? '', arName: json['ar'] ?? '');
  }
}

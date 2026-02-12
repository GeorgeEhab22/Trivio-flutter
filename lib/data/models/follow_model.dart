import 'package:auth/domain/entities/follow.dart';
import 'package:dartz/dartz.dart';

class FollowModel extends Follow {
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FollowModel({
    required super.id,
    required super.user,
    required super.follower,
    required super.status,
    this.createdAt,
    this.updatedAt,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['_id'],
      user: UserReference.fromJson(json['userId']),
      follower: UserReference.fromJson(json['followerId']),
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'followerId': follower.toJson(),
      'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

import 'package:auth/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

class GroupPost extends Equatable {
  final Post? post;
  final String? groupName;
  final String? groupCoverImage;

  const GroupPost({
    this.post,
    this.groupName,
    this.groupCoverImage
  });

  @override
  List<Object?> get props => [ post, groupName, groupCoverImage ];
}

import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/entities/follow_request.dart';

abstract class ProfileSocialInfoState extends Equatable {
  const ProfileSocialInfoState();
  @override
  List<Object?> get props => [];
}

class SocialInfoInitial extends ProfileSocialInfoState {}

class SocialInfoLoading extends ProfileSocialInfoState {}

class SocialInfoLoaded extends ProfileSocialInfoState {
  final List<Follow> following;
  final List<Follow> followers;
  final List<FollowRequest> requests;
  final List<UserProfilePreview> suggestions;
  final bool hasReachedMaxFollowers; 
  final bool hasReachedMaxFollowing; 

  const SocialInfoLoaded({
    this.following = const [],
    this.followers = const [],
    this.requests = const [],
    this.suggestions = const[],
    this.hasReachedMaxFollowers = false,
    this.hasReachedMaxFollowing = false,
  });

  SocialInfoLoaded copyWith({
    List<Follow>? following,
    List<Follow>? followers,
    List<FollowRequest>? requests,
    List<UserProfilePreview>? suggestions,
    bool? hasReachedMaxFollowers,
    bool? hasReachedMaxFollowing,
  }) {
    return SocialInfoLoaded(
      following: following ?? this.following,
      followers: followers ?? this.followers,
      requests: requests ?? this.requests,
      suggestions: suggestions?? this.suggestions,
      hasReachedMaxFollowers: hasReachedMaxFollowers ?? this.hasReachedMaxFollowers,
      hasReachedMaxFollowing: hasReachedMaxFollowing ?? this.hasReachedMaxFollowing,
    );
  }

  @override
  List<Object?> get props => [
        following,
        followers,
        requests,
        suggestions,
        hasReachedMaxFollowers,
        hasReachedMaxFollowing,
      ];
}

class SocialActionSuccess extends ProfileSocialInfoState {
  final String message;
  const SocialActionSuccess(this.message);
}

class SocialInfoFailure extends ProfileSocialInfoState {
  final String message;
  const SocialInfoFailure(this.message);
}
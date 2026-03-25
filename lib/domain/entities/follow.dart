import 'user_profile_preview.dart';

class Follow {
  final String id;
  final UserReference user;      // target user (id or preview)
  final UserReference follower;  // follower user (id or preview)
  final String status;

  const Follow({
    required this.id,
    required this.user,
    required this.follower,
    required this.status,
  });
}

//this is to handle the inconsistent API responses where sometimes we get 
//just an ID for user/follower, and sometimes we get a full preview object
class UserReference {
  final String id;
  final UserProfilePreview? preview;

  UserReference._({required this.id, this.preview});

  factory UserReference.fromJson(dynamic json) {
  if (json == null) return UserReference._(id: ''); 

  if (json is String) {
    return UserReference._(id: json);
  } else if (json is Map) { 
    return UserReference._(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      preview: UserProfilePreview(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: (json['username'] ?? json['name'] ?? 'Unknown').toString(),
        avatarUrl: json['avatar'] ?? json['profilePicture'],
      ),
    );
  } else {
    return UserReference._(id: json.toString());
  }
}

  dynamic toJson() {
    return preview != null
        ? {'_id': id, 'name': preview!.name, 'avatar': preview!.avatarUrl}
        : id;
  }
}

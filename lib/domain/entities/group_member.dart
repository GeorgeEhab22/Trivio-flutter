import 'package:equatable/equatable.dart';

class GroupMember extends Equatable {
  final String? userId;
  final String? userName;
  final String? profileImageUrl;
  final String? rule; // admin , moderator , member
  final String? statues; // active , banned 

  const GroupMember({
    this.userId,
    this.userName,
    this.profileImageUrl,
    this.rule,
    this.statues,
  });
  
  @override
  List<Object?> get props => [userId,userName,profileImageUrl,rule,statues];
  
 
}


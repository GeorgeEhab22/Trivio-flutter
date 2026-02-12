import 'package:equatable/equatable.dart';

abstract class BanMemberState extends Equatable {
  const BanMemberState();
  @override
  List<Object?> get props => [];
}

class BanMemberInitial extends BanMemberState {
  const BanMemberInitial();
}

class BanMemberLoading extends BanMemberState {
  const BanMemberLoading();
}

class BanMemberSuccess extends BanMemberState {
  final String message;
  final String userId;
  const BanMemberSuccess(this.message,this.userId);
  @override
  List<Object?> get props => [message, userId];
}

class BanMemberFailure extends BanMemberState {
  final String message;
  const BanMemberFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

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
  const BanMemberSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class BanMemberFailure extends BanMemberState {
  final String message;
  const BanMemberFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

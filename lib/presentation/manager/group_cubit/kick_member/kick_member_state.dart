import 'package:equatable/equatable.dart';

abstract class KickMemberState extends Equatable {
  const KickMemberState();
  @override
  List<Object?> get props => [];
}

class KickMemberInitial extends KickMemberState {
  const KickMemberInitial();
}

class KickMemberLoading extends KickMemberState {
  const KickMemberLoading();
}

class KickMemberSuccess extends KickMemberState {
  final String message;
  const KickMemberSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class KickMemberFailure extends KickMemberState {
  final String message;
  final String? errorType;
  const KickMemberFailure({required this.message, this.errorType});
  @override
  List<Object?> get props => [message, errorType];
}

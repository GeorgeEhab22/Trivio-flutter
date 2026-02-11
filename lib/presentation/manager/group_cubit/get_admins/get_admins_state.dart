import 'package:auth/domain/entities/group_member.dart';
import 'package:equatable/equatable.dart';

abstract class GetAdminsState extends Equatable {
  const GetAdminsState();

  @override
  List<Object?> get props => [];
}

class GetAdminsInitial extends GetAdminsState {
  const GetAdminsInitial();
}

class GetAdminsLoading extends GetAdminsState {
  const GetAdminsLoading();
}

class GetAdminsSuccess extends GetAdminsState {
  final List<GroupMember> admins;
  const GetAdminsSuccess({required this.admins});

  @override
  List<Object?> get props => [admins];
}

class GetAdminsFailure extends GetAdminsState {
  final String message;
  final String? errorType;

  const GetAdminsFailure({required this.message, this.errorType});

  @override
  List<Object?> get props => [message, errorType];
}

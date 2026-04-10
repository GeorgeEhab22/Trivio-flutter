abstract class UserGroupRoleState {}

class UserGroupRoleInitial extends UserGroupRoleState {}

class UserGroupRoleLoading extends UserGroupRoleState {}

class UserGroupRoleSuccess extends UserGroupRoleState {
  final String role;
  UserGroupRoleSuccess(this.role);
}

class UserGroupRoleFailure extends UserGroupRoleState {
  final String message;
  UserGroupRoleFailure(this.message);
}

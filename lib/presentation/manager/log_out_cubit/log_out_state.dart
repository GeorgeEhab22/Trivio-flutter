abstract class LogOutState {
  const LogOutState();
}

class LogOutInitial extends LogOutState {
  const LogOutInitial();
}

class LogOutLoading extends LogOutState {
  const LogOutLoading();
}

class LogOutSuccess extends LogOutState {
  const LogOutSuccess();
}

class LogOutFailure extends LogOutState {
  final String message;
  
  const LogOutFailure({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogOutFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
import 'package:equatable/equatable.dart';

abstract class FavTeamsState extends Equatable {
  const FavTeamsState();
  @override
  List<Object?> get props => [];
}

class FavTeamsInitial extends FavTeamsState {
  const FavTeamsInitial();
}
class FavTeamsLoading extends FavTeamsState {
  const FavTeamsLoading();
}
class FavTeamsLoaded extends FavTeamsState {
  final List<String> teams;
  const FavTeamsLoaded(this.teams);
  @override
  List<Object?> get props => [teams];
}
class FavTeamsError extends FavTeamsState {
  final String message;
  const FavTeamsError(this.message);
}
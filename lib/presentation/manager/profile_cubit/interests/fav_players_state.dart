import 'package:equatable/equatable.dart';

abstract class FavPlayersState extends Equatable {
  const FavPlayersState();
  @override
  List<Object?> get props => [];
}

class FavPlayersInitial extends FavPlayersState {
  const FavPlayersInitial();
}

class FavPlayersLoading extends FavPlayersState {
  const FavPlayersLoading();
}

class FavPlayersLoaded extends FavPlayersState {
  final List<String> players;
  const FavPlayersLoaded(this.players);
  @override
  List<Object?> get props => [players];
}

class FavPlayersError extends FavPlayersState {
  final String message;
  const FavPlayersError(this.message);
}

import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String idTeam;
  final String id;
  final String name;
  final String playerImage;

  const Player({
    required this.idTeam,
    required this.id,
    required this.name,
    required this.playerImage,
  });

  @override
  List<Object?> get props => [  idTeam,id, name, playerImage];
}
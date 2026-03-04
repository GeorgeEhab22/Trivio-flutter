import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String league;

  const Team({
    required this.id,
    required this.name,
    required this.logo,
    required this.league,
  });

  @override
  List<Object?> get props => [id, name, logo, league];
}
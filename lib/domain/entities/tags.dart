import 'package:equatable/equatable.dart';

class Tags extends Equatable {
  final String enName;
  final String arName;

  const Tags({required this.enName, required this.arName});

  @override
  List<Object?> get props => [enName, arName];
}

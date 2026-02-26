import 'package:auth/domain/entities/player.dart';
import 'package:flutter/foundation.dart';

class PlayerModel extends Player {
  const PlayerModel({
    required super.idTeam,
    required super.id,
    required super.name,
    required super.playerImage,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    String rawLogo = json['strThumb'] ?? json['strCutout'] ?? '';
    String finalLogo = rawLogo;

    if (kIsWeb && rawLogo.isNotEmpty && !rawLogo.contains('corsproxy.io')) {
      finalLogo = "https://corsproxy.io/?${Uri.encodeComponent(rawLogo)}";
    }

    return PlayerModel(
      idTeam: json['idTeam'] ?? '',
      id: json['idPlayer'] ?? '',
      name: json['strPlayer'] ?? '',
      playerImage:finalLogo,
    );
  }

  Map<String, dynamic> toJson() {
    return {  'idTeam': idTeam,'idPlayer': id, 'strPlayer': name, 'strThumb': playerImage};
  }
}

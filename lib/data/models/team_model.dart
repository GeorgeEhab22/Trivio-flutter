import 'package:auth/domain/entities/team.dart';
import 'package:flutter/foundation.dart'; 

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.logo,
    required super.league,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    String rawLogo = json['strBadge'] ?? json['strTeamBadge'] ?? '';
    
    String finalLogo = rawLogo;
    if (kIsWeb && rawLogo.isNotEmpty) {
      finalLogo = "https://corsproxy.io/?${Uri.encodeComponent(rawLogo)}";
    }

    return TeamModel(
      id: json['idTeam'] ?? '',
      name: json['strTeam'] ?? '',
      logo: finalLogo, 
      league: json['strLeague'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTeam': id,
      'strTeam': name,
      'strBadge': logo,
      'strLeague': league,
    };
  }
}
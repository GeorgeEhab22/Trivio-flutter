import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/api_service.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/player_model.dart';
import 'package:auth/data/models/team_model.dart';
import 'package:auth/data/models/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class InterestsRemoteDataSource {
  Future<List<TeamModel>> fetchTeams();
  Future<List<PlayerModel>> fetchAllPlayers();
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data);
  Future<List<String>> getFavTeams();
  Future<List<String>> getFavPlayers();
  Future<void> removeFavTeams(List<String> teams);
  Future<void> removeFavPlayers(List<String> players);
  Future<List<PlayerModel>> searchPlayersByName(String query);
}

class InterestsRemoteDataSourceImpl implements InterestsRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;
  final Dio dio;
  static const String _proxyUrl = 'https://corsproxy.io/?';
  static const String _baseUrl =
      'https://www.thesportsdb.com/api/v1/json/3/search_all_teams.php?l=';
  static const String _playerUrl =
      'https://www.thesportsdb.com/api/v1/json/3/lookup_all_players.php?id=';

  static const String _searchPlayerUrl =
      '${_proxyUrl}https://www.thesportsdb.com/api/v1/json/3/searchplayers.php?p=';

  final List<String> leagues = [
    'English Premier League',
    'Spanish La Liga',
    'German Bundesliga',
    'Italian Serie A',
    'French Ligue 1',
    'Egyptian Premier League',
  ];

  final List<String> teamsIds = const [
    /// La Liga
    '133738', // Barcelona
    '133739', // Real Madrid
    '134777', // Atletico Madrid
    /// Premier League
    '133612', // Manchester United
    '133602', // Liverpool
    '133613', // Manchester City
    '133610', // Chelsea
    '133604', // Arsenal
    '133616', // Tottenham
    /// Serie A
    '133676', // Juventus
    '133599', // AC Milan
    '133623', // Inter Milan
    '133637', // Roma
    '133638', // Napoli
    /// Ligue 1
    '133702', // PSG
    /// Bundesliga
    '133710', // Bayern Munich
    '134778', // Borussia Dortmund
    /// Egyptian League
    '138995', // Al Ahly
    '138998', // Zamalek
    '139094', // Pyramids
  ];
  InterestsRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
    required this.dio,
  });

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    if (token == null) throw AuthException('No auth token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<TeamModel>> fetchTeams() async {
    try {
      final requests = leagues.map((l) {
        return dio.get('$_baseUrl${Uri.encodeComponent(l)}');
      });

      final responses = await Future.wait(requests);
      List<TeamModel> allTeams = [];

      for (var response in responses) {
        if (response.statusCode == 200 && response.data['teams'] != null) {
          final List<dynamic> teamsList = response.data['teams'];
          allTeams.addAll(teamsList.map((j) => TeamModel.fromJson(j)).toList());
        }
      }

      return allTeams;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network Error');
    }
  }

  @override
  Future<List<PlayerModel>> fetchAllPlayers() async {
    try {
      final requests = teamsIds.map((teamId) {
        return dio.get('$_playerUrl$teamId');
      });

      final responses = await Future.wait(requests);

      List<PlayerModel> allPlayers = [];

      for (var response in responses) {
        if (response.statusCode == 200 && response.data['player'] != null) {
          final List<dynamic> playersList = response.data['player'];

          allPlayers.addAll(
            playersList.map((json) => PlayerModel.fromJson(json)),
          );
        }
      }

      return allPlayers;
    } catch (e) {
      throw Exception('Failed to fetch players');
    }
  }

  @override
  Future<UserProfileModel> updateInterests(Map<String, dynamic> data) async {
    try {
      final response = await api.patch(
        ApiEndpoints.updateProfile,
        data: data,
        options: _getAuthOptions(),
      );
      if (response["status"] == "success") {
        return UserProfileModel.fromJson(response['data']['user']);
      } else {
        throw ServerException('Failed to update interests');
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<String>> getFavTeams() async {
    final response = await api.get(
      ApiEndpoints.favTeams,
      options: _getAuthOptions(),
    );
    final teams = List<String>.from(response['data']['teams']);
    return teams;
  }

  @override
  Future<List<String>> getFavPlayers() async {
    final response = await api.get(
      ApiEndpoints.favPlayers,
      options: _getAuthOptions(),
    );
    final players = List<String>.from(response['data']['players']);
    return players;
  }

  @override
  Future<void> removeFavTeams(List<String> teams) async {
    await api.patch(
      ApiEndpoints.removeFavTeams,
      data: {'teams': teams},
      options: _getAuthOptions(),
    );
  }

  @override
  Future<void> removeFavPlayers(List<String> players) async {
    await api.patch(
      ApiEndpoints.removeFavPlayers,
      data: {'players': players},
      options: _getAuthOptions(),
    );
  }

  @override
  Future<List<PlayerModel>> searchPlayersByName(String query) async {
    try {
      final response = await dio.get(
        '$_searchPlayerUrl${Uri.encodeComponent(query)}',
      );

      if (response.statusCode == 200 && response.data['player'] != null) {
        final List<dynamic> playersList = response.data['player'];
        final parsedPlayers = playersList
            .map((json) => PlayerModel.fromJson(json))
            .toList();
        return parsedPlayers;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to search players');
    }
  }
}

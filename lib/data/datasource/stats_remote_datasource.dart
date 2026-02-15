import 'package:auth/data/datasource/stats_local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:auth/data/models/stats_dart/matches.dart';

abstract class StatsRemoteDatasource {
  Future<List<Matches>> fetchMatches();
}

class StatsRemoteDatasourceImpl implements StatsRemoteDatasource {
  final Dio dio;
  final StatsLocalDatasource localcache;

  static const String _apiKey = 'fe7743eafb25472c8f3ce45647c65cfb';
  static const String _baseUrl = 'https://api.football-data.org/v4';

  StatsRemoteDatasourceImpl(this.dio, this.localcache);

  @override
  Future<List<Matches>> fetchMatches() async {
    try {
      final response = await dio.get(
        '$_baseUrl/matches',
        options: Options(headers: {'X-Auth-Token': _apiKey}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> matchesList = response.data['matches'];
        await localcache.saveMatches(
          matchesList,
        ); 
        return matchesList
            .map((jsonMap) => Matches.fromMap(jsonMap as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load matches: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      }
      throw Exception(
        e.message ?? 'An error occurred during the network request',
      );
    }
  }
}

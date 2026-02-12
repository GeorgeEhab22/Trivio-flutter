import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/usecases/stats/stats_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this.statsUseCase) : super(StatsInitial());
  final StatsUseCase statsUseCase;

  Future<void> loadStats() async {
    emit(StatsLoading());
    try {
      final matches = await statsUseCase.call();

      emit(StatsLoaded(matches: matches));
    } catch (e) {
      emit(StatsError(message: e.toString()));
    }
  }
}
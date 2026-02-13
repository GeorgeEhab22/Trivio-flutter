import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/usecases/stats/stats_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
   final StatsUseCase statsUseCase;
  StatsCubit( this.statsUseCase) : super(StatsInitial());

 Future<void> loadStats() async {
  // 1. Immediate exit if the Cubit was closed during a restart
  if (isClosed) return; 

  emit(StatsLoading());
  
  try {
    final result = await statsUseCase.call();
    
    // 2. Check AGAIN after the async Hive/Network call
    if (isClosed) return; 

    result.fold(
      (failure) => emit(StatsError(message: failure.message)),
      (matches) => emit(StatsLoaded(matches: matches)),
    );
  } catch (e) {
    // 3. Prevent infinite loops: Just log and stay in Error state
    if (isClosed) return;
    print("StatsCubit Error: $e");
    emit(StatsError(message: "Failed to load data.")); 
  }
}
}
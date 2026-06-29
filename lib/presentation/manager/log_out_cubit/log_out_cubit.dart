import 'package:auth/presentation/manager/log_out_cubit/log_out_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitial());

  Future<void> executeLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    emit(LogOutSuccess());
  }
}

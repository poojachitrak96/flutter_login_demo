import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_demo/counter/counter_state.dart';
import 'package:flutter_login_demo/data/model/User.dart';
import 'package:flutter_login_demo/data/repository/UserRepository.dart';

class CounterCubit extends Cubit<CounterState> {
  final IUserRepository userRepo;
  final User user;

  CounterCubit({required this.userRepo, required this.user})
      : super(CounterState(user.counterValue ?? 0));

  void increment() async {
    final newCounter = state.counter + 1;
    emit(CounterState(newCounter));
    await _updateCounterInDB(newCounter);
  }

  void reset() async {
    emit(const CounterState(0));
    await _updateCounterInDB(0);
  }

  Future<void> _updateCounterInDB(int newValue) async {
    try {
      await userRepo.updateUser(user.copyWith(counterValue: newValue));
    } catch (e) {
      print("Error updating counter in DB: $e");
    }
  }
}


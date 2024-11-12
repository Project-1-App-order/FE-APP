
import 'package:bloc/bloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterEvent.dart';
import 'package:project_1_btl/blocs/Register/RegisterState.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final message = await authRepository.registerUser(event.email, event.password);
      emit(RegisterSuccess(message: message));
    } catch (error) {
      emit(RegisterFailure(error: error.toString().replaceAll('Exception: ', '')));
    }
  }
}

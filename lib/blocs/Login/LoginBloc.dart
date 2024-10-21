import 'package:bloc/bloc.dart';
import 'package:project_1_btl/blocs/Login/LoginEvent.dart';
import 'package:project_1_btl/blocs/Login/LoginState.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Đăng nhập và nhận token từ AuthRepository
      final token = await authRepository.loginUser(event.email, event.password);

      // Lưu token vào SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('auth_token', token); // Save the token

      emit(LoginSuccess(message: token));
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}

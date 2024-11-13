import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Cart/CartBloc.dart';
import 'package:project_1_btl/blocs/Login/LoginBloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterBloc.dart'; // Import RegisterBloc
import 'package:project_1_btl/network/NetworkAwareWidget.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/repository/CartRepository.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/screen/Main/SplashScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/services/CartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(authRepository: AuthRepository(AuthService())),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(authRepository: AuthRepository(AuthService())), // Add RegisterBloc provider
        ),
        BlocProvider(
          create: (context) => CartBloc(cartRepository: CartRepository(CartService())), // Create CartDetailBloc provider
        ),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(), // or RegisterScreen if needed
      ),
    );
  }
}

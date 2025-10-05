import 'package:auth/presentation/authentication/register/register_view.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/register_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_cubit.dart';
import 'package:auth/presentation/authentication/signIn/sign_in_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
      home: BlocProvider(
        create: (context) => di.sl<SignInCubit>(),
        child: const SignInPage(),
      ),
      routes: {
        '/signin': (context) => BlocProvider(
          create: (context) => di.sl<SignInCubit>(),
          child: const SignInPage(),
        ),
        '/home': (context) => const HomePage(),
        '/register': (context) => BlocProvider(
          create: (context) => di.sl<RegisterCubit>(),
          child: const RegisterPage(),
        ),
      },
    );
  }
}

// Placeholder pages
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home Page')));
  }
}

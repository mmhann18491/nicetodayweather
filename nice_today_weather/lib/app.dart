import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_today_weather/core/di/injection_container.dart';
import 'package:nice_today_weather/core/storage/storage_service.dart';
import 'package:nice_today_weather/core/theme/app_theme.dart';
import 'package:nice_today_weather/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nice_today_weather/features/auth/presentation/pages/sign_in_page.dart';
import 'package:nice_today_weather/features/location/presentation/bloc/location_bloc.dart';
import 'package:nice_today_weather/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:nice_today_weather/features/weather/presentation/pages/home_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = getIt<StorageService>().getPreferences();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<WeatherBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<LocationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Nice Today Weather',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const HomePage();
            }
            return const SignInPage();
          },
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

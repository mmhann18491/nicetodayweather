import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_today_weather/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nice_today_weather/features/location/presentation/bloc/location_bloc.dart';
import 'package:nice_today_weather/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:nice_today_weather/features/weather/presentation/widgets/current_weather_card.dart';
import 'package:nice_today_weather/features/weather/presentation/widgets/forecast_list.dart';
import 'package:nice_today_weather/features/weather/presentation/widgets/location_search_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _version = '';

  @override
  void initState() {
    super.initState();

    _checkAndRequestLocationPermission();
    _loadAppVersion();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    final locationBloc = context.read<LocationBloc>();

    // First request permission
    locationBloc.add(RequestLocationPermission());
  }

  Future<void> _openAppSettings() async {
    final opened = await openAppSettings();
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location permission in settings'),
        ),
      );
    }
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = packageInfo.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nice Today',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              'Weather',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.65),
                    letterSpacing: 1.2,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface.withOpacity(0.95),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoaded) {
            if (!context.mounted) return;
            try {
              context.read<WeatherBloc>().add(
                    GetWeatherByLocation(
                      latitude: state.location.latitude,
                      longitude: state.location.longitude,
                    ),
                  );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error updating weather data'),
                ),
              );
            }
          } else if (state is LocationPermissionDenied) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Please enable location permission to get weather for your current location.'),
              ),
            );
          } else if (state is LocationError) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<LocationBloc>().add(GetCurrentLocation());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationPermissionDenied) {
                    return SliverToBoxAdapter(
                      child: Container(
                        color: Theme.of(context).colorScheme.errorContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_off,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Location access is required for accurate weather updates',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _openAppSettings(),
                              child: const Text('Enable'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LocationSearchBar(),
                      const SizedBox(height: 16),
                      BlocBuilder<WeatherBloc, WeatherState>(
                        builder: (context, state) {
                          if (state is WeatherLoading) {
                            return const _LoadingWidget();
                          } else if (state is WeatherLoaded) {
                            return Column(
                              children: [
                                CurrentWeatherCard(weather: state.weather),
                                const SizedBox(height: 16),
                                ForecastList(forecast: state.forecast),
                              ],
                            );
                          } else if (state is WeatherError) {
                            return _ErrorWidget(message: state.message);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Version $_version',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              context.read<LocationBloc>().add(GetCurrentLocation());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

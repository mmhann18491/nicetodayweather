import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_today_weather/features/weather/presentation/bloc/weather_bloc.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          style: TextStyle(color: colorScheme.onSurface),
          selectionControls: MaterialTextSelectionControls(),
          cursorHeight: 20,
          decoration: InputDecoration(
            hintText: 'Search location...',
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.7)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<WeatherBloc>().add(GetWeatherByCity(value));
            }
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              context.read<WeatherBloc>().add(GetWeatherByCity(value));
            }
          },
        ),
      ),
    );
  }
} 
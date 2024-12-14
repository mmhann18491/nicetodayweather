import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
  });

  String _getWeatherIconUrl(String iconCode) {
    // Using OpenWeatherMap icons as an example
    // You can replace this with your preferred weather API's icon URL
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                CachedNetworkImage(
                  imageUrl: _getWeatherIconUrl(weather.icon),
                  width: 64,
                  height: 64,
                  placeholder: (context, url) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    print('Error loading weather icon: ${weather.icon}');
                    return const Icon(Icons.cloud, size: 64);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Feels like ${weather.feelsLike.round()}°C',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.water_drop, size: 16),
                        const SizedBox(width: 4),
                        Text('${weather.humidity}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.air, size: 16),
                        const SizedBox(width: 4),
                        Text('${weather.windSpeed} km/h'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
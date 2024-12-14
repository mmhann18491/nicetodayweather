import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nice_today_weather/core/extensions/string_extensions.dart';
import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';

class ForecastList extends StatelessWidget {
  final List<Weather> forecast;

  const ForecastList({
    super.key,
    required this.forecast,
  });

  String _getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Forecast',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  forecast.length,
                  (index) {
                    final weather = forecast[index];
                    return Container(
                      width: 100,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 0,
                        right: index == forecast.length - 1 ? 0 : 0,
                      ),
                      child: Card(
                        elevation: 0,
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        child: SizedBox(
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getTimeOfDay(index),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: _getWeatherIconUrl(weather.icon),
                                    width: 48,
                                    height: 48,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      print(
                                          'Error loading weather icon: ${weather.icon}');
                                      return const Icon(Icons.cloud, size: 48);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${weather.temperature.round()}°',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      weather.description.capitalized,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getTimeOfDay(int index) {
    // This is a placeholder. You should use actual timestamp from the weather data
    final hours = List.generate(24, (index) => index);
    final currentHour = DateTime.now().hour;
    final forecastHour = (currentHour + (index * 3)) % 24;
    return '${hours[forecastHour]}:00';
  }
}

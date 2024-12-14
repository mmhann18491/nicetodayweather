import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nice_today_weather/features/location/domain/entities/location.dart';
import 'package:nice_today_weather/features/location/domain/repositories/location_repository.dart';

// Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocation extends LocationEvent {}

class SearchLocation extends LocationEvent {
  final String query;

  const SearchLocation(this.query);

  @override
  List<Object?> get props => [query];
}

class RequestLocationPermission extends LocationEvent {}

// States
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationEntity location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationPermissionDenied extends LocationState {}

// Bloc
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(LocationInitial()) {
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<SearchLocation>(_onSearchLocation);
    on<RequestLocationPermission>(_onRequestLocationPermission);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final hasPermission = await _locationRepository.checkPermission();
      if (!hasPermission) {
        emit(LocationPermissionDenied());
        return;
      }

      final location = await _locationRepository.getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onSearchLocation(
    SearchLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final location = await _locationRepository.getCoordinatesFromAddress(
        event.query,
      );
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final granted = await _locationRepository.requestPermission();
      if (granted) {
        final location = await _locationRepository.getCurrentLocation();
        emit(LocationLoaded(location));
      } else {
        emit(LocationPermissionDenied());
      }
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}

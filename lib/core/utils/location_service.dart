import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Get current position with all permissions handled
  static Future<Position?> getCurrentLocation({
    bool askPermission = true,
    LocationAccuracy accuracy = LocationAccuracy.best,
  }) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check and request permissions
      LocationPermission permission;
      
      if (askPermission) {
        permission = await _checkAndRequestLocationPermission();
        if (permission != LocationPermission.whileInUse && 
            permission != LocationPermission.always) {
          throw Exception('Location permission denied');
        }
      } else {
        permission = await Geolocator.checkPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 30),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Check and request location permission
  static Future<LocationPermission> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }

  // Get location with automatic retry
  static Future<Position?> getLocationWithRetry({
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    Position? position;
    
    for (int i = 0; i < maxRetries; i++) {
      try {
        position = await getCurrentLocation();
        if (position != null) break;
        
        if (i < maxRetries - 1) {
          await Future.delayed(delay);
        }
      } catch (e) {
        print('Location attempt $i failed: $e');
      }
    }
    
    return position;
  }

  // Get continuous location updates
  static Stream<Position> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.bestForNavigation,
    int distanceFilter = 10, // meters
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  // Get last known position (cached)
  static Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      print('Error getting last known position: $e');
      return null;
    }
  }

  // Get address from coordinates (reverse geocoding)
  static Future<String?> getAddressFromCoordinates(
    double lat, 
    double lng,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }
}
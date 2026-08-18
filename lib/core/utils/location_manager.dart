// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocationManager {
//   static Position? _cachedPosition;
//   static DateTime? _lastLocationFetchTime;
//   static const Duration _cacheDuration = Duration(minutes: 5);

//   // Get location with caching
//   static Future<Position?> getLocation({
//     bool forceRefresh = false,
//     bool useCache = true,
//   }) async {
//     try {
//       // Check cache if not forcing refresh
//       if (useCache && 
//           !forceRefresh && 
//           _cachedPosition != null &&
//           _lastLocationFetchTime != null &&
//           DateTime.now().difference(_lastLocationFetchTime!) < _cacheDuration) {
//         return _cachedPosition;
//       }

//       // Try to get last known position first (faster)
//       if (!forceRefresh) {
//         Position? lastPosition = await Geolocator.getLastKnownPosition();
//         if (lastPosition != null) {
//           _cacheLocation(lastPosition);
//           return lastPosition;
//         }
//       }

//       // Get fresh position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//         timeLimit: const Duration(seconds: 15),
//       );

//       _cacheLocation(position);
//       return position;
//     } catch (e) {
//     //  print('Location error: $e');
      
//       // Try to get from shared preferences as fallback
//       if (useCache) {
//         Position? storedPosition = await _getStoredLocation();
//         if (storedPosition != null) return storedPosition;
//       }
      
//       return null;
//     }
//   }

//   static void _cacheLocation(Position position) {
//     _cachedPosition = position;
//     _lastLocationFetchTime = DateTime.now();
//     _storeLocation(position);
//   }

//   // Store location in shared preferences
//   static Future<void> _storeLocation(Position position) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setDouble('last_latitude', position.latitude);
//       await prefs.setDouble('last_longitude', position.longitude);
//       await prefs.setDouble('last_accuracy', position.accuracy ?? 0.0);
//       await prefs.setString('last_location_time', DateTime.now().toIso8601String());
//     } catch (e) {
//     //  print('Error storing location: $e');
//     }
//   }

//   // Get stored location from shared preferences
//   static Future<Position?> _getStoredLocation() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final double? lat = prefs.getDouble('last_latitude');
//       final double? lng = prefs.getDouble('last_longitude');
//       final double? accuracy = prefs.getDouble('last_accuracy');
//       final String? timeString = prefs.getString('last_location_time');
      
//       if (lat != null && lng != null && timeString != null) {
//         final storedTime = DateTime.parse(timeString);
        
//         // Only use if less than 1 hour old
//         if (DateTime.now().difference(storedTime) < const Duration(hours: 1)) {
//           return Position(
//             latitude: lat,
//             longitude: lng,
//             timestamp: storedTime,
//             accuracy: accuracy ?? 0.0,
//             altitude: 0.0,
//             heading: 0.0,
//             speed: 0.0,
//             speedAccuracy: 0.0,
//             altitudeAccuracy: 0.0,
//             headingAccuracy: 0.0,
//           );
//         }
//       }
//     } catch (e) {
//     //  print('Error reading stored location: $e');
//     }
//     return null;
//   }

//   // Get location coordinates
//   static Future<Map<String, dynamic>?> getLocationData() async {
//     final position = await getLocation();
    
//     if (position != null) {
//       return {
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'accuracy': position.accuracy,
//         'altitude': position.altitude,
//         'speed': position.speed,
//         'heading': position.heading,
//         'timestamp': position.timestamp?.toIso8601String(),
//         'source': _cachedPosition == position ? 'cached' : 'fresh',
//       };
//     }
    
//     return null;
//   }

//   // Calculate distance between two coordinates (in meters)
//   static double calculateDistance(
//     double lat1, 
//     double lng1, 
//     double lat2, 
//     double lng2,
//   ) {
//     return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
//   }
// }
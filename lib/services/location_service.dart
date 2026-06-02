import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationResult {
  final String city;
  final String country;
  final String climate;
  final String climateLabel;
  final String climateEmoji;
  final double latitude;
  final double longitude;

  const LocationResult({
    required this.city,
    required this.country,
    required this.climate,
    required this.climateLabel,
    required this.climateEmoji,
    required this.latitude,
    required this.longitude,
  });

  String get displayName =>
      country.isNotEmpty ? '$city, $country' : city;
}

class LocationService {
  LocationService._();

  /// Detects the user's current location and maps it to an African climate zone.
  /// Throws a human-readable [String] on failure.
  static Future<LocationResult> detect() async {
    // 1 — Verify device location services are on
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled on your device. Please enable them in Settings.';
    }

    // 2 — Check / request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw 'Location permission was denied. Please allow AfriGlow to access your location.';
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission is permanently denied. Enable it in your device\'s App Settings.';
    }

    // 3 — Fetch GPS coordinates (15-second timeout)
    late Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Location request timed out.'),
      );
    } on TimeoutException {
      throw 'Could not get your location in time. Please try again.';
    } catch (e) {
      throw 'Could not retrieve your location. Please check your GPS signal.';
    }

    // 4 — Determine climate zone from coordinates
    final climate = _climateFromCoords(position.latitude, position.longitude);
    final (label, emoji) = _climateInfo(climate);

    // 5 — Reverse-geocode to city name via Nominatim (graceful failure)
    String city = 'My Location';
    String country = '';
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${position.latitude}&lon=${position.longitude}'
        '&format=json&accept-language=en',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'AfriGlow/1.0 (skincare-app)'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final addr = data['address'] as Map<String, dynamic>?;
        if (addr != null) {
          city = addr['city'] as String? ??
              addr['town'] as String? ??
              addr['village'] as String? ??
              addr['county'] as String? ??
              addr['state'] as String? ??
              'My Location';
          country = addr['country'] as String? ?? '';
        }
      }
    } catch (_) {
      // Network unavailable — climate still determined from coordinates
    }

    return LocationResult(
      city: city,
      country: country,
      climate: climate,
      climateLabel: label,
      climateEmoji: emoji,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Maps GPS coordinates to one of the four AfriGlow climate zones.
  ///
  /// Zones are based on major African climatic belts:
  /// - Harmattan: Sahara + Sahel (~8°N and above, West/Central Africa)
  /// - Tropical : Equatorial belt (-5° to 8°N)
  /// - Coastal  : Transitional coastal strip
  /// - Savanna  : Southern Africa (below ~-12°S)
  static String _climateFromCoords(double lat, double lon) {
    if (lat > 18) return 'harmattan'; // Sahara / far Sahel
    if (lat > 8 && lon > -20 && lon < 20) return 'harmattan'; // West-African Sahel
    if (lat >= -5 && lat <= 8) return 'tropical'; // Equatorial belt
    if (lat < -12) return 'savanna'; // Southern Africa
    if (lat >= 5 && lat <= 15 && lon >= 20) return 'tropical'; // East-African highlands
    return 'coastal'; // Default — near coast / transitional
  }

  static (String, String) _climateInfo(String key) {
    const info = {
      'harmattan': ('Harmattan / Dry', '🌬️'),
      'tropical': ('Tropical', '🌴'),
      'coastal': ('Coastal', '🌊'),
      'savanna': ('Savanna', '🌾'),
    };
    return info[key] ?? ('Tropical', '🌴');
  }
}

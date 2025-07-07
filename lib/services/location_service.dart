import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
// Removed google_api_headers import as it's no longer required
// import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart';

class LocationService {
  static const String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: _apiKey,
  );

  // Get current location
  static Future<location_package.LocationData?> getCurrentLocation() async {
    location_package.Location location = location_package.Location();
    bool serviceEnabled;
    location_package.PermissionStatus permissionGranted;
    location_package.LocationData? locationData;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Check location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == location_package.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != location_package.PermissionStatus.granted) {
        return null;
      }
    }

    // Get current location
    try {
      locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  // Get address from coordinates
  static Future<String?> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  // Get place suggestions
  Future<List<Prediction>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _places.autocomplete(
        query,
        language: 'ar', // Arabic language
        components: [Component(Component.country, 'sa')], // Saudi Arabia
      );

      return response.predictions;
    } catch (e) {
      debugPrint('Error getting place suggestions: $e');
      return [];
    }
  }

  // Get place details
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final details = await _places.getDetailsByPlaceId(
        placeId,
        language: 'ar',
      );
      return details.result;
    } catch (e) {
      debugPrint('Error getting place details: $e');
      return null;
    }
  }
}

// Address Search Field Widget
class AddressSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(LatLng? position) onLocationSelected;
  final String? hintText;
  final String? labelText;
  final bool showCurrentLocationButton;

  const AddressSearchField({
    super.key,
    required this.controller,
    required this.onLocationSelected,
    this.hintText = 'ابحث عن عنوانك',
    this.labelText = 'العنوان',
    this.showCurrentLocationButton = true,
  });

  @override
  State<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {
  final LocationService _locationService = LocationService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: TypeAheadField<Prediction>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.length < 3) return [];
                  setState(() => _isLoading = true);
                  final suggestions =
                      await _locationService.getPlaceSuggestions(pattern);
                  setState(() => _isLoading = false);
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(
                      suggestion.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  widget.controller.text = suggestion.description ?? '';
                  final details =
                      await _locationService.getPlaceDetails(suggestion.placeId!);
                  if (details != null) {
                    final position = LatLng(
                      details.geometry!.location.lat,
                      details.geometry!.location.lng,
                    );
                    widget.onLocationSelected(position);
                  }
                },
                noItemsFoundBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('لا توجد نتائج'),
                ),
              ),
            ),
            if (widget.showCurrentLocationButton) ...[
              const SizedBox(width: 8),
              _buildCurrentLocationButton(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentLocationButton() {
    return IconButton(
      onPressed: _getCurrentLocation,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.all(12),
      ),
      icon: const Icon(Icons.my_location_outlined),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        final latLng = LatLng(position.latitude!, position.longitude!);
        final address = await LocationService.getAddressFromLatLng(latLng);
        if (mounted) {
          widget.controller.text = address ?? 'موقعك الحالي';
          widget.onLocationSelected(latLng);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  LatLng? _selectedDestination;
  LatLng? _startingLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _loadExamLocations();
  }

  void _loadExamLocations() {
    final provider = Provider.of<ExamProvider>(context, listen: false);
    final exams = provider.exams;

    setState(() {
      _markers = exams.map((exam) {
        final parts = exam.location
            .replaceAll('(', '')
            .replaceAll(')', '')
            .split(', ');
        final lat = double.parse(parts[0]);
        final lng = double.parse(parts[1]);

        return Marker(
          markerId: MarkerId(exam.id.toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: exam.subject,
            snippet: 'Tap to set as destination',
            onTap: () => _setDestination(LatLng(lat, lng)),
          ),
        );
      }).toSet();
    });
  }

  void _setStartingLocation(LatLng position) {
    setState(() {
      _startingLocation = position;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting location selected.')),
    );
  }

  void _setDestination(LatLng position) {
    setState(() {
      _selectedDestination = position;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destination selected. Tap "Find Route".')),
    );
  }

  Future<void> _findShortestRoute() async {
    if (_startingLocation == null || _selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Set both starting and destination locations.')),
      );
      return;
    }

    final baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    final apiKey = 'AIzaSyBgYIddbcG8jufmNaOvT7wu2xoISSSDxYY';

    final url =
        '$baseUrl?origin=${_startingLocation!.latitude},${_startingLocation!.longitude}'
        '&destination=${_selectedDestination!.latitude},${_selectedDestination!.longitude}'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] == null || data['routes'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No route found. Please try again.')),
          );
          return;
        }

        final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
        final polylinePoints = _decodePolyline(encodedPolyline);

        setState(() {
          _polylines = {
            Polyline(
              polylineId: PolylineId('shortestRoute'),
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          };
        });

        _adjustCameraBounds();
      } else {
        throw Exception('Failed to fetch directions. Response code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _adjustCameraBounds() {
    if (_startingLocation != null && _selectedDestination != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _startingLocation!.latitude < _selectedDestination!.latitude
              ? _startingLocation!.latitude
              : _selectedDestination!.latitude,
          _startingLocation!.longitude < _selectedDestination!.longitude
              ? _startingLocation!.longitude
              : _selectedDestination!.longitude,
        ),
        northeast: LatLng(
          _startingLocation!.latitude > _selectedDestination!.latitude
              ? _startingLocation!.latitude
              : _selectedDestination!.latitude,
          _startingLocation!.longitude > _selectedDestination!.longitude
              ? _startingLocation!.longitude
              : _selectedDestination!.longitude,
        ),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Locations Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation ?? LatLng(37.7749, -122.4194),
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (position) {
              if (_startingLocation == null) {
                _setStartingLocation(position);
              } else if (_selectedDestination == null) {
                _setDestination(position);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clear selections to choose new locations.')),
                );
              }
            },
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: _findShortestRoute,
              child: Text('Find Shortest Route'),
            ),
          ),
        ],
      ),
    );
  }
}

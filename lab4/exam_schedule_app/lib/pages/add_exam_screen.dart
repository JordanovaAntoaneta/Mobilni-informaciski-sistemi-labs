import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExamProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Exam')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) => value!.isEmpty ? 'Enter a subject' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : 'Selected: ${_selectedDate!.toLocal()}',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _selectedTime = selectedTime;
                    });
                  }
                },
                child: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : 'Selected: ${_selectedTime!.format(context)}',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  LatLng? location = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPickerScreen(),
                    ),
                  );
                  if (location != null) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  }
                },
                child: Text(
                  _selectedLocation == null
                      ? 'Pick Location'
                      : 'Location: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedDate != null &&
                      _selectedTime != null &&
                      _selectedLocation != null) {
                    provider.addExam(
                      Exam(
                        id: DateTime.now().millisecondsSinceEpoch,
                        date: _selectedDate!,
                        time: _selectedTime!.format(context),
                        location:
                        '(${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                        subject: _subjectController.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Exam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    final userLocation = await location.getLocation();
    setState(() {
      _pickedLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_pickedLocation != null) {
                Navigator.pop(context, _pickedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a location.')),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation ?? const LatLng(37.7749, -122.4194),
              zoom: 14,
            ),
            markers: {
              if (_pickedLocation != null)
                Marker(
                  markerId: const MarkerId('pickedLocation'),
                  position: _pickedLocation!,
                ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                _pickedLocation = position;
              });
            },
          ),
        ],
      ),
    );
  }
}
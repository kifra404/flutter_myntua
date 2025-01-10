import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_myntua/widgets/appbar.dart';
import 'package:flutter_myntua/widgets/friend.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Position? _currentPosition;
  Timer? _locationTimer;
  final double _markerSize = 100;

  // Initial position for the map (NTUA coordinates)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.9838, 23.7275),
    zoom: 15,
  );

  // Example locations for different NTUA spots
  static const Map<String, LatLng> ntuaLocations = {
    'NTUA Library': LatLng(37.9790, 23.7830),
    'ECE Cafeteria': LatLng(37.9775, 23.7835),
    'NTUA Restaurant': LatLng(37.9780, 23.7840),
  };

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Please enable location services to use the map features.'),
          actions: [
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _getCurrentLocation();
      _createMarkers();
    });
  }

  Future<BitmapDescriptor> _createCustomMarkerFromAsset(
      String assetPath) async {
    final ui.Image markerImage = await _loadImageFromAsset(assetPath);
    final ui.Image circularImage = await _makeCircularImage(markerImage);

    final ByteData? byteData =
        await circularImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<ui.Image> _loadImageFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: _markerSize.toInt(),
      targetWidth: _markerSize.toInt(),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image> _makeCircularImage(ui.Image image) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..isAntiAlias = true;

    // Draw circular clip
    canvas.clipPath(
        Path()..addOval(Rect.fromLTWH(0, 0, _markerSize, _markerSize)));

    // Draw image
    canvas.drawImage(image, Offset.zero, paint);

    // Draw border
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.white;
    paint.strokeWidth = 4;
    canvas.drawCircle(
      Offset(_markerSize / 2, _markerSize / 2),
      _markerSize / 2,
      paint,
    );

    return pictureRecorder.endRecording().toImage(
          _markerSize.toInt(),
          _markerSize.toInt(),
        );
  }

  Future<void> _createMarkers() async {
    Set<Marker> newMarkers = {};

    for (var friend in friends) {
      final position =
          ntuaLocations[friend.currentLocation] ?? _initialPosition.target;

      // Create custom marker icon from friend's profile picture
      final BitmapDescriptor customIcon =
          await _createCustomMarkerFromAsset(friend.photoUrl);

      newMarkers.add(Marker(
        markerId: MarkerId(friend.name),
        position: position,
        infoWindow: InfoWindow(
          title: friend.name,
          snippet: '${friend.currentLocation} - ${friend.timeSpent}',
        ),
        icon: customIcon,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendProfileScreen(friend: friend),
            ),
          );
        },
      ));
    }

    // Add current user's location marker if available
    if (_currentPosition != null) {
      newMarkers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'You are here'),
      ));
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(isHomeScreen: true),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          _createMarkers();
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true,
        compassEnabled: true,
      ),
      bottomNavigationBar: BottomBar(currentIndex: 3),
    );
  }
}

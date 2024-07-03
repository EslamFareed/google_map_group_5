import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _controller;

  getMyLocation() async {
    var isLocationService = await Geolocator.isLocationServiceEnabled();
    if (!isLocationService) {
      print("Please open your location service");
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    // Geolocator.getPositionStream().listen((pos) {
    // });

    var myPosiiton = await Geolocator.getCurrentPosition();
    _markers.add(
      Marker(
        markerId: MarkerId("3"),
        position: LatLng(myPosiiton.latitude, myPosiiton.longitude),
      ),
    );
    setState(() {});
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(myPosiiton.latitude, myPosiiton.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(30.0287457, 31.2585235),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(30.0289, 31.256),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Map"),
        actions: [
          IconButton(
            onPressed: () {
              getMyLocation();
              // _controller.animateCamera(
              //   CameraUpdate.newCameraPosition(
              //     CameraPosition(
              //       target: LatLng(30.0287457, 31.2585235),
              //       zoom: 20,
              //     ),
              //   ),
              // );
            },
            icon: const Icon(Icons.location_city),
          ),
          IconButton(
            onPressed: () {
              _controller.animateCamera(CameraUpdate.zoomIn());
            },
            icon: const Icon(Icons.zoom_in),
          ),
          IconButton(
            onPressed: () {
              _controller.animateCamera(CameraUpdate.zoomOut());
            },
            icon: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        // mapType: MapType.satellite,
        // buildingsEnabled: true,
        zoomControlsEnabled: false,
        trafficEnabled: true,
        // myLocationEnabled: true,
        // myLocationButtonEnabled: true,
        markers: _markers,
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.0287457, 31.2585235),
          zoom: 14,
        ),
      ),
    );
  }
}

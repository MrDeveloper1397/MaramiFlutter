import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mil/routes/route.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationDetails extends StatefulWidget {
  final String projectTitle;
  final String longitude;
  final String latitude;
  NavigationDetails(this.projectTitle, this.longitude, this.latitude);

  @override
  State<NavigationDetails> createState() => NavigationDetailsState();
}

class NavigationDetailsState extends State<NavigationDetails> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng _center = LatLng(0, 0);
  late LatLng _currentMapPosition;
  String ventureName = '';

  @override
  Widget build(BuildContext context) {
    double latVal = double.parse(widget.latitude);
    double longVal = double.parse(widget.longitude);
    _center = LatLng(latVal, longVal);

    _currentMapPosition = _center;

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.projectTitle,
              style: Theme.of(context).textTheme.overline)),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: markers.values.toSet(),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Align(
              alignment: Alignment.topRight,
              // child: FloatingActionButton(
              //   onPressed: () => debugPrint('You have pressed the button'),
              //   materialTapTargetSize: MaterialTapTargetSize.padded,
              //   backgroundColor: Colors.green,
              //   child: const Icon(Icons.map, size: 30.0),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  /* _onMapCreated(GoogleMapController mapController, String projectTitle) {
    mapController = mapController;
    final marker = Marker(
      markerId: MarkerId('place_name'),
      // position: LatLng(9.669111, 80.014007),
      position: _center,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
*/

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    final marker = Marker(
      markerId: MarkerId('place_name'),
      // position: LatLng(9.669111, 80.014007),
      position: _center,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: widget.projectTitle,
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }
}

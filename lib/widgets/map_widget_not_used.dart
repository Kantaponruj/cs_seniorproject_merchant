import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

// const _marker = 350.0;

class MapWidget extends StatefulWidget {
  const MapWidget({Key key, @required this.mapController, @required this.order})
      : super(key: key);
  final Completer<GoogleMapController> mapController;
  final order;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Set<Marker> _markers = Set<Marker>();
  LatLng customerLocation;
  LatLng storeLocation;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String customerName;
  String storeName;

  String _placeDistance;
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    polylinePoints = PolylinePoints();
    this.setInitialLocation();
    super.initState();
  }

  void setInitialLocation() {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    // LocationNotifier location =
    //     Provider.of<LocationNotifier>(context, listen: false);

    customerLocation = LatLng(
      double.parse(widget.order['geoPoint'].latitude.toString()),
      double.parse(widget.order['geoPoint'].longitude.toString()),
    );
    storeLocation = LatLng(
      store.store.realtimeLocation.latitude,
      store.store.realtimeLocation.longitude,
    );

    customerName = widget.order['customerName'];
    storeName = store.store.storeName;
  }

  void showMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Customer Marker'),
        position: customerLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "ลูกค้า"),
      ));

      _markers.add(Marker(
        markerId: MarkerId('Store Marker'),
        position: storeLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
        infoWindow: InfoWindow(title: "ฉัน"),
      ));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(customerLocation.latitude, customerLocation.longitude),
      PointLatLng(storeLocation.latitude, storeLocation.longitude),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
          width: 5,
          polylineId: PolylineId('polyLine'),
          // color: Color(0xFF08A5CB),
          points: polylineCoordinates,
        ));
        calculateDistance();
      });
    }
  }

  void calculateDistance() {
    double totalDistance = 0.0;

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('Distance: $_placeDistance km');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            myLocationEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            polylines: _polylines,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(13.654794229118206, 100.49792822787104),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              widget.mapController.complete(controller);
              showMarker();
              setPolylines();
            },
          ),
        ),
      ],
    );
  }
}
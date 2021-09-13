import 'dart:async';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key}) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(
        appBarTittle: 'ค้นหาสถานที่',
      ),
      body: Stack(
        children: [
          Container(
            child: Flexible(
              flex: 15,
              child: GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(13.654785665559393, 100.49794163322552),
                  zoom: 18,
                ),
                // markers: Set<Marker>.of(locationNotifier.marker.values),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        height: 180,
        margin: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Container(
                child: Text('ที่อยู่'),
              ),
            ),
            StadiumButtonWidget(
              text: 'เลือกตำแหน่ง',
              onClicked: () {
                Navigator.pop(context);
                // userNotifier.saveUserLocation(
                //     userNotifier.userModel.uid,
                //     locationNotifier.currentAddress,
                //     locationNotifier.currentPosition);
              },
            ),
          ],
        ),
      ),
    );
  }
}

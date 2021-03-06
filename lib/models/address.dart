import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String addressId;
  String address;
  String addressName;
  String addressDetail = '';
  GeoPoint geoPoint;

  Address();

  Address.fromMap(Map<String, dynamic> data) {
    addressId = data['addressId'];
    address = data['address'];
    addressName = data['addressName'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
  }

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'address': address,
      'addressName': addressName,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint
    };
  }
}

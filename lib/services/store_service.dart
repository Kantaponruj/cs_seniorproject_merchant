import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/address.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/models/store.dart';
import 'package:cs_senior_project_merchant/notifiers/address_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class StoreService {
  String collection = "stores";

  void createUser({
    String storeId,
    String email,
    String storeName,
    String description,
    String phone,
    String typeOfStore,
    List kindOfFood,
    File localFile,
    String distance,
    String shippingfee,
  }) {
    firebaseFirestore.collection(collection).doc(storeId).set({
      'storeId': storeId,
      'email': email,
      'storeName': storeName,
      'description': description,
      'storeStatus': false,
      'typeOfStore': typeOfStore,
      'image': '',
      'phone': phone,
      'isDelivery': false,
      'kindOfFood': kindOfFood,
      'realtimeLocation': GeoPoint(0, 0),
      'selectedAddress': 'โปรดระบุสถานที่จำหน่ายสินค้า',
      'selectedAddressName': '',
      'selectedLocation': GeoPoint(0, 0),
      'distanceForOrder': distance,
      'shippingfee': shippingfee,
    });
    updateImageStore(storeId, localFile);
  }

  void updateUserData(String storeId, Map<String, dynamic> value) {
    firebaseFirestore.collection(collection).doc(storeId).update(value);
  }

  Future<Store> getUserById(String storeId) => firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .get()
      .then((doc) => Store.fromSnapshot(doc));
}

updateImageStore(String storeId, File localFile) async {
  CollectionReference storeRef = firebaseFirestore.collection('stores');

  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uudid = Uuid().v4();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('store_img/$uudid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    await storeRef.doc(storeId).update({'image': url});
    print("download url: $url");
  }
}

addDateAndTime(
  DateTimeModel dateTime,
  String storeId,
  bool isUpdating,
  Function onSaveDateTime,
) async {
  CollectionReference storeRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('openingHours');

  if (isUpdating) {
    await storeRef.doc(dateTime.docId).update(dateTime.toMap());
  } else {
    DocumentReference documentRef = await storeRef.add(dateTime.toMap());
    dateTime.docId = documentRef.id;
    await documentRef.set(dateTime.toMap(), SetOptions(merge: true));
  }
  onSaveDateTime(dateTime);
}

deleteDateAndTime(DateTimeModel dateTime, String storeId, Function onDeleted) {
  firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('openingHours')
      .doc(dateTime.docId)
      .delete();

  onDeleted(dateTime);
}

Future<void> getDateAndTime(
    DateTimeNotifier dateTimeNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('openingHours')
      .get();

  List<DateTimeModel> _dateTimeList = [];

  snapshot.docs.forEach((document) {
    DateTimeModel dateTime = DateTimeModel.fromMap(document.data());
    _dateTimeList.add(dateTime);
  });

  dateTimeNotifier.dateTimeList = _dateTimeList;
}

Future<void> getAddress(AddressNotifier addressNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('address')
      .get();

  List<Address> _addressList = [];

  snapshot.docs.forEach((document) {
    Address address = Address.fromMap(document.data());
    _addressList.add(address);
  });

  addressNotifier.addressList = _addressList;
}

saveAddress(Address address, String storeId, bool isUpdating,
    {Function addAddress}) async {
  CollectionReference addressRef =
      firebaseFirestore.collection('stores').doc(storeId).collection('address');

  if (isUpdating) {
    await addressRef.doc(address.addressId).update(address.toMap());
  } else {
    DocumentReference documentRef = await addressRef.add(address.toMap());
    address.addressId = documentRef.id;
    await documentRef.set(address.toMap(), SetOptions(merge: true));

    addAddress(address);
  }
}

deleteAddress(Address address, String storeId, Function onDeletedFood) {
  firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('address')
      .doc(address.addressId)
      .delete();

  onDeletedFood(address);
}

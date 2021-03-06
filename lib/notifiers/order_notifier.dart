import 'dart:collection';

import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:flutter/foundation.dart';

class OrderNotifier with ChangeNotifier {
  List _orderList = [];
  List<OrderMenu> _orderMenuList = [];

  OrderDetail _currentOrder;

  String _arrivableTime;
  String _distance;

  UnmodifiableListView get orderList => UnmodifiableListView(_orderList);
  UnmodifiableListView<OrderMenu> get orderMenuList =>
      UnmodifiableListView(_orderMenuList);

  OrderDetail get currentOrder => _currentOrder;

  String get arrivableTime => _arrivableTime;
  String get distance => _distance;

  set orderList(List orderList) {
    Future.delayed(Duration(seconds: 1), () {
      _orderList = orderList;
      notifyListeners();
    });
  }

  set currentOrder(OrderDetail order) {
    _currentOrder = order;
    notifyListeners();
  }

  set orderMenuList(List<OrderMenu> orderMenuList) {
    _orderMenuList = orderMenuList;
    notifyListeners();
  }

  getArrivableTime(String time) {
    _arrivableTime = time;
    notifyListeners();
  }

  getDistance(String distance) {
    _distance = distance;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/mainAppBar.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/orderDetail.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // @override
  // void initState() {
  //   StoreNotifier storeNotifier =
  //       Provider.of<StoreNotifier>(context, listen: false);
  //   OrderNotifier orderNotifier =
  //       Provider.of<OrderNotifier>(context, listen: false);
  //   getOrderDelivery(orderNotifier, storeNotifier.store.storeId);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    // final order = Provider.of<List<OrderDetail>>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        appBar: MainAppbar(
          appBarTitle: 'คำสั่งซื้อ',
        ),
        body: StreamBuilder(
            stream: firebaseFirestore
                .collection('stores')
                .doc(storeNotifier.store.storeId)
                .collection('delivery-orders')
                .orderBy('timeOrdered')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              }

              return ListView(
                children: snapshot.data.docs.map((data) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: GestureDetector(
                      onTap: () {
                        // orderNotifier.currentOrder = snapshot.data;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OrderDetailPage(storeNotifier.store.storeId),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              CollectionsColors.grey,
                                          radius: 35.0,
                                          child: Text(
                                            data['customerName'][0].toString(),
                                            style: FontCollection
                                                .descriptionTextStyle,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        data['customerName'],
                                        style: FontCollection.bodyTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(
                                          'รายละเอียด',
                                          style: FontCollection
                                              .descriptionTextStyle,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                // padding: ,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              data['dateOrdered'],
                                              textAlign: TextAlign.left,
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              data['timeOrdered'],
                                              textAlign: TextAlign.left,
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          data['netPrice'],
                                          style: TextStyle(
                                            fontFamily: NotoSansFont,
                                            fontWeight: FontWeight.w700,
                                            fontSize: bigSize,
                                            color: CollectionsColors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          ' บาท',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }

  Widget buildStoreCard(final order) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: GestureDetector(
        onTap: () {
          orderNotifier.currentOrder = order;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  OrderDetailPage(storeNotifier.store.storeId),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: CollectionsColors.grey,
                            radius: 35.0,
                            child: Text(
                              order.customerName[0].toUpperCase(),
                              style: FontCollection.descriptionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          order.customerName,
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'รายละเอียด',
                            style: FontCollection.descriptionTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  // padding: ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                order.dateOrdered,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                order.timeOrdered,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            order.netPrice,
                            style: TextStyle(
                              fontFamily: NotoSansFont,
                              fontWeight: FontWeight.w700,
                              fontSize: bigSize,
                              color: CollectionsColors.red,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            ' บาท',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget priceText(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: NotoSansFont,
          fontWeight: FontWeight.w700,
          fontSize: bigSize,
          color: CollectionsColors.red,
        ),
      ),
    );
  }
}

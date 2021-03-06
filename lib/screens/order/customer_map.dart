import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/order/orderDetail.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/map_widget.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomerMapPage extends StatefulWidget {
  CustomerMapPage({
    Key key,
    @required this.order,
    @required this.orderMenu,
  }) : super(key: key);
  final order;
  final OrderMenu orderMenu;

  @override
  _CustomerMapPageState createState() => _CustomerMapPageState();
}

class _CustomerMapPageState extends State<CustomerMapPage> {
  final panelController = PanelController();
  OrderDetail _orderDetail = OrderDetail();

  @override
  Widget build(BuildContext context) {
    OrderNotifier order = Provider.of<OrderNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          children: [
            Container(
              child: Text(
                'ระยะทาง ${order.distance} กม.',
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Container(
                child: Text(
              ' ${order.arrivableTime}นาที',
              style: FontCollection.bodyTextStyle,
            )),
          ],
        ),
      ),
      body: Stack(
        children: [
          SlidingUpPanel(
            color: Theme.of(context).backgroundColor,
            controller: panelController,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            maxHeight: 420,
            panelBuilder: (scrollController) => ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: buildSlidingPanel(order),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: MapWidget(
                order: widget.order,
                isPreview: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget buildSlidingPanel(OrderNotifier order) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    String orderStatus = 'จัดส่งเรียบร้อยแล้ว';

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        elevation: 0,
        title: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: buildDragHandle(),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Text(
                  'คำสั่งซื้อ',
                  style: FontCollection.topicTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildIconText(
                      Icons.access_time,
                      '${widget.order['timeOrdered']} น.',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => OrderDetailPage(
                              storeId: storeNotifier.store.storeId,
                              order: widget.order,
                              isConfirm: true,
                              isDelivery: true,
                              typeOrder: 'delivery-orders',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'รายละเอียดคำสั่งซื้อ',
                        style: FontCollection.underlineButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              customerInfo(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'ราคารวม',
                        style: FontCollection.topicTextStyle,
                      ),
                    ),
                    Container(
                      child: Text(
                        '${widget.order['netPrice']} บาท',
                        style: FontCollection.topicTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: StadiumButtonWidget(
                  text: 'จัดส่งเรียบร้อยแล้ว',
                  onClicked: () {
                    setState(() {
                      _orderDetail.documentId = widget.order['documentId'];
                      _orderDetail.orderId = widget.order['orderId'];
                      _orderDetail.customerId = widget.order['customerId'];
                      _orderDetail.customerName = widget.order['customerName'];
                      _orderDetail.phone = widget.order['phone'];
                      _orderDetail.address = widget.order['address'];
                      _orderDetail.addressDetail =
                          widget.order['addressDetail'];
                      _orderDetail.message = widget.order['message'];
                      _orderDetail.netPrice = widget.order['netPrice'];
                      _orderDetail.dateOrdered = widget.order['dateOrdered'];
                      _orderDetail.timeOrdered = widget.order['timeOrdered'];
                      _orderDetail.startWaitingTime =
                          widget.order['startWaitingTime'];
                      _orderDetail.endWaitingTime =
                          widget.order['endWaitingTime'];
                      _orderDetail.amountOfMenu = widget.order['amountOfMenu'];
                      _orderDetail.geoPoint = widget.order['geoPoint'];
                      _orderDetail.typeOrder = widget.order['typeOrder'];
                    });

                    updateStatusOrder(
                      widget.order['customerId'],
                      widget.order['storeId'],
                      widget.order['orderId'],
                      widget.order['documentId'],
                      orderStatus,
                      'delivery-orders',
                    );

                    saveOrderToHistory(
                      storeNotifier.store.storeId,
                      _orderDetail,
                    );
                    saveOrderMenuToHistory(
                      storeNotifier.store.storeId,
                      widget.orderMenu,
                    );
                    completedOrder(
                      storeNotifier.store.storeId,
                      widget.order['documentId'],
                      'delivery-orders',
                    );

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainBottombar()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconText(IconData icon, String text) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Icon(icon),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: FontCollection.topicTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  final height = 60.0;
  final width = 60.0;

  Widget customerInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userPicAndName(),
          Container(
            width: width,
            height: height,
            child: MaterialButton(
              color: CollectionsColors.yellow,
              textColor: Colors.white,
              child: Icon(
                Icons.call,
              ),
              shape: CircleBorder(),
              onPressed: () async {
                String number = widget.order['phone'];
                await FlutterPhoneDirectCaller.callNumber(number);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget userPicAndName() {
    return Container(
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: CollectionsColors.yellow,
              radius: height,
              child: Text(
                widget.order['customerName'][0],
                style: FontCollection.descriptionTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              widget.order['customerName'],
              style: FontCollection.bodyTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

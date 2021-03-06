import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/menu/add_menu.dart';
import 'package:cs_senior_project_merchant/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final controller = ScrollController();

  @override
  void initState() {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getMenu(menuNotfier, storeNotifier.store.storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTittle: 'รายละเอียดรายการอาหาร',
        ),
        body: Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: buildHorizontalListView(menuNotfier.categoriesList),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: menuNotfier.categoriesList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return menuCategories(
                              menuNotfier.categoriesList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            menuNotfier.currentMenu = null;
            menuNotfier.toppingList.clear();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddMenuPage(isUpdating: false),
            ));
          },
          backgroundColor: CollectionsColors.orange,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildHorizontalListView(List<String> categories) => ListView.builder(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
              categories[index],
              style: FontCollection.topicBoldTextStyle,
            ),
          );
        },
      );

  Widget menuCategories(String categoryName) => BuildCard(
        headerText: categoryName,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: gridView(categoryName),
        ),
        canEdit: false,
      );

  Widget gridView(String categoryName) {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context);

    List<dynamic> menuCategory = [];

    menuNotfier.menuList.forEach((menu) {
      if (menu.categoryFood == categoryName) {
        menuCategory.add(menu);
      }
    });

    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 5,
          crossAxisSpacing: 15,
        ),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        controller: controller,
        itemCount: menuCategory.length,
        itemBuilder: (context, index) {
          Menu menu = menuCategory[index];
          return menuData(menu, menuNotfier);
        },
      ),
    );
  }

  Widget menuData(Menu menu, MenuNotfier menuNotfier) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            menuNotfier.currentMenu = menu;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddMenuPage(isUpdating: true),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            width: 150,
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: SizedBox(
                    child: menu.image != null
                        ? Image.network(
                            menu.image,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.asset(
                                'assets/images/default-photo.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Image.asset(
                            'assets/images/default-photo.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: AutoSizeText(
                    menu.name,
                    textAlign: TextAlign.left,
                    style: FontCollection.bodyTextStyle,
                    maxLines: 1,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    menu.price + ' บาท',
                    textAlign: TextAlign.left,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Menu {
  String menuId;
  String name;
  String description;
  String price;
  String image;
  String categoryFood;
  bool haveMenu = false;

  Menu();

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'categoryFood': categoryFood,
      'haveMenu': haveMenu
    };
  }

  Menu.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    name = data['name'];
    description = data['description'];
    price = data['price'];
    image = data['image'];
    categoryFood = data['categoryFood'];
    haveMenu = data['haveMenu'];
  }
}

class Topping {
  String toppingId;
  String type;
  String selectedNumberTopping;
  String topic;
  String detail;
  bool require = false;
  List<dynamic> subTopping;

  Topping({
    this.toppingId,
    this.type,
    this.selectedNumberTopping,
    this.topic,
    this.detail,
    this.subTopping,
    this.require,
  });

  @override
  String toString() {
    return '{ ${this.toppingId}, ${this.type}, ${this.selectedNumberTopping}, ${this.topic}, ${this.detail}, ${this.subTopping}, ${this.require} }';
  }

  Map<String, dynamic> toMap() {
    return {
      'toppingId': toppingId,
      'type': type,
      'selectedNumberTopping': selectedNumberTopping,
      'topic': topic,
      'detail': detail,
      'subTopping': subTopping,
      'require': require,
    };
  }

  Topping.fromMap(Map<String, dynamic> data) {
    toppingId = data['toppingId'];
    type = data['type'];
    selectedNumberTopping = data['selectedNumberTopping'];
    topic = data['topic'];
    detail = data['detail'];
    subTopping = data['subTopping'];
    require = data['require'];
  }
}

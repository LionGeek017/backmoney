import 'dart:convert';
import 'package:backmoney/check_internet.dart';
import 'package:backmoney/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_manager.dart';
import 'nav_left.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

final dataUserStorage = new FlutterSecureStorage();
Map<String, String> dataUserMap = {};
int categoryId = 0;
bool userAuth = false;
var dataUserAuthorization;
final categoriesGetUrl = '/api-application/categories';
final shopsGetUrl = '/api-application/shops';
var categoriesJson;
var shopsJson;
bool internet = true;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  void startCheckInternet() {
    checkInternet().then((response) {
      if(internet != response) {
        setState(() => internet = response);
      }
    });
  }

  final GlobalKey<RefreshIndicatorState> _globalKey = new GlobalKey<RefreshIndicatorState>();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        launch('https://play.google.com/store/apps/details?id=smartoboi.smart_oboi');
        break;

      case 1:
        launch('https://' + siteUrl);
        break;
    }
  }

  void restart() {
    setState(() {
      categoriesJson = null;
      shopsJson = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    startCheckInternet();

    // Проверяем юзера
    userCheck();
    // Получаем категории
    queryCategories();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        //brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          'BackMoney.net'
        ),
        backgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text('Проверить обновления'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Сайт BackMoney'),
              )
            ],
          )
        ]
      ),
      body: RefreshIndicator(
        key: _globalKey,
        onRefresh: () async {
          restart();
        },
        child: internet ? HomeContent() : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "Проверь подключение к Internet"
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    restart();
                  },
                  child: Text(
                      "Обновить"
                  ),
                )
              ],
            )
        ),
      ),
      drawer: Drawer(
        child: CategoryLeft(),
      ),
    );
  }

  // Загрузка категорий
  queryCategories() {
    if(categoriesJson == null) {
      APIManagerGet apiManager = new APIManagerGet();
      apiManager.getQuery(categoriesGetUrl).then((response) {
        print('Получаем категории');
        final jsonDecodeString = json.decode(response.body.toString());
        setState(() {
          categoriesJson = jsonDecodeString;
        });
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  // Проверяем юзера
  userCheck() async {
    if(dataUserAuthorization != null) {
      print('Write');
      writeDataUser();
    } else if(dataUserMap.length == 0) {
      print('Check');
      final userId = await dataUserStorage.read(key: "user_id");
      if(userId != null) {
        writeDataUserStorage(await dataUserStorage.readAll());
      } else {
        print('No User');
        dataUserMap.addAll({"user_id" : null});
      }
    }
  }

  // Запись данных юзера в хранилище
  writeDataUser() async {
    await dataUserStorage.write(key: "user_id", value: dataUserAuthorization['user_id'].toString());
    await dataUserStorage.write(key: "user_email", value: dataUserAuthorization['user_email']);
    await dataUserStorage.write(key: "user_balance", value: dataUserAuthorization['user_balance'].toString());
    await dataUserStorage.write(key: "user_reserve", value: dataUserAuthorization['user_reserve'].toString());
    await dataUserStorage.write(key: "user_currency", value: dataUserAuthorization['user_currency'].toString());
    await dataUserStorage.write(key: "user_token", value: dataUserAuthorization['user_token']);
    writeDataUserStorage(dataUserAuthorization);
  }

  // Запись данных юзера в переменную
  writeDataUserStorage(data) {
    setState(() {
      dataUserMap.addAll({
        "user_id" : data['user_id'].toString(),
        "user_token" : data['user_token'],
        "user_email" : data['user_email'],
        "user_balance" : data['user_balance'].toString(),
        "user_reserve" : data['user_reserve'].toString(),
        "user_currency" : data['user_currency']
      });
      dataUserAuthorization = null;
    });
  }
}

class HomeContent extends StatefulWidget {
  @override
  HomeContentState createState() {
    return new HomeContentState();
  }
}

class HomeContentState extends State<HomeContent> {

  @override
  Widget build(BuildContext context) {

    if(shopsJson == null) {
      queryShops();
      return Stack(
        children: [
          ListView(),
          Center(
            child: Text('Загружаем магазины ...'),
          )
        ],
      );
    } else {
      return GridView(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
        ),
        children: dataShops(),
      );
    }
  }

  // Формируем список магазинов
  List dataShops() {
    List<Widget> listShops = <Widget>[];
    final int shopsLength = shopsJson['count'];
    for(int i = 0; i < shopsLength; i++) {
      var shopData = shopsJson['data'][i];
      listShops.add(ShopCard(shopJson: shopData));
      // listShops.add(ShopCard(
      //   shopId: shopData['id'],
      //   shopIndex: i,
      //   shopImgUrl: shopData['url_img'],
      //   shopCash: shopData['cash'].toString(),
      //   shopCurrency: shopData['currency'],
      // ));
    }
    return listShops;
  }

  // Загрузка магазинов
  queryShops() {
    //Map<String, dynamic> params = {};
    String finalUrl = shopsGetUrl;
    if(categoryId > 0) {
      finalUrl = shopsGetUrl + '/category=$categoryId';
    }
    APIManagerGet apiManager = new APIManagerGet();
    apiManager.getQuery(finalUrl).then((response) {
      print('Получаем магазины');
      final jsonDecodeString = json.decode(response.body.toString());
      setState(() {
        shopsJson = jsonDecodeString;
      });
    }).catchError((onError) {
      print(onError);
    });
  }
}

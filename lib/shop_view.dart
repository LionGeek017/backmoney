import 'package:backmoney/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'home.dart';

import 'dialog_windows.dart';

ShopData shopData;

class ShopView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    shopData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'BackMoney.net'
        ),
        backgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
      ),
      body: shopContent(context),
    );
  }

  Widget shopContent(context) {

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: new FadeInImage(
                placeholder: AssetImage(
                    'assets/images/loading.gif'
                ),
                image: NetworkImage(shopData.shopJson['url_img']),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Colors.yellow[50],
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      shopData.shopJson['name'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    'кэшбэк',
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          shopData.shopJson['to_cash'] > 0 ? 'до ' : '',
                          style: TextStyle(
                              fontSize: 12,
                          ),
                        ),
                        Text(
                          shopData.shopJson['cash'].toString() + ' ' + shopData.shopJson['currency'],
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.red[900]
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Html(data: shopData.shopJson['conditions']),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(20)
              ),
              child:InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final shopId = shopData.shopJson['id'].toString();
                  final userId = dataUserMap['user_id'];
                  if(userId != null) {
                    final goShopMess = 'Кэшбэк успешно активирован! Хотите перейти на ' + shopData.shopJson['name'] + ', сделать покупку и получить с нее кэшбэк?';
                    final data = {
                      "title" : "Переход на " + shopData.shopJson['name'],
                      "mess" : goShopMess,
                      "url" : "/api-application/go-shop/shop-id=" + shopId + "/user-id=" + userId + "/token=" + dataUserMap['user_token']
                    };
                    dialogWindows(context, data);
                  } else {
                    Navigator.pushReplacementNamed(context, '/registration');
                  }
                },
                child: Text(
                  'Активировать кэшбэк',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
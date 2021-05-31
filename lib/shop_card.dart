import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {

  //const ShopCard({Key key, this.shopId, this.shopIndex, this.shopImgUrl, this.shopCash, this.shopCurrency}) : super(key: key);
  const ShopCard({Key key, this.shopJson}) : super(key: key);

  final shopJson;
  // final int shopId;
  // final int shopIndex;
  // final String shopImgUrl;
  // final String shopCash;
  // final String shopCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: Colors.green[200]
      ),
      child: InkWell(
        onTap: () {
          ShopData shopData = ShopData(shopJson:shopJson);
          Navigator.pushNamed(
            context,
            '/shop_view',
            arguments: shopData
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.all(5),
                child: new FadeInImage(
                  placeholder: AssetImage(
                    'assets/images/loading.gif'
                  ),
                  image: NetworkImage(shopJson['url_img']),
                  //fit: BoxFit.cover,
                ),
              ),
              // Container(
              //   height: 70,
              //   padding: EdgeInsets.all(5),
              //   child: new FadeInImage.memoryNetwork(
              //     placeholder: kTransparentImage,
              //     image: shopImgUrl,
              //     //fit: BoxFit.cover,
              //   ),
              // ),
              Container(
                //margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'кэшбэк',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      shopJson['to_cash'] > 0 ? 'до ' : '',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54
                      ),
                    ),
                    Text(
                      shopJson['cash'].toString() + ' ' + shopJson['currency'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[900]
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ShopData {
  final shopJson;
  ShopData({this.shopJson});
}
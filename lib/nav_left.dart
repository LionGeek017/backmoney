import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialog_windows.dart';
import 'home.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Map _dataUser;

String
  profile = 'Сейчас будет перенаправление на основной сайт сервиса для просмотра и редактирования твоего профиля.',
  payment = 'Сейчас будет перенаправление на основной сайт сервиса для заказа выплаты и просмотра истории выплат кэшбэка.',
  purchase = 'Сейчас будет перенаправление на основной сайт сервиса для просмотра истории твоих покупок.',
  faq = 'Сейчас будет перенаправление на основной сайт сервиса для просмотра частозадаваемых вопросов и ответов на них.';

class CategoryLeft extends StatefulWidget {

  @override
  CategoryLeftState createState() {
    return new CategoryLeftState();
  }
}

class CategoryLeftState extends State<CategoryLeft> {

  // @override
  // initState() {
  //   super.initState();
  //   _dataUser = widget.dataUser;
  // }

  Widget titleWidget(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget categoryCard(int index, int id, String title, String picture) {

    Widget picture;
    if(picture != null) {
      picture = Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
                image: Image.network("https://backmoney.net/img/images/$picture").image,
                fit: BoxFit.cover
            )
        ),
      );
    } else {
      picture = Container(
        width: 66,
        height: 50,
        child: Icon(
          Icons.shop_outlined,
          color: Colors.green[400],
          size: 25,
        ),
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          shopsJson = null;
          categoryId = id;
        });
        //Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Row(
        children: <Widget>[
          picture,
          titleWidget(title),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }

  List navContent() {
    // Проверяем юзера
    //userCheck();

    // Список виджетов категорий
    List<Widget> navLinks;

    if(dataUserMap.length > 0 && dataUserMap['user_id'] != null) {
      navLinks = <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Мой ID: ' + dataUserMap['user_id'],
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              Text(
                dataUserMap['user_email'],
                style: TextStyle(
                    color: Colors.white
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900],
          ),
        ),
        InkWell(
          onTap: () {
            final data = {"mess" : profile, "url" : "/api-application/auth/user-id=" + dataUserMap['user_id'] + '/token=' + dataUserMap['user_token']};
            dialogWindows(context, data);
            //Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 66,
                height: 50,
                child: Icon(
                  Icons.edit,
                  color: Colors.black54,
                  size: 25,
                ),
              ),
              titleWidget('Редактировать профиль'),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 66,
              height: 50,
              child: Icon(
                Icons.attach_money,
                color: Colors.black54,
                size: 25,
              ),
            ),
            titleWidget('Баланс: ' + dataUserMap['user_balance'] + ' ' + dataUserMap['user_currency']),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: 66,
              height: 50,
              child: Icon(
                Icons.attach_money,
                color: Colors.black54,
                size: 25,
              ),
            ),
            titleWidget('Ожидает: ' + dataUserMap['user_reserve'] + ' ' + dataUserMap['user_currency']),
          ],
        ),
        InkWell(
          onTap: () {
            final data = {"mess" : payment, "url" : "/api-application/auth/user-id=" + dataUserMap['user_id'] + '/token=' + dataUserMap['user_token']};
            dialogWindows(context, data);
            //Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 66,
                height: 50,
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.black54,
                  size: 25,
                ),
              ),
              titleWidget('Выплаты'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            final data = {"mess" : purchase, "url" : "/api-application/auth/user-id=" + dataUserMap['user_id'] + '/token=' + dataUserMap['user_token']};
            dialogWindows(context, data);
            //Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 66,
                height: 50,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black54,
                  size: 25,
                ),
              ),
              titleWidget('Покупки'),
            ],
          ),
        ),
        Container(
          child: Divider(),
        )
      ];
    } else {
      navLinks = <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black87
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 240,
                margin: EdgeInsets.only(bottom: 15),
                child: SvgPicture.asset(
                  'assets/images/logo_top.svg'
                ),
              ),
              // Container(
              //   width: 186,
              //   height: 34,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: Image.asset('assets/images/logo_site.png').image,
              //       fit: BoxFit.cover
              //     )
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/authorization');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.cyan[100],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        'Войти',
                        style: TextStyle(
                          color: Colors.black87
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/registration');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        'Регистрация',
                        style: TextStyle(
                            color: Colors.black87
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ];
    }

    navLinks.add(categoryCard(0, 0, 'Все магазины', null));

    // список категорий
    if(categoriesJson != null) {
      final categoriesData = categoriesJson['data'];
      final categoriesLength = categoriesData.length;

      for(int i = 0; i < categoriesLength; i++) {
        var category = categoriesData[i];
        navLinks.add(categoryCard(i, category["id"], category["name"], category["picture"] ?? null));
        //navLinks.add(categoryCard(i, category['id'], category["name"], category["picture"] ?? null,));
      }
    }

    navLinks.add(
        Container(
          child: Divider(),
        )
    );
    navLinks.add(
        InkWell(
          onTap: () {
            final data = {"mess" : faq, "url" : "/faq"};
            dialogWindows(context, data);
            //Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 66,
                height: 50,
                child: Icon(
                  Icons.question_answer_outlined,
                  color: Colors.black54,
                  size: 25,
                ),
              ),
              titleWidget('FAQ'),
            ],
          ),
        )
    );

    if(dataUserMap.length > 0 && dataUserMap['user_id'] != null) {
      navLinks.add(
          InkWell(
            onTap: () async {
              //final writeToken = await storageUser.write(key: "token", value: jsonDecodeString['user_token']);
              //final writeUserId = await storageUser.write(key: "user_id", value: jsonDecodeString['user_id']);
              await dataUserStorage.deleteAll();
              dataUserMap = {};
              Navigator.pushReplacementNamed(context, '/');
              //Navigator.pop(context);
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 66,
                  height: 50,
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.black54,
                    size: 25,
                  ),
                ),
                titleWidget('Выйти с аккаунта'),
              ],
            ),
          )
      );
    }

    return navLinks;
  }

  @override
  Widget build(BuildContext context) {



    return ListView(
      padding: EdgeInsets.zero,
      children: navContent(),
    );
  }


}
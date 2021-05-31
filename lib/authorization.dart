import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_manager.dart';
import 'check_internet.dart';
import 'dialog_windows.dart';
import 'home.dart';
String
    emailUser,
    passUser,
    remindPass = 'Сейчас будет перенаправление на основной сайт сервиса для восстановления пароля от твоего аккаунта.';

class AuthorizationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            );
          },
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pushReplacementNamed(context, '/');
        //     },
        //   ),
        // ],
        centerTitle: true,
        title: Text(
          'Вход в аккаунт',
          style: TextStyle(

          ),
        ),
      ),
      body: AuthorizationContent()
    );
  }
}

class AuthorizationContent extends StatefulWidget {
  @override
  AuthorizationContentState createState() {
    return new AuthorizationContentState();
  }
}

class AuthorizationContentState extends State<AuthorizationContent> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: new Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Для того чтоб кэшбэк был начислен именно тебе, войди в свой аккаунт',
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Твой E-mail',
                        // border: new OutlineInputBorder(
                        //     borderRadius: new BorderRadius.circular(25),
                        //     borderSide: new BorderSide()
                        // )
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Введи свой E-mail';
                      }
                      if(!value.contains('@')) {
                        return 'Это не E-mail';
                      }
                      setState(() => emailUser = value);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: new TextFormField(
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: 'Пароль',
                        // border: new OutlineInputBorder(
                        //     borderRadius: new BorderRadius.circular(25),
                        //     borderSide: new BorderSide()
                        // )
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Введи пароль';
                      }
                      setState(() => passUser = value);
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    Color color = Colors.red;
                    String mess;

                    if(!_formKey.currentState.validate()) {
                      mess = 'Заполнены не все поля!';
                    } else {
                      mess = 'Авторизуемся ...';
                      color = Colors.green;
                      getAuthorizationUser();
                    }
                    snackBarResult(mess, color);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.cyan[300],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Войти',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(30),
                  color: Colors.orange[50],
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          //margin: EdgeInsets.only(top: 30),
                          child: Text(
                            'Забыл пароль?',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            final data = {"mess" : remindPass, "url" : "/api-application/reset"};
                            dialogWindows(context, data);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.pink[200],
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Выслать пароль на почту',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                Icon(
                                  Icons.mail_outline,
                                  color: Colors.white,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  void getAuthorizationUser() {
    APIManagerPost apiManager = new APIManagerPost();
    String url = '/api-application/authorization';
    var params = {"email" : emailUser, "pass" : passUser};

    checkInternet().then((response) {
      if(response) {
        apiManager.getQuery(url, params).then((response) async {
          if(response != false) {
            final jsonDecodeString = json.decode(response.body.toString());
            if(jsonDecodeString['status'] == true) {
              dataUserAuthorization = jsonDecodeString;

              Navigator.pushReplacementNamed(context, '/');
              //snackBarResult(jsonDecodeString['mess'], Colors.green);
            } else {
              snackBarResult(jsonDecodeString['mess'], Colors.red);
            }
          } else {
            snackBarResult('Что-то пошло не так, перезапусти приложение', Colors.red);
          }
          //categoriesJson = jsonDecodeString;
        }).catchError((onError) {
          print(onError);
        });
      } else {
        snackBarResult('Проверь подключение к Internet', Colors.red);
      }
    });
  }

  void snackBarResult(String text, Color color) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: color,));
  }
}
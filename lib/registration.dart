import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_manager.dart';
import 'check_internet.dart';
import 'home.dart';

var countryCurrentList = {"rub" : "rub", "uah" : "uah", "usd" : "usd"};
String
  countryCurrent,
  emailUser,
  passUser;


class RegistrationPage extends StatelessWidget {
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
          centerTitle: true,
          title: Text(
              'Регистрация'
          ),
        ),
        body: RegistrationContent()
    );
  }
}

class RegistrationContent extends StatefulWidget {
  @override
  RegistrationContentState createState() {
    return new RegistrationContentState();
  }
}

class RegistrationContentState extends State<RegistrationContent> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: new Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Твой E-mail',
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25),
                            borderSide: new BorderSide()
                        )
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Введите свой E-mail';
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
                        labelText: 'Придумай пароль',
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25),
                            borderSide: new BorderSide()
                        )
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
                Center(
                  child: Text(
                    'Выбери свою страну и валюту',
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ),
                Container(
                  child: new RadioListTile(
                      title: const Text(
                        'Россия (RUB)',
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                      value: countryCurrentList['rub'],
                      groupValue: countryCurrent,
                      onChanged: (value) {
                        setState(() => countryCurrent = value);
                      }
                  ),
                ),
                Container(
                  child: new RadioListTile(
                      title: const Text(
                          'Украина (UAH)',
                          style: TextStyle(
                              fontSize: 14
                          )
                      ),
                      value: countryCurrentList['uah'],
                      groupValue: countryCurrent,
                      onChanged: (value) {
                        setState(() => countryCurrent = value);
                      }
                  ),
                ),
                Container(
                  child: new RadioListTile(
                      title: const Text(
                          'Другая страна (USD)',
                          style: TextStyle(
                              fontSize: 14
                          )
                      ),
                      value: countryCurrentList['usd'],
                      groupValue: countryCurrent,
                      onChanged: (value) {
                        setState(() => countryCurrent = value);
                      }
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Color color = Colors.red;
                      String mess;

                      if(countryCurrent == null) {
                        mess = 'Выбери страну и валюту';
                      } else if(!_formKey.currentState.validate()) {
                        mess = 'Заполнены не все поля!';
                      } else {
                        mess = 'Регистрируем ...';
                        color = Colors.green;
                        getRegistrationUser();
                      }
                      snackBarResult(mess, color);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Создать аккаунт',
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
                            'Уже есть аккаунт?',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/authorization');
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
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  void getRegistrationUser() {

    checkInternet().then((response) {
      if(response) {
        APIManagerPost apiManager = new APIManagerPost();
        String url = '/api-application/registration';
        var params = {"email" : emailUser, "pass" : passUser, "country" : countryCurrent};
        apiManager.getQuery(url, params).then((response) async {
          if(response != false) {
            final jsonDecodeString = json.decode(response.body.toString());

            print(jsonDecodeString);

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


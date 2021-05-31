import 'package:http/http.dart' as http;
final String protocol = 'https://';
final String siteUrl = 'backmoney.net';

class APIManagerGet {
  Future<dynamic> getQuery(String getUrl) async {
    var responseJson;

    final uri = Uri.https(siteUrl, getUrl);//.replace(queryParameters: getParams);
    final headers = {
      'Accept' : 'application/json'
    };

    try{
      final response = await http.get(uri, headers: headers);
      responseJson = responseCheck(response);
      return responseJson;
    } catch(error) {
      return false;
    }

  }

  dynamic responseCheck(http.Response response) {
    return response;
  }
}

class APIManagerPost {
  Future<dynamic> getQuery(String getUrl, postParams) async {
    var responseJson;

    final uri = Uri.https(siteUrl, getUrl);
    final headers = {
      'Accept' : 'application/json'
    };

    try {
      final response = await http.post(uri, body: postParams, headers: headers);
      responseJson = responseCheck(response);
      return responseJson;
    } catch(error) {
      return false;
    }
  }

  dynamic responseCheck(http.Response response) {
    return response;
  }
}
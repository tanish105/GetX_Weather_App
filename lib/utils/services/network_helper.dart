import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    Response res = await http.get(Uri.parse(url));
    String data = res.body;
    var d = jsonDecode(data);

    if(res.statusCode==200){
      return d;
    }
    else{
      print(res.statusCode);
    }
  }
}

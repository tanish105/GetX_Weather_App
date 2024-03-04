import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/services/response.dart';
import '../../../utils/services/location.dart';

class loadingController {
  String apiKey = dotenv.env['API_KEY']!; //add your api key
  String url = "https://api.openweathermap.org/data/2.5/weather";
  bool loading = true;

  Future<ResponseType> getLocationData() async{
    Location location = Location();
    await location.getPosition();

    try{
      var res = await http.get(Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric'));
      String data = res.body;
      var d = jsonDecode(data);

      if(res.statusCode==200){
        ResponseType result = ResponseType(responseEnum: ResponseEnum.success, data: d);
        loading = false;
        return result;
      }
      else{
        ResponseType result = ResponseType(responseEnum: ResponseEnum.failed, data: d);
        print(res.statusCode);
        return result;
      }
    }catch(err){
      ResponseType result = ResponseType(responseEnum: ResponseEnum.error, data: err);
      return result;
    }

  }
}
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../utils/services/location.dart';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class LocatingScreenController {
  RxInt temperature = 0.obs;
  RxString cityName = "".obs;
  RxString weatherIcon = "".obs;
  RxString message = "".obs;
  WeatherModel weather = WeatherModel();

  RxBool loading = false.obs;

  String apiKey = dotenv.env['API_KEY']!;//add your api key
  String url = "https://api.openweathermap.org/data/2.5/weather";

  Future<void> getLocationData() async {
    loading.value = true;
    try {
      Location location = Location();
      await location.getPosition();

      var response = await http.get(Uri.parse(
          '$url?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data == null || data['main'] == null || data['weather'] == null) {
          resetData();
          return;
        }

        double temp = data['main']['temp'];
        temperature.value = temp.toInt();
        var condition = data['weather'][0]['id'];
        cityName.value = data['name'];

        weatherIcon.value = weather.getWeatherIcon(condition);
        message.value = weather.getMessage(temperature.value);

        loading.value = false;
        print("Success Buddy Success!!");
      } else {
        resetData();
        loading.value = false;
        print("Not Success Buddy Not Success!!");
      }
    } catch (error) {
      resetData();
      print(error);
      loading.value = false;
      print("Error Buddy Not Error!!");
    }
  }

  Future<void> getCityWeather(String city) async {
    loading.value = true;
    try {
      Location location = Location();
      await location.getPosition();

      var response = await http.get(Uri.parse(
          '$url?q=$city&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data == null || data['main'] == null || data['weather'] == null) {
          resetData();
          return;
        }

        double temp = data['main']['temp'];
        temperature.value = temp.toInt();
        var condition = data['weather'][0]['id'];
        cityName.value = data['name'];

        weatherIcon.value = weather.getWeatherIcon(condition);
        message.value = weather.getMessage(temperature.value);

        loading.value = false;
        print("Success Buddy Success!!");
      } else {
        resetData();
        loading.value = false;
        print("Not Success Buddy Not Success!!");
      }
    } catch (error) {
      resetData();
      print(error);
      loading.value = false;
      print("Error Buddy Not Error!!");
    }
  }

  void resetData() {
    temperature.value = 0;
    weatherIcon.value = "Error";
    message.value = "Unable to get weather";
    cityName.value = '';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:weather_app/screens/locating_screen/controller/locating_screen_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../city_screen/view/city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.locationWeather,super.key});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  LocatingScreenController controller = Get.put(LocatingScreenController());

  @override
  void initState() {
    super.initState();
    controller = Get.put(LocatingScreenController());
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData){

    if(weatherData == null){

      controller.temperature.value = 0;
      controller.weatherIcon.value = "Error";
      controller.message.value = "Unable to get weather";
      controller.cityName.value = '';
      return;
    }

    double temp = weatherData['main']['temp'];
    controller.temperature.value = temp.toInt();
    var condition = weatherData['weather'][0]['id'];
    controller.cityName.value = weatherData['name'];

    controller.weatherIcon.value = controller.weather.getWeatherIcon(condition);
    controller.message.value = controller.weather.getMessage(controller.temperature.value);

    print(controller.temperature.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: controller.loading.value?Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,),):
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await controller.getLocationData();
                      },
                      child: const Icon(
                        Icons.near_me,
                        color: Colors.lightBlueAccent,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context)=>const CityScreen()));
                        print(typedName);
                        await controller.getCityWeather(typedName);
                      },
                      child: const Icon(
                        Icons.location_city,
                        color: Colors.lightBlueAccent,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${controller.temperature.value}°',
                          style: kTempTextStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          controller.weatherIcon.value,
                          style: kConditionTextStyle,
                        ),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    "${controller.message.value} in ${controller.cityName.value}!",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

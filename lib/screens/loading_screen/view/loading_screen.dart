import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/loading_screen/controller/controller.dart';
import 'package:weather_app/utils/services/response.dart';

import '../../locating_screen/view/location_screen.dart';

var APIkey = dotenv.env['API_KEY']!;//add your api key
double longitude = 0.0;
double latitude = 0.0;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}


class _LoadingScreenState extends State<LoadingScreen> {

  void getLocationData() async
  {
      loadingController controller = loadingController();
      ResponseType result = await controller.getLocationData();

      if(result.responseEnum==ResponseEnum.success){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return LocationScreen(locationWeather: result.data);
        }));
    }else{
        Get.snackbar(
            "Warning", "Error, Reopen App!!",
            snackPosition: SnackPosition.BOTTOM
        );
      }
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color:  Colors.blueAccent,
          size: 100,
        ),
      ),
    );
  }
}
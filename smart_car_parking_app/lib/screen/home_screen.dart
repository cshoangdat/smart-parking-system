import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_car_parking_app/constants/size.dart';
import 'package:smart_car_parking_app/screen/manage_screen.dart';
import 'package:smart_car_parking_app/screen/pick_up_screen.dart';
import 'package:smart_car_parking_app/screen/register_screen.dart';
import 'package:smart_car_parking_app/widget/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 300.w,
              height: 300.h,
              child: Image.asset(
                "images/sport-car.png",
                // scale: 0.52.h,
                fit: BoxFit.fill,
                // opacity: const AlwaysStoppedAnimation(.5),
              ),
            ),
          ),
          Text(
            "Smart Parking System",
            style: TextStyle(
              fontSize: headSize,
            ),
          ),
          Gap(50.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding + 8.h),
            child: customButton(
              80.w, 60.h, "Register a new vehicle", (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  (Route<dynamic> route) => false,
                );
              }, context
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding + 8.h),
            child: customButton(
              80.w, 60.h, "Pick up the vehicle", (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const PickUpScreen()),
                  (Route<dynamic> route) => false,
                );
              }, context
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding + 8.h),
            child: customButton(
              80.w, 60.h, "Manage parking lot", (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageScreen()),
                  (Route<dynamic> route) => false,
                );
              }, context
            ),
          ),
        ],
      ),
    );
  }
}
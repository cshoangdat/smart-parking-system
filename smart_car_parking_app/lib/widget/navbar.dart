// Copyright 2024 VinCSS JSC. All rights reserved.
//
// Filename: lib/widget/navbar.dart
// Author: datht
// Created: 12/07/2024 13:00:00 +07:00

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_car_parking_app/constants/size.dart';
import 'package:smart_car_parking_app/screen/home_screen.dart';
import 'package:smart_car_parking_app/screen/manage_screen.dart';
import 'package:smart_car_parking_app/screen/pick_up_screen.dart';
import 'package:smart_car_parking_app/screen/register_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
    width: 250.w,
    backgroundColor: Theme.of(context).colorScheme.primary,
     child: ListView(
      children: [
        // const Gap(homeSizedHeight),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 80.h,
              child: DrawerHeader(
                child: Row(
                  children: [
                    SizedBox(child: Image.asset("images/logo.png")),
                    SizedBox(width: 5.w,),
                    Text("Smart Parking")
                  ],
                ),
              ),
            ),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.home, ),
          title: const Text("Home"),
          onTap: (){
            MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const HomeScreen());
            Navigator.of(context).push(route);            
          },
        ),
        ListTile(
          leading: const Icon(Icons.app_registration_rounded),
          title: const Text("Register vehicle"),
          onTap: (){
            MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const RegisterScreen());
            Navigator.of(context).push(route);             
          },
        ),
        ListTile(
          leading: const Icon(Icons.drive_eta),
          title: const Text("Pick Up vehicle"),
          onTap: (){
            MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const PickUpScreen());
            Navigator.of(context).push(route);             
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_parking),
          title: const Text("Manage Parking Lot"),
          onTap: (){
            MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const ManageScreen());
            Navigator.of(context).push(route);             
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.info, ),
        //   title: const Text("About"),
        //   onTap: (){
        //     MaterialPageRoute route = MaterialPageRoute(
        //         builder: (context) => const AboutScreen());
        //     Navigator.of(context).push(route);            
        //   },
        // ),
        Gap(homeSizedHeight),
      ],
     ),       
    );
  }
}
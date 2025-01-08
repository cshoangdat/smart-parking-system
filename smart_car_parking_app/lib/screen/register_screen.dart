import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_car_parking_app/constants/size.dart';
import 'package:smart_car_parking_app/http_services.dart';
import 'package:smart_car_parking_app/screen/home_screen.dart';
import 'package:smart_car_parking_app/widget/button_widget.dart';
import 'package:smart_car_parking_app/widget/common.dart';
import 'package:smart_car_parking_app/widget/navbar.dart';

import 'package:http/http.dart' as http;


class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime date = DateTime.now();

  String getText() {
    return DateFormat('dd/MM/yyyy').format(date);
    // return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'Date',
        text: getText(),
        onClicked: () => pickDate(context),
      );

  Future pickDate(BuildContext context) async {
    // final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _plateNumberController = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay initialTime = TimeOfDay(hour: 8, minute: 0);
  String selectedPlace = "A1";

  final httpClient = HttpClientService(
    schema: 'http',
    host: "172.20.10.2",
    inner: TrustAllCertificates().sslClient()
  );

  String getDate() {
    return DateFormat('dd/MM/yyyy').format(date);
    // return '${date.month}/${date.day}/${date.year}';
  }

  String getTime(bool isStartTime) {
    return isStartTime ? '${startTime.hour}:${startTime.minute}' : '${endTime.hour}:${endTime.minute}';
  }

  Future pickDate(BuildContext context) async {
    // final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickTime(BuildContext context, bool isStartTime) async{
    final newTime = await showTimePicker(
      context: context, initialTime: initialTime
    );
    if (newTime == null) return;
    if(isStartTime){
      setState(() => startTime = newTime);
    }
    else{
      setState(() => endTime = newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            "Smart Parking System",
            style: TextStyle(
              fontSize: 20.sp
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 300.w,
                    height: 300.h,
                    child: Image.asset(
                      "images/spaces.png",
                      // scale: 0.52.h,
                      fit: BoxFit.fill,
                      // opacity: const AlwaysStoppedAnimation(.5),
                    ),
                  ),
                ),
                SizedBox(height: 30.h,),
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      const WidgetSpan(
                          child: Text(
                        "Plate Numbers: ",
                      )),
                      WidgetSpan(
                          child: SizedBox(
                            width: 200.w,
                            child: TextSelectionTheme(
                              data:
                                  const TextSelectionThemeData(
                                      selectionColor:
                                          Colors.blue,
                                      selectionHandleColor:
                                          Colors.blue),
                              child: TextField(
                                onChanged: (value) async {
                                },
                                // keyboardType:
                                //     TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                                ],
                                controller:
                                    _plateNumberController,
                                cursorColor: Theme.of(context)
                                    .colorScheme
                                    .onBackground,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.all(0.w),
                                    // focusedBorder: InputBorder.none,
                                    hintText: "59V312345",
                                    hintStyle: TextStyle(
                                        color: Theme.of(
                                                context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.3),
                                        fontWeight:
                                            FontWeight.w400),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onBackground))),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Text("Date: "),
                    Text(getDate()),
                    IconButton(
                      onPressed: (){
                        pickDate(context);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    )
                  ],
                ),
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Text("Start time: "),
                    Text(getTime(true)),
                    IconButton(
                      onPressed: (){
                        pickTime(context, true);
                      },
                      icon: Icon(Icons.timer),
                    )
                  ],
                ),  
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Text("End time: "),
                    Text(getTime(false)),
                    IconButton(
                      onPressed: (){
                        pickTime(context, false);
                      },
                      icon: Icon(Icons.timer),
                    )
                  ],
                ),
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Text("Parking location: "),
                    DropdownButton<String>(
                      value: selectedPlace,
                      items: ["A1", "A2", "A3", "A4", "A5"]
                          .map((place) => DropdownMenuItem(
                                value: place,
                                child: Text(place),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            selectedPlace = value!;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h,),
                Center(child: submitButton(() async {
                  if(startTime.isAfter(endTime)){
                    showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return warningDialog(
                            "End time must after start time",
                            (){
                              Navigator.of(context).pop();                  
                            },
                            // ignore: use_build_context_synchronously
                            context
                          );
                        });
                    return;
                  }
                  // if(!date.isAfter(DateTime.now())){
                  //   showDialog(
                  //       // ignore: use_build_context_synchronously
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return warningDialog(
                  //           "The date you choose must be after today",
                  //           (){
                  //             Navigator.of(context).pop();                  
                  //           },
                  //           // ignore: use_build_context_synchronously
                  //           context
                  //         );
                  //       });
                  //   return;
                  // }
                  late CloudResponse rsp;
                  rsp = await httpClient.addVehicle(
                    plate: _plateNumberController.text, 
                    date: getDate(), 
                    endTime: getTime(false), 
                    startTime: getTime(true), 
                    parkingLocation: selectedPlace
                  );
                  if(rsp.status == 200){
                    final response = rsp.data as AddParkingResponse;
                    showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return successDialog(
                            "Your Vehicle with plate number: ${_plateNumberController.text} has been added. UUID: ${response.uuid}",
                            (){
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                (Route<dynamic> route) => false,
                              );                        
                            },
                            // ignore: use_build_context_synchronously
                            context
                          );
                        });
                  }
                  else{
                    // final response = rsp.data as ErrorResponse;
                    showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return failedDialog(
                            "Failed in added your vehicle, ERROR: ${rsp.status}",
                            (){
                              Navigator.of(context).pop();                        
                            },
                            // ignore: use_build_context_synchronously
                            context
                          );
                        });                    
                  }
                // addParking();
                }, context))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
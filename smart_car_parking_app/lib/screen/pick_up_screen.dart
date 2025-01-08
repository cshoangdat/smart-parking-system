import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_car_parking_app/constants/size.dart';
import 'package:smart_car_parking_app/http_services.dart';
import 'package:smart_car_parking_app/screen/home_screen.dart';
import 'package:smart_car_parking_app/widget/common.dart';
import 'package:smart_car_parking_app/widget/navbar.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  TextEditingController _plateNumberController = TextEditingController();
  TextEditingController _uuidController = TextEditingController();

  final httpClient = HttpClientService(
    schema: 'http',
    host: "172.20.10.2",
    inner: TrustAllCertificates().sslClient()
  );

  final Future<FirebaseApp> _fApp = Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   // apiKey: "1:980407563367:android:dedfd5450ff1a07f2410c2", 
    //   // appId: appId, 
    //   // messagingSenderId: messagingSenderId, 
    //   // projectId: projectId
    // )
  );

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
        body: 
        FutureBuilder(
          future: _fApp, 
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Text("Something went wrong");
            }
            else if(snapshot.hasData){
              DatabaseReference _ref = FirebaseDatabase.instance.ref();
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 200.w,
                            height: 200.h,
                            child: Image.asset(
                              "images/driving-lessons.png",
                              // scale: 0.52.h,
                              fit: BoxFit.fill,
                              // opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                        ),
                        SizedBox(height: 45.h,),
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
                        SizedBox(height: 24.h,),
                        RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              const WidgetSpan(
                                  child: Text(
                                "UUID: ",
                              )),
                              WidgetSpan(
                                  child: SizedBox(
                                    width: 265.w,
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
                                            _uuidController,
                                        cursorColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.all(0.w),
                                            // focusedBorder: InputBorder.none,
                                            hintText: "UUID1806abc",
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
                        SizedBox(height: 45.h,),
                        Center(child: submitButton(
                          ()async {
                              late CloudResponse rsp;
                              rsp = await httpClient.checkOut(
                                plate: _plateNumberController.text, 
                                uuid: _uuidController.text,
                                time: '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}'
                              );
                              if(rsp.status == 200){
                                final response = rsp.data as CheckParkingResponse;
                                showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (BuildContext context) {
                                      return successDialog(
                                        "Your Vehicle with plate number: ${_plateNumberController.text} can be picked up now, The total time is ${response.time}",
                                        (){
                                          _ref.child("check_out/location").set(response.location);
                                          // Navigator.pushAndRemoveUntil(
                                          //   context,
                                          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                                          //   (Route<dynamic> route) => false,
                                          // );
                                          Navigator.of(context).pop();                        
                                        },
                                        // ignore: use_build_context_synchronously
                                        context
                                      );
                                    });
                              }
                              else if(rsp.status == 201){
                                  final response = rsp.data as CheckParkingResponse;
                                  showDialog(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) {
                                        return successDialog(
                                          "You picked up your vehicle hours later than initially planned: ${response.excessTime}, The total time is ${response.time}",
                                          (){
                                          _ref.child("check_out/location").set(response.location);
                                            Navigator.of(context).pop();                        
                                          },
                                          // ignore: use_build_context_synchronously
                                          context
                                        );
                                      });
                              }
                              else{
                                final response = rsp.data as ErrorResponse;
                                showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (BuildContext context) {
                                      return failedDialog(
                                        "ERROR: ${rsp.status} - ${response.error}",
                                        (){
                                          Navigator.of(context).pop();                        
                                        },
                                        // ignore: use_build_context_synchronously
                                        context
                                      );
                                    });                    
                              }                     
                          }
                          , context)
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return CircularProgressIndicator();
            }
          }
        )
      ),
    );
  }
}